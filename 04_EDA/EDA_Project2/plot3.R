data_dir <- "./04_EDA/Data/exdata-data-NEI_data"
plot_dir <- "./04_EDA/EDA_Project2"
NEI <- readRDS(paste(data_dir, "summarySCC_PM25.rds", sep = "/"))
SCC <- readRDS(paste(data_dir, "Source_Classification_Code.rds", sep = "/"))

# 3. Of the four types of sources indicated by the  type (point,
# nonpoint, onroad, nonroad) variable, which of these four sources
# have seen decreases in emissions from 1999–2008 for Baltimore City?
# Which have seen increases in emissions from 1999–2008? Use the ggplot2
# plotting system to make a plot answer this question.

library(dplyr)
library(ggplot2)

# Tidy dataset
tot_pm25_baltimore_type <- select(NEI, c(fips, Emissions, type, year)) %>%
        filter(fips == "24510" & year %in% c(1999, 2008)) %>%
        group_by(type, year) %>%
        summarize(sum(Emissions))

# Clean column name.
# Categorical variables become factors.
names(tot_pm25_baltimore_type)[3] = "Emissions"
tot_pm25_baltimore_type <- transform(tot_pm25_baltimore_type, type = factor(type))
tot_pm25_baltimore_type <- transform(tot_pm25_baltimore_type, year = factor(year))

# Plot
plot_fil <- "plot3.png"
png(paste(plot_dir, plot_fil, sep = "/"))
ggplot(tot_pm25_baltimore_type, aes(x = type, y = Emissions)) +
        geom_bar(aes(fill = year),
                 stat = "identity", position = "dodge") +
        labs(title = "Baltimore City, MD PM2.5 Emissions",
             subtitle = "Comparison between years by source") +
        ylab("Emissions (tons)") +
        xlab("Source")
dev.off()