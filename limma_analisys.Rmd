library("devtools")
library("AnnotationDbi")
library("org.Vvinifera.eg.db")

#My limma pipeline
setwd("~/Documentos/Vitis_Meta_analysis")

out.file <- readRDS(file = "data/out.file.RDS")

library("limma")
library("edgeR")
library("RColorBrewer")
library("gplots")

# Dataframe in proper conditions
counts_data <- data.frame(out.file[,-1], row.names=out.file[,1])
# Fix colnames to be RUN
colnames(counts_data) <- sub('_counts','',colnames(counts_data))

# Load phenotype table, with RUN collum as row.names
# Use read.delim insted of read.table, because read.table refused to read all the rows
conditions <- read.delim("expression/htseq-count/phenotype_global.tsv", sep = "\t", header = TRUE, row.names = 22, stringsAsFactors = F)

pinot <- conditions[conditions$Vitis.Genotype == "Vitis vinifera Pinot Noir" & conditions$Tissue == "leaves",]

#############################################################
# Try to correct some of the metadata
unique(pinot$Stress)
pinot$Stress[pinot$Stress == ""] <- "Control"
pinot$Stress[pinot$Stress == "Constitutive"] <- "Control"
pinot$Stress[pinot$Stress == "drought"] <- "Water deficit"
unique(pinot$Stress)

unique(pinot$Tissue)
pinot$Tissue[pinot$Tissue == "pericarp"] <- "berry"
unique(pinot$Tissue)

#############################################################

# Set "Control" as default level, facilitates data analysis downstream
pinot$Stress <- relevel(factor(pinot$Stress), ref = "Control")

design <- model.matrix(~ Stress, data = pinot)

# Create a new counts_data to conform to the design samples, this will help if we want to subset the data

counts_data <- subset(counts_data, select = rownames(design))

# Create DGEList object with the edgeR package

dge <- DGEList(counts = counts_data)

# Remove  rows  that  consistently  have  zero  or  very  low  counts
keep <- filterByExpr(dge, design)
dge <- dge[keep,,keep.lib.sizes=FALSE]

# apply scale normalization to RNA-seq read counts with the TMM normalization method

dge <- calcNormFactors(dge)

# Remove low counts genes
cutoff <- 4
drop <- which(apply(cpm(dge), 1, max) < cutoff)
dge <- dge[-drop,] 
dim(dge) # number of genes left

# Plot MDS
plotMDS(dge)

logcpm <- cpm(dge, prior.count=2, log=TRUE)

# Differential expression using : voom
v <- voom(dge, design=design, plot=TRUE)
# dev.off()


# The usual limma pipelines for differential expression

fit <- lmFit(v, design)
fit <- eBayes(fit)
# Coef = 2 genes modulated when infected with plasmopara viticola
Plasmopara <- topTable(fit, coef=2,  sort.by = "logFC", number = length(fit$sigma))

top25 <- topTable(fit, coef=2,  sort.by = "logFC", number = 25)
# Plasmopara[Plasmopara$P.Value < 0.05,]

write.table(Plasmopara, file = "Plasmopara.tsv", sep = "\t")

# HeatMap top 25
heatmap.2(logcpm[rownames(top25),],col=brewer.pal(11,"RdBu"),scale="row", trace="none")

