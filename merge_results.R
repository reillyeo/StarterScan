# Install packages if needed
if (!require("dplyr")) install.packages("dplyr")
if (!require("readr")) install.packages("readr")
if (!require("optparse")) install.packages("optparse")

# load necessary libraries
suppressMessages(library(optparse))
suppressMessages(library(readr))
suppressMessages(library(dplyr))

# Option sorting
option_list = list(
  make_option(c("-o", "--output_dir"), type = "character",
              help = "Path to the output directory")                      
)

# Parse the command line arguments
args <- parse_args(OptionParser(option_list = option_list))

output_dir <- args$output_dir

# Load data
count_data <- read_tsv(paste(output_dir,"/gene_detection_results.tsv",sep=""))
annotation_data <- read_delim("~/my_scripts/starterscan/data/gene_products.csv", delim=";", col_names = c("gene","product"))

merged_data <- count_data %>% left_join(annotation_data, by = "gene",unmatched = "drop") %>%
    select(c(product,read_count,RP2Mb)) %>%
    group_by(product)%>%
    summarise(read_count=sum(read_count),RP2Mb=sum(RP2Mb))

# save merged data table as tsv file
write_csv(merged_data, paste(output_dir,"/annotated_genecounts.csv",sep=""))