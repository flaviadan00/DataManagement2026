 print("Hello R")
#load packages
  library(learnr)

 library(usethis)
 use_git_config(user.name = "flaviadangelo", user.email = "flavia.dangelo@student.univaq.it")
 
 library(gitcreds)
 
 
  

 usethis::create_github_token()
 
 # --- 5) Salva il token nel credential manager usato da Git sul tuo computer ---
 # (quando chiede "Enter password or token:", incolla il token e premi invio)
 gitcreds::gitcreds_set()
 
