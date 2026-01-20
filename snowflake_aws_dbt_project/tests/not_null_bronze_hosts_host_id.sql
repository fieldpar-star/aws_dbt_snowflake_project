-- Test: Ensure host_id is not null in bronze_hosts
-- This test fails if any null values are found

SELECT
    host_id
FROM {{ ref('bronze_hosts') }}
WHERE host_id IS NULL
