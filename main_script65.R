#main_script1.R

# Make sure working directory is the same as the script location (implicitly handled in GitHub Actions)
# Print working directory
cat("Working directory:", getwd(), "\n")

# Set up and confirm output folder
output_dir <- file.path(getwd(), "outputs/script65")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
cat("Created directory:", output_dir, "\n")

# Confirm contents before saving
print("Files in 'outputs' before saving:")
print(list.files("outputs", recursive = TRUE))

# Save dummy test file just to verify
writeLines("test", file.path(output_dir, "test.txt"))





source("RD_and_DT_Algorithm.R")  # Ensure this file is in the same directory


results_1 <- data.frame(
  ii = integer(),
  jj = integer(),
  kk = integer(),
  Cost = numeric(),
  NumDisambigs = integer()
)


for(i in 1:6){
  
  # Load the shared bgpp1_1 data
  
  bgpp_1 <- read.csv(paste0("CodeRD/code/bgpp", i, "/bgno65.csv"), header = FALSE, row.names = NULL)
  colnames(bgpp_1) <- c('x', 'y', 'cost', 'prob')
  bgpp_1$status <- 0
  bgpp_1$cost <- 5
  
  the_1_list <- list()
  
  for(k in c(20, 30, 40, 50, 60)){
    # Loop through j from 1 to 19
    for (j in 1:19) {
      # Build the obstacle file path
      path <- paste0("CodeRD/code/obstpp", j, "/obstpp", j, "_", k, "_65.csv")
      
      # Read obstacle data
      obst <- read.csv(path, header = FALSE, row.names = NULL)
      colnames(obst) <- c('x', 'y', 'cost', 'prob')
      obst$status <- 1
      obst$cost <- 5
      
      # Combine with bgpp1_1
      combined <- rbind(bgpp_1, obst)
      
      # Store in list with name like "the1_1_20_1", etc.
      the_1_list[[paste0("the1_", j, "_", k, "_1")]] <- combined
      
      thetest <- RD_Alg_M(the_1_list[[paste0("the1_", j, "_", k, "_1")]])
      
      test <- data.frame(
        ii = i,
        jj = j,
        kk = k,
        Cost = thetest$Length_total,
        NumDisambigs = length(thetest$Disambiguate_state)
      )

      results_1 <- rbind(results_1, test)
      
    }
  }
}


saveRDS(results_1, file.path(output_dir, "data_1.rds"))

