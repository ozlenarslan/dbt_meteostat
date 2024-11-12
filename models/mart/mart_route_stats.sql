WITH Step_1_route_stat AS (
		SELECT 	origin,
		dest,
		COUNT(*) AS flight_count,
 		COUNT(DISTINCT tail_number) AS unique_airplanes,
 		count (DISTINCT AIRLINE) AS unique_airlines,
 		sum(ACTUAL_ELAPSED_TIME) AS avg_elapsed_time,
 		avg(ARR_DELAY) AS avg_arr_delay,
 		max (DEP_DELAY) AS max_dep_delay,
 		max (ARR_DELAY) AS max_arr_delay,
 		min (DEP_DELAY) AS min_dep_delay,
 		min (ARR_DELAY) AS min_arr_delay,
 		sum(CANCELLED) AS total_cancelled,
 		sum(DIVERTED) AS total_diverted
FROM {{ref('PREP_FLIGHTS')}}
GROUP BY origin, dest
)
SELECT 
    ap_origin.city AS origin_city,
    ap_origin.country AS origin_country,
    ap_origin.name AS origin_airport_name,
    ap_dest.city AS dest_city,
    ap_dest.country AS dest_country,
    ap_dest.name AS dest_airport_name,
    s.*
FROM 
    {{ref('Step_1_route_stat')}}
LEFT JOIN 
    prep_airports ap_origin ON s.origin = ap_origin.faa
LEFT JOIN 
    prep_airports ap_dest ON s.dest = ap_dest.faa;