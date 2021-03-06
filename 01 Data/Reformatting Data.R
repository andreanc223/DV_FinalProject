setwd("C:/cs329e/DataVisualization/DV_FinalProject/01 Data")
# file_path <- "Sample - Superstore - English (Extract).csv"
# measures <- c("Customer_ID", "Discount", "Number_of_Records", "Order_ID", "Order_Quantity", "Product_Base_Margin", "Profit", "Sales", "Shipping_Cost", "Unit_Price" )

file_path <- "PTBACKGROUND.csv"
measures <- c("Total Years of Service","Years In Present Job","Under 2 Yrs","Caffeine","Caffeine Amount","Sick Days","Health Status","Perceived Age","Diagnosed Sleep Disorder","Sleep Arrangement 1","Sleep Arrangement 2","Weekly Work Hours","Rest Days","Worked Restday	","Well rested at work","Work Schedule","Sleep Loss","Rest Interruption","Coordination","Rules","Mgt. Policies","Job Security","Communication","Staffing","Crew Mgt.","Others' Safety","Break Time","Time Off","New Hire Oversight","Other Stress","Life Events"	
)

df <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))

str(df) # Uncomment this to get column types to use for getting the list of measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(df), measures)
for(d in dimensions) {
  # Get rid of " and ' in dimensions.
  df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
  # Change & to and in dimensions.
  df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
  # Change : to ; in dimensions.
  df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
}

library(lubridate)
# Fix date columns, this needs to be done by hand because | needs to be correct.
#                                                        \_/
df$Order_Date <- gsub(" [0-9]+:.*", "", gsub(" UTC", "", mdy(as.character(df$Order_Date), tz="UTC")))
df$Ship_Date  <- gsub(" [0-9]+:.*", "", gsub(" UTC", "", mdy(as.character(df$Ship_Date),  tz="UTC")))

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.
for(m in measures) {
  df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.,0-9]",replacement= ""))
}

write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE)

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
for(d in dimensions) {
   sql <- paste(sql, paste(d, "varchar2(4000),\n"))
}
for(m in measures) {
  if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
  else sql <- paste(sql, paste(m, "number(38,4)\n"))
}
sql <- paste(sql, ");")
cat(sql)