import os
import requests
import pandas as pd

def get_hydro_power_plants_in_operation():
    url = "https://api.nve.no/web/Powerplant/GetHydroPowerplantsInOperation"

    # Make the request, return data
    response = requests.get(url)
    data = response.json()

    # Path to the existing Energi folder
    output_folder = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "04_Klima og ressursforvaltning", "Energi")
    os.makedirs(output_folder, exist_ok=True)
    
    # Convert to pandas dataframe and save as CSV
    df = pd.DataFrame(data)
    output_path = os.path.join(output_folder, "nve_kraft.csv")
    df.to_csv(output_path, index=False)
    print(f"Data saved to {output_path}")

if __name__ == '__main__':
    get_hydro_power_plants_in_operation()