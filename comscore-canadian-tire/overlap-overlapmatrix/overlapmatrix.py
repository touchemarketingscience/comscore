import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

def read_and_prepare_data(csv_file):
    data = pd.read_csv(csv_file)
    data['Percent'] = data['Percent'] * 100
    pivot_data = data.pivot_table(index="Primary", columns="Secondary", values="Percent")
    return pivot_data

def create_heatmap(data, title="Heatmap", xlabel="Also Visited", ylabel="Primary Visit"):
    plt.figure(figsize=(10, 8))
    
    sns.set(font_scale=0.8)
    
    mask = (data >= 1)
    custom_cmap = sns.color_palette("ch:s=.25,rot=-.25", as_cmap=True)
    # custom_cmap = sns.diverging_palette(200, 0, s=100, l=100, as_cmap=True, n=256)
    #custom_cmap.set_bad(color='#D3D3D3')

    ax = sns.heatmap(
        data, 
        annot=True, 
        mask=mask,
        cmap=custom_cmap, #"YlGnBu", 
        fmt=".1%", 
        linewidths=0.5, 
        annot_kws={"fontsize": 8, "color": "#fff"},
        cbar_kws={'label': 'Value'},
        vmin=0,
        vmax=0.85,
        center=None,
        square=False
    )
    
    # Move the x-axis labels to the top
    ax.xaxis.tick_top()
    ax.xaxis.set_label_position('top')
    
    plt.title('', fontsize=0)
    plt.xlabel('', fontsize=0)
    plt.ylabel('', fontsize=0)
    plt.xticks(rotation=0)
    plt.yticks(rotation=0)
    plt.show()

csv_file = "input_percentage.csv"  # Replace with the path to your CSV file
data = read_and_prepare_data(csv_file)
data = data / 100  # Convert percentage values to decimals for heatmap formatting
create_heatmap(data)


# import pandas as pd
# import seaborn as sns
# import matplotlib.pyplot as plt

# def read_and_prepare_data(csv_file):
#     data = pd.read_csv(csv_file)
#     pivot_data = data.pivot_table(index="Primary", columns="Secondary", values="Percent")

#     # Calculate row totals and convert values to percentages
#     # row_totals = pivot_data.sum(axis=1)
#     # pivot_data_percentage = pivot_data.div(row_totals, axis=0) * 100

#     return pivot_data

# def create_heatmap(data, title="Heatmap", xlabel="Attributes", ylabel="Competitors"):
#     plt.figure(figsize=(10, 8))
#     sns.set(font_scale=1.2)
#     sns.heatmap(data, annot=True, cmap="YlGnBu", fmt="g", linewidths=0.5, cbar_kws={'label': 'Value'})
#     plt.title(title, fontsize=18)
#     plt.xlabel(xlabel, fontsize=16)
#     plt.ylabel(ylabel, fontsize=16)
#     plt.xticks(rotation=45)
#     plt.yticks(rotation=0)
#     plt.show()

# csv_file = "input_percentage.csv"  # Replace with the path to your CSV file
# data = read_and_prepare_data(csv_file)
# create_heatmap(data)
