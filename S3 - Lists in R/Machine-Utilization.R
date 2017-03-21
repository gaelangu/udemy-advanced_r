getwd()

util <- read.csv("Machine-Utilization.csv")

head(util, 10)
str(util)
summary(util)

### Derive Utilization column

util$Utilization = 1 - util$Percent.Idle
head(util,12)


### Handling Date-Times in R

tail(util)
# European date format used

# Portable Operating System Interface (POSIX) - standard for time, date, etc.
# repesented by digits to seconds from the beginning of 1970
?POSIXct

util$PosixTime <- as.POSIXct(util$Timestamp, format="%d/%m/%Y %H:%M")
#capital letters for full format

head(util, 12)
summary(util)

# TIP: How to rearrange columns in a df
util$Timestamp <- NULL
util <- util[, c(4,1,2,3)]
  #POSIX Timestamp now moved to first column


### What is a List?

summary(util)

RL1 <- util[util$Machine == "RL1", ]
summary(RL1)

# Remove legacy factor memory
RL1$Machine <- factor(RL1$Machine)
summary(RL1)

# Construct List
#Character: Machine name
#Vector: (min, mean, max) Utilization for the month (excluding unknown hours)
#Logical: Has utilization ever fallen below 90%? TRUE/FALSE

util_stats_rl1 <- c(min(RL1$Utilization, na.rm=TRUE), 
                    mean(RL1$Utilization, na.rm=TRUE),
                    max(RL1$Utilization, na.rm=TRUE))

# which indices have TRUE values
util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0
  # length tells how many values there are

list_rl1 <- list("RL1", util_stats_rl1, util_under_90_flag)


### Naming components of a list

names(list_rl1) <- c("Machine", "Stats", "LowThreshold")

# Another way, like with DataFrames:

rm(list_rl1)

list_rl1 <- list(Machine="RL1", Stats=util_stats_rl1, LowThreshold=util_under_90_flag)
list_rl1


### Extracting components of a list
#3 ways:
#[] - will always return a list
  #for subsetting
list_rl1[1]
#[[]] - will always return the actual object (vector, not list)
  #for accessing components of a list
list_rl1[[1]]
#$ - same as [[]] but prettier
list_rl1$Machine

list_rl1[2]
typeof(list_rl1[2])
  #list

list_rl1[[2]]
typeof(list_rl1[[2]])
  #double

list_rl1$Stats
typeof(list_rl1$Stats)
  #double

# how would you access the 3rd element of the vector (max utilization)?
list_rl1[[2]][3]
list_rl1$Stats[3]


### Adding and deleting list components

list_rl1
list_rl1[4] <- "New Information"

#Another way to add a component - via the $
#We will add:
#Vector: All hours where utilization is unknown (NA's)
list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization), "PosixTime"]

#Remove a component. Use the NULL method:
list_rl1[4] <- NULL

#Add another component
list_rl1$Data <- RL1

summary(list_rl1)
str(list_rl1)


#Quick Challenge
list_rl1$UnknownHours[1]
list_rl1[[4]][1]


### Subsetting a list
list_rl1[1:2]
list_rl1[c(1,4)]
sublist_rl1 <- list_rl1[c("Machine","Stats")]
sublist_rl1[[2]][2]

#[[]] are NOT for subsetting
#list_rl1[[1:3]] #ERROR


###Building a timeseries plot
library(ggplot2)

p <- ggplot(data=util)
p + geom_line(aes(x=PosixTime, y=Utilization,
                  colour=Machine), size=1.2) +
  facet_grid(Machine~.) +
  geom_hline(yintercept = 0.90,
             colour="Gray", size=1.2,
             linetype=3)

?linetype

myplot <- p + geom_line(aes(x=PosixTime, y=Utilization,
                            colour=Machine), size=1.2) +
  facet_grid(Machine~.) +
  geom_hline(yintercept = 0.90,
             colour="Gray", size=1.2,
             linetype=3)

list_rl1$Plot <- myplot
list_rl1

summary(list_rl1)
str(list_rl1)






