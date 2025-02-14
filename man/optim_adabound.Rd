% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adabound.R
\name{optim_adabound}
\alias{optim_adabound}
\title{Adabound optimizer}
\usage{
optim_adabound(
  params,
  lr = 0.001,
  betas = c(0.9, 0.999),
  final_lr = 0.1,
  gamma = 0.001,
  eps = 1e-08,
  weight_decay = 0
)
}
\arguments{
\item{params}{List of parameters to optimize.}

\item{lr}{Learning rate (default: 1e-3)}

\item{betas}{Coefficients computing running averages of gradient
and its square (default: (0.9, 0.999))}

\item{final_lr}{Final (SGD) learning rate (default: 0.1)}

\item{gamma}{Convergence speed of the bound functions
(default: 1e-3)}

\item{eps}{Term added to the denominator to improve numerical
stability (default: 1e-8)}

\item{weight_decay}{Weight decay (L2 penalty) (default: 0)}
}
\value{
A torch optimizer object implementing the \code{step} method.
}
\description{
R implementation of the AdaBound optimizer proposed
by Luo et al.(2019). We used the implementation available at
https://github.com/jettify/pytorch-optimizer/blob/master/torch_optimizer/yogi.py.
Thanks to Nikolay Novik for providing the pytorch code.

The original implementation is licensed using the Apache-2.0 software license.
This implementation is also licensed using Apache-2.0 license.

AdaBound is a variant of the Adam stochastic optimizer which is
designed to be more robust to extreme learning rates.
Dynamic bounds are employed on learning rates,
where the lower and upper bound are initialized as zero and
infinity respectively, and they both smoothly converge to a
constant final step size. AdaBound can be regarded as an adaptive
method at the beginning of training, and thereafter it gradually and
smoothly transforms to SGD (or with momentum) as the time step increases.
}
\examples{
if (torch::torch_is_installed()) {
library(torch)
# define test function
test_matyas <- function(x, y) { log(0.26 * (x^2 + y^2) - 0.48 * x * y)}
# define starting point
x0 <- -5
y0 <- -5
# create tensor
x <- torch::torch_tensor(x0, requires_grad = TRUE)
y <- torch::torch_tensor(y0, requires_grad = TRUE)
# define optimizer
optim <- optim_adabound
opt_hparams <- list(lr = 0.5)
optim <- do.call(optim, c(list(params = list(x, y)), opt_hparams))
# run optimizer
steps <- 200
x_steps <- numeric(steps)
y_steps <- numeric(steps)
for (i in seq_len(steps)) {
     x_steps[i] <- as.numeric(x)
     y_steps[i] <- as.numeric(y)
     optim$zero_grad()
     z <- test_matyas(x, y)
     z$backward()
     optim$step()
}
}
}
\references{
Liangchen Luo, Yuanhao Xiong, Yan Liu, Xu Sun,
"Adaptive Gradient Methods with Dynamic Bound of Learning Rate",
International Conference on Learning Representations (ICLR), 2019.
https://arxiv.org/abs/1902.09843
}
\author{
Rolf Simoes, \email{rolf.simoes@inpe.br}

Felipe Souza, \email{lipecaso@gmail.com}

Alber Sanchez, \email{alber.ipia@inpe.br}

Gilberto Camara, \email{gilberto.camara@inpe.br}
}
