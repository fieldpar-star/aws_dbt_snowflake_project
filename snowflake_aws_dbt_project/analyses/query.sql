SELECT                                                                        
                                                     
          silver_bookings.*,                 
                                                     
          silver_listings.HOST_ID, silver_listings.PROPERTY_TYPE,    
  silver_listings.ROOM_TYPE, silver_listings.CITY,                              
  silver_listings.PRICE_PER_NIGHT, silver_listings.CREATED_AT,                 
                                                     
          silver_hosts.HOST_NAME, silver_hosts.HOST_SINCE,           
  silver_hosts.IS_SUPERHOST, silver_hosts.RESPONSE_RATE,                        
  silver_hosts.RESPONSE_RATE_QUALITY, silver_hosts.CREATED_AT                 
                                                                    
  FROM                                                                          
                                                     
                                                             
              DBT_LEARN.silver.silver_bookings AS silver_bookings                          
                                                                     
                                                     
                                                                      
              LEFT JOIN DBT_LEARN.silver.silver_listings AS silver_listings                
                  ON silver_bookings.LISTING_ID =                       
  silver_listings.LISTING_ID                                
                                                                     
                                                     
                                                                      
              LEFT JOIN DBT_LEARN.silver.silver_hosts AS silver_hosts                
                  ON silver_listings.HOST_ID = silver_hosts.HOST_ID                                
                                                                     
          