-- Test: Ensure host_id is unique in bronze_hosts
-- This test fails if any duplicate host_id values are found

SELECT
    host_id,
    COUNT(*) AS record_count
FROM {{ ref('bronze_hosts') }}
GROUP BY host_id
HAVING COUNT(*) > 1
