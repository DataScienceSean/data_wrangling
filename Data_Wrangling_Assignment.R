library(readxl)
library(dplyr)
library(tidyr)
library(dummies)

# Read the excel file into R
refine_original <- read_excel("refine.xlsx")
refine_original

# I noticed that when importing the file, it picked up the row names as a column
# Check the Column names for the extra column
colnames(refine_original)

# Write the data to a CSV file
write.csv(refine_original, "refine_original.csv")

# Turning the data from the csv file into a data frame
refine_original <- data.frame(rf_data)
rf_data

# Checking column names to enure the next function are for the correct columns
colnames(rf_data)

# Task 1 - Clean up the company names

# Used gsub to replace the incorrect Company names
rf_data$company <- gsub("phillips", "philips", rf_data$company)
rf_data$company <- gsub("fillips", "philips", rf_data$company)
rf_data$company <- gsub("phlips", "philips", rf_data$company)
rf_data$company <- gsub("Phillips", "philips", rf_data$company)
rf_data$company <- gsub("phillipS", "philips", rf_data$company)
rf_data$company <- gsub("AKZO", "akzo", rf_data$company)
rf_data$company <- gsub("ak zo", "akzo", rf_data$company)
rf_data$company <- gsub("akz0", "akzo", rf_data$company)
rf_data$company <- gsub("Akzo", "akzo", rf_data$company)
rf_data$company <- gsub("Van Houten", "van houten", rf_data$company)
rf_data$company <- gsub("van Houten", "van houten", rf_data$company)
rf_data$company <- gsub("unilver", "unilever", rf_data$company)
rf_data$company <- gsub("Uniliver", "unilever", rf_data$company)

# Task 2 - Separating product.code...number into two separate columns.
# Renaming the first to "product_code" and the second to "product_number"
rf_data <- rf_data %>% separate("Product.code...number",c("product_code", "product_number"),"-", remove = TRUE)
rf_data

# Task 3 - Add Product Categories.
# Adding the column and copying the product code.
rf_data <- mutate(rf_data, product_category = product_code)

#Replaceing the product code with the product category
rf_data$product_category <- gsub("p", "Smartphone", rf_data$product_category)
rf_data$product_category <- gsub("v", "TV", rf_data$product_category)
rf_data$product_category <- gsub("x", "Laptop", rf_data$product_category)
rf_data$product_category <- gsub("q", "Tablet", rf_data$product_category)

# Task 4 - combining the three columns of "address", "city", and "country" into a single column called "full_address"
rf_data <- rf_data %>% unite("full_address", "address", "city", "country", sep = ", ")
rf_data

# Task 5 - Create dummy variables for company and product category
# Option 1

# Im using Dummy to create the binaries and columns for me
# Because I only used the one column, the cbind did not add it to the exisitng dataframe, so I created a table

comp_bio <- cbind(rf_data$company, dummy(rf_data$company, sep = "_"))
comp_bio
prod_bio <- cbind(rf_data$product_category, dummy(rf_data$product_category, sep = "_"))
prod_bio

# I want to add these to my existing dataframe, so I turned them into dataframes
bio_df <- data.frame(comp_bio, prod_bio)
bio_df

# This process added a first column that wasn't needed, so I am removing it.
bio_df$V1 <- NULL
bio_df$V1.1 <- NULL


# I noticed that method I used caused the bianary for product category to be product_category_name
# I am removing the word category from the column names

bio_df <- bio_df %>% rename(product_Laptop = product_category_Laptop)
bio_df <- bio_df %>% rename(product_smartphone = product_category_Smartphone)
bio_df <- bio_df %>% rename(product_tablet = product_category_Tablet)
bio_df <- bio_df %>% rename(product_tv = product_category_TV)
bio_df <- bio_df %>% rename(company_van_houten = company_van.houten)
colnames(bio_df)

# Adding the two dataframes together
rf_data <- data.frame(rf_data, bio_df)

# Option 2
#Using ifelse statements and mutate
#I thought that dummy would have been a simpler option, but I used a lot more code than I expected

rf_data <- mutate(rf_data, Company_philips = ifelse(rf_data$company == "philips", 1, 0))
rf_data <- mutate(rf_data, Company_akzo = ifelse(rf_data$company == "akzo", 1, 0))
rf_data <- mutate(rf_data, Company_van_houten = ifelse(rf_data$company == "van houten", 1, 0))
rf_data <- mutate(rf_data, Company_unilever = ifelse(rf_data$company == "unilever", 1, 0))
rf_data <- mutate(rf_data, product_smartphone = ifelse(rf_data$product_category == "Smartphone", 1, 0))
rf_data <- mutate(rf_data, product_tv = ifelse(rf_data$product_category == "TV", 1, 0))
rf_data <- mutate(rf_data, product_laptop = ifelse(rf_data$product_category == "Laptop", 1, 0))
rf_data <- mutate(rf_data, product_tablet = ifelse(rf_data$product_category == "Tablet", 1, 0))
rf_data
           
# Task 6 - Save the Dataframe into a new CSV file named refine_clean.csv

write.csv(rf_data, file = "refine_clean.csv")

# And Im done!  Yeah!