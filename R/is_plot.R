#' Check if an expression is calling a plot function
#'
#' @param x an R expression
#'
#' @return logical
#' @export
#'
#' @examples
#' expr <- matahari::dance_tbl()$expr
#' purrr::map_lgl(expr, is_plot)

is_plot <- function(x) {
  if (class(x) %in% c("call", "<-")) {
    x <- pryr::fun_calls(x)
    return(
      any(x %in%
            c("plot", "abline", "arrows", "asp",
              "assocplot", "Axis", "axis",
              "axTicks", "barplot", "bxp", "cdplot", "clip",
              "co.intervals", "contour", "coplot", "curve",
              "dotchart", "filled.contour", "fourfoldplot",
              "frame", "grconvertX", "grconvertY", "grid",
              "hist", "identify", "image", "lcm",
              "legend", "lines", "locator", "matlines", "matplot",
              "matpoints", "mosaicplot", "mtext", "pairs", "panel.smooth",
              "par", "pch", "points", "polygon", "polypath", "rasterImage",
              "rect", "rug", "segments", "smoothScatter", "spineplot",
              "stars", "stem", "strheight", "stripchart", "strwidth",
              "sunflowerplot", "symbols", "text", "title", "xinch", "xlim",
              "xspline", "xyinch", "yinch", "ylim",
              "ggplot", "bmp", "jpeg", "png", "tiff"))
    )
  } else FALSE
}

