library(dplyr)
library(tidyr)

# Reading the csv file into R
rf_data = read.csv("refine_original.csv")

#turning the data from the csv file into a data frame
rf_data <- data.frame(rf_data)
rf_data

# Checking column names to enure the next function are for the correct columns
colnames(rf_data)

# Task 1 - Clean up the company names
#Tried using gsub
rf_data <- gsub("phillips", "philips", rf_data$company)
#Ruined my dataframe, it's just names now.

#tried doing something different with gsub
rf_data$company <- gsub("phillips", "philips", rf_data$company)
rf_data$company <- gsub("fillips", "philips", rf_data$company)
rf_data$company <- gsub("phlips", "philips", rf_data$company)
#This Acts like it works but when I look at the data in the dataframe, nothing changed.

#this is my attempt to us replace
rf_data$company <- replace(rf_data$company, c("phillips", "fillips", "phlips"), "philips")
# This code produced this error - Error in `$<-.data.frame`(`*tmp*`, company, value = c(10L, 8L, 7L, 13L,  : 
#replacement has 28 rows, data has 25


# Suggestion from FaceBook
rf_data$company(ifelse(rf_data$company == "phillips","philips",rf_data$company))
# Result - Error: attempt to apply non-function
#this makes sence after the fact since I didn't actually tell R to do anything.

#this is my attempt to use mutate and an ifelse statment
rf_data$company <- mutate(rf_data$company,ifelse(rf_data$company == "phillips","philips",rf_data$company))

# Task 2 - Separating product.code...number into two separate columns.
# Renaming the first to "product_code" and the second to "product_number"
rf_data <- rf_data %>% separate("Product.code...number",c("product_code", "product_number"),"-", remove = TRUE)
rf_data
# This code worked as expected.

# Task 3 - Add Product Categories.
# Don't know where to start with this.
rf_data %>% if("product_code" = "p")
{mutate()}


# Task 4 - combining the three columns of "address", "city", and "country" into a single column called "full_address"
rf_data <- rf_data %>% unite("full_address", "address", "city", "country", sep = ", ")
rf_data
# This code worked as expected.

# Task 5 - Create dummy variables for company and product category
# I'm supposed to creat four bionaries for each company name and four bionaries for each product code
#This looks like the same thing I would do with Task 3 once that is done, I will be able to do this.


# Task 6 - Save the Dataframe into a new CSV file named refine_clean.csv
# Of course, I will run this when Im done.
write.csv(refine_clean.csv)