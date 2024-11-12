-- In a table mart_faa_stats.sql we want to see for each airport over all time:

select * from prep_flights;

-- unique number of departures connections

select * from prep_flights,
group BY origin; --origin or destination

--unique number of arrival connections

select dest,
	count(*)
	from prep_flights;
group by dest

--how many flight were planned in total (departures & arrivals)
select origin,
	count(*) as nunique_dep
	count (sched_dep_time) as dep_planned
	from prep_flights;
group by origin;

select dest,
	count(*)
	count (sched_arr_time) as arr_planned
	from prep_flights;
group by dest;

--how many flights were canceled in total (departures & arrivals)

select origin,
	count(*) as nunique_to
	count (sched_dep_time) as dep_planned
	SUM(cancelled) as dep_cancelled
from prep_flights
group by origin;

select dest,
	count(*)
	count (sched_arr_time) as arr_planned
	from prep_flights;
group by dest;


--how many flights were diverted in total (departures & arrivals)

select origin,
	count(*) as nunique_to
	count (sched_dep_time) as dep_planned
	SUM(cancelled) as dep_cancelled
	SUM(diverted) as dep_diverted
from prep_flights
group by origin;

select dest,
	count(*) as nunique_from
	count (sched_arr_time) as arr_planned
	SUM(cancelled) as arr_cancelled
	SUM(diverted) as dep_diverted
	from prep_flights;
group by dest;

--how many flights actually occured in total (departures & arrivals)

select origin,
	count(*) as nunique_to
	count (sched_dep_time) as dep_planned,
	SUM(cancelled) as dep_cancelled,
	SUM(diverted) as dep_diverted,
	count (dep-time)as dep_n_fligts
from prep_flights
group by origin;

select dest,
	count(*) as nunique_from
	count (sched_arr_time) as arr_planned,
	SUM(cancelled) as arr_cancelled,
	SUM(diverted) as dep_diverted,
	count(arr_time) as arr_n_flights
from prep_flights;
group by dest;

--(optional) how many unique airplanes travelled on average
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

--(optional) how many unique airlines were in service on average

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





