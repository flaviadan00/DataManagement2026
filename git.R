library(usethis)
use_git_config(user.name = "flaviadangelo", user.email = "flavia.dangelo@student.univaq.it")

library(gitcreds)




usethis::create_github_token()

# --- 5) Salva il token nel credential manager usato da Git sul tuo computer ---
# (quando chiede "Enter password or token:", incolla il token e premi invio)
3


git remote add origin https://github.com/flaviadan00/DataManagement2026.git
git branch -M main
git push -u origin main
