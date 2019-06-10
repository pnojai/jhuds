data_dir <- "./04_EDA/Data/exdata-data-NEI_data"
plot_dir <- "./04_EDA/EDA_Project2"
NEI <- readRDS(paste(data_dir, "summarySCC_PM25.rds", sep = "/"))
SCC <- readRDS(paste(data_dir, "Source_Classification_Code.rds", sep = "/"))

# 5. How have emissions from motor vehicle sources changed from 1999–2008
# in Baltimore City?

tot_pm25_baltimore_onroad <- with(subset(NEI,
                                         subset = fips == "24510" & year %in% c(1999, 2008)),
                                  tapply(Emissions / 1000, year, sum))

plot_fil <- "plot5.png"
png(paste(plot_dir, plot_fil, sep = "/"))
barplot(tot_pm25_baltimore_onroad,
        main = "Total Baltimore, MD PM2.5 Emissions Year Comparison",
        ylab = "Tons (1000)")
dev.off()
