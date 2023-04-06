import pandas as pd

# Read the input CSV file
input_file = 'input.csv'
df = pd.read_csv(input_file)

# Create an empty DataFrame to store the output data
output_data = pd.DataFrame(columns=['age'])

# Process the input data
for index, row in df.iterrows():
    age = row['age']
    count = row['count']
    
    # Create a DataFrame with the desired number of rows for each age
    age_rows = pd.DataFrame({'age': [age] * count})
    
    # Append the age_rows DataFrame to the output_data DataFrame
    output_data = output_data.append(age_rows, ignore_index=True)

# Write the output data to a new CSV file
output_file = 'output.csv'
output_data.to_csv(output_file, index=False)