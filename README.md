# Student Performance — MapReduce & Pig Analysis

A Big Data project analyzing a 10,000-row student performance dataset using
**3 Hadoop MapReduce jobs** (Python streaming) and **5 Apache Pig scripts**.

## Dataset

`data/students.csv` — 10,000 students, 25 columns including demographics
(age, gender, ethnicity), family background (parental education, income),
school info (type, region), study habits (study hours, attendance,
tutoring), wellbeing (sleep, stress, motivation), academic scores
(reading, writing, math, science), overall GPA, and pass/fail status.

## Project Structure

```
project/
├── data/
│   └── students.csv
├── mapreduce/
│   ├── job1_avg_gpa_by_region/
│   │   ├── mapper.py
│   │   └── reducer.py
│   ├── job2_pass_rate_by_school_type/
│   │   ├── mapper.py
│   │   └── reducer.py
│   └── job3_stress_motivation_by_parental_involvement/
│       ├── mapper.py
│       └── reducer.py
├── pig/
│   ├── 01_avg_gpa_by_region.pig
│   ├── 02_study_hours_vs_stress.pig
│   ├── 03_top10_students_by_gpa.pig
│   ├── 04_attendance_by_laptop_access.pig
│   └── 05_avg_scores_by_schooltype_gender.pig
├── run_mapreduce.sh
├── run_pig.sh
└── README.md
```

## MapReduce Jobs

| Job | Question Answered | Output |
|---|---|---|
| **Job 1** | What is the average GPA in each school region? | `region, avg_gpa, count` |
| **Job 2** | What percentage of students pass, by school type? | `school_type, pass_rate%, count` |
| **Job 3** | How do stress & motivation vary by parental involvement level? | `involvement, avg_stress, avg_motivation, count` |

## Pig Scripts

| Script | Question Answered |
|---|---|
| **01** | Average GPA per school region (same as Job 1, done in Pig Latin) |
| **02** | Average stress level across study-hours buckets |
| **03** | Top 10 students ranked by overall GPA |
| **04** | Average attendance rate by laptop access (yes/no) |
| **05** | Average subject scores by school type × gender |

## Setup

1. Start HDFS and put the dataset on it:
   ```bash
   hdfs dfs -mkdir -p /user/hadoop
   hdfs dfs -put data/students.csv /user/hadoop/students.csv
   ```

2. Run the MapReduce jobs:
   ```bash
   chmod +x run_mapreduce.sh
   ./run_mapreduce.sh
   ```

3. Run the Pig scripts (requires Apache Pig on your PATH):
   ```bash
   chmod +x run_pig.sh
   ./run_pig.sh
   ```

Each Pig script also writes its result to `output/<script_name>/` via `STORE`.

## Notes

- MapReduce mappers/reducers are plain Python 3 (Hadoop Streaming) — no
  extra libraries needed on the cluster nodes.
- Pig scripts assume the CSV has been uploaded to HDFS at
  `/user/hadoop/students.csv`; edit the `LOAD` path in each `.pig` file if
  your cluster uses a different location.
- The first data row is skipped in every job by filtering out the header
  (`student_id,...`).
