bigquery_schemas = {
    "francetravailoffers": [
        {"name": "id", "type": "STRING", "mode": "NULLABLE"},
        {"name": "intitule", "type": "STRING", "mode": "NULLABLE"},
        {"name": "description", "type": "STRING", "mode": "NULLABLE"},
        {"name": "dateCreation", "type": "TIMESTAMP", "mode": "NULLABLE"},
        {"name": "dateActualisation", "type": "TIMESTAMP", "mode": "NULLABLE"},
        {
            "name": "lieuTravail",
            "type": "RECORD",
            "mode": "NULLABLE",
            "fields": [
                {"name": "libelle", "type": "STRING", "mode": "NULLABLE"},
                {"name": "latitude", "type": "FLOAT64", "mode": "NULLABLE"},
                {"name": "longitude", "type": "FLOAT64", "mode": "NULLABLE"},
                {"name": "codePostal", "type": "STRING", "mode": "NULLABLE"},
                {"name": "commune", "type": "STRING", "mode": "NULLABLE"},
            ]
        },
        {"name": "romeCode", "type": "STRING", "mode": "NULLABLE"},
        {"name": "romeLibelle", "type": "STRING", "mode": "NULLABLE"},
        {"name": "appellationlibelle", "type": "STRING", "mode": "NULLABLE"},
        {"name": "typeContrat", "type": "STRING", "mode": "NULLABLE"},
        {"name": "typeContratLibelle", "type": "STRING", "mode": "NULLABLE"},
        {"name": "natureContrat", "type": "STRING", "mode": "NULLABLE"},
        {"name": "experienceExige", "type": "STRING", "mode": "NULLABLE"},
        {"name": "experienceLibelle", "type": "STRING", "mode": "NULLABLE"},
        {
            "name": "salaire",
            "type": "RECORD",
            "mode": "NULLABLE",
            "fields": [
                {"name": "libelle", "type": "STRING", "mode": "NULLABLE"}
            ]
        },
        {"name": "dureeTravailLibelle", "type": "STRING", "mode": "NULLABLE"},
        {"name": "dureeTravailLibelleConverti", "type": "STRING", "mode": "NULLABLE"},
        {"name": "alternance", "type": "BOOLEAN", "mode": "NULLABLE"},
        {"name": "accessibleTH", "type": "BOOLEAN", "mode": "NULLABLE"},
        {"name": "qualificationCode", "type": "STRING", "mode": "NULLABLE"},
        {"name": "qualificationLibelle", "type": "STRING", "mode": "NULLABLE"},
        {"name": "codeNAF", "type": "STRING", "mode": "NULLABLE"},
        {"name": "secteurActivite", "type": "STRING", "mode": "NULLABLE"},
        {"name": "secteurActiviteLibelle", "type": "STRING", "mode": "NULLABLE"},
        {"name": "urlOrigine", "type": "STRING", "mode": "NULLABLE"},
        {"name": "offresManqueCandidats", "type": "BOOLEAN", "mode": "NULLABLE"}
    ]
}
