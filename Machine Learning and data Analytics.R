# Libraries
install.packages('psych', dep=TRUE, lib=NULL)
# Naive Bayes

# Libraries
library(naivebayes)
library(dplyr)
library(ggplot2)
library(psych)

#Read data file
getwd()
data <- read.csv('https://raw.githubusercontent.com/bkrai/Statistical-Modeling-and-Graphs-with-R/main/binary.csv')

#contingency table 
xtabs(~admit + rank, data = data)

#Rank & admit are categorical variables
data$rank <- as.factor(data$rank)
data$admit <- as.factor(data$admit)

# Visualization
pairs.panels(data[-1])
data %>% 
  group_by(admit) %>%
  ggplot(aes(x=admit, y=gre, fill=admit)) +
  geom_boxplot() 

data %>% 
  ggplot(aes(x=admit, y=gpa, fill=admit)) +
  geom_boxplot() +
  ggtitle('Box Plot') 

data %>%
  ggplot(aes(x=gre, fill=admit)) +
  geom_density(alpha=0.8, color='black') +
  ggtitle('Density Plot') 

data %>%
  ggplot(aes(x=gpa, fill=admit)) +
  geom_density(alpha=0.8, color='black') +
  ggtitle('Density Plot') 


#Split data into Training (80%) and Testing (20%) datasets
set.seed(1234)
ind<- sample(2,nrow(data),replace=TRUE, prob=c(0.8,.2))
train <- data[ind==1,]
test <- data[ind==2,]

# Naive Bayes
model <- naive_bayes(admit ~ ., data = train)
model
plot(model)

# numeric predictors - means (1st col) & sd's (2nd col) 
train %>% filter(admit=="0") %>% 
  summarize(mean(gre), sd(gre))

# Predict
p <- predict(model, train, type= 'prob')
head(cbind(p, train))

# Misclassification error - train data
p1 <- predict(model, train)
(tab1 <- table(p1, train$admit))
1 - sum(diag(tab1))/ sum(tab1)

# Misclassification error - test data
p2 <- predict(model, test)
(tab2 <- table(p2, test$admit))
1 - sum(diag(tab2))/ sum(tab2)