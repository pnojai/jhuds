# Data source - Course website:
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

data_dir <- "./04_EDA/Data/exdata-data-NEI_data"
plot_dir <- "./04_EDA/EDA_Project2"
NEI <- readRDS(paste(data_dir, "summarySCC_PM25.rds", sep = "/"))
SCC <- readRDS(paste(data_dir, "Source_Classification_Code.rds", sep = "/"))

str(NEI)
str(SCC)

head(NEI)
head(SCC)
summary(NEI)

# 1. Have total emissions from PM2.5 decreased in the United States from 1999
# to 2008? Using the base plotting system, make a plot showing the total
# PM2.5 emission from all sources for each of the years 1999, 2002, 2005,
# and 2008.

# Missings values. None.
sum(is.na(NEI$Emissions))

tot_pm25 <- with(NEI, tapply(Emissions / 1000, year, sum))

plot_fil <- "plot1.png"
png(paste(plot_dir, plot_fil, sep = "/"))
barplot(tot_pm25,
        main = "Total U.S. PM2.5 Emissions by Year",
        ylab = "Tons (1000)")
dev.off()

# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# ( fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.

str(NEI)
subset(NEI, subset = fips == "24510")

tot_pm25_baltimore <- with(subset(NEI, subset = fips == "24510"),
                           tapply(Emissions / 1000, year, sum))

plot_fil <- "plot2.png"
png(paste(plot_dir, plot_fil, sep = "/"))
barplot(tot_pm25_baltimore,
        main = "Total Baltimore City, MD PM2.5 Emissions by Year",
        ylab = "Tons (1000)")
dev.off()

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
