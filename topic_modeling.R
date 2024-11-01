# Load the Required Libraries
install.packages("ldatuning")
install.packages("NLP")
install.packages("topicmodels")
install.packages("tidytext")
library(ldatuning)
library(NLP)
library(topicmodels)
library(tidytext)

# Create DocumentTermMatrix
dtm <- DocumentTermMatrix(corpus_clean)

# Inspect DocumentTermMatrix
inspect(dtm)

# Determine the optimal number of topics
result <- FindTopicsNumber(
  dtm,
  topics = seq(from = 2, to = 15, by = 1),
  metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010", "Deveaud2014"),
  method = "Gibbs",
  control = list(seed = 77),
  mc.cores = 2L,
  verbose = TRUE
)

# Plot the results of FindTopicsNumber
FindTopicsNumber_plot(result)

# Build LDA model with the optimal number of topics (e.g., k=5)
topics <- LDA(dtm, k=5, control=list(seed=12345))

# Tidy the LDA model results
terms <- tidy(topics, matrix = "beta")

# Select the top terms for each topic
top_terms <- terms %>%
  group_by(topic) %>%
  top_n(15, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

# Print the top terms
print(top_terms)