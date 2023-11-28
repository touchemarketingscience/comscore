# Author: Roman-GPT

# Choose file interactively
file_path <- file.choose()

# Read the CSV file
dataTable <- read.csv(file_path)

# Convert guid and brand columns to character
dataTable$guid <- as.character(dataTable$guid)
dataTable$brand <- as.character(dataTable$brand)
dataTable$category <- as.character(dataTable$category)

# Get unique brands
unique_brands <- unique(dataTable$brand)
unique_categories <- unique(dataTable$category)

# Create an empty matrix with row and column names as unique brands
data <- matrix(0, nrow = length(unique_brands), ncol = length(unique_categories))
colnames(data) <- unique_categories
rownames(data) <- unique_brands

# Loop through each combination of brand pairs
for (i in seq_along(unique_brands)) {
  brand_i <- unique_brands[i]
  guids_i <- unique(dataTable$guid[dataTable$brand == brand_i])
  
  for (j in seq_along(unique_categories)) {
    category_j <- unique_categories[j]
    guids_j <- unique(dataTable$guid[dataTable$category == category_j])

    # Calculate cross-visitation proportion
    common_guids <- sum(guids_i %in% guids_j)
    data[i, j] <- common_guids / length(guids_i)
  }
}

# Write the output to a CSV file
write.csv(data, 'crossvisitation-brand-vs-category.csv', row.names = TRUE)