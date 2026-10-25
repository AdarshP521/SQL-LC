WITH cte AS (
    SELECT 
        user_id,
        event_date,
        event_type,
        plan_name AS current_plan,
        monthly_amount,

        MIN(event_date) OVER (
            PARTITION BY user_id
        ) AS min_event_date,

        MAX(event_date) OVER (
            PARTITION BY user_id
        ) AS max_event_date,

        SUM(
            CASE 
                WHEN event_type = 'downgrade' THEN 1 
                ELSE 0 
            END
        ) OVER (
            PARTITION BY user_id
        ) AS is_hv_downgrade,

        MAX(monthly_amount) OVER (
            PARTITION BY user_id
        ) AS max_historical_amount,

        MAX(
            CASE 
                WHEN event_type = 'cancel' THEN event_date
                ELSE NULL
            END
        ) OVER (
            PARTITION BY user_id
        ) AS max_cancel_event_date,

        DATEDIFF(
            MAX(event_date) OVER (PARTITION BY user_id),
            MIN(event_date) OVER (PARTITION BY user_id)
        ) AS days_as_subscriber,

        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_date DESC
        ) AS rn

    FROM subscription_events
)

SELECT
    user_id,
    current_plan,
    monthly_amount AS current_monthly_amount,
    max_historical_amount,
    days_as_subscriber
FROM cte
WHERE rn = 1
  AND max_cancel_event_date IS NULL
  AND is_hv_downgrade > 0
  AND days_as_subscriber > 59
  AND monthly_amount / CAST(max_historical_amount AS FLOAT) <= 0.5
ORDER BY days_as_subscriber DESC, user_id;