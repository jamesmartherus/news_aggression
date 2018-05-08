#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 10 14:56:23 2018

@author: jamesmartherus
"""


from googleapiclient import discovery
import pandas as pd
import numpy as np
#%matplotlib inline

####### Setup
API_KEY='AIzaSyAH1XWENEx6-zYXJ2LGDGJAC_es27c90rc'

# Generates API client object dynamically based on service name and version.
service = discovery.build('commentanalyzer', 'v1alpha1', developerKey=API_KEY)

#loop here
filename = "/users/jamesmartherus/Dropbox/Research/Partisan_Dehumanization/Data/Sood_news_database/archive-cc-2017-clean_0421.csv"
filename_out = "/users/jamesmartherus/Dropbox/Research/Partisan_Dehumanization/Data/Sood_news_database/archive-cc-2017-0421-scored.csv"
#still need to figure out how to assign the first row with colnames since i dont include header in the loop.
colnames = ["program","network","year","text","toxic_score"]
chunk_size = 50000
start_at = 100000

#for second session, add argument skiprows=10000 (for example) to read_csv

for chunk in pd.read_csv(filename, chunksize=chunk_size, skiprows=range(1, start_at)):
    #data = pd.read_csv("/users/jamesmartherus/Dropbox/Research/Partisan_Dehumanization/Data/Sood_news_database/archive-cc-2017-clean_0421.csv")
    chunk["toxic_score"] = np.nan


    # Have the API score each sentence in the chunk
    for i in range(0,chunk_size):
        if i % 1000 == 0:
            print(i)
        statement = chunk['text'][i]
        analyze_request = {
      'comment': { 'text': statement },
      'requestedAttributes': {'TOXICITY': {}}
      }
        try:
            response = service.comments().analyze(body=analyze_request).execute()
        except:
            continue
        #store toxic score in a new column
        chunk["toxic_score"][i] = response["attributeScores"]["TOXICITY"]["summaryScore"]["value"]    
    
    #write the scored version of data to the file
    chunk.to_csv(filename_out, mode='a', header=False)
    start_at+=chunk_size




### Still to do
# Figure out how to do this in chunks rather than all at once

