library(RCurl)
library(dplyr)
library(tidyr)
library(ggplot2)

df_sleepalert <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tsleepalert"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

df_activity <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from tactivity"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521:ORCL', USER='C##cs329e_thc359', PASS='orcl_thc359', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))

dfe <- left_join(df_sleepalert, df_activity, by="ID_NUMBER")

#different activity types
dfe %>% select(ID_NUMBER, ACTIVITY) %>% group_by(ACTIVITY) %>% count(ACTIVITY)
g <- ggplot(dfe, aes(ACTIVITY)) + geom_bar()
g + geom_bar(width=.7) + theme(legend.position="none") + labs(x="Activity Type", y="Count", title="Count of Different Activity Types")

#sleep quality different activity types
dff <- dfe %>% select(ID_NUMBER, SLEEP_QUALITY, ACTIVITY) %>% group_by(ACTIVITY) %>% summarise(avg=mean(SLEEP_QUALITY))
g <- ggplot(dff, aes(x=ACTIVITY, y=avg)) + geom_point()
g + theme(legend.position="none") + labs(x="Activity Type", y="Avg Quality of Sleep", title="Quality of Sleep with Different Activity Types")
