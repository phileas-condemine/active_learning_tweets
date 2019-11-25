library(data.table)
library(magrittr)
library(DT)
library(shinydashboard)
library(bit64)
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
tweets=do.call("rbind",tweets)
tweets=unique(tweets)%>%data.table

suppr = readLines("data/to_remove.txt")
# tweets[status_id%in%suppr]
tweets = tweets[!status_id%in%suppr]

done = fread("data/tagged_tweets.txt")
names(done) <- c("status_id","domaine","sentiment","statut")

to_do = tweets[!status_id%in%as.character(done$status_id)]

# tweets[,"text":=iconv(text,to="UTF-8")]
