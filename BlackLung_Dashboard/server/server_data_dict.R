output$data_dict_table <- renderDataTable(
  
  data_dict %>%
    slice(match(dictionary_list, Variable)) %>% 
    left_join(crosswalk %>%
                select(variable, full_title),
              by = c('Variable' = 'variable')) %>% 
    select(full_title, Description, `Formula (if applicable)`) %>% 
    rename(Variable = full_title) %>% 
    mutate(`Formula (if applicable)` = str_replace_all(`Formula (if applicable)`, replacements)) 
    
    # select(-c(Variable, `Map Variable Name`, Format, `Label Name`)) %>% view()
  
  # data_dict %>% 
  #   slice(match(variables, Variable)) %>% 
  #   bind_rows(data_dict %>% 
  #               filter(!(Variable %in% variables))) 
    # mutate(Name = str_replace_all(Name, "_", " "),
    #        Name = str_replace(Name, "pct", "Percent"),
    #        Name = str_replace(Name, "acshouseheatingfueltotalocc", "acs house heating fuel total occ"),
    #        Name = str_replace(Name, "acshouseheatingfulepercentu", "acs house heating fuel percent"),
    #        Name = str_replace(Name, "totalmines", "total mines 20"),
    #        Name = str_replace(Name, "totalprodx1000st", "total production (x1000) 20"),
    #        Name = str_replace(Name, "per1000", "(per 1000)"),
    #        Name = str_replace(Name, "undrgrnd", "Underground"),
    #        Name = str_to_title(Name),
    #        Name = str_replace(Name, "Acs", "ACS"),
    #        Name = str_replace(Name, "Cwppmf", "CWP PMF"),
    #        Name = str_replace(Name, "Cwp", "CWP"),
    #        Name = str_replace(Name, "Occ", "OCC"))
)
