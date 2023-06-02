import pandas as pd
import urllib.parse
import re
from collections import Counter
from wordcloud import WordCloud
import matplotlib.pyplot as plt
from tqdm import tqdm

# Read the CSV file
df = pd.read_csv('urls.csv')

# 1. Parsing URLs
keywords = []
for url in tqdm(df['url'], desc="Processing URLs"):  # assuming 'url' is the column name
    parsed_url = urllib.parse.urlparse(url)
    path = parsed_url.path
    keywords.extend(re.split(r'[-/_]', path))

# 2. Cleaning and normalizing keywords
keywords = [word.lower() for word in keywords if word != ""]

# 3. Counting the frequency of each keyword
word_counts = Counter(keywords)

# 4. Generating the word cloud
word_cloud = WordCloud(width = 1000, height = 500).generate_from_frequencies(word_counts)

# 5. Displaying the word cloud
plt.figure(figsize=(15,8))
plt.imshow(word_cloud)
plt.axis("off")
plt.show()
