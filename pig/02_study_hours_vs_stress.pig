-- 02_study_hours_vs_stress.pig
-- Buckets students by weekly study hours and shows average stress level per bucket

students = LOAD '/user/hadoop/students.csv'
    USING PigStorage(',')
    AS (student_id:chararray, age:int, gender:chararray, ethnicity:chararray,
        parental_education:chararray, family_income:chararray, school_type:chararray,
        school_region:chararray, study_hours_per_week:float, attendance_rate:float,
        extracurricular_activities:int, sports_participation:chararray,
        tutoring_sessions:int, parental_involvement:chararray, internet_access:chararray,
        has_laptop:chararray, sleep_hours:float, stress_level:float, motivation_score:float,
        reading_score:float, writing_score:float, math_score:float, science_score:float,
        overall_gpa:float, passed:int);

students = FILTER students BY student_id != 'student_id';

bucketed = FOREACH students GENERATE
    (
        (study_hours_per_week < 5) ? 'low (<5h)' :
        (study_hours_per_week < 10) ? 'medium (5-10h)' :
        (study_hours_per_week < 15) ? 'high (10-15h)' : 'very_high (15h+)'
    ) AS study_bucket,
    stress_level,
    motivation_score;

grouped_by_bucket = GROUP bucketed BY study_bucket;

stress_by_bucket = FOREACH grouped_by_bucket GENERATE
    group AS study_bucket,
    AVG(bucketed.stress_level) AS avg_stress,
    AVG(bucketed.motivation_score) AS avg_motivation,
    COUNT(bucketed) AS student_count;

stress_by_bucket = ORDER stress_by_bucket BY study_bucket;

DUMP stress_by_bucket;
STORE stress_by_bucket INTO 'output/study_hours_vs_stress' USING PigStorage(',');
