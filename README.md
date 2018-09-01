
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

Load the tidycode library.

``` r
library(tidycode)
```

We can use the expressions from this matahari tibble extract the names
of the packages included.

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
#> # ... with 2,391 more rows
```

Create a dataframe of your expressions, splitting each into individual
functions.

``` r
u <- unnest_calls(m$expr)
```

Left join the package tibble to classify your functions by package name.

``` r
u <- u %>%
  dplyr::left_join(pkg_tbl, c("names" = "func"))
u
#> # A tibble: 8 x 4
#>   names     args        line package
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
classification_tbl <- get_classification_tbl()
u %>%
  dplyr::left_join(classification_tbl, c("names" = "func"))
#> # A tibble: 8 x 5
#>   names     args        line package classification
#>   <chr>     <list>     <int> <chr>   <chr>         
#> 1 library   <list [1]>     1 base    setup         
#> 2 library   <list [1]>     2 base    setup         
#> 3 <-        <list [2]>     3 base    <NA>          
#> 4 lm        <list [2]>     3 stats   modeling      
#> 5 ~         <list [2]>     3 base    <NA>          
#> 6 <-        <list [2]>     4 base    <NA>          
#> 7 tidy      <list [1]>     4 broom   <NA>          
#> 8 glue_data <list [2]>     5 glue    <NA>
```

### Extract Plots and Models *(this may get deprecated, we are looking into new ways to label functions)*

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
is_plot(expr)
#> [1] FALSE FALSE  TRUE FALSE FALSE
```

We can check which expressions are calling modeling functions using the
`is_model()` function.

``` r
is_model(expr)
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
