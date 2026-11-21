
from pathlib import Path
from google.cloud import bigquery

# Lokasi project dan dataset BigQuery
PROJECT_ID = "mytest-379811"
DATASET_ID = "olist_raw"
LOCATION = "US"

# Lokasi folder CSV
BASE_DIR = Path(__file__).resolve().parents[1]
RAW_DIR = BASE_DIR / "data" / "raw"

# Inisialisasi BigQuery
client = bigquery.Client(project=PROJECT_ID)

csv_files = sorted(RAW_DIR.glob("*.csv"))

if not csv_files:
    raise FileNotFoundError(f"Tidak ada file CSV di {RAW_DIR}")

print(f"Menemukan {len(csv_files)} file CSV.\n")

for csv_file in csv_files:
    table_id = (
        f"{PROJECT_ID}.{DATASET_ID}.{csv_file.stem}"
    )

    print(f"Mengupload: {csv_file.name}")

    job_config = bigquery.LoadJobConfig(
    source_format=bigquery.SourceFormat.CSV,
    skip_leading_rows=1,
    autodetect=True,
    allow_quoted_newlines=True,
    write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
    )

    with csv_file.open("rb") as file:
        job = client.load_table_from_file(
            file,
            table_id,
            job_config=job_config,
            location=LOCATION,
        )

    job.result()

    table = client.get_table(table_id)

    print(
        f"Berhasil: {table.table_id} "
        f"| Rows: {table.num_rows:,}"
    )

print("\nSemua proses upload selesai!")
