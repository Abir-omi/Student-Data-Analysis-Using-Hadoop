-- 05_avg_scores_by_schooltype_gender.pig
-- Average reading/writing/math/science scores grouped by school type and gender

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

grouped = GROUP students BY (school_type, gender);

avg_scores = FOREACH grouped GENERATE
    FLATTEN(group) AS (school_type, gender),
    AVG(students.reading_score) AS avg_reading,
    AVG(students.writing_score) AS avg_writing,
    AVG(students.math_score) AS avg_math,
    AVG(students.science_score) AS avg_science,
    COUNT(students) AS student_count;

avg_scores = ORDER avg_scores BY school_type, gender;

DUMP avg_scores;
STORE avg_scores INTO 'output/avg_scores_by_schooltype_gender' USING PigStorage(',');
