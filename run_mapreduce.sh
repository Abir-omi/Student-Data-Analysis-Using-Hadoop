#!/usr/bin/env bash
# Runs all 3 MapReduce jobs using Hadoop Streaming with Java mappers/reducers.
# Assumes students.csv is already uploaded to HDFS at /user/hadoop/students.csv
# and $HADOOP_HOME / $HADOOP_STREAMING_JAR are set correctly. Needs a JDK (javac).
#
# Usage: ./run_mapreduce.sh

set -e

STREAMING_JAR="${HADOOP_STREAMING_JAR:-$(ls $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar | head -1)}"
INPUT="/user/hadoop/students.csv"
BUILD_DIR="build"

echo ">>> Compiling Java mappers and reducers"
mkdir -p "${BUILD_DIR}"
javac -d "${BUILD_DIR}" mapreduce/*/*.java

run_job () {
    local mapper=$1
    local reducer=$2
    local job_name=$3
    local output_dir="/user/hadoop/output/${job_name}"

    echo ">>> Running ${job_name}"
    hdfs dfs -rm -r -f "${output_dir}" || true

    hadoop jar "${STREAMING_JAR}" \
        -files "${BUILD_DIR}/${mapper}.class,${BUILD_DIR}/${reducer}.class" \
        -mapper "java -cp . ${mapper}" \
        -reducer "java -cp . ${reducer}" \
        -input "${INPUT}" \
        -output "${output_dir}"

    echo ">>> Output for ${job_name}:"
    hdfs dfs -cat "${output_dir}/part-00000"
    echo
}

run_job Mapper     Reducer     "job1_avg_gpa_by_region"
run_job Job2Mapper Job2Reducer "job2_pass_rate_by_school_type"
run_job Job3Mapper Job3Reducer "job3_stress_motivation_by_parental_involvement"
