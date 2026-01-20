{% set cols = ['nights_booked', 'booking_date', 'booking_amount'] %}

SELECT 
{% for col in cols %}
    {{ col }}
    {% if not loop.last %}, {% endif %}
{% endfor %}
FROM {{ ref('bronze_bookings') }}
