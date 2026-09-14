-- 04_attendance_by_laptop_access.pig
-- Average attendance rate grouped by whether the student has a laptop

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

grouped_by_laptop = GROUP students BY has_laptop;

attendance_by_laptop = FOREACH grouped_by_laptop GENERATE
    group AS has_laptop,
    AVG(students.attendance_rate) AS avg_attendance,
    AVG(students.overall_gpa) AS avg_gpa,
    COUNT(students) AS student_count;

attendance_by_laptop = ORDER attendance_by_laptop BY has_laptop;

DUMP attendance_by_laptop;
STORE attendance_by_laptop INTO 'output/attendance_by_laptop_access' USING PigStorage(',');
