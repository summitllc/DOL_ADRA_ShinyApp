output$data_dict_table <- renderDataTable(
  data_dict %>%
    slice(match(dictionary_list, Variable)) %>% 
    left_join(crosswalk %>%
                select(variable, full_title),
              by = c('Variable' = 'variable')) %>% 
    select(full_title, Description, `Formula (if applicable)`) %>% 
    rename(Variable = full_title) %>% 
    mutate(`Formula (if applicable)` = str_replace_all(`Formula (if applicable)`, replacements)) 
)
