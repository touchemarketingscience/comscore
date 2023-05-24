# Author: Roman-GPT

# Choose file interactively
file_path <- file.choose()

# Read the CSV file
indigo <- read.csv(file_path)

# Convert guid and brand columns to character
indigo$guid <- as.character(indigo$guid)
indigo$brand <- as.character(indigo$brand)

# Get unique brands
unique_brands <- unique(indigo$brand)

# Create an empty matrix with row and column names as unique brands
data <- matrix(0, nrow = length(unique_brands), ncol = length(unique_brands))
colnames(data) <- unique_brands
rownames(data) <- unique_brands

# Loop through each combination of brand pairs
for (i in seq_along(unique_brands)) {
  brand_i <- unique_brands[i]
  guids_i <- unique(indigo$guid[indigo$brand == brand_i])
  
  for (j in seq_along(unique_brands)) {
    brand_j <- unique_brands[j]
    guids_j <- unique(indigo$guid[indigo$brand == brand_j])

    # Calculate cross-visitation proportion
    common_guids <- sum(guids_i %in% guids_j)
    data[i, j] <- common_guids / length(guids_i)
  }
}

# Write the output to a CSV file
write.csv(data, 'cv_pets.csv', row.names = TRUE)