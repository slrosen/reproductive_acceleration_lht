# Export manuscript figures as high-resolution PNG + TIFF for Phil Trans B.
# Regenerates figures from the manuscript's own code (via knitr::purl) so the
# raster versions are identical to the PDFs in the manuscript.
#
# Output: figures/<name>.png and figures/<name>.tiff at 600 dpi.

suppressPackageStartupMessages({
  library(knitr)
  library(ragg)
})

figdir <- "figures"
dpi <- 600

# 1. Extract all R code from the manuscript and run it to build the figure
#    objects (p_causal, p_acct, repro_data, draw_figure2, arrow_style, ...).
code_file <- tempfile(fileext = ".R")
purl("manuscript.Rmd", output = code_file, documentation = 0, quiet = TRUE)
source(code_file, local = TRUE, echo = FALSE)

# Helper: save a ggplot object at both PNG and TIFF.
save_gg <- function(plot, name, width, height) {
  ggplot2::ggsave(file.path(figdir, paste0(name, ".png")), plot,
                  device = ragg::agg_png, width = width, height = height,
                  units = "in", dpi = dpi)
  ggplot2::ggsave(file.path(figdir, paste0(name, ".tiff")), plot,
                  device = ragg::agg_tiff, width = width, height = height,
                  units = "in", dpi = dpi, compression = "lzw")
  cat("saved", name, "\n")
}

# Helper: save a base-R plotting call at both PNG and TIFF.
save_base <- function(draw_fun, name, width, height) {
  ragg::agg_png(file.path(figdir, paste0(name, ".png")),
                width = width, height = height, units = "in", res = dpi)
  draw_fun(); invisible(dev.off())
  ragg::agg_tiff(file.path(figdir, paste0(name, ".tiff")),
                 width = width, height = height, units = "in", res = dpi,
                 compression = "lzw")
  draw_fun(); invisible(dev.off())
  cat("saved", name, "\n")
}

# 2. Re-save each figure using the same dimensions as the original ggsave/pdf() calls.
save_gg(p_causal, "causal_dag",       width = 4.5, height = 3.7)
save_gg(p_acct,   "accounting_dag",   width = 4,   height = 3)

# The LRS scatter was saved via last_plot(); rebuild it explicitly from repro_data.
p_lrs <- ggplot2::ggplot(repro_data, ggplot2::aes(x = lrs_adj_pred, y = lrs)) +
  ggplot2::geom_point(color = "darkorange", alpha = 0.6, size = 2) +
  ggplot2::geom_abline(intercept = 0, slope = 1, linetype = "solid", color = "blue") +
  ggplot2::labs(
    x = "Accounting model equation ([(L - A)/IBI] + 0.5)",
    y = "Observed lifetime reproductive success (LRS)"
  ) +
  ggplot2::xlim(0, 15) + ggplot2::ylim(0, 15) +
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.title = ggplot2::element_text(size = 12))
save_gg(p_lrs, "LRS_predictedLRS", width = 8, height = 6)

save_base(draw_figure2, "tradeoff_simulation", width = 10, height = 5)

cat("\nDone. Files in", normalizePath(figdir), "\n")
