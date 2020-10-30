
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/LucyMcGowan/tidycode.svg?branch=master)](https://travis-ci.org/LucyMcGowan/tidycode)
[![Codecov test
coverage](https://codecov.io/gh/LucyMcGowan/tidycode/branch/master/graph/badge.svg)](https://codecov.io/gh/LucyMcGowan/tidycode?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidycode)](https://cran.r-project.org/package=tidycode)
<!-- badges: end -->

# tidycode

The goal of tidycode is to allow users to analyze R expressions in a
tidy way.

## Installation

You can install tidycode from CRAN with:

``` r
install.packages("tidycode")
```

You can install the development version of tidycode from github with:

``` r
# install.packages("remotes")
remotes::install_github("LucyMcGowan/tidycode")
```

## Example

### Read in existing code

Using the matahari package, we can read in existing code, either as a
string or a file, and turn it into a matahari tibble using
`matahari::dance_recital()`.

``` r
code <- "
library(broom)
library(glue)
m <- lm(mpg ~ am, data = mtcars)
t <- tidy(m)
glue_data(t, 'The point estimate for term {term} is {estimate}.')
"

m <- matahari::dance_recital(code)
```

Alternatively, you may already have a matahari tibble that was recorded
during an R session.

Load the tidycode library.

``` r
library(tidycode)
```

We can use the expressions from this matahari tibble to extract the
names of the packages included. We can also create a data frame that
will include *all* functions of the packages included.

``` r
(pkg_names <- ls_packages(m$expr))
#> [1] "broom" "glue"
pkg_functions <- get_package_functions(m$expr)
```

Create a data frame of your expressions, splitting each into individual
functions.

``` r
u <- unnest_calls(m, expr)
```

Merge in the package names

``` r
u <- u %>%
  dplyr::left_join(pkg_functions) %>%
  dplyr::select(func, args, line, package)
#> Joining, by = "func"
u
#> # A tibble: 8 x 4
#>   func      args              line package
#>   <chr>     <list>           <int> <chr>  
#> 1 library   <list [1]>           1 base   
#> 2 library   <list [1]>           2 base   
#> 3 <-        <list [2]>           3 base   
#> 4 lm        <named list [2]>     3 stats  
#> 5 ~         <list [2]>           3 base   
#> 6 <-        <list [2]>           4 base   
#> 7 tidy      <list [1]>           4 broom  
#> 8 glue_data <list [2]>           5 glue
```

Add in the function classifications\!

``` r
u %>%
  dplyr::inner_join(
    get_classifications("crowdsource", include_duplicates = FALSE)
    )
#> Joining, by = "func"
#> # A tibble: 8 x 5
#>   func      args              line package classification
#>   <chr>     <list>           <int> <chr>   <chr>         
#> 1 library   <list [1]>           1 base    setup         
#> 2 library   <list [1]>           2 base    setup         
#> 3 <-        <list [2]>           3 base    data cleaning 
#> 4 lm        <named list [2]>     3 stats   modeling      
#> 5 ~         <list [2]>           3 base    modeling      
#> 6 <-        <list [2]>           4 base    data cleaning 
#> 7 tidy      <list [1]>           4 broom   modeling      
#> 8 glue_data <list [2]>           5 glue    communication
```

We can also remove a list of “stopwords”. We have a function,
`get_stopfuncs()` that lists common “stopwords”, frequently used
operators, like `%>%` and `+`.

``` r
u %>%
  dplyr::inner_join(
    get_classifications("crowdsource", include_duplicates = FALSE)
    ) %>%
  dplyr::anti_join(get_stopfuncs()) %>%
  dplyr::select(func, classification)
#> Joining, by = "func"
#> Joining, by = "func"
#> # A tibble: 5 x 2
#>   func      classification
#>   <chr>     <chr>         
#> 1 library   setup         
#> 2 library   setup         
#> 3 lm        modeling      
#> 4 tidy      modeling      
#> 5 glue_data communication
```
