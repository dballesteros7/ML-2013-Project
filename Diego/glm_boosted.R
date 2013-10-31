require(mboost)
require(stats)
require(boot)

# Scale the variables
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

# Try a single GLM classifier, note that there is no regularization there.
# Check the CV(RMSE) in 10-fold cross-validation, although no hyper parameter is being optimized.

simple_model <- glm(V15 ~ ., data = scaled_training)
print(summary(simple_model))
cverror_simple <- cv.glm(scaled_training, simple_model, K = 10)
#Print the CV(RMSE)
print(cverror_simple$delta[2]/mean(scaled_training[,15]))

# Now let's boost the GLM classifier
model <- glmboost(V15 ~ ., data = scaled_training, control = boost_control(mstop = 1000))
cv10f <- cv(model.weights(model), type = "kfold", B = 10)
cvm <- cvrisk(model, folds = cv10f, papply = lapply)
print(summary(model[mstop(cvm)]))
plot(cvm)
print(mean(cvm[, mstop(cvm)])/mean(scaled_training[,15]))