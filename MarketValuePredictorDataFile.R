library(rvest)
library(dplyr)
library(stringr)
library(ggplot2)

presurl <- "https://sofifa.com/?showCol%5B0%5D=ae&showCol%5B1%5D=oa&showCol%5B2%5D=pt&showCol%5B3%5D=vl&showCol%5B4%5D=wg&showCol%5B5%5D=tt&showCol%5B6%5D=pi&showCol%5B7%5D=hi&showCol%5B8%5D=wi&showCol%5B9%5D=pf&showCol%5B10%5D=bo&showCol%5B11%5D=bp&showCol%5B12%5D=gu&showCol%5B13%5D=jt&showCol%5B14%5D=le&showCol%5B15%5D=rc&showCol%5B16%5D=ta&showCol%5B17%5D=cr&showCol%5B18%5D=fi&showCol%5B19%5D=he&showCol%5B20%5D=sh&showCol%5B21%5D=vo&showCol%5B22%5D=ts&showCol%5B23%5D=dr&showCol%5B24%5D=cu&showCol%5B25%5D=fr&showCol%5B26%5D=lo&showCol%5B27%5D=bl&showCol%5B28%5D=to&showCol%5B29%5D=ac&showCol%5B30%5D=sp&showCol%5B31%5D=ag&showCol%5B32%5D=re&showCol%5B33%5D=ba&showCol%5B34%5D=tp&showCol%5B35%5D=so&showCol%5B36%5D=ju&showCol%5B37%5D=st&showCol%5B38%5D=sr&showCol%5B39%5D=ln&showCol%5B40%5D=te&showCol%5B41%5D=ar&showCol%5B42%5D=in&showCol%5B43%5D=po&showCol%5B44%5D=vi&showCol%5B45%5D=pe&showCol%5B46%5D=cm&showCol%5B47%5D=td&showCol%5B48%5D=ma&showCol%5B49%5D=sa&showCol%5B50%5D=sl&showCol%5B51%5D=tg&showCol%5B52%5D=gd&showCol%5B53%5D=gh&showCol%5B54%5D=gc&showCol%5B55%5D=gp&showCol%5B56%5D=gr&showCol%5B57%5D=bs&showCol%5B58%5D=wk&showCol%5B59%5D=sk&showCol%5B60%5D=aw&showCol%5B61%5D=dw&showCol%5B62%5D=ir&showCol%5B63%5D=bt&showCol%5B64%5D=pac&showCol%5B65%5D=sho&showCol%5B66%5D=pas&showCol%5B67%5D=dri&showCol%5B68%5D=def&showCol%5B69%5D=phy&r=190075&set=true&offset=0"

tablexpath <- '//*[@id="body"]/div[1]/div/div[2]/div/table'

prestable <- presurl %>%
  read_html() %>%
  html_element(xpath = tablexpath) %>%
  html_table()


x <- 60

while (x < 5641) {
  print(x)
  x_string <- as.character(x)
  new_url <- str_replace(presurl, str_sub(presurl, 1370, -1), paste("t=", x_string))
  
  updated_tables <- new_url %>%
    read_html() %>%
    html_element(xpath = tablexpath) %>%
    html_table()
  
  prestable <- unique(rbind(prestable, updated_tables))
  
  x <- x + 60
}

write.csv(prestable, file = 'sofifadata.csv', row.names = FALSE)


