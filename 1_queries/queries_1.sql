--  Get the names of all of the students from a single cohort.
SELECT id, name -- Select their id and name.
FROM students  
WHERE cohort_id = 1 --Since this query needs to work with any specific cohort, just use any number for the cohort_id.
ORDER BY name; -- Order them by their name in alphabetical order.


-- The admissions department wants to know the total number of students from any number of cohorts combined.
-- Select the total number of students who were in the first 3 cohorts.
SELECT count(id)
FROM students 
WHERE cohort_id IN (1,2,3);


-- We need to make sure that we can contact students through a phone number or through email.
-- If student's don't have a phone number or email associated with their account, 
-- we'll need to message them on slack to update their details.
SELECT name, id, cohort_id
FROM students
WHERE email IS NULL
OR phone IS NULL;


-- Recently we've been having trouble emailing students without a gmail account. 
-- To make sure that we can reliably contact all students, 
-- we'll need to make sure that student's without a gmail account have a phone number.
-- Get all of the students without a gmail.com account and a phone number.
SELECT name, id, email, cohort_id
FROM students
WHERE email NOT LIKE '%gmail.com'
AND phone IS NULL;

-- A student's end date will be NULL when they are currently enrolled in Bootcamp.
-- Get all of the students currently enrolled.
SELECT name, id, cohort_id
FROM students
WHERE end_date IS NULL
ORDER BY cohort_id;

-- Once a student graduates, the career services department needs to keep track of their activity on Github.
-- If a graduate has not linked their Github account, we need to contact them to do so.
-- Get their name, email, and phone.

SELECT name, email, phone
FROM students
WHERE github IS NULL
AND end_date IS NOT NULL;