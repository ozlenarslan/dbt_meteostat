WITH departures AS (
			SELECT origin AS faa,
					COUNT(*) AS nunique_to,
					COUNT(sched_dep_time) AS dep_planned,
					SUM(cancelled) AS dep_cancelled,
					SUM(diverted) AS dep_diverted,
					COUNT(dep_time) AS dep_n_flights,
					COUNT(DISTINCT tail_number) AS dep_nunique_tails,
					COUNT(DISTINCT airline) AS dep_nunique_airlines
			FROM {{ref('prep_flights')}}
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
			FROM {{ref('prep_flights')}}
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
LEFT JOIN {{ref('prep_airports')}} ap
USING (faa)


















