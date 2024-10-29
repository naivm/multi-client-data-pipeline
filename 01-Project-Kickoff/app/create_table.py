from schemas import bigquery_schemas
from google.cloud import bigquery
from dotenv import load_dotenv

import os

# Load environment variables from .env file
load_dotenv()

def convert_schema(schema):
    """
    Convert the schema to the format expected by bigquery.SchemaField.
    This handles nested RECORD fields.
    """
    converted_schema = []
    for field in schema:
        if "fields" in field:
            # Handle RECORD type (nested fields)
            sub_fields = convert_schema(field["fields"])
            converted_schema.append(
                bigquery.SchemaField(
                    name=field["name"],
                    field_type=field["type"],
                    mode=field["mode"],
                    fields=sub_fields  # Add the nested schema
                )
            )
        else:
            # Regular field
            converted_schema.append(
                bigquery.SchemaField(
                    name=field["name"],
                    field_type=field["type"],
                    mode=field["mode"]
                )
            )
    return converted_schema


def main():
    """
    Main function to take the bigquery schemas and create the tables in the raw dataset.
    """
    client = bigquery.Client()

    dataset_name = os.environ.get("BIGQUERY_DATASET")

    # Debug: Print the dataset name to verify it's being read correctly
    print(f"Dataset name from environment variable: {dataset_name}")

    if not dataset_name:
        raise ValueError("BIGQUERY_DATASET environment variable is not set")

    # Reference to the dataset
    dataset_ref = client.dataset(dataset_name)

    # Debug: Print the dataset reference to verify it's correct
    print(f"Dataset reference: {dataset_ref}")

    for table_name, schema in bigquery_schemas.items():
            # Define table reference
            table_ref = dataset_ref.table(table_name)

            try:
                # Check if the table exists
                client.get_table(table_ref)
                print(f"Table {table_name} already exists. Skipping creation.")
            except bigquery.NotFound:
                # Table does not exist, so create it
                table_schema = convert_schema(schema)
                table = bigquery.Table(table_ref, schema=table_schema)
                try:
                    client.create_table(table)
                    print(f"Table {table_name} created successfully.")
                except Exception as e:
                    print(f"Failed to create table {table_name}: {e}")


if __name__ == "__main__":
    main()
