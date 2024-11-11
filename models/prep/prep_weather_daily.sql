WITH daily_data AS (
    SELECT *
    FROM {{ ref('staging_weather_daily') }}
),
add_features AS (
    SELECT *
        , DATE_PART('day', date) AS date_day
        , DATE_PART('month', date) AS date_month
        , DATE_PART('year', date) AS date_year
        , EXTRACT(WEEK FROM date) AS cw  -- Adjusted for general SQL compatibility
        , TO_CHAR(date, 'Month') AS month_name  -- For databases like PostgreSQL
        , TO_CHAR(date, 'Day') AS weekday       -- For databases like PostgreSQL
    FROM daily_data
),
add_more_features AS (
    SELECT *
        , (CASE
            WHEN DATE_PART('month', date) IN (12, 1, 2) THEN 'winter'
            WHEN DATE_PART('month', date) IN (3, 4, 5) THEN 'spring'
            WHEN DATE_PART('month', date) IN (6, 7, 8) THEN 'summer'
            WHEN DATE_PART('month', date) IN (9, 10, 11) THEN 'autumn'
        END) AS season
    FROM add_features
)
SELECT *
FROM add_more_features
ORDER BY date