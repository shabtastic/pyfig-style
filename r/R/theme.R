## Font registry — mirror of shabviz_style._FONT_SOURCES.
## sysfonts/showtext is the most reliable cross-platform install path.
.font_sources <- list(
  Inter = list(
    family = "Inter",
    google = "Inter"  # name as it appears in Google Fonts
  ),
  `Source Sans 3` = list(
    family = "Source Sans 3",
    google = "Source Sans 3"
  ),
  `IBM Plex Sans` = list(
    family = "IBM Plex Sans",
    google = "IBM Plex Sans"
  )
)

#' Install Inter (or another registered font) via sysfonts/showtext
#'
#' Uses sysfonts::font_add_google(), which requires internet access. After
#' install, calls showtext::showtext_auto() so ggplot2 picks up the font.
#'
#' For a more permanent solution, install Inter system-wide
#' (https://rsms.me/inter/) and the systemfonts backend will pick it up
#' without showtext.
#'
#' @param name Font name from .font_sources. Default "Inter".
#' @return TRUE if the font is now available, FALSE otherwise.
#' @export
install_inter <- function(name = "Inter") {
  if (!name %in% names(.font_sources)) {
    warning(sprintf("Font '%s' is not in the registry.", name))
    return(FALSE)
  }

  if (!.font_available(name)) {
    if (!requireNamespace("sysfonts", quietly = TRUE) ||
        !requireNamespace("showtext", quietly = TRUE)) {
      message(
        "[shabvizstyle] To auto-install fonts, install the 'sysfonts' and ",
        "'showtext' packages:\n",
        "  install.packages(c('sysfonts', 'showtext'))\n",
        "Or install ", name, " system-wide and restart R."
      )
      return(FALSE)
    }
    google_name <- .font_sources[[name]]$google
    tryCatch({
      sysfonts::font_add_google(google_name, name)
      showtext::showtext_auto()
    }, error = function(e) {
      message(sprintf("[shabvizstyle] Could not install %s: %s",
                      name, conditionMessage(e)))
      return(FALSE)
    })
  }
  .font_available(name)
}

.font_available <- function(name) {
  ## Check both system fonts (via systemfonts) and showtext-registered fonts.
  in_system <- name %in% systemfonts::system_fonts()$family
  in_showtext <- if (requireNamespace("sysfonts", quietly = TRUE)) {
    name %in% sysfonts::font_families()
  } else FALSE
  in_system || in_showtext
}

#' shabviz ggplot2 theme
#'
#' Mirrors the matplotlib rcParams from shabviz_style: Inter font (or fallback),
#' top/right spines off, subtle grid off, sensible sizes for both publication
#' and presentation use.
#'
#' @param base_size Base font size in points. Default 11.
#' @param base_family Font family. If "" (default), tries Inter, then falls
#'   back to system sans.
#' @return A ggplot2 theme object.
#' @export
theme_shabviz <- function(base_size = 11, base_family = "") {
  family <- if (identical(base_family, "")) {
    if (.font_available("Inter")) "Inter" else ""
  } else base_family

  ggplot2::theme_minimal(base_size = base_size, base_family = family) +
    ggplot2::theme(
      text = ggplot2::element_text(colour = "#333333"),
      plot.title = ggplot2::element_text(size = base_size * 1.18,
                                         face = "plain",
                                         margin = ggplot2::margin(b = 10)),
      plot.subtitle = ggplot2::element_text(size = base_size,
                                            colour = "#666666"),
      axis.title = ggplot2::element_text(size = base_size, colour = "#333333"),
      axis.text = ggplot2::element_text(size = base_size * 0.9,
                                        colour = "#333333"),
      axis.line = ggplot2::element_line(colour = "#333333", linewidth = 0.4),
      axis.ticks = ggplot2::element_line(colour = "#333333", linewidth = 0.4),
      axis.ticks.length = grid::unit(3, "pt"),

      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_rect(fill = "white", colour = NA),
      plot.background = ggplot2::element_rect(fill = "white", colour = NA),

      legend.position = "right",
      legend.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      legend.title = ggplot2::element_text(size = base_size * 0.9),
      legend.text = ggplot2::element_text(size = base_size * 0.9),

      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(size = base_size,
                                         colour = "#333333",
                                         face = "plain"),

      plot.margin = ggplot2::margin(8, 8, 8, 8)
    )
}

#' Set up shabvizstyle: register theme, default scales, and font
#'
#' Sets the active ggplot2 theme to theme_shabviz() and installs default
#' discrete/continuous color and fill scales tied to the chosen cmap.
#' After calling this, every ggplot inherits the theme and palette without
#' explicit + theme_shabviz() / + scale_colour_shabviz_d().
#'
#' @param cmap Base colormap. Default "viridis".
#' @param font Body font. Default "Inter".
#' @param auto_install Whether to attempt auto-installing the font.
#' @param base_size Base font size in points.
#' @param verbose Print status messages.
#' @export
setup <- function(cmap = "viridis", font = "Inter",
                  auto_install = TRUE, base_size = 11,
                  verbose = FALSE) {
  if (auto_install && font %in% names(.font_sources)) {
    ok <- install_inter(font)
    if (verbose) {
      message(sprintf("[shabvizstyle] %s",
        if (ok) sprintf("%s registered.", font)
        else sprintf("%s not available; using fallback sans-serif.", font)
      ))
    }
  }

  ggplot2::theme_set(theme_shabviz(base_size = base_size,
                                 base_family = if (.font_available(font)) font else ""))

  ## Default discrete scales — applied automatically when a plot has discrete
  ## color/fill aesthetics.
  options(
    ggplot2.discrete.colour = function() scale_colour_shabviz_d(cmap = cmap),
    ggplot2.discrete.fill   = function() scale_fill_shabviz_d(cmap = cmap),
    ggplot2.continuous.colour = function() scale_colour_shabviz_c(cmap = cmap),
    ggplot2.continuous.fill   = function() scale_fill_shabviz_c(cmap = cmap)
  )

  if (verbose) {
    message(sprintf("[shabvizstyle] Theme and scales applied (cmap=%s, font=%s).",
                    cmap, font))
  }
  invisible(NULL)
}
