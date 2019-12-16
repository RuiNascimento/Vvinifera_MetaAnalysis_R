library(data.table)
library(ggplot2)
library(magrittr)

tcd <- t(counts_data)
i <- ecdf(tcd[,1])
plot(ecdf(tcd[,1]))


# This one
plot(density(tcd[,1]))
plot(density(log(tcd[,1])))


df_tcd <- as.data.frame(tcd)

ggplot(df_tcd, aes(x = row.names(df_tcd))) +
  geom_density(color="blue")

boxplot(log(counts_data))

# True Plots below

log_counts_data <- log2(counts_data)

df <- melt(data = log_counts_data, value.name = "Counts")

setnames(df, "variable", "Run")

pinot$Run <- rownames(pinot)

final <- merge.data.table(x = df, y = pinot, by = "Run")


# Plot expeiment

# By Layout
final %>%
ggplot(aes(x = Run, y = Counts, fill = LibraryLayout)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](normalized_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Raw Counts by Lybrary Layout")

# By Stress
final %>%
  ggplot(aes(x = Run, y = Counts, fill = Stress)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](normalized_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Raw Counts by Stress")

# By BioProject
final %>%
  ggplot(aes(x = Run, y = Counts, fill = BioProject)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](normalized_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Raw Counts by Bioproject")

# Density
final %>%
  ggplot(aes(x = Counts, colour = Run, fill = Run)) +
  geom_density(alpha = 0.1) +
  theme(legend.position = "none") + xlab(expression(log[2](count + 1))) +
  labs(title="Density Plot of Raw Counts")

# Experiment 2 (normalized counts with limma)

df_cpm <- melt(data = logcpm, value.name = "Counts")
setnames(df_cpm, "Var2", "Run")
final_norm <- merge.data.table(x = df_cpm, y = pinot, by = "Run")
# final_norm <- data.table(final_norm)

# By Layout
final_norm %>%
ggplot(aes(x = Run, y = Counts, fill = LibraryLayout)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](normalized_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Normalized Counts by Lybrary Layout")

# By Stress
final_norm %>%
  ggplot(aes(x = Run, y = Counts, fill = Stress)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](normalized_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Normalized Counts by Stress")

# By BioProject
final_norm %>%
  ggplot(aes(x = Run, y = Counts, fill = BioProject)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](normalized_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Normalized Counts by Bioproject")

# Density
final_norm %>%
  ggplot(aes(x = Counts, colour = BioProject, fill = Run)) +
  geom_density(alpha = 0.1) +
  theme(legend.position = "none") + xlab(expression(log[2](count + 1))) +
  labs(title="Density Plot of Normalized Counts")


# final_norm <- data.table(final_norm)
# final_norm[BioProject == "PRJNA381300",]

