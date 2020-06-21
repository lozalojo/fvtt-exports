library(tidyverse)
library(openxlsx)
library(jsonlite)

export.journal <- function(i.jou){
  if (!file.exists(i.jou)) stop("dictionary not found, provide full path\n")
  bullets <- c("&#129;","&#149;","&#134;","&#172;")
  wb <- loadWorkbook(i.jou)
  temp1 <- readWorkbook(i.jou, "index")
  for (i in 1:NROW(temp1)){
    cat("file:\t",temp1$file[i],"\n")
    
    temp2 <- readWorkbook(i.jou, temp1$file[i]) %>%
      mutate(nr=1:n())
    temp3 <- max(stringr::str_count(temp2$pages, ","), na.rm=T)
    temp4 <- temp2 %>%
      separate(pages, paste0("pages", 1:(temp3+1)), ",", remove=T, extra="merge", fill="right") %>%
      mutate_at(paste0("pages", 1:(temp3+1)), trimws, which="both") %>%
      select(-level, -name) %>%
      gather("dummy1", "value", -nr) %>%
      filter(!is.na(value)) %>%
      separate(value, paste0("value", 1:2), "-", remove=F, extra="merge", fill="right") %>%
      mutate(value2=ifelse(is.na(value2), value1, value2)) %>%
      select(-dummy1) %>%
      arrange(nr, as.numeric(value1), as.numeric(value2)) %>%
      group_by(nr) %>%
      mutate(page=1:n()) %>%
      ungroup() %>%
      left_join(temp2 %>%
                  select(nr, level), by="nr") %>%
      mutate(description=paste0("<em class=\"",temp1$class[i],
                                "\" data-book=\"",temp1$book[i],
                                "\" data-page-start=\"",as.character(as.numeric(value1)+temp1$`page-offset`[i]),
                                "\" data-page-end=\"",as.character(as.numeric(value2)+temp1$`page-offset`[i]),
                                "\">",value,
                                "</em>"))
    
    bullets.i <- rep(bullets, length.out=max(temp4$level))
    temp5 <- temp4 %>%
      group_by(nr) %>%
      summarise(dummy1=paste(description, collapse=", ")) %>%
      ungroup() %>%
      right_join(temp2, by="nr") %>%
      mutate(dummy2=ifelse(is.na(dummy1),"",paste0(" ", dummy1)),
             dummy3=bullets.i[level]) %>%
      mutate(description=paste0("<h",level+2,">",strrep("&nbsp;",4*(level-1)),dummy3,strrep("&nbsp;",2), name, dummy2,"</h",level+2,">"))
    
    o.file <- file.path(dirname(tools::file_path_as_absolute(i.jou)), temp1$file[i])
    fileConn.in <- file(o.file, encoding="UTF-8")
    write(temp5$description, file=fileConn.in)
    close(fileConn.in)
  }
}

export.compendium <- function(i.com){
  if (!file.exists(i.com)) stop("dictionary not found, provide full path\n")
  
  wb <- loadWorkbook(i.com)
  temp1 <- readWorkbook(i.com, "index")
  for (i in 1:NROW(temp1)){
    cat("file:\t",temp1$file[i],"\n")
    temp2 <- readWorkbook(i.com, temp1$file[i]) %>%
      mutate(`page-end`=ifelse(is.na(`page-end`),`page-start`,`page-end`)) %>%
      mutate(`page-start-text`=ifelse(is.na(`page-start`),"@ref-error",as.character(`page-start`+temp1$`page-offset`[i])),
             `page-end-text`=ifelse(is.na(`page-end`),"@ref-error",as.character(`page-end`+temp1$`page-offset`[i])),
             `page-real-text`=ifelse(is.na(`page-start`),"@ref-error",as.character(`page-start`)),
             description=paste0("<p class=\"",temp1$class[i],
                                "\" data-book=\"",temp1$book[i],
                                "\" data-page-start=\"",`page-start-text`,
                                "\" data-page-end=\"",`page-end-text`,
                                "\">&nbsp; Ver página ",`page-real-text`,
                                " del manual básico</p>")) %>%
      select(-`page-start`,-`page-end`,-`page-start-text`,-`page-end-text`,-`page-real-text`)
    temp3 <- list()
    temp3$label <- temp1$label[i]
    temp3$mapping <- list()
    temp3$mapping$description <- "data.description"
    temp3$label <- unbox(temp3$label)
    temp3$mapping$description <- unbox(temp3$mapping$description)
    temp3$entries <- temp2
    temp4 <- toJSON(temp3, pretty=TRUE)
    o.file <- file.path(dirname(tools::file_path_as_absolute(i.com)), temp1$file[i])
    fileConn.in <- file(o.file, encoding="UTF-8")
    write(temp4, file=fileConn.in)
    close(fileConn.in)
  }
}
