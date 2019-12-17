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

# talvez usar log2(counts_data+1) para ficar sem zeros??

log_counts_data <- log2(counts_data)

df <- data.table::melt(data = log_counts_data,
           value.name = "Counts",
           variable.name = "Run",
           measure.vars = names(counts_data))

metadata <- data.table(pinot, keep.rownames = TRUE)
setnames(metadata, "rn", "Run")

final <- data.table(merge.data.table(x = df, y = metadata, by = "Run"))


# Plot expeiment

# By Layout
final %>%
ggplot(aes(x = Run, y = Counts, fill = LibraryLayout)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](raw_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Raw Counts by Lybrary Layout")

# By Stress
final %>%
  ggplot(aes(x = Run, y = Counts, fill = Stress)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](raw_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Raw Counts by Stress")

# By BioProject
final %>%
  ggplot(aes(x = Run, y = Counts, fill = BioProject)) + geom_boxplot() + xlab("") +
  ylab(expression(log[2](raw_counts))) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Raw Counts by Bioproject")

# Density
final %>%
  ggplot(aes(x = Counts, colour = Run, fill = Run)) +
  geom_density(alpha = 0.1) +
  theme(legend.position = "none") + xlab(expression(log[2](count + 1))) +
  labs(title="Density Plot of Raw Counts")

# Experiment 2 (normalized counts with limma)

df_cpm <- data.table::melt(data = logcpm,
                       value.name = "Counts",
                       variable.name = "Run",
                       measure.vars = names(logcpm))

setnames(df_cpm, c("Var1", "Var2"), c("ID", "Run"))
final_norm <- data.table(merge.data.table(x = df_cpm, y = metadata, by = "Run"))
# final_norm <- data.table(final_norm)

# By Layout
final_norm %>%
ggplot(aes(x = Run, y = Counts, fill = LibraryLayout)) + geom_boxplot() + xlab("") +
  ylab(expression(normalied_counts)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Normalized Counts by Lybrary Layout")

# By Stress
final_norm %>%
  ggplot(aes(x = Run, y = Counts, fill = Stress)) + geom_boxplot() + xlab("") +
  ylab(expression(normalied_counts)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Normalized Counts by Stress")

# By BioProject
final_norm %>%
  ggplot(aes(x = Run, y = Counts, fill = BioProject)) + geom_boxplot() + xlab("") +
  ylab(expression(normalied_counts)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("Normalized Counts by Bioproject")

# Density
final_norm %>%
  ggplot(aes(x = Counts, colour = BioProject, fill = Run)) +
  geom_density(alpha = 0.1) +
  theme(legend.position = "none") + xlab(expression(normalied_counts)) +
  labs(title="Density Plot of Normalized Counts")


# Plot a Random number of Runs

number_of_samples = 10

final_norm[Run %in% sample(unique(final_norm$Run), number_of_samples)] %>%
  ggplot(aes(x = Counts, colour = Run, fill = BioProject)) +
  geom_density(alpha = 0.1) +
  theme(legend.position = "right") + xlab(expression(normalied_counts)) +
  labs(title="Density Plot of Normalized Counts")

# final_norm <- data.table(final_norm)
# final_norm[BioProject == "PRJNA381300",]

