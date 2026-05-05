"""Generate a visual reference of the palette helpers."""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib.patches import Rectangle

import shabviz_style as pf

pf.setup()

fig, axes = plt.subplots(4, 1, figsize=(9, 6.5),
                         gridspec_kw={'hspace': 1.1})


def draw_swatches(ax, colors, labels=None, title=''):
    n = len(colors)
    for i, c in enumerate(colors):
        ax.add_patch(Rectangle((i, 0), 0.95, 1, facecolor=c, edgecolor='none'))
        if labels:
            ax.text(i + 0.475, -0.35, labels[i], ha='center', va='top',
                    fontsize=10, color='#333')
    ax.set_xlim(-0.1, n + 0.1)
    ax.set_ylim(-0.6, 1.05)
    ax.set_title(title, loc='left', fontsize=12, pad=6)
    ax.set_xticks([])
    ax.set_yticks([])
    for s in ax.spines.values():
        s.set_visible(False)


# 1. Default cycle (used for unordered categorical)
default_cycle = pf.palette(6, ordered=False, cmap='viridis')
draw_swatches(axes[0], default_cycle,
              labels=[f'C{i}' for i in range(6)],
              title='Default cycle  —  palette(6, ordered=False)')

# 2. Ordered (used for ordinal categorical)
ordered = pf.palette(6, ordered=True, cmap='viridis')
draw_swatches(axes[1], ordered,
              labels=[f'level {i+1}' for i in range(6)],
              title='Ordered  —  palette(6, ordered=True)')

# 3. Binary pair
binary = pf.binary_palette()
draw_swatches(axes[2], binary,
              labels=['group A', 'group B'],
              title='Binary  —  binary_palette()')

# 4. Cousin colormaps (continuous strips)
ax = axes[3]
ax.set_title('Continuous viridis cousins  —  available as cmap=...',
             loc='left', fontsize=12, pad=6)
gradient = np.linspace(0, 1, 256).reshape(1, -1)
available = [c for c in pf.SEQUENTIAL_CMAPS if c in mpl.colormaps]
n_maps = len(available)
for i, cmap_name in enumerate(available):
    ax.imshow(gradient, aspect='auto', cmap=cmap_name,
              extent=[0, 1, n_maps - i - 1, n_maps - i - 0.15])
    ax.text(-0.012, n_maps - i - 0.575, cmap_name,
            ha='right', va='center', fontsize=10, color='#333')
ax.set_xlim(-0.18, 1.02)
ax.set_ylim(-0.05, n_maps)
ax.set_xticks([])
ax.set_yticks([])
for s in ax.spines.values():
    s.set_visible(False)

fig.savefig('/home/claude/palette_reference.png', dpi=160)
print('Saved /home/claude/palette_reference.png')
