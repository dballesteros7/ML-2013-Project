ML-2013-Project
===============

Jonas
---
**Check analysis.html for a description of the analysis.**
Run make to generate predictions for the validation testset.

| Model        | Training Set [1]   | Validation Set  |
| -------------     |:-------------:| -----:|
| simple LM                 | 12025 | 0.44  |
| simple logLM              | 31288 | 1.2   |
| complex LM                | 9652  | 0.36  |
| regularized complex LM    |   9500    |   	0.40    |
| GAM                       |   **5514**    |   **0.17**   |

-   *simple LM*: First analysis with linear regression in R, use the significant features: IQSize,RFSize,BranchesAllowed,Depth,L2Ucache
-   *simple logLM*: model with log-transformation for dependent variable
-   *complex LM*: using logarithmic feature transformation, polynomial features and interactions. Without regularization.
-   *regularized complex LM*: with regularization (ridge regression).
-   *GAM*: Generalized additive model using splines and tensor product.

[1] Mean RSME of 10-fold cross-validation

Diego
---

Epsilon-Support Vector Regression
--

Input data normalized to 0-1
Output data scaled down by a factor of 10^4

Training with libsvm
10-fold cross validation, selecting on best CV(RMSE)

1. Exploration of C and g over a large range

    Range for C: 2 to 32768
    Range for g: 0.00390625 to 1

    Best C: 20171
    Best G: 0.00390625

    Best cost: 0.402
  
    Validation test results: 0.365239727094791

2. Closing in on the optimal C and g values

    Range for C: 4096 to 2.621e5
    Range for g: 0.0009766 to 0.01563
    
    Best C: 1.7925e5
    Best g: 0.0013
    
    Best cost: 0.3863
    
    Validation test results: 0.3615159865445466
    
Boosting with GLM and GAM
--

1. 10-fold cross validation with simple GLM from R

    5000 max boosting iterations

    Optimal iteration numbers: 165
    CV(RMSE) on cross-validation: 0.5993471

    Validation test result: 0.451003493590818

2. 10-fold cross validation with GAM from R

    1000 max boosting iterations

    Optimal iteration numbers: 159
    CV(RMSE) on cross-validation: 0.3154474

    Validation test result: 0.33336512653300393

3. 10-fold cross validation with GAM and splines from R

    1000 max boosting iterations
    Optimal iteration numbers: 170
    CV(RMSE) on cross-validation: 0.3075744

    Validation test result: 0.33274169155253847

4. 10-fold cross validation with GAM from R
    
    Formula:  V15 ~ bbs(V13) + bbs(V14) + bbs(V13, by = V14) + bbs(V4) + bbs(V5) + bbs(V4, by = V5) + V3 + V10 + V8 + V12 + V1 + V7 + V2
    
    1000 max boosting iterations
    
    Optimal iteration numbers: 307
    CV(RMSE) on cross-validation: 0.1175413
    
    Validation test result: 0.1804036769599063
    

5. 10-fold cross validation with GAM from R
    
    Formula:  V15 ~ bbs(V14) + bbs(V13, by=V14) + bbs(V4) + bbs(V5) + bbs(V4, by=V5) + btree(V3) + bbs(V10) + btree(V12) + btree(V2)
    
    1000 max boosting iterations
    
    Optimal iteration numbers: 226
    CV(RMSE) on cross-validation: 0.1152574
    
    Validation test result: 0.17877985269267538
    
