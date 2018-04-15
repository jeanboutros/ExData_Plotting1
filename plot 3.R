setwd("~/R projects/ExData_Plotting1/")

# This is the main data frame
hpc_data <- NULL

# If data has been read already and cleaned, read them from the clean csv file
# Else read the data, filter the needed dates and save them the a csv for a faster reading
# time for every plot
if(file.exists("./household_power_consumption_clean.csv")){
  hpc_data <<- read.csv("./household_power_consumption_clean.csv")
} else {
  
  # If the dataset has not been downloaded, then download it
  if(!file.exists("./exdata-data-household_power_consumption.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./")
  }
  
  # If the dataset has been unziped, skip thie unzipping process 
  if(!file.exists("./household_power_consumption.txt")) {
    unzip("./exdata-data-household_power_consumption.zip")
  }
  
  # Read all the data from the dataset with the headers
  # All the data will be read as strings (character)
  hpc_data <<- read.table("./household_power_consumption.txt", header = TRUE, sep = ";", comment.char = "", skipNul = TRUE, stringsAsFactors = FALSE)
  
  # Format the first column as Date
  hpc_data$Date <- as.Date(hpc_data$Date, "%d/%m/%Y")
  hpc_data[,3:9] <- lapply(hpc_data[,3:9], as.numeric)
  
  # Keep only the subset of data that we need (2007-02-01 and 2007-02-02)
  hpc_data <<- hpc_data[hpc_data$Date == as.Date("2007-02-01") | hpc_data$Date == as.Date("2007-02-02"),]
  
  # Calculate the means of every column and replace the missing values by their respective means
  means <- sapply(hpc_data[,3:9], mean, na.rm = TRUE)
  for (i in c(3:9)) {
    replace(hpc_data[,i], NA, means[i-2])
  }
  
  # Write a clean csv file to the disk to be read faseter on the next run
  write.csv(hpc_data, "./household_power_consumption_clean.csv")
  
}

#summary(hpc_data)

# Create the plot, save it and close the device
days <- paste0(hpc_data$Date, " ", hpc_data$Time)
days <- as.POSIXlt(days)
png("plot3.png", width = 480, height = 480, units = "px")
plot(days, hpc_data$Sub_metering_1, type="l", pch=1, col="black", ylab = "Energy sub metering", xlab = "")
lines(days, hpc_data$Sub_metering_2, type="l", pch=1, col="red")
lines(days, hpc_data$Sub_metering_3, type="l", pch=1, col="blue")
legend("topright", c("Sub metering 1", "Sub metering 2", "Sub metering 3"), pch = 8, col = c("black", "red", "blue"))
dev.off()

