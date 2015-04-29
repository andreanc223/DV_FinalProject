setwd("C:/cs329e/DataVisualization/DV_FinalProject/PossibleData/school")
# file_path <- "Sample - Superstore - English (Extract).csv"
# measures <- c("Customer_ID", "Discount", "Number_of_Records", "Order_ID", "Order_Quantity", "Product_Base_Margin", "Profit", "Sales", "Shipping_Cost", "Unit_Price" )

file_path <- "elsec12.csv"
measures <- c("YRDATA","V33","TOTALREV","TFEDREV","C14","C15","C16","C17","C19","B11","C20","C25","C36","B10","B12","B13","TSTREV","C01","C04","C05","C06","C07","C08","C09","C10","C11","C12","C13","C24","C35","C38","C39","TLOCREV","T02","T06","T09","T15","T40","T99","D11","D23","A07","A08","A09","A11","A13","A15","A20","A40","U11","U22","U30","U50","U97","TOTALEXP","TCURELSC","TCURINST","E13","J13","J12","J14","V91","V92","TCURSSVC","E17","E07","E08","E09","V40","V45","V90","V85","J17","J07","J08","J09","J40","J45","J90","J11","J96","TCUROTH","E11","V60","V65","J10","J97","NONELSEC","V70","V75","V80","J98","TCAPOUT","F12","G15","K09","K10","K11","J99","L12","M12","Q11","I86","Z32","Z33","V11","V13","V15","V17","V21","V23","V37","V29","Z34","V10","V12","V14","V16","V18","V22","V24","V38","V30","V32","_19H","_21F","_31F","_41F","_61V","_66V","W01","W31","W61"
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