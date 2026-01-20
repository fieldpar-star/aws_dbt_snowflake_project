-- Test: Ensure listing_id is unique in silver_listings
-- This test fails if any duplicate listing_id values are found

SELECT
    listing_id,
    COUNT(*) AS record_count
FROM {{ ref('silver_listings') }}
GROUP BY listing_id
HAVING COUNT(*) > 1
