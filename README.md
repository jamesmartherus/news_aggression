# news_aggression
Takes news transcripts scraped from archive.org and analyzes them for aggressive language

# Getting news transcript data

The data used in this project was gathered by [Gaurav Sood](gsood.com), and can be found [here](https://github.com/notnews/archive_news_cc)

# Scripts

1. [split_transcripts.Rmd](https://github.com/jamesmartherus/news_aggression/blob/master/split_transcripts.Rmd) cleans the data, splits each transcript into individual sentences, and outputs the result.

2. [call_perspective_api.py](https://github.com/jamesmartherus/news_aggression/blob/master/call_perspective_api.py) assigns an aggression score to each sentence by calling the [perspective API](https://github.com/notnews/archive_news_cc). 

3. [clean_local_call_nums.r](https://github.com/jamesmartherus/news_aggression/blob/master/clean_local_call_nums.R) takes a list of local channels and ties them to the corresponding national network. 

4. [chart_creation.r](https://github.com/jamesmartherus/news_aggression/blob/master/chart_creation.R) cleans the scored data and includes basic exploratory analysis.

# Data

[local_channels.csv](https://github.com/jamesmartherus/news_aggression/blob/master/local_channels.csv) includes every local news channel in the country along with the corresponding national network. Data gathered [here](https://en.wikipedia.org/wiki/List_of_United_States_over-the-air_television_networks).


