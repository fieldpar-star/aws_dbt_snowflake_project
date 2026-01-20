-- Test: Ensure listing_id is not null in silver_listings
-- This test fails if any null values are found

SELECT
    listing_id
FROM {{ ref('silver_listings') }}
WHERE listing_id IS NULL
