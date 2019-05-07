
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

Use the `get_packages_tbl()` to create a tibble of all functions
included in the packages that were used.

``` r
(pkg_tbl <- get_packages_tbl(pkg_names))
#> # A tibble: 2,401 x 2
#>    func            package
#>    <chr>           <chr>  
#>  1 augment         broom  
#>  2 augment_columns broom  
#>  3 bootstrap       broom  
#>  4 confint_tidy    broom  
#>  5 finish_glance   broom  
#>  6 fix_data_frame  broom  
#>  7 glance          broom  
#>  8 inflate         broom  
#>  9 tidy            broom  
#> 10 tidyMCMC        broom  
#> # … with 2,391 more rows
```

Create a data frame of your expressions, splitting each into individual
functions.

``` r
u <- unnest_calls(m$expr)
```

Left join the package tibble to classify your functions by package name.

``` r
u <- u %>%
  dplyr::left_join(pkg_tbl)
#> Joining, by = "func"
u
#> # A tibble: 8 x 4
#>   func      args        line package
#>   <chr>     <list>     <int> <chr>  
#> 1 library   <list [1]>     1 base   
#> 2 library   <list [1]>     2 base   
#> 3 <-        <list [2]>     3 base   
#> 4 lm        <list [2]>     3 stats  
#> 5 ~         <list [2]>     3 base   
#> 6 <-        <list [2]>     4 base   
#> 7 tidy      <list [1]>     4 broom  
#> 8 glue_data <list [2]>     5 glue
```

Add in the function classifications\!

``` r
classification_tbl <- get_classifications()
u %>%
  dplyr::left_join(classification_tbl)
#> Joining, by = "func"
#> # A tibble: 53 x 7
#>    func    args        line package classification     n prevalence
#>    <chr>   <list>     <int> <chr>   <chr>          <int>      <dbl>
#>  1 library <list [1]>     1 base    setup           1235    0.687  
#>  2 library <list [1]>     1 base    import           382    0.213  
#>  3 library <list [1]>     1 base    visualization     61    0.0339 
#>  4 library <list [1]>     1 base    data cleaning     50    0.0278 
#>  5 library <list [1]>     1 base    modeling          24    0.0134 
#>  6 library <list [1]>     1 base    exploratory       23    0.0128 
#>  7 library <list [1]>     1 base    communication     15    0.00835
#>  8 library <list [1]>     1 base    evaluation         5    0.00278
#>  9 library <list [1]>     1 base    export             2    0.00111
#> 10 library <list [1]>     2 base    setup           1235    0.687  
#> # … with 43 more rows
```
