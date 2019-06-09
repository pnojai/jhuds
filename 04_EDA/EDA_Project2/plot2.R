data_dir <- "./04_EDA/Data/exdata-data-NEI_data"
plot_dir <- "./04_EDA/EDA_Project2"
NEI <- readRDS(paste(data_dir, "summarySCC_PM25.rds", sep = "/"))
SCC <- readRDS(paste(data_dir, "Source_Classification_Code.rds", sep = "/"))

# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# ( fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.

tot_pm25_baltimore <- with(subset(NEI, subset = fips == "24510"),
                           tapply(Emissions / 1000, year, sum))

plot_fil <- "plot2.png"
png(paste(plot_dir, plot_fil, sep = "/"))
barplot(tot_pm25_baltimore,
        main = "Total Baltimore City, MD PM2.5 Emissions by Year",
        ylab = "Tons (1000)")
dev.off()