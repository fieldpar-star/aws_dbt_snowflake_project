-- Test: Ensure listing_id is not null in bronze_listings
-- This test fails if any null values are found

SELECT
    listing_id
FROM {{ ref('bronze_listings') }}
WHERE listing_id IS NULL
