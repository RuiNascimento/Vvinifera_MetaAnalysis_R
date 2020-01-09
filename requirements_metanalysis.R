# Install/Updates the required packages for the MetaAnalisys if necessary
# org.Vvinifera.eg.db was generated in house with a modified version of AnnotationDbi and not yet available to download

# Install BiocManager if required
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
# Install/Update packages
BiocManager::install(c("devtools", "AnnotationDbi", "limma","edgeR", "RColorBrewer", "gplots",
                       "data.table", "ggplot2", "magrittr", "topGO", "KEGGREST", "pathview"))