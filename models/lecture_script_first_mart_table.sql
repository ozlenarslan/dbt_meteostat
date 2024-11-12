--In a table mart_faa_stats.sql we want to see for each airport over all time:

SELECT * FROM prep_flights;

--unique number of departures connections
SELECT origin,
		COUNT(*)
FROM prep_flights
GROUP BY origin;

--unique number of arrival connections
SELECT dest,
		COUNT(*)
FROM prep_flights
GROUP BY dest;

--how many flight were planned in total (departures & arrivals)
SELECT origin,
		COUNT(*) AS nunique_to,
		COUNT(sched_dep_time) AS dep_planned
FROM prep_flights
GROUP BY origin;
----
SELECT dest,
		COUNT(*),
		COUNT(sched_arr_time) AS arr_planned
FROM prep_flights
GROUP BY dest;

--how many flights were canceled in total (departures & arrivals)

SELECT origin,
		COUNT(*) AS nunique_to,
		COUNT(sched_dep_time) AS dep_planned,
		SUM(cancelled) AS dep_cancelled
FROM prep_flights
GROUP BY origin;

-----this is going to be another CTE step
SELECT dest,
		COUNT(*),
		COUNT(sched_arr_time) AS arr_planned,
		SUM(cancelled) AS arr_cancelled
FROM prep_flights
GROUP BY dest;


--how many flights were diverted in total (departures & arrivals)
SELECT origin,
		COUNT(*) AS nunique_to,
		COUNT(sched_dep_time) AS dep_planned,
		SUM(cancelled) AS dep_cancelled,
		SUM(diverted) AS dep_diverted
FROM prep_flights
GROUP BY origin;

-----this is going to be another CTE step
SELECT dest,
		COUNT(*) AS nunique_from, 
		COUNT(sched_arr_time) AS arr_planned,
		SUM(cancelled) AS arr_cancelled,
		SUM(diverted) AS arr_diverted
FROM prep_flights
GROUP BY dest;


--how many flights actually occured in total (departures & arrivals)
SELECT origin,
		COUNT(*) AS nunique_to,
		COUNT(sched_dep_time) AS dep_planned,
		SUM(cancelled) AS dep_cancelled,
		SUM(diverted) AS dep_diverted,
		COUNT(dep_time) AS dep_n_flights
FROM prep_flights
GROUP BY origin;

-----this is going to be another CTE step
SELECT dest,
		COUNT(*) AS nunique_from, 
		COUNT(sched_arr_time) AS arr_planned,
		SUM(cancelled) AS arr_cancelled,
		SUM(diverted) AS arr_diverted,
		COUNT(arr_time) AS arr_n_flights
FROM prep_flights
GROUP BY dest;
--(optional) how many unique airplanes travelled on average
SELECT origin,
		COUNT(*) AS nunique_to,
		COUNT(sched_dep_time) AS dep_planned,
		SUM(cancelled) AS dep_cancelled,
		SUM(diverted) AS dep_diverted,
		COUNT(dep_time) AS dep_n_flights
		COUNT(DISTINCT tail_number) AS dep_nunique_tails
FROM prep_flights
GROUP BY origin;

-----this is going to be another CTE step
SELECT dest,
		COUNT(*) AS nunique_from, 
		COUNT(sched_arr_time) AS arr_planned,
		SUM(cancelled) AS arr_cancelled,
		SUM(diverted) AS arr_diverted,
		COUNT(arr_time) AS arr_n_flights,
		COUNT(DISTINCT tail_number) AS arr_nunique_tails
FROM prep_flights
GROUP BY dest;

--(optional) how many unique airlines were in service on average
SELECT origin,
		COUNT(*) AS nunique_to,
		COUNT(sched_dep_time) AS dep_planned,
		SUM(cancelled) AS dep_cancelled,
		SUM(diverted) AS dep_diverted,
		COUNT(dep_time) AS dep_n_flights,
		COUNT(DISTINCT tail_number) AS dep_nunique_tails,
		COUNT(DISTINCT airline) AS dep_nunique_airlines
FROM prep_flights
GROUP BY origin;

-----this is going to be another CTE step
SELECT dest,
		COUNT(*) AS nunique_from, 
		COUNT(sched_arr_time) AS arr_planned,
		SUM(cancelled) AS arr_cancelled,
		SUM(diverted) AS arr_diverted,
		COUNT(arr_time) AS arr_n_flights,
		COUNT(DISTINCT tail_number) AS arr_nunique_tails,
		COUNT(DISTINCT airline) AS arr_nunique_arilines
FROM prep_flights
GROUP BY dest;

--add city, country and name of the airport
WITH departures AS (
			SELECT origin AS faa,
					COUNT(*) AS nunique_to,
					COUNT(sched_dep_time) AS dep_planned,
					SUM(cancelled) AS dep_cancelled,
					SUM(diverted) AS dep_diverted,
					COUNT(dep_time) AS dep_n_flights,
					COUNT(DISTINCT tail_number) AS dep_nunique_tails,
					COUNT(DISTINCT airline) AS dep_nunique_airlines
			FROM prep_flights
			GROUP BY origin
),
-----this is going to be another CTE step
arrivals AS (
			SELECT dest AS faa,
					COUNT(*) AS nunique_from, 
					COUNT(sched_arr_time) AS arr_planned,
					SUM(cancelled) AS arr_cancelled,
					SUM(diverted) AS arr_diverted,
					COUNT(arr_time) AS arr_n_flights,
					COUNT(DISTINCT tail_number) AS arr_nunique_tails,
					COUNT(DISTINCT airline) AS arr_nunique_arilines
			FROM prep_flights
			GROUP BY dest
),
total_stats AS (
			SELECT 	d.faa,
					nunique_to, 
					nunique_from,
					(dep_planned + arr_planned) AS total_planned,
					(dep_cancelled + arr_cancelled) AS total_cancelled,
					(dep_diverted + arr_diverted) AS total_diverted,
					(dep_n_flights + arr_n_flights) AS total_flights
			FROM departures d
			JOIN arrivals a
			ON d.faa = a.faa
)
SELECT ap.city, 
		ap.country, 
		ap.name,
		t.* 
FROM total_stats t
LEFT JOIN prep_airports ap
USING (faa)

-- checking columns in prep_airports
SELECT * FROM prep_airports;




