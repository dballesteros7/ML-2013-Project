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
