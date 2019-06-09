data_dir <- "./04_EDA/Data/exdata-data-NEI_data"
plot_dir <- "./04_EDA/EDA_Project2"
NEI <- readRDS(paste(data_dir, "summarySCC_PM25.rds", sep = "/"))
SCC <- readRDS(paste(data_dir, "Source_Classification_Code.rds", sep = "/"))

# 1. Have total emissions from PM2.5 decreased in the United States from 1999
# to 2008? Using the base plotting system, make a plot showing the total
# PM2.5 emission from all sources for each of the years 1999, 2002, 2005,
# and 2008.

tot_pm25 <- with(NEI, tapply(Emissions / 1000, year, sum))
plot_fil <- "plot1.png"
png(paste(plot_dir, plot_fil, sep = "/"))
barplot(tot_pm25,
        main = "Total U.S. PM2.5 Emissions by Year",
        ylab = "Tons (1000)")
dev.off()