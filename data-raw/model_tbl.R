library(tidyverse)
library(rprojroot)
library(recipes)
library(lme4)
library(survival)
library(rpart)
library(nnet)
library(glmnet)
library(gbm)
library(lars)
library(randomForest)
library(caret)

df <- tibble(
  model_fx = c(ls("package:stats"),
               ls("package:recipes"),
               ls("package:lme4"),
               ls("package:survival"),
               ls("package:rpart"),
               ls("package:nnet"),
               ls("package:glmnet"),
               ls("package:gbm"),
               ls("package:lars"),
               ls("package:randomForest"),
               ls("package:caret"))
)

write_csv(df, path = find_package_root_file("inst", "extdata", "model_tbl.csv"))

