# pyfig-style

Personal matplotlib/seaborn style spec for scientific figures.
Built around viridis-family colormaps and the Inter font by default —
both are configurable, and the architecture is designed to grow as you
add presets.

## Install

In each environment where you want it available:

```bash
pip install -e /path/to/pyfig-style          # editable: edits propagate
# or:
uv pip install -e /path/to/pyfig-style
```

To install from a git repo (works across machines, no path required):

```bash
pip install git+https://github.com/<you>/pyfig-style.git
```

## Use

```python
import pyfig_style as pf
pf.setup()                                   # default: viridis + Inter

# Continuous: viridis is now the default cmap
plt.imshow(arr)

# Categorical (matplotlib will cycle through 6 viridis-derived colors,
# starting with the binary pair)
sns.lineplot(data=df, x='t', y='y', hue='condition')

# When you know N up front and want the optimal palette:
colors = pf.palette(3)                       # unordered categorical
colors = pf.palette(3, ordered=True)         # ordinal: low/medium/high
colors = pf.binary_palette()                 # the high-contrast pair
colors = pf.palette(4, cmap='mako')          # use a viridis cousin

# Pass to seaborn:
sns.barplot(..., palette=pf.palette(3))
```

## Customizing

The most common tweaks are first-class arguments to `setup()`:

```python
pf.setup(cmap='mako')                          # different base palette
pf.setup(font='IBM Plex Sans')                 # different body font
pf.setup(cmap='rocket', font='Source Sans 3')  # both
pf.setup(rc_overrides={                        # arbitrary rcParam tweaks
    'figure.figsize': (8, 5),
    'mathtext.fontset': 'cm',                  # LaTeX-classic math
    'axes.grid': True,
})
```

Auto-installable fonts: **Inter**, **Source Sans 3**, **IBM Plex Sans**.
Any other font name works if it's installed system-wide.

To register a new font for auto-install, append to `_FONT_SOURCES` at
the top of `pyfig_style.py`:

```python
_FONT_SOURCES['MyFont'] = [
    'https://primary.example.com/MyFont.ttf',
    'https://fallback.example.com/MyFont.ttf',
]
```

## Cousin colormaps

Sequential: `viridis`, `mako`, `rocket`, `crest`, `flare`, `cividis`
Diverging: `vlag`, `icefire`, `coolwarm`

The seaborn-provided cousins (mako, rocket, crest, flare, vlag, icefire)
register automatically when this module is imported.

For darker cousins like mako or rocket where 0.05 is near-black, the
module automatically lifts the dark end of the binary range to 0.20.
Override per call:

```python
pf.binary_palette(cmap='mako', positions=(0.20, 0.92))
pf.palette(4, cmap='rocket', lo=0.25, hi=0.95)
```
