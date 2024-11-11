WITH daily_data AS (
    SELECT * 
    FROM {{ref('staging_weather_daily')}}
),
add_features AS (
    SELECT *
		, ... AS date_day
		, ... AS date_month
		, ... AS date_year
		, ... AS cw
		, ... AS month_name
		, ... AS weekday
    FROM daily_data 
),
add_more_features AS (
    SELECT *
		, (CASE 
			WHEN month_name in ... THEN 'winter'
			WHEN ... THEN 'spring'
            WHEN ... THEN 'summer'
            WHEN ... THEN 'autumn'
		END) AS season
    FROM add_features
)
SELECT *
FROM add_more_features
ORDER BY date