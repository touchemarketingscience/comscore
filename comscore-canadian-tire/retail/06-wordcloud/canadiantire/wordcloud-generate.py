
import pandas as pd
import urllib.parse
import re
from collections import Counter
from wordcloud import WordCloud
import matplotlib.pyplot as plt
from tqdm import tqdm

# Read the CSV file
df = pd.read_csv('urls.csv')

exclusion_list = [
    'content', 
    'search', 
    'de', 
    'et', 
    '.html', 
    'jcr:content', 
    'cat', 
    'a', 
    'store', 
    'results.html', 
    'in', 
    'cart.html', 
    'personalized', 
    'en', 
    'outbound', 
    'data.content.html', 
    'osversion', 
    'details', 
    'checkout.html', 
    'activation.html', 
    'my', 
    'on.store.html', 
    'confirmation.html', 
    'resultats', 
    's', 
    'ml',
    'mastheaden',
    'jcr',
    'header',
    'all',
    'appversion',
    'account',
    'order',
    'system',
    'recherche',
    'au',
    'with',
    'for',
    'd',
    'column',
    'x',
    'pdp',
    'ft',
    'on',
    'nov25',
    'paragraph.lazyload.hcfa711252fe83e3917e647d2ab5ebfd4',
    'maximum',
    'pour',
    'pk'
    ] 

# 1. Parsing URLs

keywords = []
for url in tqdm(df['url'], desc="Processing URLs"):  # assuming 'url' is the column name
    parsed_url = urllib.parse.urlparse(url)
    path = parsed_url.path

    split_key = None

    if '/en/pdp/' in path:
        split_key = '/en/pdp/'

    elif '/fr/pdp/' in path:
        split_key = '/fr/pdp/'

    elif '/en/' in path:
        split_key = '/en/'

    elif '/fr/' in path:
        split_key = '/fr/'

    if split_key:
        path_list = path.split(split_key, 1)
        if len(path_list) > 1:  # If split_key is found in path, the length of path_list will be more than 1
            path = path_list[1]
            # Split path into keywords, ignore numbers
            words = re.split(r'[-/_]', path)
            words = [word for word in words if not word.isdigit() and word not in exclusion_list]
            keywords.extend(word.replace('.html', '') for word in words)

# 2. Cleaning and normalizing keywords
keywords = [word.lower() for word in keywords if word != ""]

# 3. Counting the frequency of each keyword
word_counts = Counter(keywords)

# 4. Generating the word cloud
word_cloud = WordCloud(background_color='white', colormap='hot', width = 1597, height = 610).generate_from_frequencies(word_counts)

word_cloud.generate_from_frequencies(word_counts)

# 5. Displaying the word cloud
plt.figure(figsize=(15,8))
plt.imshow(word_cloud, interpolation="bilinear")
plt.axis("off")
plt.show()

# 'Accent', 'Accent_r', 'Blues', 'Blues_r', 'BrBG', 'BrBG_r', 'BuGn', 'BuGn_r', 'BuPu', 'BuPu_r', 'CMRmap', 'CMRmap_r', 'Dark2', 'Dark2_r', 'GnBu', 'GnBu_r', 'Greens', 'Greens_r', 'Greys', 'Greys_r', 'OrRd', 'OrRd_r', 
# 'Oranges', 'Oranges_r', 'PRGn', 'PRGn_r', 'Paired', 'Paired_r', 'Pastel1', 'Pastel1_r', 'Pastel2', 'Pastel2_r', 'PiYG', 'PiYG_r', 'PuBu', 'PuBuGn', 'PuBuGn_r', 'PuBu_r', 'PuOr', 'PuOr_r', 'PuRd', 'PuRd_r', 'Purples', 'Purples_r', 'RdBu', 'RdBu_r', 'RdGy', 'RdGy_r', 'RdPu', 'RdPu_r', 'RdYlBu', 'RdYlBu_r', 'RdYlGn', 'RdYlGn_r', 'Reds', 'Reds_r', 'Set1', 'Set1_r', 'Set2', 'Set2_r', 'Set3', 'Set3_r', 'Spectral', 'Spectral_r', 'Wistia', 'Wistia_r', 'YlGn', 'YlGnBu', 'YlGnBu_r', 'YlGn_r', 'YlOrBr', 'YlOrBr_r', 'YlOrRd', 'YlOrRd_r', 'afmhot', 'afmhot_r', 'autumn', 'autumn_r', 'binary', 'binary_r', 'bone', 'bone_r', 'brg', 'brg_r', 'bwr', 'bwr_r', 'cividis', 'cividis_r', 'cool', 'cool_r', 'coolwarm', 'coolwarm_r', 'copper', 'copper_r', 'cubehelix', 'cubehelix_r', 'flag', 'flag_r', 'gist_earth', 'gist_earth_r', 'gist_gray', 'gist_gray_r', 'gist_heat', 'gist_heat_r', 'gist_ncar', 'gist_ncar_r', 'gist_rainbow', 'gist_rainbow_r', 'gist_stern', 'gist_stern_r', 'gist_yarg', 'gist_yarg_r', 'gnuplot', 'gnuplot2', 'gnuplot2_r', 'gnuplot_r', 'gray', 'gray_r', 'hot', 'hot_r', 'hsv', 'hsv_r', 'inferno', 'inferno_r', 'jet', 'jet_r', 'magma', 'magma_r', 'nipy_spectral', 'nipy_spectral_r', 'ocean', 'ocean_r', 'pink', 'pink_r', 'plasma', 'plasma_r', 'prism', 'prism_r', 'rainbow', 'rainbow_r', 'seismic', 'seismic_r', 'spring', 'spring_r', 'summer', 'summer_r', 'tab10', 'tab10_r', 'tab20', 'tab20_r', 'tab20b', 'tab20b_r', 'tab20c', 'tab20c_r', 'terrain', 'terrain_r', 'turbo', 'turbo_r', 'twilight', 'twilight_r', 'twilight_shifted', 'twilight_shifted_r', 'viridis', 'viridis_r', 'winter', 'winter_r'