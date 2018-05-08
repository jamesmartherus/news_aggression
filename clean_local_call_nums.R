##### Get local news station call numbers and convert to network


local_call_nums <- read.csv("/Users/jamesmartherus/Dropbox/Research/Partisan_Dehumanization/Data/Sood_news_database/local_channels.csv")

local_call_nums <- local_call_nums[local_call_nums$call_letters!="",]
local_call_nums$network <- as.character(local_call_nums$network)
local_call_nums$network <- gsub('[[:digit:]]+', '', local_call_nums$network)
local_call_nums$network <- gsub('[.]', '', local_call_nums$network)
local_call_nums$call_letters <- gsub('[-TV]', '', local_call_nums$call_letters)


write.csv(local_call_nums, "/Users/jamesmartherus/Dropbox/Research/Partisan_Dehumanization/Data/Sood_news_database/local_channels_clean.csv")
