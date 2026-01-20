-- Test: Ensure booking_id is not null in silver_bookings
-- This test fails if any null values are found

SELECT
    booking_id
FROM {{ ref('silver_bookings') }}
WHERE booking_id IS NULL
