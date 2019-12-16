library(data.table)
library(magrittr)
library(DT)
library(shinydashboard)
library(bit64)
library(text2vec)
library(glmnet)
library(tidyr)
library(magrittr)
library(shinycssloaders)

default_vars = c("screen_name","text","hashtags","urls_url")
domaine_cats = c("Protection sociale"="protec_soc","Santé"="sante","Retraite"="retraite","Handicap/Dépendence"="handicap","Jeunesse"="jeunesse","Pauvreté/Précarité"="pauvrete")
sentiment_cats = c("Référence/argument/citation"="reference","Communication/diffusion"="pub","Critique/inégalité/injustice"="critique","Proposition/suggestion/idée"="proposition")
statut_cats = c("Institution"="institution","Association"="association","Presse"="presse","Entreprise"="entreprise","Citoyen"="citoyen")
path_to_tweets = "../dataviz.drees_consultations_GAnalytics/tweet_history/"
nm = sample(list.files(path_to_tweets),1)
tweets=purrr::map(list.files(path_to_tweets),function(nm){
  load(paste0(path_to_tweets,nm))
  tweets_drees
})
tweets=rbindlist(tweets,fill = T)
tweets$hashtags = unlist(lapply(tweets$hashtags,paste,collapse=" "))
tweets$urls_url = unlist(lapply(tweets$urls_url,paste,collapse=" "))
# uniqueN(tweets[,.(status_id,text,hashtags,urls_url)])

tweets = tweets[,.(status_id,screen_name,text,hashtags,urls_url,
                   profile_expanded_url,favourites_count,
                   followers_count,friends_count,statuses_count)]
tweets = tweets[,.SD[1],by=.(screen_name,text)]




source('predict.R',local = T)

# tweets[,"text":=iconv(text,to="UTF-8")]
