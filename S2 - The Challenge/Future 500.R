getwd()

setwd("C:/Users/Gaelan/Dropbox/#Documents/#R Scripts/Advanced/")

fin <- read.csv("Future-500.csv", na.strings=c("")) #replace empty chars with NA
head(fin)
str(fin)
summary(fin)

### Changing from non-factor to factor
factor(fin$ID)
#Levels is a giveaway for factor

fin$Inception <- factor(fin$Inception)
summary(fin)
str(fin)

# Factor Variable Trap (FVT)
# For characters
a <- c("12","13","14","12","12")
a
typeof(a)

b <- as.numeric(a)
b
typeof(b)

### Converting into Numerics for Factors
z <- factor(c("12","13","14","12","12"))
z
typeof(z)

y <- as.numeric(z)
y
typeof(y)

#------ Correct way:
x <- as.numeric(as.character(z))
x
typeof(x)

# Convert into raw character first before into numeric so that
# the numbers are not identified as factors

# FVT Example

head(fin)
str(fin)
# fin$Profit <- factor(fin$Profit) #Dangerous

# fin$profit <- as.numeric(fin$Profit) #Dangerous


### sub() and gsub()
fin$Expenses <- gsub(" Dollars", "", fin$Expenses)
fin$Expenses <- gsub(",", "", fin$Expenses)
head(fin)
str(fin)

fin$Revenue <- gsub("\\$", "", fin$Revenue)
fin$Revenue <- gsub(",", "", fin$Revenue)
head(fin)

fin$Growth <- gsub("%", "", fin$Growth)
head(fin)
str(fin)

# convert character to numeric
fin$Expenses <- as.numeric(fin$Expenses)
fin$Revenue <- as.numeric(fin$Revenue)
fin$Growth <- as.numeric(fin$Growth)
str(fin)
summary(fin)


### What is an NA?
?NA

TRUE #1
FALSE #0
NA

### Locating Missing Data
head(fin,24)

#returns TRUE if not blank cell
complete.cases(fin)

#shows cases with NA, but only those it identifies as NA (cannot identify empty chars)
fin[!complete.cases(fin),]

#more rows picked up as NA after replacing empty chars with NA

# <NA> for NA factors
# NA for NA numbers


### Filtering: using which() for non-missing data
head(fin)
fin[fin$Revenue == 9746272,] 
  # NA values appear as well as R does not know what to do with NA!

?which # looks through vector and picks out TRUE values only, ignores NA
which(fin$Revenue == 9746272)
fin[which(fin$Revenue == 9746272),]

fin[fin$Employees == 45,] #NA picked up
#to get rid of NAs,
fin[which(fin$Employees == 45),]


### Filtering: using is.na() for missing data
head(fin,24)

#fin$Expenses == NA
#everything will be NA because result will always be NA

#correct function is...
is.na(fin$Expenses)
fin[is.na(fin$Expenses),]


### Removing records with missing data

# Creating a backup of dataset
fin_backup <- fin

fin[!complete.cases(fin),]
fin[is.na(fin$Industry),] #which values are empty
fin[!is.na(fin$Industry),] #opposite
fin <- fin[!is.na(fin$Industry),] #removing rows without blank Industry values
fin


### Resetting the DataFrame Index

# when rows are removed, the index needs to be reset to follow the order
fin
rownames(fin) <- 1:nrow(fin) #reset index with number of rows
rownames(fin) <- NULL #faster way to reset index
fin

### Replacing Missing Data: Factual Analysis Method
fin[!complete.cases(fin),]

# Focus on State col with NA
fin[is.na(fin$State),]
fin[is.na(fin$State) & fin$City == "New York", "State"] <- "NY"

#check:
fin[c(11,377),] #State has been updated to NY

fin[!complete.cases(fin),]
#list has reduced

fin[is.na(fin$State) & fin$City == "San Francisco", "State"] <- "CA"

#check
fin[c(82,265),]


### Replacing Missing Data: Median Imputation Method - for Employees col

mean(fin[, "Employees"], na.rm=TRUE)
median(fin[, "Employees"], na.rm=TRUE)
med_empl_retail <- median(fin[fin$Industry == "Retail", "Employees"], na.rm=TRUE)
mean(fin[fin$Industry == "Retail", "Employees"], na.rm=TRUE)

#input median of employees into Retail sector with NA value
fin[is.na(fin$Employees) & fin$Industry == "Retail", "Employees"] <- med_empl_retail

#check
fin[3,]

# finding median of employees in FS sector, less NA entries
med_empl_fs <- median(fin[fin$Industry == "Financial Services", "Employees"], na.rm=TRUE)
# input median into NA entry of Employees col for FS sector
fin[is.na(fin$Employees) & fin$Industry == "Financial Services", "Employees"] <- med_empl_fs

#check
fin[330,]

fin[!complete.cases(fin),]


### Replacing Missing Data: Median Imputation Method (Part 2)
#Growth
med_growth_constr <- median(fin[fin$Industry == "Construction", "Growth"], na.rm=TRUE)
fin[is.na(fin$Growth) & fin$Industry == "Construction", "Growth"] <- med_growth_constr

#check
fin[8,]

fin[!complete.cases(fin), ]

#Expenses
med_exp_constr <- median(fin[fin$Industry == "Construction", "Expenses"], na.rm=TRUE)
fin[is.na(fin$Expenses) & fin$Industry == "Construction", "Expenses"] <- med_exp_constr

fin[!complete.cases(fin), ]

#Revenue
med_rev_constr <- median(fin[fin$Industry == "Construction", "Revenue"], na.rm=TRUE)
fin[is.na(fin$Revenue) & fin$Industry == "Construction", "Revenue"] <- med_rev_constr

fin[!complete.cases(fin), ]


### Replacing Missing Data: Deriving Values

#Revenue - Expenses = Profit
#Expenses = Revenue - Profit

fin[is.na(fin$Profit), "Profit"] <- fin[is.na(fin$Profit), "Revenue"] - fin[is.na(fin$Profit), "Expenses"]

#check
fin[c(8,42),]

fin[is.na(fin$Expenses), "Expenses"] <- fin[is.na(fin$Expenses), "Revenue"] - fin[is.na(fin$Expenses), "Profit"]

#check
fin[15,]

fin[!complete.cases(fin),]

#Data Preparation Completed


### Data Visualization

library(ggplot2)

p <- ggplot(data=fin)

p + geom_point(aes(x=Revenue, y=Expenses,
                   colour=Industry, size=Profit))
# A scatterplot that includes industry trends for the expenses-revenue
d <- ggplot(data=fin, aes(x=Revenue, y=Expenses,
                          colour=Industry))
d + geom_point() +
  geom_smooth(fill=NA, size=1.2)

  #geom_point shows the data points and geom_smooth displays the trends

# box plots showing growth by industry
f <- ggplot(data=fin, aes(x=Industry, y=Growth,
                          colour=Industry))

f + geom_boxplot(size=1)

# Extra
f + geom_jitter() +
  geom_boxplot(size=1, alpha=0.5, outlier.color = NA)
