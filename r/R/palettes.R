## Per-cmap default sample range. For darker cousins, lift the dark end so
## the first cycle entry doesn't go nearly black.
.default_range <- list(
  viridis = c(0.05, 0.92),
  mako    = c(0.20, 0.92),
  rocket  = c(0.20, 0.92),
  crest   = c(0.10, 0.92),
  flare   = c(0.10, 0.92),
  cividis = c(0.05, 0.95)
)
.fallback_range <- c(0.05, 0.92)

.resolve_range <- function(cmap, lo = NULL, hi = NULL) {
  default <- .default_range[[cmap]] %||% .fallback_range
  c(if (is.null(lo)) default[1] else lo,
    if (is.null(hi)) default[2] else hi)
}

`%||%` <- function(a, b) if (is.null(a)) b else a

## Reorder so the result starts with both endpoints (max contrast for binary
## use), then fills in by greedy max-min-distance.
.maxdist_reorder <- function(items) {
  n <- length(items)
  if (n <= 2) return(items)
  out <- c(1L, n)
  while (length(out) < n) {
    candidates <- setdiff(seq_len(n), out)
    dists <- vapply(candidates, function(c) min(abs(c - out)), numeric(1))
    out <- c(out, candidates[which.max(dists)])
  }
  items[out]
}

## Look up a viridis-family cmap by name. Uses viridisLite for the canonical
## six (viridis, mako, rocket, plasma, inferno, magma, cividis); for crest and
## flare we approximate with viridisLite::viridis since R's ggplot2 ecosystem
## doesn't ship them as palette functions outside seaborn.
.cmap_function <- function(cmap) {
  switch(cmap,
    viridis = viridisLite::viridis,
    mako    = viridisLite::mako,
    rocket  = viridisLite::rocket,
    plasma  = viridisLite::plasma,
    inferno = viridisLite::inferno,
    magma   = viridisLite::magma,
    cividis = viridisLite::cividis,
    ## Fallbacks — these aren't in viridisLite, so use viridis as a stand-in.
    ## Users who want true crest/flare should build them via colorRampPalette.
    crest   = viridisLite::viridis,
    flare   = viridisLite::rocket,
    stop(sprintf("Unknown cmap '%s'. Try one of: %s", cmap,
                 paste(names(.default_range), collapse = ", ")))
  )
}

#' n perceptually distinct colors from a viridis-family colormap
#'
#' @param n Number of colors. n=1 returns the midpoint; n>=2 samples the
#'   colormap linearly between [lo, hi].
#' @param ordered If TRUE, return colors in colormap order (use for ordinal
#'   data: low/medium/high). If FALSE (default), reorder so the first two
#'   entries are the colormap endpoints (max binary contrast) and the rest
#'   fill in.
#' @param cmap Sequential colormap name. One of "viridis", "mako", "rocket",
#'   "plasma", "inferno", "magma", "cividis".
#' @param lo,hi Sample range within the colormap. Defaults are tuned per-cmap.
#' @return Character vector of hex color codes, length n.
#' @export
palette_sv <- function(n, ordered = FALSE, cmap = "viridis",
                       lo = NULL, hi = NULL) {
  if (n < 1) stop("n must be >= 1")

  fn <- .cmap_function(cmap)
  rng <- .resolve_range(cmap, lo, hi)

  if (n == 1) return(fn(1, begin = 0.5, end = 0.5))

  positions <- seq(rng[1], rng[2], length.out = n)
  colors <- vapply(positions, function(p) fn(1, begin = p, end = p),
                   character(1))

  if (!ordered) colors <- .maxdist_reorder(colors)
  colors
}

#' High-contrast binary pair from a viridis-family colormap
#'
#' @param cmap Colormap name.
#' @param positions Length-2 numeric in [0,1] for sample positions. NULL
#'   uses the per-cmap default from `.default_range`.
#' @return Length-2 character vector of hex color codes.
#' @export
binary_palette <- function(cmap = "viridis", positions = NULL) {
  fn <- .cmap_function(cmap)
  if (is.null(positions)) {
    positions <- .default_range[[cmap]] %||% .fallback_range
  }
  c(fn(1, begin = positions[1], end = positions[1]),
    fn(1, begin = positions[2], end = positions[2]))
}
