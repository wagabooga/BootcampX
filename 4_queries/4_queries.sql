-- We need to be able to see how many assistance requests any teacher has completed.
-- Get the total number of assistance_requests for a teacher.
-- Select the teacher's name and the total assistance requests.
-- Since this query needs to work with any specific teacher name, use 'Waylon Boehm' for the teacher's name here.
SELECT count(assistance_requests.*) as total_assistances, teachers.name
FROM assistance_requests
JOIN teachers ON teachers.id = teacher_id
WHERE name = 'Waylon Boehm'
GROUP BY teachers.name;


-- We need to be able to see how many assistance requests any student has requested.
-- Get the total number of assistance_requests for a student.
-- Select the student's name and the total assistance requests.
-- Since this query needs to work with any specific student name, use 'Elliot Dickinson' for the student's name here.
SELECT count(assistance_requests.*) as total_assistances, students.name
FROM assistance_requests
JOIN students ON students.id = student_id
WHERE name = 'Elliot Dickinson'
GROUP BY students.name;


-- Each assistance request is related to a bunch of data like a teacher, student, assignment, and more. 
-- We want to be able to see all important data about an assistance request.
-- Get important data about each assistance request.
-- Select the teacher's name, student's name, assignment's name, and the duration of each assistance request.
-- Subtract completed_at by started_at to find the duration.
-- Order by the duration of the request.
SELECT teachers.name as teacher, students.name as student, assignments.name as assignment, (completed_at-started_at) as duration
FROM assistance_requests
JOIN teachers ON teachers.id = teacher_id
JOIN students ON students.id = student_id
JOIN assignments ON assignments.id = assignment_id
ORDER BY duration;


-- We need to be able to see the current average time it takes to complete an assistance request.
-- Get the average time of an assistance request.
-- Select just a single row here and name it average_assistance_request_duration
-- In Postgres, we can subtract two timestamps to find the duration between them. (timestamp1 - timestamp2)
SELECT avg(completed_at - started_at) as average_assistance_request_duration
FROM assistance_requests;


-- Average Cohort Assistance Time
-- We need to be able to see the average duration of a single assistance request for each cohort.
-- Get the average duration of assistance requests for each cohort.
-- Select the cohort's name and the average assistance request time.
-- Order the results from shortest average to longest.
SELECT cohorts.name, avg(completed_at - started_at) as average_assistance_time
FROM assistance_requests 
JOIN students ON students.id = assistance_requests.student_id
JOIN cohorts ON cohorts.id = cohort_id
GROUP BY cohorts.name
ORDER BY average_assistance_time;


-- Cohort With Longest Assistances
-- Get the cohort with the longest average duration of assistance requests.
-- The same requirements as the previous query, but only return the single row with the longest average.
SELECT cohorts.name, avg(completed_at - started_at) as average_assistance_time
FROM assistance_requests 
JOIN students ON students.id = assistance_requests.student_id
JOIN cohorts ON cohorts.id = cohort_id
GROUP BY cohorts.name
ORDER BY average_assistance_time DESC
LIMIT 1;


-- Average Assistance Request Wait Time
-- We need to know the average amount of time that students are waiting for an assistance request. 
-- This is the duration between an assistance request being created, and it being started.
-- Calculate the average time it takes to start an assistance request.
SELECT avg(started_at-created_at) as average_wait_time
FROM assistance_requests;


-- Total Cohort Assistance Duration
-- We need to be able to see the total amount of time being spent on an assistance request for each cohort. 
-- This number will tell use how much time is being spent on assistance requests for each cohort.
-- Get the total duration of all assistance requests for each cohort.
-- Select the cohort's name and the total duration the assistance requests.
-- Order by total_duration.
SELECT cohorts.name as cohort, sum(completed_at-started_at) as total_duration
FROM assistance_requests
JOIN students ON students.id = student_id
JOIN cohorts on cohorts.id = cohort_id
GROUP BY cohorts.name
ORDER BY total_duration;


-- We also need to know the average total amount of time being spent on an assistance request for each cohort. 
-- This is just the average of the total_duration column from the previous query.
-- Calculate the average total duration of assistance requests for each cohort.
-- Use the previous query as a sub query to determine the duration per cohort.
-- Return a single row average_total_duration
SELECT avg (total_duration) as average_total_duration
FROM (
  SELECT cohorts.name as cohort, sum(completed_at-started_at) as total_duration
  FROM assistance_requests
  JOIN students ON students.id = student_id
  JOIN cohorts on cohorts.id = cohort_id
  GROUP BY cohorts.name
  ORDER BY total_duration
) as total_durations;


-- We need to know which assignments are causing the most assistance requests.
-- List each assignment with the total number of assistance requests with it.
-- Select the assignment's id, day, chapter, name and the total assistances.
-- Order by total assistances in order of most to least.
SELECT assignments.id, name, day, chapter, count(assistance_requests) as total_requests
FROM assignments
JOIN assistance_requests ON assignments.id = assignment_id
GROUP BY assignments.id
ORDER BY total_requests DESC;


-- We need to be able to see the number of assignments that each day has and the total duration of assignments for each day.
-- Get each day with the total number of assignments and the total duration of the assignments.
-- Select the day, number of assignments, and the total duration of assignments.
-- Order the results by the day.
SELECT day, count(*) as number_of_assignments, sum(duration) as duration
FROM assignments
GROUP BY day
ORDER BY day;

-- We need to know which teachers actually assisted students during any cohort.
-- Get the name of all teachers that performed an assistance request during a cohort.
-- Select the instructor's name and the cohort's name.
-- Don't repeat the instructor's name in the results list.
-- Order by the instructor's name.
-- This query needs to select data for a cohort with a specific name, use 'JUL02' for the cohort's name here.

SELECT DISTINCT teachers.name as teacher, cohorts.name as cohort
FROM teachers
JOIN assistance_requests ON teacher_id = teachers.id
JOIN students ON student_id = students.id
JOIN cohorts ON cohort_id = cohorts.id
WHERE cohorts.name = 'JUL02'
ORDER BY teacher;

-- We need to know which teachers actually assisted students during any cohort, and how many assistances they did for that cohort.
-- Perform the same query as before, but include the number of assistances as well.

SELECT teachers.name as teacher, cohorts.name as cohort, count(assistance_requests) as total_assistances
FROM teachers
JOIN assistance_requests ON teacher_id = teachers.id
JOIN students ON student_id = students.id
JOIN cohorts ON cohort_id = cohorts.id
WHERE cohorts.name = 'JUL02'
GROUP BY teachers.name, cohorts.name
ORDER BY teacher;