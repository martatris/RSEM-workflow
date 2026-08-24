R SEM, Regularized SEM & Latent Growth Modeling
=================================================

This repository contains R examples demonstrating Confirmatory Factor Analysis (CFA), Regularized Structural Equation Modeling (RegSEM) using LASSO, and Latent Growth Curve Modeling using lavaan and regsem.

OVERVIEW
--------

The project covers three main examples:

1. Confirmatory Factor Analysis (CFA) using the bfi dataset
2. Regularized SEM using LASSO and cross-validation
3. Latent Growth Curve Modeling using simulated longitudinal data


PACKAGES
--------

The analysis uses:

library(ggplot2)
library(psych)
library(psychTools)
library(lavaan)
library(regsem)
library(tidyverse)
library(colorspace)

Install them with:

install.packages(c(
  "ggplot2",
  "psych",
  "psychTools",
  "lavaan",
  "regsem",
  "tidyverse",
  "colorspace"
))


1. CONFIRMATORY FACTOR ANALYSIS
-------------------------------

The first example uses the bfi dataset.

A subset of 250 observations is selected:

bfi2 <- bfi[1:250, c(1:5, 18, 22)]

The first variable is reverse-scored:

bfi2[, 1] <- reverse.code(-1, bfi2[, 1])

A one-factor CFA model is specified:

mod <- "
  f1 =~ NA*A1 + A2 + A3 + A4 + A5 + O2 + N3
  f1 ~~ 1*f1
"

The model is estimated using lavaan:

out <- cfa(mod, data = bfi2)
summary(out)

The latent factor f1 is measured by:

- A1
- A2
- A3
- A4
- A5
- O2
- N3

The latent variance is fixed to 1 for model identification.


2. REGULARIZED SEM
------------------

The CFA model is used as the starting point for regularized SEM.

Model matrices can be inspected with:

extractMatrices(out)$A

A LASSO-regularized model is estimated using cross-validation:

out.reg <- cv_regsem(
  out,
  type = "lasso",
  pars_pen = 1:7,
  n.lambda = 25,
  jump = 0.05
)

LASSO REGULARIZATION

LASSO applies a penalty to selected parameters. This can shrink weak parameters toward zero and can be useful for identifying a more parsimonious model.

Results can be inspected with:

summary(out.reg)

head(round(out.reg$parameters, 2), 5)

head(round(out.reg$fits, 2))

The regularization path can be visualized using BIC:

plot(out.reg, show.minimum = "BIC")

The final selected parameters are available through:

out.reg$final_pars


3. LATENT GROWTH CURVE MODEL
----------------------------

The second example creates simulated longitudinal data for 200 observations.

Four repeated measurements are generated:

dat_growth <- data.frame(
  x1 = rnorm(200, 50, 10),
  x2 = rnorm(200, 52, 10),
  x3 = rnorm(200, 55, 10),
  x4 = rnorm(200, 58, 10),
  matrix(rnorm(200 * 10), ncol = 10)
)

Ten additional variables are created as covariates:

names(dat_growth)[5:14] <- paste0("c", 1:10)

The resulting dataset contains:

x1  x2  x3  x4  c1  c2  ...  c10


GROWTH MODEL
------------

The latent growth model contains two latent factors:

- i = intercept
- s = slope

mod1 <- "
  i =~ 1*x1 + 1*x2 + 1*x3 + 1*x4

  s =~ 0*x1 + 1*x2 + 2*x3 + 3*x4

  i ~ c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10

  s ~ c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10
"

The intercept factor represents the overall level across the four measurement occasions.

The slope factor represents linear change over time:

Time 1 -> 0
Time 2 -> 1
Time 3 -> 2
Time 4 -> 3

The ten covariates are used to predict both:

- initial status (i)
- rate of change (s)

The model is estimated with:

lav.growth <- growth(
  mod1,
  data = dat_growth,
  fixed.x = TRUE
)

summary(lav.growth)


METHODS
-------

CFA
    Package: lavaan
    Purpose: Test latent factor structure

SEM
    Package: lavaan
    Purpose: Estimate relationships between latent and observed variables

Regularized SEM
    Package: regsem
    Purpose: Penalize parameters and encourage sparsity

LASSO
    Package: regsem
    Purpose: Select or shrink parameters

Cross-validation
    Package: regsem
    Purpose: Select the regularization level

Latent Growth Model
    Package: lavaan
    Purpose: Model longitudinal change


KEY CONCEPTS
------------

Confirmatory Factor Analysis:
CFA tests whether observed variables adequately measure one or more hypothesized latent constructs.

Regularized SEM:
Regularized SEM adds a penalty to model parameters. With LASSO, weak parameters can be pushed toward zero, potentially producing a simpler model.

Latent Growth Modeling:
Latent growth models represent individual trajectories over time through latent intercept and slope factors.


PROJECT STRUCTURE
-----------------

Suggested repository structure:

.
├── README.md
├── sem_analysis.R
└── figures/
    └── regularization_path.png


REQUIREMENTS
------------

- R >= 4.0
- lavaan
- regsem
- psych
- psychTools
- tidyverse
- ggplot2
- colorspace


NOTES
-----

The growth-model dataset is simulated data and is intended for demonstration purposes rather than substantive statistical conclusions.

The CFA example uses the bfi dataset, while the regularized SEM example builds on the fitted CFA model.


REFERENCES
----------

- Rosseel, Y. (2012). lavaan: An R package for structural equation modeling.
- Jacobucci, R., Grimm, K. J., & McArdle, J. J. regsem: Regularized Structural Equation Modeling.
- Revelle, W. psych: Procedures for Psychological, Psychometric, and Personality Research.
