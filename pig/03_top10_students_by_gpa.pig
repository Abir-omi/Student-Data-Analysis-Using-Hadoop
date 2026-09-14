-- 03_top10_students_by_gpa.pig
-- Top 10 students ranked by overall GPA

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

relevant = FOREACH students GENERATE
    student_id, school_type, school_region, overall_gpa, attendance_rate, study_hours_per_week;

ranked = ORDER relevant BY overall_gpa DESC;

top10 = LIMIT ranked 10;

DUMP top10;
STORE top10 INTO 'output/top10_students_by_gpa' USING PigStorage(',');
