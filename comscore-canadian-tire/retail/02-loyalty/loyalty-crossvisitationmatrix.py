import pandas as pd
import numpy as np

# Request user input for the file path
file_path = input("Enter the path to your CSV file: ")

# Load data from CSV file into a DataFrame
dataframe = pd.read_csv(file_path)

# Convert 'guid' and 'brand' columns to string data type
dataframe['guid'] = dataframe['guid'].astype(str)
dataframe['brand'] = dataframe['brand'].astype(str)

# Extract unique brands from the DataFrame
unique_brands = dataframe['brand'].unique()

# Initialize an empty DataFrame with rows and columns labeled with unique brands
cross_visitation_matrix = pd.DataFrame(0, index=unique_brands, columns=unique_brands)

# Loop over each unique brand to calculate cross-visitation proportions
for i, current_brand in enumerate(unique_brands):
    # Get unique 'guid's associated with the current brand
    current_brand_guids = dataframe[dataframe['brand'] == current_brand]['guid'].unique()
    
    for j, comparison_brand in enumerate(unique_brands):
        # Get unique 'guid's associated with the comparison brand
        comparison_brand_guids = dataframe[dataframe['brand'] == comparison_brand]['guid'].unique()

        # Compute the number of 'guid's common to both the current brand and comparison brand
        common_guids_count = np.sum(np.isin(current_brand_guids, comparison_brand_guids))
        
        # Compute cross-visitation proportion for current_brand-guids visiting comparison_brand
        cross_visitation_matrix.iloc[i, j] = common_guids_count / len(current_brand_guids)

# Save the cross-visitation matrix as a CSV file
cross_visitation_matrix.to_csv('cross_visitation.csv')
