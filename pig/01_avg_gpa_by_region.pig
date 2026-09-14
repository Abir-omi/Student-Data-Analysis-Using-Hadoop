-- 01_avg_gpa_by_region.pig
-- Average overall GPA grouped by school region

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

-- drop header row
students = FILTER students BY student_id != 'student_id';

grouped_by_region = GROUP students BY school_region;

avg_gpa_by_region = FOREACH grouped_by_region GENERATE
    group AS school_region,
    AVG(students.overall_gpa) AS avg_gpa,
    COUNT(students) AS student_count;

avg_gpa_by_region = ORDER avg_gpa_by_region BY avg_gpa DESC;

DUMP avg_gpa_by_region;
STORE avg_gpa_by_region INTO 'output/avg_gpa_by_region' USING PigStorage(',');
