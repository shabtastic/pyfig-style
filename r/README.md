# shabvizstyle (R)

Personal ggplot2 style spec for scientific figures — companion to the Python
`shabviz-style` package, with matched palette decisions and Inter as the body
font.

## Install

```r
# Install dependencies first (one-time)
install.packages(c("remotes", "ggplot2", "viridisLite", "systemfonts",
                   "sysfonts", "showtext"))

# Install shabvizstyle from GitHub
remotes::install_github("shabtastic/shabvizstyle.r")
```

## Use

```r
library(ggplot2)
library(shabvizstyle)

setup()                                      # default: viridis + Inter

# Discrete and continuous scales are now defaults — no need to add
# scale_colour_*() to every ggplot.
ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_point(size = 3)                       # uses palette_sv() automatically

# Continuous fill works the same
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster()                              # viridis automatically

# Explicit palette helpers when you need them:
palette_sv(3)                                # 3 unordered categorical colors
palette_sv(3, ordered = TRUE)                # ordinal: low / mid / high
binary_palette()                             # the high-contrast pair
palette_sv(4, cmap = "mako")                 # use a viridis cousin
```

## Customizing

```r
setup(cmap = "mako")                         # different base palette
setup(font = "IBM Plex Sans")                # different body font
setup(base_size = 14)                        # bigger text (presentation mode)

# Per-plot overrides still work:
my_plot + scale_colour_shabviz_d(cmap = "rocket")
my_plot + theme_shabviz(base_size = 14)
```

## Cousin colormaps

`viridis`, `mako`, `rocket`, `plasma`, `inferno`, `magma`, `cividis` —
all from the `viridisLite` package, which `shabvizstyle` imports. Names match
the Python package where the colormaps overlap.

## Fonts

`shabvizstyle` tries to use Inter via `systemfonts` (if installed
system-wide) or falls back to downloading via `sysfonts::font_add_google()`.
For best results across PDF/PNG/SVG output, install Inter system-wide once:
https://rsms.me/inter/. Then the `systemfonts` + `ragg` graphics backend
will pick it up everywhere.

For PNG output that respects fonts cleanly:

```r
ggsave("fig.png", device = ragg::agg_png, width = 6.5, height = 4.5,
       units = "in", dpi = 300)
```

## Relationship to the Python package

This package mirrors `shabviz-style` (Python) so figures share visual identity
across languages. Same defaults: viridis cmap, Inter font, binary pair at
viridis(0.05) / viridis(0.92), ordinal scales spanning the full perceptual
range. Function names follow R/ggplot2 conventions:

| Python                       | R                              |
|------------------------------|--------------------------------|
| `pf.setup()`                 | `setup()`                      |
| `pf.palette(n)`              | `palette_sv(n)`                |
| `pf.palette(n, ordered=True)`| `palette_sv(n, ordered=TRUE)`  |
| `pf.binary_palette()`        | `binary_palette()`             |
| (matplotlib rcParams)        | `theme_shabviz()`                |
| (default cmap on imshow)     | `scale_*_shabviz_c()` (default)  |
