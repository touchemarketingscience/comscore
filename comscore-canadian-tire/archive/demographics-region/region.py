import geopandas as gpd
import matplotlib.pyplot as plt

# Define the data as a dictionary
data = {
    "Region": ["Atlantic", "British Columbia", "Ontario", "Prairies", "Quebec"],
    "Index": [275.0122102, 143.5111318, 59.952055, 79.82141003, 108.9337729],
}

# Load the geometries for Canadian provinces
canada = gpd.read_file("https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/gpr_000b11a_e.zip")
canada = canada.to_crs("EPSG:3857")  # Reproject to the Web Mercator projection

# Combine the Atlantic provinces into one region
atlantic_provinces = ["New Brunswick", "Newfoundland and Labrador", "Nova Scotia", "Prince Edward Island"]
canada.atlantic = canada.geometry.apply(lambda x: x if canada["PRENAME"].iloc[0] not in atlantic_provinces else None)
canada.atlantic = canada.atlantic.dropna()
atlantic_geometry = canada.atlantic.unary_union

# Combine the Prairie provinces into one region
prairie_provinces = ["Alberta", "Manitoba", "Saskatchewan"]
canada.prairies = canada.geometry.apply(lambda x: x if canada["PRENAME"].iloc[0] not in prairie_provinces else None)
canada.prairies = canada.prairies.dropna()
prairies_geometry = canada.prairies.unary_union

# Create a new GeoDataFrame with the desired regions
regions = gpd.GeoDataFrame(
    data,
    geometry=[
        atlantic_geometry,
        canada.loc[canada["PRENAME"] == "British Columbia"].geometry.values[0],
        canada.loc[canada["PRENAME"] == "Ontario"].geometry.values[0],
        prairies_geometry,
        canada.loc[canada["PRENAME"] == "Quebec"].geometry.values[0],
    ],
    crs="EPSG:3857",
)

# Plot the map
fig, ax = plt.subplots(figsize=(12, 6))
regions.plot(column="Index", cmap="coolwarm_r", linewidth=0.8, edgecolor="0.8", legend=True, ax=ax)
ax.set_title("Canadian Regions by Index Value")
ax.set_axis_off()

# Show the plot
plt.show()
