from fastapi import FastAPI, Query
import requests
import os
from dotenv import load_dotenv

# Load environment variables from the .env file
load_dotenv()

app = FastAPI()

FRANCE_TRAVAIL_API_URL = "https://api.francetravail.io/partenaire/offresdemploi/v2/offres/search"

# Check if the environment variables are loaded correctly
CLIENT_KEY = os.getenv("TOKEN")
print(CLIENT_KEY)

# Ensure the Client Key is passed as Bearer token
headers = {
    "Authorization": f"Bearer {CLIENT_KEY}",
    "Accept": "application/json",

}

@app.get("/")
def test_connection():
    """Test the connection to the France Travail API."""
    print(f"Bearer token being used: {CLIENT_KEY}")
    headers = {
    "Authorization": f"Bearer {CLIENT_KEY}",
    "Accept": "application/json",
}

    try:
        response = requests.get(FRANCE_TRAVAIL_API_URL, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.HTTPError as http_err:
        return {"status": "error", "message": f"HTTP error occurred: {http_err}"}
    except Exception as err:
        return {"status": "error", "message": f"An error occurred: {err}"}

# Existing route for actual data fetching
@app.get("/search")
def search_offers(
    q: str = Query(None, description="Search query"),
    code_metier: str = Query(None, description="Job code (ROME)"),
    commune: str = Query(None, description="Commune INSEE code"),
    rayon: int = Query(30, description="Search radius in kilometers"),
    min_salaire: int = Query(None, description="Minimum salary"),
    max_salaire: int = Query(None, description="Maximum salary"),
    contrat_type: str = Query(None, description="Type of contract"),
    page: int = Query(1, description="Page number"),
    limit: int = Query(10, description="Number of results per page"),
    publieeDepuis: int = Query(7, description="Number of days since publication")
):
    """Search for job offers based on the provided query parameters."""

    query_params = {
        "q": q,
        "codeMetier": code_metier,
        "commune": commune,
        "rayon": rayon,
        "minSalaire": min_salaire,
        "maxSalaire": max_salaire,
        "typeContrat": contrat_type,
        "page": page,
        "limit": limit,
        "publieeDepuis": publieeDepuis
    }

    # Remove any query parameters that are None
    query_params = {k: v for k, v in query_params.items() if v is not None}

    headers = {
    "Authorization": f"Bearer {CLIENT_KEY}",
    "Accept": "application/json",
    }

    try:
        response = requests.get(FRANCE_TRAVAIL_API_URL, headers=headers, params=query_params)
        response.raise_for_status()
        # print(response.json())
        return response.json()
    except requests.exceptions.HTTPError as http_err:
        return {"error": f"HTTP error occurred: {http_err}"}
    except Exception as err:
        return {"error": f"An error occurred: {err}"}

def get_offers() -> dict:
    """Get a list of offers. Return a dictionary containing the results."""
    #pass  # YOUR CODE HERE
    input = test_connection()
    json_data = input
    offers_dict = json_data['resultats']
    print(offers_dict[0])
    return offers_dict

# if __name__ == "__main__":
#     test_connection()
