#### Dette er et testscript for å spørre etter og behandle data fra SSBs API.
#### Marker kode og trykk "Shift + Enter" for å kjøre den valgte koden.

######## Laste nødvendige (standard-)pakker

import requests  # For å kjøre spørringer mot alle mulige APIer ++
import pandas as pd  # For å håndtere data i tabellform. Standard i "Data science"
from pyjstat import pyjstat  # Anbefalt av SSB for å håndtere JSON-stat2 formatet

######## Hente data fra SSB API

# Endepunkt for SSB API
url = "https://data.ssb.no/api/v0/no/table/14288/"

# Spørring fra SSB API (kjent fra før..)
tfk_query = {
  "query": [
    {
      "code": "Region",
      "selection": {
        "filter": "vs:KommunFram2024Agg",
        "values": [
          "4212"
        ]
      }
    },
    {
      "code": "Alder",
      "selection": {
        "filter": "item",
        "values": [
          "000","001","002","003","004","005","006","007","008","009",
          "010","011","012","013","014","015","016","017","018","019",
          "020","021","022","023","024","025","026","027","028","029",
          "030","031","032","033","034","035","036","037","038","039",
          "040","041","042","043","044","045","046","047","048","049",
          "050","051","052","053","054","055","056","057","058","059",
          "060","061","062","063","064","065","066","067","068","069",
          "070","071","072","073","074","075","076","077","078","079",
          "080","081","082","083","084","085","086","087","088","089",
          "090","091","092","093","094","095","096","097","098","099",
          "100"
        ]
      }
    },
    {
      "code": "ContentsCode",
      "selection": {
        "filter": "item",
        "values": [
          "Personer"
        ]
      }
    }
  ],
  "response": {
    "format": "json-stat2"
  }
}

######## Spørring vha. "requests"-modulen (Promt til ChatGPT: "Gi meg Python-kode for å hente data fra SSBs API ved hjelp av følgende kode: [limte inn alt over denne linjen]")

# Send POST-forespørselen
response = requests.post(url, json=tfk_query)

# Sjekk om forespørselen var vellykket
if response.status_code == 200:
    print("Forespørsel vellykket!")

    # Last JSON-stat2-data direkte til Dataset-objektet
    dataset = pyjstat.Dataset(response.json())

    # Konverter dataset til pandas DataFrame
    df = dataset.write("dataframe")

    # Skriv ut DataFrame for å verifisere data
    print(df.head())
else:
    print(f"Feil ved henting av data. Statuskode: {response.status_code}")
    print(response.text)


######## Leke seg med datasett (kalles en "dataframe" i pandas)

## Skriv # etterfulgt av en enkel beskrivelse av hva du ønsker å gjøre med datasettet.
## Trykk "Enter", vent på forslag fra Github Copilot, og trykk "Tab" for å godta forslaget.

# Vis grunnleggende info om datasettet
df.info()

# Vis de første 5 radene i datasettet
df.head()

## TIPS: Dobbeltklikke på en enkeltvariabel (f. eks. "df") og trykk "Shift + Enter" for å se innholdet i variabelen.
# Sammenlikne f. eks. "print(df)" med å dobbeltklikke på "df" og trykke "Shift + Enter"

######## Til slutt: Skrive endelig dataframe (df) til .csv-fil
df.to_csv("Bef_test.csv", index=False)
