# Setting working directories
version <- "04042024_v6"
N <- 104
J <- 34
PROJECT <- dirname(dirname(getwd()))
DATA <- file.path(PROJECT, "data")
OUTPUT <- file.path(PROJECT, "output")

library(rmarkdown)
library(readxl)
library(stringr)


# Loading developing country data
countries <- read_excel(file.path(DATA, 
                                  paste0("dictionary_GTAP_",version,".xlsx")),
                        sheet = "Developing")
sectors <- read_excel(file.path(DATA, 
                                paste0("dictionary_GTAP_",version,".xlsx")), 
                      sheet = "labels_sec")

# Cleaning ID data
full_sample_path <- "full_sample.rmd"
country_sample_path <- "country_sample.Rmd"

render("carbon_price_selection.Rmd", output_file = "carbon_price_selection.html")

for (carbon_price in c(163)) {
  # Read the template content
  template_content <- readLines(full_sample_path)
  
  # Replace "{{country}}" placeholder with the current country
  modified_content <- gsub("\\{carbon\\}", carbon_price, template_content)
  
  
  
  # Temporary path for the modified Rmd file
  temp_rmd_path <- "tempfile.Rmd"
  
  # Write the modified content to a temporary Rmd file
  writeLines(modified_content, temp_rmd_path)
  
  # Render the modified Rmd file to HTML
  render(temp_rmd_path, output_file = paste0("ALL_", carbon_price, ".html"))
  
  # Delete the temporary Rmd file if desired
  file.remove(temp_rmd_path)
  for (country in countries$code) {

    # Read the template content
    template_content <- readLines(country_sample_path)

    # Replace "{country}" and "{carbon}" placeholder with the current country and carbon price
    template_content <- gsub("\\{country\\}", country, template_content)
    modified_content <- gsub("\\{carbon\\}", carbon_price, template_content)

    # Temporary path for the modified Rmd file
    temp_rmd_path <- "tempfile.Rmd"

    # Write the modified content to a temporary Rmd file
    writeLines(modified_content, temp_rmd_path)

    # Render the modified Rmd file to HTML
    render(temp_rmd_path, output_file = paste0(country, "_", carbon_price, ".html"))

    # Delete the temporary Rmd file if desired
    file.remove(temp_rmd_path)
  }
}




