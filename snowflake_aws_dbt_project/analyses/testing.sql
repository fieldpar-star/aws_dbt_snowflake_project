SELECT
    -- Bookings
    silver_bookings.BOOKING_ID,
    silver_bookings.LISTING_ID,
    silver_bookings.BOOKING_DATE,
    silver_bookings.TOTAL_AMOUNT,
    silver_bookings.SERVICE_FEE,
    silver_bookings.CLEANING_FEE,
    silver_bookings.BOOKING_STATUS,
    silver_bookings.CREATED_AT AS BOOKING_CREATED_AT,

    -- Listings
    silver_listings.HOST_ID,
    silver_listings.PROPERTY_TYPE,
    silver_listings.ROOM_TYPE,
    silver_listings.CITY,
    silver_listings.PRICE_PER_NIGHT,
    silver_listings.CREATED_AT AS LISTING_CREATED_AT,

    -- Hosts
    silver_hosts.HOST_NAME,
    silver_hosts.HOST_SINCE,
    silver_hosts.IS_SUPERHOST,
    silver_hosts.RESPONSE_RATE,
    silver_hosts.RESPONSE_RATE_QUALITY,
    silver_hosts.CREATED_AT AS HOST_CREATED_AT

FROM DBT_LEARN.silver.silver_bookings AS silver_bookings
LEFT JOIN DBT_LEARN.silver.silver_listings AS silver_listings
    ON silver_bookings.LISTING_ID = silver_listings.LISTING_ID
LEFT JOIN DBT_LEARN.silver.silver_hosts AS silver_hosts
    ON silver_listings.HOST_ID = silver_hosts.HOST_ID    