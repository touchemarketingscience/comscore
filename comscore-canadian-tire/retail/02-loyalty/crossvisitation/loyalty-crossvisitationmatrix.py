import pandas as pd
import numpy as np
from tqdm import tqdm

# Use a fixed file name for input
file_path = "cross_visitation_input.csv"

# Load data from CSV file into a DataFrame
dataframe = pd.read_csv(file_path)

# Convert 'guid' and 'brand' columns to string data type
dataframe['guid'] = dataframe['guid'].astype(str)
dataframe['brand'] = dataframe['brand'].astype(str)

# Extract unique brands from the DataFrame
unique_brands = dataframe['brand'].unique()

# Create a dictionary to store unique 'guids' for each brand
brand_guids_dict = {brand: set(dataframe[dataframe['brand'] == brand]['guid'].unique()) for brand in unique_brands}

# Initialize an empty DataFrame with rows and columns labeled with unique brands
cross_visitation_matrix = pd.DataFrame(0, index=unique_brands, columns=unique_brands)

# Loop over each unique brand to calculate cross-visitation proportions
for i, current_brand in tqdm(enumerate(unique_brands), total=len(unique_brands), desc="Processing brands"):
    # Get unique 'guid's associated with the current brand from the precomputed dictionary
    current_brand_guids = brand_guids_dict[current_brand]
    
    for j, comparison_brand in enumerate(unique_brands):
        # Get unique 'guid's associated with the comparison brand from the precomputed dictionary
        comparison_brand_guids = brand_guids_dict[comparison_brand]

        # Compute the number of 'guid's common to both the current brand and comparison brand
        common_guids_count = len(current_brand_guids.intersection(comparison_brand_guids))
        
        # Compute cross-visitation proportion for current_brand-guids visiting comparison_brand
        cross_visitation_matrix.iloc[i, j] = common_guids_count / len(current_brand_guids)

# Save the cross-visitation matrix as a CSV file
cross_visitation_matrix.to_csv('cross_visitation_output.csv')
