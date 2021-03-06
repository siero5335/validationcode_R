#Library
library(caret)
library(mlbench)

#Data
data(BostonHousing)
set.seed(71)
Index <- createDataPartition(BostonHousing$medv, p = .7,
                                  list = FALSE,
                                  times = 1)

Train <- BostonHousing[ Index,]
Test  <- BostonHousing[-Index,]

#Training
set.seed(71)
con<-trainControl(method = "repeatedcv",
                  number = 10,
                  preProc = c("center", "scale"))

train_grid = expand.grid(mtry = 1:10)

rf_fit = train(Train[ , 1:13], Train$medv,
                 method = "rf", 
                 tuneGrid = train_grid,
                 trControl=con)

rf_fit

#Result
pred <- predict(rf_fit, Test[ , 1:13])
pred2 <- predict(rf_fit, Train[ , 1:13])

sqrt(mean((pred - Test$medv)^2))
cor(pred, Test$medv)^2
cor(pred2, Train$medv)^2

#Validation 
#Tropsha's R^2: (Acceptable: Tropha's R^2 > 0.5)
R2_tr <- 1 -  sum((Test$medv - (pred))^2)/sum((Test$medv - mean(pred2))^2)
R2_tr 

# K:(Acceptable: 0.85 < k < 1.15)
k <- (sum(pred * Test$medv))/(sum((pred)^2))
k

#R^20 (Acceptable: (R2_tr-R_20)/R2_tr < 0.1)
R_20 <- 1 - (sum((pred - k*(pred))^2)/sum((pred - mean(pred))^2))
(R2_tr-R_20)/R2_tr
