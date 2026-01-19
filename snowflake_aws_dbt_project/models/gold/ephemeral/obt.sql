{% set configs = [                                                                                                  
      {                                                                                                               
          "table": "DBT_LEARN.silver.silver_bookings",                                                                
          "column": "*",                                                                                              
          "alias": "silver_bookings"                                                                                  
      },                                                                                                              
      {                                                                                                               
          "table": "DBT_LEARN.silver.silver_listings",                                                                
          "column": "silver_listings.host_id, silver_listings.listing_name, silver_listings.listing_description,      
  silver_listings.listing_type, silver_listings.listing_price, silver_listings.listing_location,                      
  silver_listings.listing_created_at, silver_listings.listing_updated_at",                                            
          "alias": "silver_listings",                                                                                 
          "join_condition": "silver_bookings.LISTING_ID = silver_listings.LISTING_ID"                                 
      },                                                                                                              
      {                                                                                                               
          "table": "DBT_LEARN.silver.silver_hosts",                                                                   
          "column": "silver_hosts.HOST_NAME, silver_hosts.HOST_SINCE, silver_hosts.IS_SUPERHOST,                      
  silver_hosts.created_at, silver_hosts.RESPONSE_RATE, silver_hosts.RESPONSE_TIME",                                   
          "alias": "silver_hosts",                                                                                    
          "join_condition": "silver_listings.HOST_ID = silver_hosts.HOST_ID"                                          
      }                                                                                                               
  ] %}   