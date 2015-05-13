library(RCurl)
library(dplyr)
library(tidyr)
library(jsonlite)
library(scales)
library(ggplot2)
library(ggthemes)
require(jsonlite)

df_background <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tbackground"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

df_background <- df_background[-61, ]
df_background <- df_background[-3, ]
df_background <- df_background[-96, ]
df_background <- df_background[-177, ]

g <- df_background %>% group_by(TOTAL_YEARS_OF_SERVICE, NEW_HIRE_OVERSIGHT, JOB_SECURITY, SEX) %>% ggplot(aes(x= as.numeric(as.character(JOB_SECURITY)), y=as.numeric(as.character(TOTAL_YEARS_OF_SERVICE)), color=NEW_HIRE_OVERSIGHT)) + geom_point() + facet_wrap(~SEX) + ggtitle('Years Worked vs Job Security and New Hire Oversight') +theme(plot.title=element_text(size=20,face="bold",vjust=1,lineheight=0.6)) + labs(x = 'Job Security', y = 'Total Years of Service')
g
