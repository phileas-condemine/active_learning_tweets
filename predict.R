get_next_tweet = function(){
  suppr = readLines("data/to_remove.txt")
  # tweets[status_id%in%suppr]
  tweets = tweets[!status_id%in%suppr]
  done = fread("data/tagged_tweets.txt")
  names(done) <- c("status_id","domaine","sentiment","statut")
  done = melt(done,id.vars="status_id")
  to_do = tweets[!status_id%in%as.character(done$status_id)]
  
  done[,status_id:=as.character(status_id)]
  done%<>%
    separate_rows(sep = "/",value)
  
  train_data = merge(done,unique(tweets[,.(status_id,text)]),by="status_id")
  
  prep_fun = tolower
  tok_fun = word_tokenizer
  
  it_train = itoken(train_data$text, 
                    preprocessor = prep_fun, 
                    tokenizer = tok_fun, 
                    ids = train_data$status_id, 
                    progressbar = FALSE)
  vocab = create_vocabulary(it_train, ngram = c(1L, 2L))
  
  pruned_vocab = prune_vocabulary(vocab, 
                                  term_count_min = 3, 
                                  doc_proportion_max = 0.8,
                                  doc_proportion_min = 0.01)
  vectorizer = vocab_vectorizer(pruned_vocab)
  
  dtm_train = create_dtm(it_train, vectorizer)
  glmnet_classifier = glmnet(x = dtm_train, y = done[['value']], 
                             family = 'multinomial', 
                             # L1 penalty
                             alpha = 1,
                             # high value is less accurate, but has faster training
                             thresh = 1e-3,
                             # again lower number of iterations for faster training
                             maxit = 1e3)
  
  
  it_test = to_do$text %>% 
    prep_fun %>% 
    tok_fun %>% 
    itoken(ids = to_do$status_id, 
           # turn off progressbar because it won't look nice in rmd
           progressbar = FALSE)
  
  dtm_test = create_dtm(it_test, vectorizer)
  
  preds = predict(glmnet_classifier, dtm_test, type = 'response')
  preds_w_overfit = preds[,,dim(preds)[3]]
  pred_score = rowSums(preds_w_overfit^2)
  next_id = names(sort(pred_score,decreasing = F)[1])
  next_id
}
