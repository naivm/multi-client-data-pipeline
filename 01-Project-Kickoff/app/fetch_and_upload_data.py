import os
import requests
import create_table
from google.cloud import bigquery
from main import get_offers

# Step 1: Define the schema for the table
create_table.main()

# Step 2: Fetch JSON Data from FastAPI Endpoint
def fetch_api_data():
    try:
        response = get_offers()
        # print(response)
        return response  # Extract the 'resultats' field from the API response
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")
        return []

#  Step 3: Upload JSON Data to BigQuery (append each row)
def upload_to_bigquery(json_data):
    client = bigquery.Client()
    table_id = os.getenv('BIGQUERY_TABLE_ID')  # Make sure to set this environment variable

    # Prepare rows for BigQuery, limit to the first 100 items
    rows_to_insert = []
    for job in json_data[:100]:  # Limiting to the first 100 jobs
        row = {
            "id": job["id"],
            "intitule": job["intitule"],
            "description": job.get("description"),
            "dateCreation": job["dateCreation"],
            "dateActualisation": job.get("dateActualisation"),
            "lieuTravail": {
                "libelle": job["lieuTravail"].get("libelle"),
                "latitude": job["lieuTravail"].get("latitude"),
                "longitude": job["lieuTravail"].get("longitude"),
                "codePostal": job["lieuTravail"].get("codePostal"),
                "commune": job["lieuTravail"].get("commune"),
            },
            "romeCode": job.get("romeCode"),
            "romeLibelle": job.get("romeLibelle"),
            "appellationlibelle": job.get("appellationlibelle"),
            "typeContrat": job.get("typeContrat"),
            "typeContratLibelle": job.get("typeContratLibelle"),
            "natureContrat": job.get("natureContrat"),
            "experienceExige": job.get("experienceExige"),
            "experienceLibelle": job.get("experienceLibelle"),
            "salaire": {
                "libelle": job["salaire"].get("libelle"),
            },
            "dureeTravailLibelle": job.get("dureeTravailLibelle"),
            "dureeTravailLibelleConverti": job.get("dureeTravailLibelleConverti"),
            "alternance": job.get("alternance"),
            "accessibleTH": job.get("accessibleTH"),
            "qualificationCode": job.get("qualificationCode"),
            "qualificationLibelle": job.get("qualificationLibelle"),
            "codeNAF": job.get("codeNAF"),
            "secteurActivite": job.get("secteurActivite"),
            "secteurActiviteLibelle": job.get("secteurActiviteLibelle"),
            "urlOrigine": job["origineOffre"].get("urlOrigine"),
            "offresManqueCandidats": job.get("offresManqueCandidats", False),
        }
        rows_to_insert.append(row)

    # Insert (append) rows into BigQuery table
    errors = client.insert_rows_json(table_id, rows_to_insert)

    if not errors:
        print("Data successfully uploaded to BigQuery.")
    else:
        print(f"Encountered errors while uploading: {errors}")

# Step 4: Run the Functions to Fetch Data and Upload to BigQuery
def main():
    data = fetch_api_data()
    if data:
        upload_to_bigquery(data)
    else:
        print("No data to upload.")

if __name__ == "__main__":
    main()
