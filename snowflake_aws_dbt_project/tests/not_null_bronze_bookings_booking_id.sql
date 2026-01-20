-- Test: Ensure booking_id is not null in bronze_bookings
-- This test fails if any null values are found

SELECT
    booking_id
FROM {{ ref('bronze_bookings') }}
WHERE booking_id IS NULL
