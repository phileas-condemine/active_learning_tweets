dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    selectInput("vars_to_show","Informations à afficher",choices = names(tweets),multiple = T,selected = default_vars)
  ),
  dashboardBody(
    fluidRow(
      box(DTOutput("tweet"),collapsible = T,title = "Champs",status = "info",width = 12),
      box(title = "Annotation",checkboxGroupInput("tag_domaine","Domaine",choices = domaine_cats,inline = T),
          checkboxGroupInput("tag_sentiment","Sentiment",selected = "",choices = sentiment_cats,inline = T),
          checkboxGroupInput("tag_statut","Statut",selected = "",choices = statut_cats,inline = T),
          actionButton("apply_tags","Soumettre",icon=shiny::icon("paper-plane")),
          collapsible = T,status="primary"),
      box(actionButton("rerun","Changer de tweet"),
          actionButton("rm","Supprimer ce tweet")))
  ),
  title = "Annotation DREES-tweets"
)
