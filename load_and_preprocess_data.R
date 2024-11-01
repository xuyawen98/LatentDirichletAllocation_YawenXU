# Load the Required Libraries
install.packages("jiebaR")
install.packages("dplyr")
install.packages("tm")
library(jiebaR)
library(dplyr)
library(tm)

# Set the working directory and load the text data
setwd("/Users/xuyawen/Downloads")
data.txt <- scan("追寻记忆的痕迹.txt", what = '', sep='\n', encoding = "UTF-8")

# Perform text segmentation using jiebaR
demo.engine1 <- worker()
demo.words <- segment(data.txt, demo.engine1)

# View the first 300 segmentation results
demo.words[1:300]

# Calculate word frequency
demo.wordsfreq <- freq(demo.words)

# Arrange the word frequency in descending order and view the top 500 results
top_words <- arrange(demo.wordsfreq, desc(freq))[1:500,]

# Print the top 500 high-frequency words
print(top_words)

# Combine the top 300 high-frequency words into a text vector
top_words_vector <- top_words$char

# Print the text vector
print(top_words_vector)

# Convert the text vector into a single text document
text_vector <- paste(top_words_vector, collapse = " ")
text <- text_vector

# Create a simple Chinese stopword list
chinese_stopwords <- c("三","什么","得到","有些","获得","让","名","这种","位","较","一年","时候","来","给","日","大","把","以下","目前","经过","而且","他们","通过","为","多","方面","提出","其中","成为","作","这些","可","特别","并","月","想","作为","各","许多","为了","但是","其","过","具有","里","最","不能","根据","起来","所","后","副","下","由于","用","这样","就是","时","可以","各种","已经","出","能","向","们","开始","学","这个","的","是", "和", "了", "在", "我", "有", "他", "这", "也", "就", "不", "人", "都", "一个", "上", "我们", "到", "说", "要", "去", "会", "你", "自己", "好", "去", "国", "又", "中", "地", "说", "之", "已", "以", "而", "使", "但", "由", "这", "很", "吗", "看", "于", "及", "那", "也", "与", "或", "它", "就", "因", "被", "也", "你", "都", "得", "着", "等", "对", "从", "一", "将", "如", "要是", "没有", "你们")

# Read stopword list from text file
stopwords_en <- stopwords("en")
stopwords_ch <- readLines(jiebaR:::stopwords_file())
chinese_stopwords <- readLines("cn.txt")
stopwords_new <- c("出现","他","两个","产生","下","所有","很","引起","甚至","发生","方面","也","这一","是否","尽管","经历","特定", ...)  # Add more stopwords as needed

# Create a corpus
corpus <- Corpus(VectorSource(text))

# Preprocess the corpus
corpus_clean <- tm_map(corpus, content_transformer(tolower))
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, c(stopwords_en, chinese_stopwords, stopwords_new))
corpus_clean <- tm_map(corpus_clean, stripWhitespace)