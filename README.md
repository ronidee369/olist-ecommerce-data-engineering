# Olist E-Commerce Data Engineering Pipeline

**An End-to-End Data Engineering Project | Python · Google BigQuery · dbt Core · Apache Airflow · Docker**

Building an end-to-end data pipeline to ingest, store, transform, test, and orchestrate Brazilian e-commerce data using modern data engineering technologies.

---

## Project Architecture

![Olist E-Commerce Data Pipeline Architecture](docs/images/Olist%20E-Commerce%20Data%20Pipeline.png)

The pipeline consists of five main stages, starting from raw e-commerce data and ending with automated workflow orchestration using Apache Airflow.

## Project Overview

This project demonstrates the implementation of an end-to-end data engineering pipeline using the Brazilian E-Commerce Public Dataset by Olist.

The objective is to transform raw CSV datasets into structured and reliable data models using Google BigQuery and dbt Core, with Apache Airflow managing the transformation and data quality testing workflow.

The project covers five stages:

1. Data Source
2. Data Ingestion
3. Data Storage
4. Data Transformation
5. Workflow Orchestration

## Dataset

**Brazilian E-Commerce Public Dataset by Olist**

- **Source:** Kaggle
- **Link:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Period:** 2016–2018
- **Volume:** Approximately 100,000 orders
- **Format:** CSV

The dataset contains nine related tables:

| Dataset | Description |
|---|---|
| Customers | Customer information |
| Geolocation | Brazilian geographic information |
| Orders | Order transactions and status |
| Order Items | Products included in each order |
| Order Payments | Payment information |
| Order Reviews | Customer reviews and ratings |
| Products | Product information |
| Sellers | Seller information |
| Product Category Translation | Product category translations |

The original CSV files are not included in this repository. Download the dataset from Kaggle and place the files inside `data/raw/`.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Data inspection and ingestion |
| Google BigQuery | Cloud data warehouse |
| dbt Core | Data transformation and testing |
| Apache Airflow | Workflow orchestration |
| Docker | Containerized Airflow environment |
| Git & GitHub | Version control |

---

## End-to-End Data Pipeline

### 1. Data Source — Olist Dataset

The pipeline starts with the Brazilian E-Commerce Public Dataset by Olist.

The dataset provides nine CSV files containing information about customers, orders, products, sellers, payments, reviews, and geolocation.

### 2. Data Ingestion — Python

Python is used to inspect and upload the raw CSV datasets into Google BigQuery.

Main scripts:

- `scripts/inspect_data.py` — inspects CSV files, row counts, columns, and file sizes.
- `scripts/upload_to_bigquery.py` — loads CSV files into BigQuery.

### 3. Data Storage — Google BigQuery

Google BigQuery acts as the central cloud data warehouse.

All nine source datasets are loaded into the `olist_raw` dataset.

**Raw Layer:**
- 9 source tables
- 1,556,922 total rows uploaded

### 4. Data Transformation — dbt Core

dbt Core transforms raw datasets into structured data models using a three-layer architecture.

| Layer | Models | Materialization | Purpose |
|---|---:|---|---|
| Staging | 9 | Views | Standardize and prepare source data |
| Intermediate | 4 | Views | Build reusable transformation logic |
| Marts | 5 | Tables | Produce final analytical data models |
| **Total** | **18** | | |

**Staging Models**
- `stg_customers`
- `stg_geolocation`
- `stg_orders`
- `stg_order_items`
- `stg_order_payments`
- `stg_order_reviews`
- `stg_products`
- `stg_product_category_translation`
- `stg_sellers`

**Intermediate Models**
- `int_orders`
- `int_order_items`
- `int_payments`
- `int_reviews`

**Marts Models**
- `dim_customers`
- `dim_products`
- `dim_sellers`
- `fct_orders`
- `fct_order_items`

### 5. Workflow Orchestration — Apache Airflow

Apache Airflow orchestrates the dbt transformation and data quality testing workflow inside a Docker container.

The DAG is named:

`olist_dbt_pipeline`

The workflow contains two sequential tasks:

```text
dbt_run
   |
   v
dbt_test
```

**Task 1 — dbt_run**

Executes all dbt transformation models in BigQuery.

