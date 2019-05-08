
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/LucyMcGowan/tidycode.svg?branch=master)](https://travis-ci.org/LucyMcGowan/tidycode)
[![Codecov test
coverage](https://codecov.io/gh/LucyMcGowan/tidycode/branch/master/graph/badge.svg)](https://codecov.io/gh/LucyMcGowan/tidycode?branch=master)
<!-- badges: end -->

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

### Read in exisiting code

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
names of the packages included.

``` r
(pkg_names <- ls_packages(m$expr))
#> [1] "broom" "glue"
```

Create a data frame of your expressions, splitting each into individual
functions.

``` r
u <- unnest_calls(m, expr)
```

Add in the function classifications\!

``` r
u %>%
  dplyr::left_join(
    get_classifications("crowdsource", include_duplicates = FALSE)
    )
#> Joining, by = "func"
#> # A tibble: 8 x 8
#>   result     error  output   warnings messages func   args   classification
#>   <list>     <list> <list>   <list>   <list>   <chr>  <list> <chr>         
#> 1 <chr [8]>  <NULL> <chr [1… <chr [1… <chr [0… libra… <list… setup         
#> 2 <chr [9]>  <NULL> <chr [1… <chr [1… <chr [0… libra… <list… setup         
#> 3 <S3: lm>   <NULL> <chr [1… <chr [0… <chr [0… <-     <list… data cleaning 
#> 4 <S3: lm>   <NULL> <chr [1… <chr [0… <chr [0… lm     <list… modeling      
#> 5 <S3: lm>   <NULL> <chr [1… <chr [0… <chr [0… ~      <list… modeling      
#> 6 <tibble [… <NULL> <chr [1… <chr [0… <chr [0… <-     <list… data cleaning 
#> 7 <tibble [… <NULL> <chr [1… <chr [0… <chr [0… tidy   <list… modeling      
#> 8 <S3: glue> <NULL> <chr [1… <chr [0… <chr [0… glue_… <list… communication
```

We can also remove a list of “stopwords”. We have a function,
`get_stopfuncs()` that lists common “stopwords”, frequently used
operators, like `%>%` and `+`.

``` r
u %>%
  dplyr::left_join(
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
