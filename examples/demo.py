"""Demo: continuous, ordered categorical, binary, and unordered categorical."""

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import shabviz_style as pf

pf.setup(verbose=True)

rng = np.random.default_rng(7)

fig, axes = plt.subplots(2, 2, figsize=(11, 8))

# ---------------------------------------------------------------------------
# 1. Continuous: heatmap with the default cmap (viridis)
# ---------------------------------------------------------------------------
ax = axes[0, 0]
data = (np.outer(np.linspace(0, 1, 30), np.linspace(0, 1, 30))
        + rng.normal(0, 0.05, (30, 30)))
im = ax.imshow(data, aspect='auto', origin='lower')
ax.set_title('Continuous — imshow with viridis')
ax.set_xlabel('x position')
ax.set_ylabel('y position')
fig.colorbar(im, ax=ax, label='intensity')

# ---------------------------------------------------------------------------
# 2. Ordered categorical (e.g. low → high): keep colormap order
# ---------------------------------------------------------------------------
ax = axes[0, 1]
n_groups = 5
x = np.linspace(0, 10, 100)
colors = pf.palette(n_groups, ordered=True)
for i, c in enumerate(colors):
    y = np.sin(x + i * 0.6) + i * 0.3 + rng.normal(0, 0.05, len(x))
    ax.plot(x, y, color=c, label=f'level {i+1}')
ax.set_title('Ordered categorical — palette(5, ordered=True)')
ax.set_xlabel('time (s)')
ax.set_ylabel(r'response amplitude ($\mu$V)')
ax.legend(title='dose level')

# ---------------------------------------------------------------------------
# 3. Binary: high-contrast pair
# ---------------------------------------------------------------------------
ax = axes[1, 0]
groups = ['control', 'treatment']
group_data = [rng.normal(4.2, 1.0, 60), rng.normal(6.8, 1.2, 60)]
parts = ax.violinplot(group_data, showmeans=False, showmedians=True)
for body, c in zip(parts['bodies'], pf.binary_palette()):
    body.set_facecolor(c)
    body.set_edgecolor(c)
    body.set_alpha(0.7)
for key in ('cbars', 'cmins', 'cmaxes', 'cmedians'):
    parts[key].set_color('#333333')
ax.set_xticks([1, 2], groups)
ax.set_title('Binary — binary_palette()')
ax.set_ylabel('outcome (a.u.)')
ax.text(0.97, 0.04, r'$n = 60$ each, $p < 0.001$',
        transform=ax.transAxes, ha='right', fontsize=9,
        color='#666666')

# ---------------------------------------------------------------------------
# 4. Unordered categorical: rely on the default cycle
# ---------------------------------------------------------------------------
ax = axes[1, 1]
xs = np.arange(20)
labels = ['alpha', 'beta', 'gamma', 'delta']
for i, lab in enumerate(labels):
    ax.plot(xs, rng.normal(i, 0.5, len(xs)), marker='o', markersize=4, label=lab)
ax.set_title('Unordered categorical — default cycle')
ax.set_xlabel('observation')
ax.set_ylabel('value')
ax.legend(ncol=2, title='condition', loc='upper left',
          bbox_to_anchor=(0.0, -0.18))

fig.tight_layout()
fig.savefig('/home/claude/demo.png', dpi=160)
print('Saved /home/claude/demo.png')

# Also save a PDF to verify font embedding
fig.savefig('/home/claude/demo.pdf')
print('Saved /home/claude/demo.pdf')
