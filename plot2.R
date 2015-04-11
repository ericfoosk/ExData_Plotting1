# Load library
library(sqldf)

## Getting full dataset
fullData <- read.csv(".\\Data\\household_power_consumption.txt", 
                     header = TRUE, 
                     sep = ";", 
                     na.strings = "?", 
                     colClasses = c("character", "character", rep("numeric",7)))

## Subsetting the data
subsetData <- sqldf("select * from fullData where Date in ('1/2/2007','2/2/2007')")

## Remove the fullData from environment
rm(fullData)

## Converting date and create a new column "Datetime" to store the new date format
subsetData$Date <- as.Date(subsetData$Date, format = "%d/%m/%Y")

date_Time <- paste(as.Date(subsetData$Date), subsetData$Time)

subsetData$Datetime <- as.POSIXct(date_Time)

## Remove the date_Time from environment
rm(date_Time)

## Open the PNG graphics device and create 'plot2.png' in working directory
png(filename = "plot2.png", height = 480, width = 480)

## Create plot and send to the file (no plot appears on screen)
with(subsetData, plot(Global_active_power ~ Datetime, 
                        type = "l", 
                        xlab = "", 
                        ylab = "Global Active Power (kilowatts)"))

## Close the PNG graphics device
dev.off()