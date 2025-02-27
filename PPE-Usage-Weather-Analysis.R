#loading in required libraries
library(tidyverse)
library(lubridate)

#loading in data set
df <- read.csv("2020_NYU_egress_covid19_raw_v3.csv", stringsAsFactors = FALSE)

#printing summary of data set
print(summary(df))  
missing_data <- colSums(is.na(df))  #check for missing values
print(missing_data)



#Cleaning and Preprocessing data:
df_clean <- df %>%
  mutate(PPE_Use = tolower(PPE_Use),  #changing PPE_use values to lowercase
         
         #standardizing values to "Yes" or "No"
         #"yes" or "recorded" values are changed to "Yes"
         #"no", empty values, or spaces are changed to "No"
         PPE_Use = ifelse(PPE_Use %in% c("yes", "recorded"), "Yes", 
                          ifelse(PPE_Use %in% c("no", "", " "), "No", NA)),
         
         #convert 'PPE_Use' to factor
         PPE_Use = factor(PPE_Use, levels = c("Yes", "No")),
         
         #convert 'Temp' to numeric
         Temp = as.numeric(Temp),
         
         #removing '%' from 'Humidity' and convert to percentage
         Humidity = as.numeric(gsub("%", "", Humidity)),
         
         #convert 'Weather' values to lowercase for standardization
         Weather = tolower(Weather),  
         
         #convert 'Date' values to a standardized date format
         Date = as.Date(Date, format = "%m/%d/%Y")) %>%
  
  #remove rows with NA
  filter(!is.na(PPE_Use), !is.na(Temp), !is.na(Humidity))

#check summary data again after cleaning
print(summary(df_clean))



#Exploratory Data Analysis:
# 1. univariate analysis - distribution of PPE Use
ggplot(df_clean, aes(x = PPE_Use)) +
  geom_bar(fill = "lightblue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of PPE Usage", x = "PPE Usage", y = "Count") +
  theme_minimal()

# 2. univariate analysis - distribution of weather types
ggplot(df_clean, aes(x = Weather)) +
  geom_bar(fill = "lightblue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Weather Types", x = "Weather Type", y = "Count") +
  theme_minimal()



#Further Data Analyses:
# 1. Bivariate Analysis - Temperature vs PPE Usage with spacing
ggplot(df_clean, aes(x = Temp, fill = PPE_Use)) +
  geom_histogram(position = "stack", bins = 30, color = "black", alpha = 0.7, width = 0.8) +  # Adjust width for spacing
  labs(title = "Temperature vs PPE Usage", x = "Temperature (°F)", y = "Count") +
  theme_minimal()

# 2. Bivariate Analysis - Humidity vs PPE Usage with spacing
ggplot(df_clean, aes(x = Humidity, fill = PPE_Use)) +
  geom_histogram(position = "stack", bins = 30, color = "black", alpha = 0.7, width = 0.8) +  # Adjust width for spacing
  labs(title = "Humidity vs PPE Usage", x = "Humidity (%)", y = "Count") +
  theme_minimal()

ggplot(df_clean, aes(x = Weather, fill = PPE_Use)) +
  geom_bar(position = "stack") +
  labs(title = "Weather Type vs PPE Usage", x = "Weather Type", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

# 4. Time-Based Analysis: PPE Usage Over Time
ggplot(df_clean, aes(x = Date, fill = PPE_Use)) +
  geom_bar(position = "stack") +
  labs(title = "PPE Usage Over Time", x = "Date", y = "Count") +
  theme_minimal()
