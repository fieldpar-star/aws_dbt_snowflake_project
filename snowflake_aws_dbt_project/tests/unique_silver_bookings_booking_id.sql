-- Test: Ensure booking_id is unique in silver_bookings
-- This test fails if any duplicate booking_id values are found

SELECT
    booking_id,
    COUNT(*) AS record_count
FROM {{ ref('silver_bookings') }}
GROUP BY booking_id
HAVING COUNT(*) > 1
