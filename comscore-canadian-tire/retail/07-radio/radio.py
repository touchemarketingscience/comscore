import csv
import requests
from bs4 import BeautifulSoup
import pandas as pd
from tqdm import tqdm

def get_description(url):
    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, "html.parser")
        description_tag = soup.find("h4", string="Description").find_next_sibling("p")
        return description_tag.text
    except Exception as e:
        print(f"Error while crawling '{url}': {e}")
        return None

def main():
    input_file = 'old.csv'
    output_file = 'new.csv'

    # Read URLs from the input CSV file
    urls_df = pd.read_csv(input_file)

    # Extract description for each URL with progress tracking
    urls_df['description'] = [get_description(url) for url in tqdm(urls_df['url'], desc="Crawling URLs")]

    # Save the result to the output CSV file
    urls_df.to_csv(output_file, index=False)

if __name__ == "__main__":
    main()