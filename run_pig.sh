#!/usr/bin/env bash
# Runs all 5 Pig scripts.
# Assumes students.csv is already uploaded to HDFS at /user/hadoop/students.csv
# and Pig is installed and on your PATH.
#
# Usage: ./run_pig.sh

set -e

for script in pig/*.pig; do
    echo ">>> Running ${script}"
    pig -x mapreduce "${script}"
    echo
done
