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

## Open the PNG graphics device and create 'plot4.png' in working directory
png(filename = "plot4.png", height = 480, width = 480)

## Create plot and send to the file (no plot appears on screen)
par(mfrow = c(2, 2), mar = c(6, 6, 2, 1), oma = c(0, 0, 2 ,0))

## Create Top-Left plot
with(subsetData, plot(Global_active_power ~ Datetime, 
                        type = "l", 
                        xlab = "", 
                        ylab = "Global Active Power"))

## Create Top-Right plot
with(subsetData, plot(Voltage ~ Datetime, 
                        type = "l", 
                        xlab = "datetime", 
                        ylab = "Voltage"))

## Create Bottom-Left plot
with(subsetData, plot(Sub_metering_1 ~ Datetime, 
                        type = "l", 
                        xlab = "", 
                        ylab = "Energy sub metering"))

with(subsetData, lines(Sub_metering_2 ~ Datetime, 
                         col = "Red"))

with(subsetData, lines(Sub_metering_3 ~ Datetime, 
                         col = "Blue"))

## Create legend for the plot
legend("topright", 
       col = c("Black", "Red", "Blue"), 
       lty = 1, 
       lwd = 1, 
       bty = "n", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       cex = 0.9)

## Create Bottom-Right plot
with(subsetData, plot(Global_reactive_power ~ Datetime, 
                        type = "l", 
                        xlab = "datetime",
                        ylab = "Global_reactive_power"))

## Close the PNG graphics device
dev.off()