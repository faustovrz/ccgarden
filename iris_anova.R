# Iris: ANOVA + Tukey HSD + Compact Letter Display
# A plain R script for Session 1: interactively run lines (Cmd+Enter / Ctrl+Enter)
# and watch Positron's Plot, Help, and Variables panes light up.


# ---- 0. Install required packages -----------------------------------------

# Run this block once. It only installs what's missing; safe to re-run.
needed <- c("multcompView", "ggplot2")
to_install <- setdiff(needed, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install)


# ---- 1. Look at the data ---------------------------------------------------

data(iris)

# Click the iris row in the Variables pane (top-right) to open the
# data viewer. You can sort columns, filter rows, no code required.
View(iris)

head(iris)
summary(iris)
table(iris$Species)


# ---- 2. Get help on any function ------------------------------------------

# Put the cursor anywhere on `aov` and press F1 — the Help pane opens.
# Or run this directly:
?aov


# ---- 3. Quick exploratory plot --------------------------------------------

# Base R boxplot — appears in the Plots pane (bottom-right).
boxplot(Sepal.Length ~ Species, data = iris,
        col = c("#F8766D", "#00BA38", "#619CFF"),
        ylab = "Sepal length (cm)",
        main = "Sepal length by species")


# ---- 4. One-way ANOVA -----------------------------------------------------

fit <- aov(Sepal.Length ~ Species, data = iris)
summary(fit)

# `fit` now appears in the Variables pane — click the triangle to expand
# and inspect the model object.


# ---- 5. Tukey HSD post-hoc test -------------------------------------------

tuk <- TukeyHSD(fit)
tuk

plot(tuk)   # 95% confidence intervals for each pairwise difference


# ---- 6. Compact letter display --------------------------------------------

library(multcompView)

cld <- multcompLetters4(fit, tuk)
cld_letters <- cld$Species$Letters

cld_df <- data.frame(
  Species = names(cld_letters),
  cld     = unname(cld_letters)
)
cld_df


# ---- 7. Publication-style boxplot with letters ----------------------------

library(ggplot2)

y_label_pos <- max(iris$Sepal.Length) + 0.4

ggplot(iris, aes(Species, Sepal.Length, fill = Species)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 1) +
  geom_text(
    data = cld_df,
    aes(x = Species, y = y_label_pos, label = cld),
    inherit.aes = FALSE, size = 6, fontface = "bold"
  ) +
  labs(
    title    = "Sepal length by Iris species",
    subtitle = "Means sharing a letter are not significantly different (Tukey HSD, α = 0.05)",
    y        = "Sepal length (cm)",
    x        = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")

# Save the last plot to disk:
ggsave("iris_anova_boxplot.png", width = 6, height = 4, dpi = 300)
