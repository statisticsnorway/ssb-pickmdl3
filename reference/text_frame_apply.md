# Apply function(s) with input from a data frame

Apply function(s) with input from a data frame

## Usage

``` r
text_frame_apply(
  text_frame,
  fun = NULL,
  id = NULL,
  ...,
  call_list = NULL,
  drop = TRUE,
  verbose = FALSE,
  envir = NULL
)
```

## Arguments

- text_frame:

  Data frame to specify function arguments. See details.

- fun:

  The function to be called, given as a character string.

- id:

  To select rows from input `text_frame` (name or number).

- ...:

  Extra arguments that do not change.

- call_list:

  Extra arguments that do not change, specified as a list.

- drop:

  Whether to omit list output when a single row is specified by `id`.

- verbose:

  When `TRUE`, function calls will be printed.

- envir:

  The environment for the function evaluation. See
  [`eval`](https://rdrr.io/r/base/eval.html).

## Value

A list of function evaluation outputs or output from a single function
evaluation (see `drop`).

## Details

Data frame where all variables are character and with parameter names as
column names. Each cell contains text with R code written as source code
in a function call. The parameter will be omitted when the cell is
missing (`NA`). The row names will be used as names in the output and
can be used in selections with the `id` parameter. With `fun = NULL`,
the first column must contain function name(s) to be called.

## Note

This function is general and may be usable outside the pickmdl package.

## Examples

``` r
ax_plus_b <- function(a = 2, b = 3, x = 5) {a * x + b}
z <- data.frame(a = c("1", "2", NA), b = "7", x = c(NA, "9", "2"))
rownames(z) <- c("A", "B", "C")
z
#>      a b    x
#> A    1 7 <NA>
#> B    2 7    9
#> C <NA> 7    2
text_frame_apply(z, "ax_plus_b", verbose = TRUE)
#>   ----   id =  A    ----
#> ax_plus_b(a = 1, b = 7)
#> 
#>   ----   id =  B    ----
#> ax_plus_b(a = 2, b = 7, x = 9)
#> 
#>   ----   id =  C    ----
#> ax_plus_b(b = 7, x = 2)
#> 
#> $A
#> [1] 12
#> 
#> $B
#> [1] 25
#> 
#> $C
#> [1] 11
#> 
text_frame_apply(cbind(data.frame("ax_plus_b"), z))
#> $A
#> [1] 12
#> 
#> $B
#> [1] 25
#> 
#> $C
#> [1] 11
#> 
text_frame_apply(z[c(1, 3)], "ax_plus_b", id = 1:2)
#> $A
#> [1] 8
#> 
#> $B
#> [1] 21
#> 
text_frame_apply(z[c(1, 3)], "ax_plus_b", b = 7, id = "B")
#> [1] 25
text_frame_apply(z[c(1, 3)], "ax_plus_b", call_list = list(b = 7))
#> $A
#> [1] 12
#> 
#> $B
#> [1] 25
#> 
#> $C
#> [1] 11
#> 
text_frame_apply(z[c(1, 3)], "ax_plus_b", b = 1:2, id = "B", drop = FALSE)
#> $B
#> [1] 19 20
#> 
text_frame_apply(z[3], "ax_plus_b", a = 1, call_list = list(b = 7))
#> $A
#> [1] 12
#> 
#> $B
#> [1] 16
#> 
#> $C
#> [1] 9
#> 
```
