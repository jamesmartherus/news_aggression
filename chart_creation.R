#### Create text analysis charts
library(ggplot2)
library(dplyr)
library(stringr)
library(gridExtra)
library(stargazer)

content <- read.csv("/users/jamesmartherus/Dropbox/Research/Partisan_Dehumanization/Data/Sood_news_database/archive-cc-2017-scored.csv", strip.white=T)

#drop nonsense rows
drop_these <- c("h264","mpeg2video","wmv2","msmpeg4v3","wmv3","mpeg1video")
content <-  content %>%
  subset(!(year %in% drop_these)) %>%
  subset(!(program==""))

#turn these columns to character so we can use REGEX
content$contributor <- as.character(content$contributor)
content$program <- as.character(content$program)

#replace local call numbers with network name (eg. We want "NBC", not "KUTV" or whatever).
local_channels <- read.csv("/users/jamesmartherus/Dropbox/Research/Partisan_Dehumanization/Data/Sood_news_database/local_channels_clean.csv")
content <- merge(content, local_channels, by.y="call_letters", by.x="contributor", all.x=TRUE)
content$network <- as.character(content$network)
content <- content %>% 
  mutate(contributor = ifelse(grepl("[K]",contributor), network, contributor)) %>%
  mutate(contributor = ifelse(grepl("[W]",contributor), network, contributor)) 

########### clean the network names
content$contributor <- str_trim(content$contributor)

content$contributor[content$contributor == "ALJAZAM"] <- "ALJAZEERA"
content$contributor[content$contributor == "ALJAZ"] <- "ALJAZEERA"
content$contributor[content$contributor == "BBCAMERICA"] <- "BBCNEWS"
content$contributor[content$contributor == "CNNW"] <- "CNN"
content$contributor[content$contributor == "CSPAN2"] <- "CSPAN"
content$contributor[content$contributor == "CSPAN3"] <- "CSPAN"
content$contributor[content$contributor == "FOXNEWSW"] <- "FOXNEWS"
content$contributor[content$contributor == "MSNBCW"] <- "MSNBC"
content$contributor[content$contributor == "EducationalIndependent"] <- "Independent"
content$contributor[content$contributor == "COM"] <- "COMEDY CENTRAL"
content$contributor[content$contributor == "ENT"] <- "E NEWS"

content <- content[!is.na(content$contributor),]
content$contributor <- toupper(content$contributor)
content <- content[content$contributor != "BOSTON, MASSACHUSETTS",]
content <- content[content$contributor != "BALTIMORE, MARYLAND",]

############ Clean the program names
content$program[content$program == "Politics\n&\nPublic Policy Today"] <- "Politics and Public Policy Today"

########### Add Network Ideology Scores
news_ideology <- read.csv("/users/jamesmartherus/Dropbox/Research/Partisan_Dehumanization/Data/Sood_news_database/news_ideology_gentzkow.csv")
news_ideology$slant <- news_ideology$pct_lib - news_ideology$pct_con
content <- merge(content, news_ideology, by.x="contributor",by.y="network",all.x=TRUE)


##################
# Analysis
##################

#### Average score for each network
avg_score_network <- content %>%
  group_by(contributor) %>%
  summarize(mean_toxic=mean(toxic_score, na.rm=T), n=n()) %>%
  transform(contributor=reorder(contributor, mean_toxic))

avg_toxic_network <- avg_score_network %>% ggplot(aes(x=contributor, y=mean_toxic)) +
  geom_col() +
  coord_flip() +
  ylab("Average Toxicity") + 
  xlab("Channel") +
  theme_bw() +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),axis.text.x=element_text(size=5)) 
avg_toxic_network

#### Average score for each program
avg_score_program <- content %>%
  group_by(program) %>%
  summarize(mean_toxic=mean(toxic_score, na.rm=T), n=n()) %>%
  transform(program=reorder(program, mean_toxic)) %>%
  filter(n > 150)

avg_toxic_program <- avg_score_program %>% ggplot(aes(x=program, y=mean_toxic)) +
  geom_col() +
  coord_flip() +
  ylab("Average Toxicity") + 
  xlab("Program") +
  theme_bw() +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),axis.text.x=element_text(size=5)) 
avg_toxic_program

grid.arrange(avg_toxic_network, avg_toxic_program, ncol=2)

####### Slant and Toxicity
# Nothing here really
slant_toxic <- content %>%
  ggplot(aes(x=as.factor(slant), y=toxic_score)) +
  geom_boxplot()
slant_toxic

avg_score_network <- merge(avg_score_network, news_ideology, by.x="contributor",by.y="network",all.x=TRUE)
model1 <- lm(avg_score_network$mean_toxic ~ avg_score_network$slant, data=avg_score_network, na.rm=T)
stargazer(model1, type='text')

content$extreme <- 0
content$extreme[content$toxic_score >= .6] <- 1

model_extreme <- glm(extreme ~ slant, data=content, family="binomial")
stargazer(model_extreme)



### distribution of scores
qplot(content$toxic_score)

#because we have very few highly toxic statements, the mean might not be most helpful.
#maybe I want to look at which networks have the most highly toxic statements
content_toxic <- content %>%
  filter(toxic_score > .5)


