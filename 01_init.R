 print("Hello R")
#load packages
  library(learnr)

 # --- 1) Imposta l'email usata da Git per i commit (metti la TUA email) ---
 system('git config --global user.email "flavia.dangelo@student.univaq.it"')
 
 # --- 2) Imposta il nome usato da Git per i commit (metti il TUO nome e cognome) ---
 system('git config --global user.name "flaviadangelo"')
 
 # --- 3) Controlla che Git abbia salvato le impostazioni globali ---
 # (stampa la lista delle configurazioni globali; cerca user.name e user.email)
 system("git config --global --list")
 