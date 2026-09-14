#!/usr/bin/env bash
# Runs all 3 MapReduce jobs using Hadoop Streaming.
# Assumes students.csv is already uploaded to HDFS at /user/hadoop/students.csv
# and $HADOOP_HOME / $HADOOP_STREAMING_JAR are set correctly.
#
# Usage: ./run_mapreduce.sh

set -e

STREAMING_JAR="${HADOOP_STREAMING_JAR:-$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar}"
INPUT="/user/hadoop/students.csv"

run_job () {
    local job_dir=$1
    local job_name=$2
    local output_dir="/user/hadoop/output/${job_name}"

    echo ">>> Running ${job_name}"
    hdfs dfs -rm -r -f "${output_dir}" || true

    hadoop jar ${STREAMING_JAR} \
        -files "${job_dir}/mapper.py,${job_dir}/reducer.py" \
        -mapper "python3 mapper.py" \
        -reducer "python3 reducer.py" \
        -input "${INPUT}" \
        -output "${output_dir}"

    echo ">>> Output for ${job_name}:"
    hdfs dfs -cat "${output_dir}/part-00000"
    echo
}

run_job "mapreduce/job1_avg_gpa_by_region" "job1_avg_gpa_by_region"
run_job "mapreduce/job2_pass_rate_by_school_type" "job2_pass_rate_by_school_type"
run_job "mapreduce/job3_stress_motivation_by_parental_involvement" "job3_stress_motivation_by_parental_involvement"
