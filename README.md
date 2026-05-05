# shabviz-style

Personal style spec for scientific figures in matplotlib/seaborn (Python)
and ggplot2 (R). Built around viridis-family colormaps and the Inter font.
The two implementations share design decisions so figures look consistent
across languages.

## Python

```bash
pip install "git+https://github.com/shabtastic/shabviz-style.git#subdirectory=python"
```

```python
import shabviz_style as sv
sv.setup()                                   # default: viridis + Inter

# Palette helpers
sv.palette(3)                                # unordered categorical
sv.palette(3, ordered=True)                  # ordinal: low / mid / high
sv.binary_palette()                          # high-contrast pair
sv.palette(4, cmap='mako')                   # cousin colormap
```

See [`python/README.md`](python/README.md) for full Python docs (if separated).

## R

```r
remotes::install_github("shabtastic/shabviz-style", subdir = "r")
```

```r
library(shabvizstyle)
setup()

palette_sv(3)
palette_sv(3, ordered = TRUE)
binary_palette()
palette_sv(4, cmap = "mako")
```

See [`r/README.md`](r/README.md) for full R docs.

## Defaults

Both versions use:
- **Colormap:** viridis (with mako, rocket, crest, flare, cividis as alternates)
- **Font:** Inter (with system sans-serif fallback)
- **Binary pair:** viridis(0.05) and viridis(0.92) — `#471365` and `#cae11f`
- **Math:** stixsans (Python only; R uses ggplot2's expression handling)
