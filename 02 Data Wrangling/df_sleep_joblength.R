library(RCurl)
library(dplyr)
library(tidyr)
library(jsonlite)
library(scales)
library(ggplot2)
library(ggthemes)
require(jsonlite)

df_sleepalert <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tsleepalert"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

df_background <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tbackground"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

dfc <- right_join(df_sleepalert, df_background, by="ID_NUMBER")


dfc %>% select(YEARS_IN_PRESENT_JOB, SLEEP_LENGTH, SLEEP_QUALITY) %>% group_by(SLEEP_QUALITY) %>% ggplot(aes(as.numeric(as.character(SLEEP_LENGTH)), as.numeric(as.character(YEARS_IN_PRESENT_JOB)),  color = SLEEP_QUALITY))+geom_point() + ggtitle('Years Worked in Comparison to Sleep Length and Quality') +theme(plot.title=element_text(size=20,face="bold",vjust=1,lineheight=0.6)) + labs(x = 'Sleep Length', y = 'Years Worked') + geom_jitter(alpha=0.5,aes(color=SLEEP_QUALITY),position=position_jitter(width=.2)) + scale_colour_tableau()

