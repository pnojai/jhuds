data_dir <- "./04_EDA/Data/exdata-data-NEI_data"
plot_dir <- "./04_EDA/EDA_Project2"
NEI <- readRDS(paste(data_dir, "summarySCC_PM25.rds", sep = "/"))
SCC <- readRDS(paste(data_dir, "Source_Classification_Code.rds", sep = "/"))

# 4. Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

library(dplyr)
library(ggplot2)

# Source Code Classifications referring to coal.
scc_coal_ei_sector <- grep("[Cc]oal", SCC$EI.Sector)
scc_coal <- SCC[scc_coal_ei_sector, "SCC"]

# Tidy dataset
tot_pm25_coal <- select(NEI, c(SCC, Emissions, year)) %>%
        filter(SCC %in% scc_coal & year %in% c(1999, 2008)) %>%
        group_by(year) %>%
        summarize(sum(Emissions))

# Clean column name.
# Categorical variables become factors.
# Transform scale of emissions
names(tot_pm25_coal)[2] = "Emissions"
tot_pm25_coal <- transform(tot_pm25_coal, year = factor(year))
tot_pm25_coal <- transform(tot_pm25_coal, Emissions = Emissions / 1000)

# Plot
plot_fil <- "plot4.png"
png(paste(plot_dir, plot_fil, sep = "/"))
ggplot(tot_pm25_coal, aes(x = year, y = Emissions)) +
        geom_bar(stat = "identity", position = "dodge") +
        labs(title = "U.S. PM2.5 Emissions",
             subtitle = "Comparison between years for coal combustion-related sources") +
        ylab("Emissions (tons in 1000s)")
dev.off()
