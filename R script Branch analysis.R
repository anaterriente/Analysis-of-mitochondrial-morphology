
# Before you start:

install.packages(c("data.table", "tidyverse"))

library(readxl)
library(data.table)
library(tidyverse)
library(tidyr)
library(dplyr)
library(utils)
library(magrittr)
library(lubridate)


# To analyse the median branch length for each genotype, 

# save in one folder all the "Branch information" tables generated after applying "Analyze Skeleton (2D/3D)" to each individual motoneuron.
# In our script we have called them "_branch_length.csv"
# The best practise is to name your TIFF files with a common name for each of the genotypes.
# Then apply:

median_by_genotype <- function(folder_path) {

  # Read the files and prepare the format of the output.
  
  files <- list.files(input_path, pattern = "\\.csv$", full.names = TRUE)

  results <- data.frame(
    Genotype_A = numeric(0),
    Genotype_B = numeric(0),
    Genotype_C = numeric(0)
    )
  

  A_vals <- c()
  B_vals <- c()
  C_vals <- c()

  for (f in files) {
    

    df <- read.table(f, header = TRUE, sep = "\t")
    
    # Calculate the median Branch.length in each table
    
    med <- median(df$Branch.length, na.rm = TRUE)
    

    # Generate one column per genotype - based on the filename
    
    if (grepl("Genotype_A", f, ignore.case = TRUE)) {
      A_vals <- c(A_vals, med)
    } else if (grepl("Genotype_B", f, ignore.case = TRUE)) {
      B_vals <- c(B_vals, med)
    } else if (grepl("Genotype_C", f, ignore.case = TRUE)) {
      C_vals <- c(C_vals, med)
    }
  }
  

  max_len <- max(length(A_vals), length(B_vals), length(C_vals))
  
  results <- data.frame(
    Genotype_A = c(A_vals, rep(NA, max_len - length(A_vals))),
    Genotype_B = c(B_vals, rep(NA, max_len - length(B_vals))),
    Genotype_C = c(C_vals, rep(NA, max_len - length(C_vals)))
  )
  
  return(results)
}


Median_branch_genotype <- median_by_genotype("/path")

setwd("output path")
write.csv(Median_branch_genotype, "Median_branch_genotype")

# To analyse the network of mitochondrial branches,
# save in one folder all the "Results" tables generated after applying "Analyze Skeleton (2D/3D)" to each individual motoneuron. 
# in our script we have called them "_branch_junctions.csv"
# These files should have a common name for each genotype.
# Then apply:

analyse_branch <- function(input_path) {
  
  # Read the files and prepare the format of the output.
  
  files <- list.files(input_path, pattern = "\\.csv$", full.names = TRUE)
  
  results_list <- list()
  
  for (f in files) {
    
    df <- read.csv(f, na.strings = c("", "NA"))
    
    a <- as.numeric(df$X..Branches)
    a <- a[!is.na(a) & a != 0]

    # Calculate the histogram of the data distribution.
    
    breaks2 <- seq(0, max(a), by = 1)
    
    h <- hist(a, breaks = breaks2, plot = FALSE)
    Density <- h$density
    
    # Extract the distribution of the branches with a relatively low complexity.
    
    rods <- Density[1]
    network <- Density[2:11]
    
    result <- c(rods = rods, network = network)
    
    results_list[[basename(f)]] <- result
  }
  

  combined_df <- do.call(rbind, results_list)
  combined_df <- as.data.frame(combined_df)
  

  combined_df$file <- rownames(combined_df)
  rownames(combined_df) <- NULL
  
  combined_df$genotype <- NA
  
  # Generate one set of data per genotype.
  
  combined_df$genotype[grepl("Genotype_A", combined_df$file, ignore.case = TRUE)] <- "Genotype_A"
  combined_df$genotype[grepl("Genotype_B", combined_df$file, ignore.case = TRUE)] <- "Genotype_B"
  combined_df$genotype[grepl("Genotype_C", combined_df$file, ignore.case = TRUE)] <- "Genotype_C"
  
  df_A <- subset(combined_df, genotype == "Genotype_A")
  df_B <- subset(combined_df, genotype == "Genotype_B")
  df_C <- subset(combined_df, genotype == "Genotype_C")
  
  return(list(
    Genotype_A = df_A,
    Genotype_B = df_B,
    Genotype_C = df_C
  ))
}

results <- analyse_branch("/Users/amt54/Documents/confoco/Pink1 mutants/CCAP neurons/Raw files for analysis/branch connections")

# save the results that are now ready for plotting and for stats. 

setwd("output path")

write.csv(results[[1]], "Genotype_A.csv")
write.csv(results[[2]], "Genotype_B.csv")
write.csv(results[[3]], "Genotype_C.csv")
