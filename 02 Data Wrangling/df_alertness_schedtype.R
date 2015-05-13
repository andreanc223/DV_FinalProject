library(RCurl)
library(dplyr)
library(tidyr)
library(jsonlite)
library(ggplot2)
require(jsonlite)

df_sleepalert <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tsleepalert"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

df_background <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tbackground"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))


dfc <- inner_join(df_sleepalert, df_background, by="ID_NUMBER")


dfc %>% select(SCHEDTYPE, ALERTNESS) %>% group_by(SCHEDTYPE) %>% ggplot(aes(x=SCHEDTYPE, y=ALERTNESS)) + geom_jitter(alpha=0.5,aes(color=SCHEDTYPE),position=position_jitter(width=.2)) + ggtitle('Alertness of Different Types of Workers')+theme(plot.title=element_text(size=20,face="bold",vjust=1,lineheight=0.6)) + labs(x = 'Schedule Type of Employees', y = 'Alertness Levels') + scale_color_discrete(name="Schedule Types")

