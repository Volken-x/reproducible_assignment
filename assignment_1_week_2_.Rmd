---
title: "Reproducible course assignment"
author: "Leonardo"
date: "23/07/2020"
output: html_document
---
## Loading the dataset

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```



```{r}

activity = read.csv("C:/Users/Leo/Downloads/repdata_data_activity/activity.csv")
```

The dataset look like this:
```{r, echo=FALSE}
head(activity)
```



## What is mean total number of steps taken per day?  

 First, we create an array of the number of steps, by day

```{r, echo=TRUE}
summary(activity$steps)
count = tapply(activity$steps, activity$date, sum, na.rm=TRUE)
View(count)
```


 After we get the mean of the values of steps/day
```{r, echo=TRUE}
 mean(count)
```


## Make a histogram of the total number of steps taken each day:

````{r}
Hcount= as.vector(count)
hist(Hcount)
````

## Calculate and report the mean and median of the total number of steps taken per day

Now we try to discover the mean and median

````{r}
summary(Hcount)
```


 Or we can  use the direct functions
````{r}
mean(Hcount) 
```

````{r}
median(Hcount) 
```
## Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


 Lets calculate the mean steps per interval of the period
````{r}
smean = as.data.frame(tapply(activity$steps, activity$interval, mean, na.rm=TRUE))
```

## We will need to change the current column name, ad right after include de row names as separate column, and check the data to finish

```{r}
names(smean)[1] = "mean_values" 
smean$interval = row.names(smean)
head(smean)
```


 to the plot part we will use the ggplot2 package
```{r}
require(ggplot2) 
```

 plotting the graph using or first dataset
````{r}
ggplot(smean, aes( x = interval,y = mean_values,group = 1))+
  geom_line() +
  scale_x_discrete(breaks = seq(0,2355,150))+
theme_classic()

```

## Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

Now we obtain the maximum value throught the *smean* dataset

```{r}
sapply(smean, max, na.rm = FALSE)
```

## Calculate and report the total number of missing values in the dataset 

 let's just sum the numbe of NAs
```{r}
sum(is.na(activity$steps))
```
## Devise a strategy for filling in all of the missing values in the dataset.

The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

## Create a new dataset that is equal to the original dataset but with the missing data filled in.

We will deal with these parts toghether, filing the NAs as the mean steps of the period

```{r}
Ractivity = activity
Ractivity[is.na(Ractivity)] = mean(Ractivity$steps, na.rm = TRUE)
head(Ractivity)
```

## Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day

```{r}
Rmean = tapply(Ractivity$steps, Ractivity$date, sum, na.rm=TRUE)
summary(Rmean)
```

## Creating the histogram:
```{r}
hist(Rmean)
```
#Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?
## We see that the distributions and the central measurements were very different when we fill the missing values by the mean


#Are there differences in activity patterns between weekdays and weekends?
For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.

## Create a new factor variable in the dataset with two levels 

"weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

First we will change the dataset to include the dates

```{r}
datamean= as.data.frame(Rmean)
names(datamean)[1] = "values" 
datamean$date = row.names(datamean)
```

we must change the class of the data to date and crate a new colum with the weekdays (only to check)  and other as "weekdays" or "weekends"

```{r}
wkdate = datamean
wkdate$date = as.Date(wkdate$date, format =  c("%Y-%m-%d"))
wkdate$day = weekdays(wkdate$date)
wkdate$class = ifelse(wkdate$day %in% c("segunda-feira","terça-feira","quarta-feira","quinta-feira","sexta-feira"), "weekday", "weekend")
```


 Although the last step could be simplified to:

```{r}
wkdate$class = ifelse(wkdate$day %in% c("sábado", "domingo"), "weekend", "weekday")
```

Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).


now we include the new column as the weekdays or weekends

```{r}
ggplot(wkdate, aes(x= date, y= values))+ geom_line(aes(color = class))
```

