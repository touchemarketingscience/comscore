# Author: Roman-GPT Python Ver.

import pandas as pd
import numpy as np

# Choose file
file_path = input("Enter the path to your file: ")

# Read the CSV file
indigo = pd.read_csv(file_path)

# Convert guid and brand columns to string
indigo['guid'] = indigo['guid'].astype(str)
indigo['brand'] = indigo['brand'].astype(str)

# Get unique brands
unique_brands = indigo['brand'].unique()

# Create an empty dataframe with row and column names as unique brands
data = pd.DataFrame(0, index=unique_brands, columns=unique_brands)

# Loop through each combination of brand pairs
for i, brand_i in enumerate(unique_brands):
    guids_i = indigo[indigo['brand'] == brand_i]['guid'].unique()
    
    for j, brand_j in enumerate(unique_brands):
        guids_j = indigo[indigo['brand'] == brand_j]['guid'].unique()

        # Calculate cross-visitation proportion
        common_guids = np.sum(np.isin(guids_i, guids_j))
        data.iloc[i, j] = common_guids / len(guids_i)

# Write the output to a CSV file
data.to_csv('cv_pets.csv')
