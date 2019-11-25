function(input,output,session){

  
  current_tweet = reactiveVal(to_do[sample(nrow(to_do),1)])
  
  observeEvent(input$rm,{
    if(input$rm){
      write(file = "data/to_remove.txt",append = T,x = current_tweet()$status_id)
    }
    num = sample(nrow(to_do),1)
    print(num)
    current_tweet(to_do[num])
  })
  
  observeEvent(input$rerun,{
    num = sample(nrow(to_do),1)
    print(num)
    current_tweet(to_do[num])
  })
  
  observeEvent(input$apply_tags,{
    tag_domaine = paste0(input$tag_domaine,collapse = "/")
    tag_sentiment = paste0(input$tag_sentiment,collapse = "/")
    tag_statut = paste0(input$tag_statut,collapse = "/")
    res = paste(current_tweet()$status_id,tag_domaine,tag_sentiment,tag_statut,sep=";")
    print(res)
    write(file = "data/tagged_tweets.txt",append = T,x = res)
    updateCheckboxGroupInput(session,"tag_domaine",selected = "")
    updateCheckboxGroupInput(session,"tag_sentiment",selected = "")
    updateCheckboxGroupInput(session,"tag_statut",selected = "")
    num = sample(nrow(to_do),1)
    print(num)
    current_tweet(to_do[num])
  })
  
  output$tweet = renderDT({
    datatable(current_tweet()[,input$vars_to_show,with=F],rownames = FALSE)
  })
  
}