**Task 2 — dbt_test**

Executes dbt data quality tests after the transformation succeeds.

The DAG has been manually triggered and successfully verified through the Apache Airflow web interface.

**Note:** The current DAG orchestrates dbt transformations and tests. Python data ingestion is executed separately through the ingestion script.

---

## Data Quality & Validation Results

The pipeline has been validated through dbt model execution and data quality testing.

| Validation | Result |
|---|---:|
| Staging Models | 9/9 PASS |
| Intermediate Models | 4/4 PASS |
| Marts Models | 5/5 PASS |
| Total dbt Models | 18/18 PASS |
| Data Quality Tests | 51/51 PASS |
| Warnings | 0 |
| Errors | 0 |

**Final validation status: All 18 models and 51 tests passed successfully.**

## Project Structure

```text
olist-ecommerce-data-engineering/
│
├── airflow/
│   ├── dags/
│   │   ├── hello_airflow.py
│   │   └── olist_dbt_pipeline.py
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   └── .env.example
│
├── data/
│   └── raw/
│
├── docs/
│   └── images/
│       └── Olist E-Commerce Data Pipeline.png
│
├── olist_dbt/
│   ├── models/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── marts/
│   ├── analyses/
│   ├── macros/
│   ├── seeds/
│   ├── snapshots/
│   ├── tests/
│   └── dbt_project.yml
│
├── scripts/
│   ├── inspect_data.py
│   └── upload_to_bigquery.py
│
└── .gitignore
```

## Getting Started

### Prerequisites

- Python 3.12
- Docker Desktop
- Google Cloud project with BigQuery access
- Google Cloud CLI
- dbt Core and dbt-bigquery
- Git

### 1. Clone the Repository

```bash
git clone <your-github-repository-url>
cd olist-ecommerce-data-engineering
```

### 2. Download the Dataset

Download the CSV files from:

[Olist Brazilian E-Commerce Dataset — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Extract the nine CSV files into:

```text
data/raw/
```

### 3. Configure Google Cloud and dbt

Authenticate with Google Cloud and configure your local dbt profile.

Your dbt profile must contain your own Google Cloud project ID, BigQuery dataset, location, and authentication method.

Do not commit credentials or personal configuration files.

### 4. Run Data Ingestion

Install the required Python dependencies and configure the Google Cloud project ID in `scripts/upload_to_bigquery.py`.

Run:

```bash
python scripts/inspect_data.py
python scripts/upload_to_bigquery.py
```

**Important:** The ingestion script uses `WRITE_TRUNCATE`, which replaces existing destination tables when uploading again.

### 5. Run dbt Transformations

From the project root:

```bash
dbt debug --project-dir ./olist_dbt --profiles-dir ~/.dbt

dbt run --project-dir ./olist_dbt --profiles-dir ~/.dbt

dbt test --project-dir ./olist_dbt --profiles-dir ~/.dbt
```

On Windows, use your actual dbt profiles directory if `~/.dbt` is not resolved correctly.

### 6. Configure Airflow

Navigate to the Airflow directory:

```bash
cd airflow
```

Copy the example configuration file:

```powershell
Copy-Item .env.example .env
```

Update the local file paths in `.env` to match your machine.

Configure access to your dbt profile and Google Cloud application default credentials.

### 7. Start Airflow with Docker

From the `airflow/` directory:

```bash
docker compose --env-file .env up --build -d
```

Open the Airflow web interface:

[http://localhost:8080](http://localhost:8080)

Trigger the `olist_dbt_pipeline` DAG to execute the dbt transformation and testing workflow.

---

## Important Notes

- This project was developed using Google BigQuery Sandbox. Sandbox limitations and table expiration policies apply.
- The raw CSV dataset is excluded from this repository and must be downloaded separately.
- Google Cloud credentials, dbt profiles, and local `.env` files must never be committed.
- The current implementation ends at Apache Airflow orchestration.
- No dashboard or BI layer is included in this project.

## Acknowledgements

Dataset provided by Olist:

[Brazilian E-Commerce Public Dataset by Olist — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Please refer to the original dataset page for licensing and attribution information.

---

**Built as a hands-on Data Engineering portfolio project.**