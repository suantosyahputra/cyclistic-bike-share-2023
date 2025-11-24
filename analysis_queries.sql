1. Total rides by rider type

SELECT 
    member_casual,
    COUNT(*) AS total_trips
FROM cyclistic_trips_clean
GROUP BY member_casual
ORDER BY total_trips DESC;

2. Member vs casual behaviour differences
2.1 Average ride length

SELECT 
 member_casual,
 ROUND(AVG(ride_length), 2) AS avg_ride_length_min
FROM cyclistic_trips_complete_clean
GROUP BY member_casual
ORDER BY avg_ride_length_min DESC;

2.2 Ride length distribution 

SELECT 
  ride_length_category,
  member_casual,
 COUNT(*) AS total_trips
FROM cyclistic_trips_complete_clean
GROUP BY ride_length_category, member_casual
ORDER BY ride_length_category, member_casual;

2.3 Variability

SELECT 
    member_casual,
    ROUND(AVG(ride_length),2) AS avg_len,
    ROUND(STDDEV(ride_length),2) AS std_len
FROM cyclistic_trips_complete_clean
GROUP BY member_casual;

3. Time-based behaviour
3.1 Hour of day

SELECT hour_of_day, member_casual, COUNT(*)
FROM cyclistic_trips_complete_clean
GROUP BY hour_of_day, member_casual
ORDER BY hour_of_day;

3.2 Day of week

SELECT day_of_week, member_casual, COUNT(*)
FROM cyclistic_trips_complete_clean
GROUP BY day_of_week, member_casual
ORDER BY day_of_week;

4. Seasonal trends (spring/summer/fall/winter)

4.1 Seasonal trip counts

SELECT season, member_casual, COUNT(*)
FROM cyclistic_trips_complete_clean
GROUP BY season, member_casual
ORDER BY season, member_casual;

4.2 Average ride length by season

SELECT season, member_casual,
       ROUND(AVG(ride_length),2)
FROM cyclistic_trips_complete_clean
GROUP BY season, member_casual;

5. Monthly trends

SELECT trip_month, member_casual, COUNT(*)
FROM cyclistic_trips_complete_clean
GROUP BY trip_month, member_casual
ORDER BY trip_month, member_casual;

6. Popular stations

6.1 Most popular start stations overall

SELECT start_station_name, COUNT(*)
FROM cyclistic_trips_complete_clean
GROUP BY start_station_name
ORDER BY COUNT(*) DESC
LIMIT 10;

6.2 Most popular among members

SELECT start_station_name, COUNT(*)
FROM cyclistic_trips_complete_clean
WHERE member_casual = 'member'
GROUP BY start_station_name
ORDER BY COUNT(*) DESC
LIMIT 10;

6.3 Most popular among casual members

SELECT start_station_name, COUNT(*)
FROM cyclistic_trips_complete_clean
WHERE member_casual = 'casual'
GROUP BY start_station_name
ORDER BY COUNT(*) DESC
LIMIT 10;

7. Geographic insights

Station popularity overall

SELECT
  start_station_name,
    AVG(start_lat) AS lat,
    AVG(start_lng) AS lng,
    COUNT(*) AS total_trips
FROM cyclistic_trips_complete_clean
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY total_trips DESC;


Members vs casual at each station

SELECT
    start_station_name,
    AVG(start_lat) AS lat,
    AVG(start_lng) AS lng,
    member_casual,
    COUNT(*) AS total_trips
FROM cyclistic_trips_complete_clean
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name, member_casual
ORDER BY total_trips DESC;








