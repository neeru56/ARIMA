

```{r}
# Data overview
x<-read.csv("D://projects//ECLERX.csv",header=T)
```


```{r}
# Data exploration 
str(x)
View(x)
summary(x)
```



```{r}
# taking only 2 columns
x1<-x[ ,c(1,5)]
View(x1)
head(x1)
```




```{r}

# identify count of NAs in data frame
sum(is.na(x1))

# columns wise na values
colSums(is.na(x1))
```


```{r}
x1$Close[is.na(x1$Close)] <- mean(x1$Close, na.rm = TRUE)
x1$Date[is.na(x1$Date)] <-0
```


```{r}
# correcting the data type of the columns
x1$Close<- as.numeric(x1$Close)
x1$Date <- as.Date(x1$Date, format = "%Y-%m-%d")
```



```{r}
# convert to ln format as these are in percentages
#which(as.numeric(as.character(x1$Close)))
```

```{r}
# 
lnstock=log(x1$Close)
```



```{r}
class(x1$Date)
```



```{r}
library(tidyr)
a=x1 %>% complete(Date = seq.Date(min(Date), max(Date), by="day"))
View(a)


colSums(is.na(a))
which(is.na(a$Close))
a$Close[is.na(a$Close)] <- mean(a$Close, na.rm = TRUE)
```



```{r}
m<-ts(x1$Close,frequency = 12,start=c(2013,05),end=c(2018,04))
class(m)

head(m)
tail(m)
```



```{r}
# check seasonaity
boxplot(m~cycle(m))
```



```{r}
# AR-p,I-d,MA-q
#trend of the data 
# log -constant variance, diff - constant mean 
par(mfrow=c(1,1))
plot(m)
plot(log(m))
plot(diff(log(m)))
plot(diff(diff(log(m))))

acf(m)
acf(log(m)) # no change
par(mfrow=c(1,1))
acf(diff(m))
acf(diff(diff(m))) # performing worse
#q=1
pacf(diff(m))
#p=0
#d=1
# either wrie diff or put value d=1
fit<-arima(m,c(0,1,1),seasonal=list(order=c(0,1,1),period=12))
pred<-predict(fit,n.ahead = 5*12)
ts.plot(m,pred$pred,lty=c(1,3))
```


```{r}
# testing ur model 
dat<-ts(m,frequency = 12,start=c(2013,05),end=c(2016,12))
fit<-arima(dat,c(0,1,1),seasonal=list(order=c(0,1,1),period=12))
pred<-predict(fit,n.ahead=2*12)  

```


