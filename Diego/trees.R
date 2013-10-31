require(mboost)
require(stats)
require(boot)
require(party)
require(mgcv)
require(caret)

# First scale the variables
scaled_training <- training;
scaled_training[,1] = scaled_training[,1]/8;
scaled_training[,2] = scaled_training[,2]/160;
scaled_training[,3] = scaled_training[,3]/80;
scaled_training[,4] = scaled_training[,4]/80;
scaled_training[,5] = scaled_training[,5]/160;
scaled_training[,6] = scaled_training[,6]/16;
scaled_training[,7] = scaled_training[,7]/8;
scaled_training[,8] = scaled_training[,8]/32768;
scaled_training[,9] = scaled_training[,9]/1024;
scaled_training[,10] = scaled_training[,10]/32;
scaled_training[,11] = scaled_training[,11]/1024;
scaled_training[,12] = scaled_training[,12]/1024;
scaled_training[,13] = scaled_training[,13]/8192;
scaled_training[,14] = scaled_training[,14]/3;
scaled_training[,15] = scaled_training[,15]/1e4

# Define an utility function for calculating the 10-fold cross-validation error

cv_rmse_ctree <- function(training_set, k = 10){
  accum_error = 0;
  folds <- createFolds(training_set[,1]);
  for(foldName in names(folds)){
    current_tree <- ctree(V15 ~ ., data = training_set[-folds[[foldName]],]);
    prediction <- predict(current_tree, newdata = training_set[folds[[foldName]],1:14]);
    error <- (prediction - training_set[folds[[foldName]],15])^2;
    accum_error <- accum_error + sum(error)/length(folds[[foldName]]);
  }
  return(accum_error/k);
}

# Let's try a non-linear conditional inference tree
tree_simple = ctree(V15 ~ ., data = scaled_training)
plot(tree_simple)
cverror_simple <- cv_rmse_ctree(scaled_training)/mean(scaled_training[,15])
print(cverror_simple)

# Now using boosting for the same conditional inference trees
model <- blackboost(V15 ~ ., data = scaled_training,
                  control = boost_control(mstop = 500))
cv10f <- cv(model.weights(model), type = "kfold")
cvm <- cvrisk(model, folds = cv10f, papply = lapply)
plot(cvm)
print(mean(cvm[, mstop(cvm)])/mean(scaled_training[,15]))

# Now based on the analysis from the signficance of the variables, try a different boosted formula

model_less <- blackboost(V15 ~ V13 + V14 + V5 + V10, data = scaled_training,
                    control = boost_control(mstop = 500))
cv10f <- cv(model.weights(model), type = "kfold")
cvm <- cvrisk(model, folds = cv10f, papply = lapply)
plot(cvm)
print(mean(cvm[, mstop(cvm)])/mean(scaled_training[,15]))

write.table(predict(tree_simple, newdata = scaled_validation)*1e4, file='CTree.csv', row.names=FALSE, col.names=FALSE)
write.table(predict(model, newdata = scaled_validation)*1e4, file='BoostedTreeFull.csv', row.names=FALSE, col.names=FALSE)
write.table(predict(model_less, newdata = scaled_validation)*1e4, file='BoostedTreesFewFeatures.csv', row.names=FALSE, col.names=FALSE)