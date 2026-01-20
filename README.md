# AWS S3 to Snowflake Data Pipeline with dbt Medallion Architecture

## Project Overview

This project implements a modern data engineering pipeline that extracts raw data from Amazon Web Services Simple Storage Service (AWS S3), loads it into Snowflake, and transforms it using dbt following the medallion architecture pattern. The pipeline processes booking, listing, and host data for a property rental platform.

## Table of Contents

1. [Architecture](#architecture)
2. [Data Flow](#data-flow)
3. [Medallion Architecture Layers](#medallion-architecture-layers)
4. [Project Structure](#project-structure)
5. [Setup and Configuration](#setup-and-configuration)
6. [Running the Pipeline](#running-the-pipeline)
7. [CI/CD Pipeline](#cicd-pipeline)

---

## Architecture

The solution follows a three-tier medallion architecture, which provides a structured approach to data transformation and quality improvement at each stage.

```
AWS S3 (Raw Files)
       |
       v
Snowflake External Stage
       |
       v
+------------------+     +------------------+     +------------------+
|   Bronze Layer   | --> |   Silver Layer   | --> |    Gold Layer    |
|   (Raw Ingest)   |     |   (Cleaned)      |     |   (Analytics)    |
+------------------+     +------------------+     +------------------+
```

### Technology Stack

- **Cloud Storage**: Amazon S3
- **Data Warehouse**: Snowflake
- **Transformation Tool**: dbt (Data Build Tool)
- **CI/CD**: GitHub Actions
- **Language**: SQL with Jinja templating

---

## Data Flow

### Stage 1: Data Ingestion from AWS S3

Raw data files are stored in an S3 bucket and made accessible to Snowflake through an external stage. Snowflake connects to the S3 bucket using AWS credentials and loads the data into staging tables.

The raw tables include:
- **raw_bookings**: Contains reservation and booking transaction data
- **raw_listings**: Contains property listing information
- **raw_hosts**: Contains host profile and response data

### Stage 2: Bronze Layer Processing

The bronze layer performs initial data ingestion from the staging area. Models in this layer use incremental materialization to efficiently process only new records based on the CREATED_AT timestamp. This approach reduces processing time and compute costs for subsequent runs.

### Stage 3: Silver Layer Transformation

The silver layer applies business logic and data cleansing transformations. This includes:
- Data type standardization
- Calculated fields such as total booking amounts
- Host response quality categorization
- String formatting and normalization

### Stage 4: Gold Layer Aggregation

The gold layer creates analytics-ready datasets by joining the silver layer tables into denormalized structures. The One Big Table pattern is used to create a comprehensive view that combines bookings, listings, and host information for downstream reporting and analysis.

---

## Medallion Architecture Layers

### Bronze Layer

The bronze layer serves as the landing zone for raw data. It maintains data in its original form with minimal transformation, preserving the source system structure for auditability and reprocessing capabilities.

**Models:**
- bronze_bookings: Raw booking transactions
- bronze_listings: Raw property listings
- bronze_hosts: Raw host profiles

**Characteristics:**
- Incremental loading based on creation timestamp
- Schema matches source system
- No business logic applied

### Silver Layer

The silver layer contains cleansed and standardized data. Business rules are applied here to ensure data quality and consistency across the organization.

**Models:**
- silver_bookings: Cleaned bookings with calculated total amounts
- silver_listings: Standardized listings with price categorization
- silver_hosts: Processed hosts with response quality ratings

**Transformations Applied:**
- TOTAL_AMOUNT: Calculated from nights booked and booking amount
- RESPONSE_RATE_QUALITY: Categorized as Very Good, Good, Fair, or Poor based on response rate thresholds
- HOST_NAME: Formatted with underscores replacing spaces

### Gold Layer

The gold layer provides business-ready datasets optimized for analytics and reporting. Tables are denormalized and structured for query performance.

**Models:**
- obt: One Big Table joining bookings, listings, and hosts
- fact: Fact table for dimensional modeling

---

## Project Structure

```
snowflake_aws_dbt_project/
    models/
        sources/
            sources.yml          # Source definitions for staging tables
        bronze/
            bronze_bookings.sql  # Raw bookings ingestion
            bronze_listings.sql  # Raw listings ingestion
            bronze_hosts.sql     # Raw hosts ingestion
        silver/
            silver_bookings.sql  # Cleaned bookings
            silver_listings.sql  # Cleaned listings
            silver_hosts.sql     # Cleaned hosts
        gold/
            obt.sql              # One Big Table
            fact.sql             # Fact table
            ephemeral/
                bookings.sql     # Ephemeral booking transformations
                listings.sql     # Ephemeral listing transformations
                hosts.sql        # Ephemeral host transformations
        properties.yml           # Model tests and documentation
    macros/
        generate_schema_name.sql # Custom schema naming
        multiply.sql             # Multiplication helper
        tag.sql                  # Tagging helper
        trimmer.sql              # String trimming helper
    profiles.yml                 # Connection configuration
    dbt_project.yml              # Project configuration
```

---

## Setup and Configuration

### Prerequisites

- Python 3.12 or higher
- Snowflake account with appropriate permissions
- AWS S3 bucket with raw data files
- Git for version control

### Installation

1. Clone the repository:
   ```
   git clone <repository-url>
   cd aws_dbt_snowflake_project/snowflake_aws_dbt_project
   ```

2. Create and activate a virtual environment:
   ```
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. Install dependencies:
   ```
   pip install dbt-snowflake
   ```

4. Configure environment variables:
   ```
   export SNOWFLAKE_ACCOUNT="your_account"
   export SNOWFLAKE_USER="your_username"
   export SNOWFLAKE_PASSWORD="your_password"
   export SNOWFLAKE_ROLE="your_role"
   export SNOWFLAKE_WAREHOUSE="your_warehouse"
   export SNOWFLAKE_DATABASE="your_database"
   export SNOWFLAKE_SCHEMA="your_schema"
   ```

5. Verify the connection:
   ```
   dbt debug
   ```

---

## Running the Pipeline

### Full Pipeline Execution

To run all models in dependency order:
```
dbt run
```

### Layer-Specific Execution

Run bronze layer only:
```
dbt run --select bronze
```

Run silver layer only:
```
dbt run --select silver
```

Run gold layer only:
```
dbt run --select gold
```

### Testing

Execute all tests:
```
dbt test
```

### Documentation

Generate and serve documentation:
```
dbt docs generate
dbt docs serve
```

---

## CI/CD Pipeline

The project includes a GitHub Actions workflow that automates testing and deployment.

### Pipeline Triggers

- **Pull Request to main**: Runs dbt build and test to validate changes
- **Push to main**: Deploys to production and generates documentation

### Workflow Steps

1. Checkout code from repository
2. Set up Python environment
3. Install dbt-snowflake
4. Run dbt deps to install packages
5. Run dbt debug to verify connection
6. Run dbt build to compile and execute models
7. Run dbt test to validate data quality
8. Generate and upload artifacts

### Required Secrets

The following secrets must be configured in the GitHub repository settings:

- SNOWFLAKE_ACCOUNT
- SNOWFLAKE_USER
- SNOWFLAKE_PASSWORD
- SNOWFLAKE_ROLE
- SNOWFLAKE_WAREHOUSE
- SNOWFLAKE_DATABASE
- SNOWFLAKE_SCHEMA

---

## Data Quality

Data quality is enforced through dbt tests defined in the properties.yml file:

- **Not Null Tests**: Ensure primary key columns contain values
- **Unique Tests**: Verify no duplicate records exist for key columns

Primary keys tested:
- host_id in bronze_hosts
- listing_id in bronze_listings
- booking_id in bronze_bookings

---

## Contributing

1. Create a feature branch from main
2. Make changes and test locally with dbt run and dbt test
3. Submit a pull request to main
4. CI pipeline will validate changes automatically
5. Upon approval and merge, changes deploy to production

---

## License

This project is proprietary and confidential.
