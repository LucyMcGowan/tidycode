
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidycode

The goal of tidycode is to allow users to analyze R expressions in a
tidy way.

## Installation

You can install tidycode from github with:

``` r
# install.packages("devtools")
devtools::install_github("LucyMcGowan/tidycode")
```

## Example

Using the matahari package, we can capture R expressions that are
called. For example, the following code will capture the two lines of R
code, a plot and a model.

``` r
library(tidycode)
```

``` r
matahari::dance_start()
plot(1:10)
```

![](README-example-1.png)<!-- -->

``` r
m <- lm(mpg ~ cyl, mtcars)
matahari::dance_stop()
expr <- matahari::dance_tbl()$expr
```

Let’s look at those expressions.

``` r
expr
#> [[1]]
#> sessionInfo()
#> 
#> [[2]]
#> matahari::dance_start()
#> 
#> [[3]]
#> plot(1:10)
#> 
#> [[4]]
#> m <- lm(mpg ~ cyl, mtcars)
#> 
#> [[5]]
#> sessionInfo()
```

We can check which expressions are plots using the `is_plot()` function.

``` r
purrr::map_lgl(expr, is_plot)
#> [1] FALSE FALSE  TRUE FALSE FALSE
```

We can check which expressions are calling modeling functions using the
`is_model()` function.

``` r
purrr::map_lgl(expr, is_model)
#> [1] FALSE FALSE FALSE  TRUE FALSE
```

Now let’s clean up\!

``` r
matahari::dance_remove()
```

## Contributing

Currently, the model and plot functions work by pulling in all functions
from certain packages that are intended for modeling and plotting. To
add more functions, update the files in the
[`data-raw`](https://github.com/LucyMcGowan/tidycode/tree/master/data-raw)
folder.
