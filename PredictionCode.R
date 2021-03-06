# PredictionCode.R
suppressPackageStartupMessages({
      library(tidytext)
      library(tidyverse)
      library(stringr)
      library(knitr)
      library(wordcloud)
      library(ngram)
})
 setwd("C:/Users/laksk/Documents/daisy")

# Download and unzip the Data

if(!file.exists("Coursera-SwiftKey.zip")){
      download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", "Coursera-SwiftKey.zip")
      unzip("Coursera-SwiftKey.zip")
}
# Load the Data
blogs_file <- "./final/en_US/en_US.blogs.txt"
news_file <- "./final/en_US/en_US.news.txt"
twitter_file <- "./final/en_US/en_US.twitter.txt"

# Read the Data using readLines

con <- file(news_file, open="rb")

# Read the news file using binary/binomial mode
# as there are special characters in the text

news <- readLines(con,  skipNul = TRUE)
blogs <- readLines(blogs_file, skipNul = TRUE)
twitter <- readLines(twitter_file, skipNul = TRUE)

close(con)
rm(con)

# Create Dataframes for the Data

blogs <- data_frame(text = blogs)
news <- data_frame(text = news)
twitter <- data_frame(text = twitter)

# Sampling the Data
set.seed(42)
sample_percentage <- 0.02


blogs_sample <- blogs %>%
      sample_n(., nrow(blogs)*sample_percentage)
news_sample <- news %>%
      sample_n(., nrow(news)*sample_percentage)
twitter_sample <- twitter %>%
      sample_n(., nrow(twitter)*sample_percentage)

# Create tidy Sample Data
sampleData <- bind_rows(
      mutate(blogs_sample, source = "blogs"),
      mutate(news_sample,  source = "news"),
      mutate(twitter_sample, source = "twitter")
)


sampleData$source <- as.factor(sampleData$source)

# Clear the un-neccessary data variables
rm(list = c("twitter_sample", "news_sample", "blogs_sample", "sample_percentage",
            "twitter", "news", "blogs", "twitter_file", "news_file", "blogs_file")
)

# Clean the sampleData
# Create filters for: non-alphanumeric's, url's, repeated letters(+3x)
# Data Cleaning
data("stop_words")

# remove profanity
# Use this link to download the banned words http://www.bannedwordlist.com/

swear_words <- read_delim("C:/Users/laksk/Documents/daisy/BannedWords.csv", delim = "\n", col_names = FALSE)
swear_words <- unnest_tokens(swear_words, word, X1)

replace_reg <- "[^[:alpha:][:space:]]*"
replace_url <- "http[^[:space:]]*"
replace_aaa <- "\\b(?=\\w*(\\w)\\1)\\w+\\b"

# Clean the sampleData. Cleaning is separted from tidying so `unnest_tokens` function can be used for words, and ngrams.
clean_sampleData <-  sampleData %>%
      mutate(text = str_replace_all(text, replace_reg, "")) %>%
      mutate(text = str_replace_all(text, replace_url, "")) %>%
      mutate(text = str_replace_all(text, replace_aaa, "")) %>%
      mutate(text = iconv(text, "ASCII//TRANSLIT"))

rm(list = c("sampleData"))



                                    # Generate Ngrams
# Unigrams
unigramData <- clean_sampleData %>%
      unnest_tokens(word, text) %>%
      anti_join(swear_words) %>%
      anti_join(stop_words)


# Bigrams
bigramData <- clean_sampleData %>%
      unnest_tokens(bigram, text, token = "ngrams", n = 2)

# Trigrams
trigramData <- clean_sampleData %>%
      unnest_tokens(trigram, text, token = "ngrams", n = 3)

# Quadgrams
quadgramData <- clean_sampleData %>%
      unnest_tokens(quadgram, text, token = "ngrams", n = 4)

# Quintgrams
quintgramData <- clean_sampleData %>%
      unnest_tokens(quintgram, text, token = "ngrams", n = 5)

# Sextgrams
sextgramData <- clean_sampleData %>%
      unnest_tokens(sextgram, text, token = "ngrams", n = 6)
   

       # Reduce n-grams files
# Bigrams
bigram_tiny <- bigramData %>%
      count(bigram) %>%
      filter(n > 10) %>%
      arrange(desc(n))
rm(list = c("bigramData"))

# Trigrams
trigram_tiny <- trigramData %>%
      count(trigram) %>%
      filter(n > 10) %>%
      arrange(desc(n))
rm(list = c("trigramData"))

# Quadgrams
quadgram_tiny <- quadgramData %>%
      count(quadgram) %>%
      filter(n > 10) %>%
      arrange(desc(n))
rm(list = c("quadgramData"))

# Quintgrams
quintgram_tiny <- quintgramData %>%
      count(quintgram) %>%
      filter(n > 10) %>%
      arrange(desc(n))
rm(list = c("quintgramData"))

# Sextgrams
sextgram_tiny <- sextgramData %>%
      count(sextgram) %>%
      filter(n > 10) %>%
      arrange(desc(n))
rm(list = c("sextgramData"))

                                    # Separate words
# NgramWords
bi_words <- bigram_tiny %>%
      separate(bigram, c("word1", "word2"), sep = " ")

tri_words <- trigram_tiny %>%
      separate(trigram, c("word1", "word2", "word3"), sep = " ")

quad_words <- quadgram_tiny %>%
      separate(quadgram, c("word1", "word2", "word3", "word4"), sep = " ")

quint_words <- quintgram_tiny %>%
      separate(quintgram, c("word1", "word2", "word3", "word4", "word5"), sep = " ")

sext_words <- sextgram_tiny %>%
      separate(sextgram, c("word1", "word2", "word3", "word4", "word5", "word6"), sep = " ")

saveRDS(bi_words, "C:/Users/laksk/Documents/daisy/bigrams.rds")
saveRDS(tri_words, "C:/Users/laksk/Documents/daisy/trigrams.rds")
saveRDS(quad_words,"C:/Users/laksk/Documents/daisy/quadgrams.rds")
saveRDS(quint_words,"C:/Users/laksk/Documents/daisy/quintgrams.rds")
saveRDS(sext_words,"C:/Users/laksk/Documents/daisy/sextgrams.rds")

