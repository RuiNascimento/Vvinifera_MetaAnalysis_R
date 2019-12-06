library("AnnotationDbi")
library("org.Vvinifera.eg.db")

# Columns
columns(org.Vvinifera.eg.db)

# Help
help("SYMBOL")

# Keytypes
keytypes(org.Vvinifera.eg.db)

# If we want to extract some sample keys of a particular type, we can use the keys method
head(keys(org.Vvinifera.eg.db, keytype="SYMBOL"))

# And finally, if we have some keys, we can useselectto extract them

k <- head(keys(org.Vvinifera.eg.db,keytype="GID"))
# then call select
select(org.Vvinifera.eg.db, keys=k, columns=c("SYMBOL","GENENAME"), keytype="GID")

#Finally if you wanted to extract only one column of data you could instead use themapIds method like this:
#1st get some example keys
k <- head(keys(org.Vvinifera.eg.db,keytype="GID"))
# then call mapIds
mapIds(org.Vvinifera.eg.db, keys=k, column=c("GENENAME"), keytype="GID")
