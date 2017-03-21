
getwd()

setwd("./Advanced/S4 - Apply Family of Functions/")

Chicago <- read.csv("Chicago-C.csv", row.names=1)
NewYork <- read.csv("NewYork-C.csv", row.names=1)
Houston <- read.csv("Houston-C.csv", row.names=1)
SanFrancisco <- read.csv("SanFrancisco-C.csv", row.names=1)

#dataframes imported:
is.data.frame(Chicago)

#convert to matrices
Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco <- as.matrix(SanFrancisco)

#check:
is.matrix(Chicago)

#put into a list:
Weather <- list(Chicago=Chicago, 
                NewYork=NewYork, 
                Houston=Houston, 
                SanFrancisco=SanFrancisco)

Weather[[3]]

#apply(M, 1, mean) 
  #apply mean to rows (indicated by 1) of matrix M
#apply(M, 2, max) 
  #apply max to cols (indicated by 2) of matrix M


### Using apply()

#avg of all values in each row
apply(Chicago, 1, mean)

#check:
mean(Chicago["DaysWithPrecip", ])

apply(Chicago, 1, max)
apply(Chicago, 1, min)

#for practice:
apply(Chicago, 2, max)
apply(Chicago, 2, min)

#Compare:
apply(Chicago, 1, mean)
apply(NewYork, 1, mean)
apply(Houston, 1, mean)
apply(SanFrancisco, 1, mean)

  #<<< deliverable 1 but incomplete


### Recreating the apply function with loops (advanced topic)

# find mean of every row:
# 1 - via loops

output <- NULL #prepare an empty vector
for(i in 1:5){
  output[i] <- mean(Chicago[i,])
}

names(output) <- rownames(Chicago)

#check:
output

# 2 - via apply function
apply(Chicago, 1, mean)


### Using lapply()

?lapply

# transpose a matrix
t(Chicago)

# transpose a list
lapply(Weather, t) # list(t(Chicago), t(NewYork), t(Houston), t(SanFrancisco))

mynewlist <- lapply(Weather, t)

# example 2
rbind(Chicago, NewRow=1:12)

lapply(Weather, rbind, NewRow=1:12)
# always returns a list

# example 3
rowMeans(Chicago) #identical to: apply(Chicago, 1, mean)

lapply(Weather, rowMeans)
  # <<< deliverable 1, but still incomplete

#rowMeans
#colMeans
#rowSums
#colSums


### Combining lapply with the [] operator

Weather$Chicago[1,1]  #Weather[[1]][1,1], Weather[[2]],[1,1], etc
# identical to:
Weather[[1]][1,1] #Weather$Chicago[1,1], Weather$NewYork[1,1], etc

# select [1,1] of each matrix
lapply(Weather, "[", 1, 1)

# select first row data of each matrix
lapply(Weather, "[", 1, ) # R thinks there is a missing arg

# select March info
lapply(Weather, "[", ,3)


### Adding your own functions

# selects 1st row of each matrix in the list
lapply(Weather, function(x) x[1,] )
# selects 5th row of each matrix in the list
lapply(Weather, function(x) x[5,] )
# selects 12th col of each matrix in the list
lapply(Weather, function(x) x[,12] )

# difference between high and low temp for each month
lapply(Weather, function(z) z[1,]-z[2,])
# in % form
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], 2))
  # Deliverable 2, will be improved


### Using sapply()

#AvgHigh for July:
lapply(Weather, "[", 1, 7)
#returns the same in a vector form
sapply(Weather, "[", 1, 7)

#AvgHigh for 4th quarter
lapply(Weather, "[", 1, 10:12)
#returns the same in a matrix form
sapply(Weather, "[", 1, 10:12)

#rowMeans
lapply(Weather, rowMeans)
#returns the same in a matrix form
sapply(Weather, rowMeans)
round(sapply(Weather, rowMeans), 2)
  # <<< Deliverable 1 Complete

# temp fluctuations
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], 2))
sapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], 2))
  # <<< Deliverable 2 Complete

#By the way:
sapply(Weather, rowMeans, simplify=FALSE) #same as lapply


### Nesting Apply Functions

lapply(Weather, rowMeans)
#no predefined functions for min or max

apply(Chicago, 1, max)
#apply across whole list (nested apply)
lapply(Weather, apply, 1, max) # preferred
lapply(Weather, function(x) apply(x, 1, max)) #same result as above
#tidy up:
sapply(Weather, apply, 1, max) #<<< deliverable 3
sapply(Weather, apply, 1, min) #<<< deliverable 4


### Very advanced tutorial
### which.max() and which.min()

which.max(Chicago[1,])
#gives index of where that max occurred
names(which.max(Chicago[1,]))

#apply to iterate over rows of the matrix
#lapply/sapply to iterate over components of the list

apply(Chicago, 1, function(x) names(which.max(x)))
  #returns which month the max of each row occurred in Chicago

sapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x))))
  #returns which month the max of each row occured in each component of Weather
  #>>> deliverable 5


