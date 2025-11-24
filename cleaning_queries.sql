1. MIN and MAX start and end of trip:

SELECT
	MIN(started_at) AS min_started_at,
	MAX(started_at) AS max_started_at,
	MIN(ended_at) AS min_ended_at,
	MAX(ended_at) AS max_ended_at
FROM cyclistic_trips_complete;

2. Data outside 2023

SELECT ride_id, started_at, ended_at
FROM cyclistic_trips_complete
WHERE started_at < '2023-01-01'
OR started_at >= '2024-01-01'
LIMIT 100;

3. Negative or zero trip durations

SELECT 
    COUNT(*) AS total_trips,
    SUM(CASE WHEN ended_at <= started_at THEN 1 ELSE 0 END) AS non_positive_trips
FROM cyclistic_trips_complete;

4. Inspect negative or zero trip durations

SELECT 
    ride_id,
    started_at,
    ended_at,
    ended_at - started_at AS ride_duration
FROM cyclistic_trips_complete
WHERE ended_at <= started_at
ORDER BY started_at
LIMIT 100;

5. Count the impossibly long trips:

SELECT 
    COUNT(*) AS total_trips,
    SUM(CASE WHEN ended_at - started_at > INTERVAL '1 day' THEN 1 ELSE 0 END) AS impossibly_long_trips
FROM cyclistic_trips_complete;

6. Inspect the impossibly long trips:

SELECT 
    ride_id,
    started_at,
    ended_at,
    ended_at - started_at AS ride_duration
FROM cyclistic_trips_complete
WHERE ended_at - started_at > INTERVAL '1 day'
ORDER BY ride_duration DESC
LIMIT 100;

7. Remove negative and zero-length trips:

DELETE FROM cyclistic_trips_complete
WHERE ended_at <= started_at;

8. Create clean analysis table excluding the impossibly long trips

CREATE TABLE cyclistic_trips_complete_clean AS
SELECT *
FROM cyclistic_trips_complete
WHERE ended_at > started_at
  AND ended_at - started_at <= INTERVAL '1 day';

9. Re-check after cleaning

SELECT 
    SUM(CASE WHEN ended_at <= started_at THEN 1 END) AS invalid_trips,
    SUM(CASE WHEN ended_at - started_at > INTERVAL '1 day' THEN 1 END) AS long_trips
FROM cyclistic_trips_complete_clean;

10. Calculate ride length

UPDATE cyclistic_trips_complete_clean
SET ride_length = EXTRACT(EPOCH FROM (ended_at - started_at)) / 60.0;

11. Label the weekday name

UPDATE cyclistic_trips_complete_clean
SET day_of_week = TO_CHAR(started_at, 'Day');

12. Add month and year columns

ALTER TABLE cyclistic_trips_complete_clean
ADD COLUMN trip_month int,
ADD COLUMN trip_year int;

13. Fill month and year

UPDATE cyclistic_trips_complete_clean
SET trip_month = EXTRACT(MONTH FROM started_at),
        trip_year  = EXTRACT(YEAR FROM started_at);

14. Verify that the month and year columns present in the table

SELECT ride_id, started_at, ended_at, ride_length_minutes, day_of_week
FROM cyclistic_trips_complete_clean
LIMIT 10;

15 Add features:

a. Hour of day

ALTER TABLE cyclistic_trips_complete_clean
ADD COLUMN hour_of_day int;
UPDATE cyclistic_trips_complete_clean
SET hour_of_day = EXTRACT(HOUR FROM started_at);

b. Day type (weekend or weekdays)

ALTER TABLE cyclistic_trips_complete_clean
ADD COLUMN day_type text;
UPDATE cyclistic_trips_complete_clean
SET day_type = CASE
    WHEN EXTRACT(ISODOW FROM started_at) IN (6, 7) THEN 'Weekend'
    ELSE 'Weekday'
END;

c. Season

ALTER TABLE cyclistic_trips_complete_clean
ADD COLUMN season text;
UPDATE cyclistic_trips_complete_clean
SET season = CASE
    WHEN EXTRACT(MONTH FROM started_at) IN (12, 1, 2) THEN 'Winter'
    WHEN EXTRACT(MONTH FROM started_at) IN (3, 4, 5) THEN 'Spring'
    WHEN EXTRACT(MONTH FROM started_at) IN (6, 7, 8) THEN 'Summer'
    WHEN EXTRACT(MONTH FROM started_at) IN (9, 10, 11) THEN 'Fall'
END;

d. Ride length category

ALTER TABLE cyclistic_trips_complete_clean
ADD COLUMN ride_length_category text;

UPDATE cyclistic_trips_complete_clean
SET ride_length_category = CASE
    WHEN ride_length < 5 THEN 'Very Short'
    WHEN ride_length < 15 THEN 'Short'
    WHEN ride_length < 30 THEN 'Medium'
    WHEN ride_length < 60 THEN 'Long'
    ELSE 'Very Long'
END;

e. Add month name

ALTER TABLE cyclistic_trips_complete_clean
ADD COLUMN month_name text;
UPDATE cyclistic_trips_complete_clean
SET month_name = TO_CHAR(started_at, 'Month');










