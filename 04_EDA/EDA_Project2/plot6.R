data_dir <- "./04_EDA/Data/exdata-data-NEI_data"
plot_dir <- "./04_EDA/EDA_Project2"
NEI <- readRDS(paste(data_dir, "summarySCC_PM25.rds", sep = "/"))
SCC <- readRDS(paste(data_dir, "Source_Classification_Code.rds", sep = "/"))

# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips=="06037").
# Which city has seen greater changes over time in motor vehicle emissions?

library(dplyr)
library(ggplot2)

# Tidy dataset
tot_pm25_onroad_balt_la <- select(NEI, c(fips, type, Emissions, year)) %>%
        filter(type == "ON-ROAD" & fips %in% c("24510", "06037") & year %in% c(1999, 2008)) %>%
        group_by(fips, year) %>%
        summarize(sum(Emissions))

# Clean column name.
# Categorical variables become factors.
# Replace fips with county names.
names(tot_pm25_onroad_balt_la)[3] = "Emissions"
tot_pm25_onroad_balt_la <- transform(tot_pm25_onroad_balt_la, year = factor(year))
tot_pm25_onroad_balt_la <- mutate(tot_pm25_onroad_balt_la, County = NA)
tot_pm25_onroad_balt_la[tot_pm25_onroad_balt_la$fips == "06037", "County"] <- "Los Angeles"
tot_pm25_onroad_balt_la[tot_pm25_onroad_balt_la$fips == "24510", "County"] <- "Baltimore"

# Plot
plot_fil <- "plot6.png"
png(paste(plot_dir, plot_fil, sep = "/"))
ggplot(tot_pm25_onroad_balt_la, aes(x = County, y = Emissions)) +
        geom_bar(aes(fill = year),
                 stat = "identity", position = "dodge") +
        labs(title = "Motor Vehicle PM2.5 Emissions",
             subtitle = "Comparison between years for counties of Baltimore and Los Angeles") +
        ylab("Emissions (tons)") +
        xlab("County")
dev.off()
