import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

import matplotlib.dates as mdates
import seaborn as sns
from scipy.stats import mstats

COLUMN_NAMES = [
    "date",
    "value"
]

def remove_outliers(series, factor=1.5):
    Q1 = series.quantile(0.25)
    Q3 = series.quantile(0.75)
    IQR = Q3 - Q1
    lower_bound = Q1 - factor * IQR
    upper_bound = Q3 + factor * IQR
    return np.where((series < lower_bound) | (series > upper_bound), np.nan, series)
    
def fourier_transform(data, freq_threshold):
    fft_data = np.fft.fft(data)
    fft_data[np.abs(fft_data) < freq_threshold * np.max(np.abs(fft_data))] = 0
    cleaned_data = np.real(np.fft.ifft(fft_data))
    return cleaned_data

def process_csv(input_path, output_path):

    df = pd.read_csv(input_path)
    df.columns = COLUMN_NAMES
    df['date'] = pd.to_datetime(df['date'])
    df['Date'] = pd.to_datetime(df['date'])
    df.set_index('date', inplace=True)
    date_range = pd.date_range(df.index.min(), df.index.max())
    df = df.reindex(date_range, fill_value=np.nan).reset_index()
    
    
    name1 = 'value'
    clean1 = 'cleaned_value'
    
    array = []
    array.append(name1)
    
    df['index'] = pd.to_datetime(df['index'])
    df.set_index('index', inplace=True)
    
    for name in array:
        df[name] = df[name].interpolate(method='time')
        df[name] = remove_outliers(df[name])
        df[name] = df[name].interpolate(method='time')

    df[clean1] = fourier_transform(df[name1], 0.000001) #.025 default frequency
    
    print(df.columns)
    
    df.to_csv(output_path, index=False, encoding='utf-8')

    sns.set_style("whitegrid")
    sns.set_context("notebook", font_scale=1.25, rc={"lines.linewidth": 2.5})
    
    width = 15
    height = 8

    fig, ax = plt.subplots(figsize=(width, height))
    
    sns.lineplot(
        x='index',
        y=name1,
        data=df,
        ax=ax,
        label='Original',
        color='pink',
        linewidth=1.414
    )
    
    sns.lineplot(
        x='index',
        y=clean1,
        data=df,
        ax=ax,
        label='Fourier Transform',
        color='red',
        linewidth=1.414
    )
    
    print(df.columns)

    ax.set_xlabel('', fontsize=10)
    ax.set_ylabel('Unique Users', fontsize=10)
    ax.set_title('', fontsize=16)
    ax.set(yticklabels=[])
    ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m'))
    ax.xaxis.set_major_locator(mdates.AutoDateLocator())
    plt.xticks(rotation=90, fontsize = 10)
    ax.grid(color='gray', linestyle='-', linewidth=0.5, alpha=0.13)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.legend(loc='best', fontsize=10)
    plt.savefig('time_series_visualization.png', dpi=300, bbox_inches='tight')
    plt.show()

if len(sys.argv) != 3:
    print("Usage: python3 process_csv.py input.csv output.csv")
else:
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    process_csv(input_file, output_file)
    print("CSV file saved successfully!")