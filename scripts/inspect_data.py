
import csv
from pathlib import Path

# Lokasi folder dataset
PROJECT_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = PROJECT_DIR / "data" / "raw"


def inspect_csv_files():
    csv_files = sorted(DATA_DIR.glob("*.csv"))

    if not csv_files:
        print("Tidak ada file CSV ditemukan!")
        return

    print("=" * 70)
    print("OLIST DATASET INSPECTION")
    print("=" * 70)

    for file_path in csv_files:
        print(f"\nFile: {file_path.name}")
        print(f"Ukuran: {file_path.stat().st_size / (1024 * 1024):.2f} MB")

        try:
            with open(
                file_path,
                mode="r",
                encoding="utf-8-sig",
                newline=""
            ) as file:
                reader = csv.reader(file)
                columns = next(reader, [])

                total_rows = sum(1 for _ in reader)

                print(f"Jumlah baris : {total_rows:,}")
                print(f"Jumlah kolom : {len(columns)}")
                print(f"Nama kolom   : {columns}")

        except Exception as error:
            print(f"ERROR: {error}")

    print("\n" + "=" * 70)
    print("INSPEKSI DATA SELESAI")
    print("=" * 70)


if __name__ == "__main__":
    inspect_csv_files()
