#install.packages("psychTools")
#install.packages("CRAN")
#install.packages("Rcpp")
#install.packages("Rsolnp")

#install.packages(c("colorspace", "ggplot2", "scales", "RColorBrewer"))

library(ggplot2)
library(psych)
library(psychTools)
library(lavaan)
library(regsem)
library(tidyverse)
library(colourspace)

library(regsem)
library(colorspace)


bfi
bfi2 <- bfi[1:250, c(1:5, 18,22)]
bfi2[,1] <- reverse.code(-1, bfi2[,1])


mod <- "

f1 =˜ NA*A1+A2+A3+A4+A5+O2+N3

f1˜˜1*f1

"
mod

out <- cfa(mod, bfi2)


out





#regsem
extractMatrices(out)$A


# this takes a long time to fit
out.reg <- cv_regsem(out, type="lasso",pars_pen=c(1:7),n.lambda=25,jump=.05)

# run summary to check it out
summary(out.reg)


head(round(out.reg$parameters,2),5)


head(round(out.reg$fits,2))
plot(out.reg,show.minimum="BIC")


out.reg$final_pars


# looking at penalties, EXAMPLESSSSS


required <- c(
  paste0("x", 1:4),
  paste0("c", 1:10)
)

required %in% names(dat)



# this is the second example
set.seed(123)

dat_growth <- data.frame(
  x1 = rnorm(200, 50, 10),
  x2 = rnorm(200, 52, 10),
  x3 = rnorm(200, 55, 10),
  x4 = rnorm(200, 58, 10),
  matrix(rnorm(200 * 10), ncol = 10)
)

mod1 <- "

i =˜ 1*x1 + 1*x2 + 1*x3 + 1*x4

s =˜ 0*x1 + 1*x2 + 2*x3 + 3*x4

i ˜ c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10

s ˜ c1 + c2 + c3 + c4 + c5 + c6 + c7 + c8 + c9 + c10

"

names(dat_growth)[5:14] <- paste0("c", 1:10)

lav.growth <- growth(
  mod1,
  data = dat_growth,
  fixed.x = TRUE
)

summary(lav.growth)








