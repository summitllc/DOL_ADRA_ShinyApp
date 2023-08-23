output$data_download <- downloadHandler(
  
  filename = function() {
    paste("blacklung_dataset", "xlsx", sep=".")
  },
  content = function(file) {
    
    file.copy('black lung analytic dataset FOR MAP.xlsx', file,overwrite = TRUE)
  },
  contentType = "text/xlsx"
)

output$text <- renderText({
  "Insert Paragraphs? from Kyle"
})