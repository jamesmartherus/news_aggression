# news_aggression
Takes news transcripts scraped from archive.org and analyzes them for aggressive language

# Getting news transcript data

The data used in this project was gathered by Gaurav Sood, and can be found here: https://github.com/notnews/archive_news_cc

# Scripts

1. split_transcripts.Rmd cleans the data, splits each transcript into individual sentences, and outputs the result.

2. call_perspective_api.py assigns an aggression score to each sentence by calling the [perspective API](https://github.com/notnews/archive_news_cc). 


