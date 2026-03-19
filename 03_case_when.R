############################################################
# TIDYVERSE – LEZIONE 2
# mutate(), transmute(), case_when() e introduzione ai loop
############################################################
install.packages("tidylog")
library(tidylog) #per vedere cosa succede quando facciamo mutate, transmute, filter, select, ecc
library(dplyr)
library(palmerpenguins)
library(ggplot2)
library(tidyverse)

data(penguins)

# Guardiamo il dataset
glimpse(penguins)


############################################################
# 1 MUTATE
############################################################

# mutate() serve per creare nuove colonne
# oppure modificare colonne esistenti

penguins |>
  mutate(    body_mass_kg = body_mass_g / 1000  ) |>
  head()
#ctrlF ci appare la cartella find dove possiamo cambiare una cosa in tutto il codice

# Possiamo creare più colonne

penguins |>
  mutate(
    body_mass_kg = body_mass_g / 1000,
    bill_ratio = bill_length_mm / bill_depth_mm
  ) |>
  head() #head visualizza la tabella alla fine
#se facciamo mutate senza cambiare il nome alla colonna si aggiunge una nuova colonna

# Possiamo anche modificare una colonna esistente

penguins |>
  mutate(
    body_mass_g = body_mass_g / 1000
  ) |>
  head()

penguins_mod<- penguins |>
  mutate(
    body_mass_Kg = body_mass_g / 1000,
   bill_ratio = bill_length_mm / bill_depth_mm  ) |> 
  head()


#senza pipe, ma è la stessa cosa 
mutate(penguins, body_mass_g = body_mass_g / 1000)
############################################################
# 2 TRANSMUTE
############################################################

# transmute() crea nuove colonne
# ma elimina quelle vecchie
#si usa tanto quando si inizia a lavorare con il codice, 
#e serve per eliminare delle colonne che non ci servono

penguins |>
  transmute(
    species = as.character(species),
    body_mass_kg = body_mass_g / 1000 ) |>
  head()

# Differenza:
# mutate() mantiene tutto
# transmute() tiene solo le nuove colonne


############################################################
# 3 CLASSIFICARE VARIABILI CON MUTATE
############################################################

# Possiamo creare categorie

 penguins |>
  mutate(
    big_penguin = body_mass_g > 5000
  ) |>
  select(species, body_mass_g, big_penguin) |>
  head()


############################################################
# 4 INTRODUZIONE AI LOOP
############################################################

# Prima delle funzioni vettoriali
# spesso si usavano loop

mass <- penguins$body_mass_g

#versione tidyverse
mass1 <- penguins |> 
  pull(body_mass_g) 

identical(mass, mass1) #funzione che ci dice se le due cose sono identiche

size_class <- vector(length = length(mass))
#sono parole chiave quelle in arancione, quindi non bisogna chiamare gli oggetti con questi nomi
#e neanche con il nome delle fuzioni
#gni volta che fa un giro i cambia valore, quante volte gira dipende dalla lunghezza del vettore
#versione più semplice di for i
for(i in 1:length(mass)){    #i 1: qualcosa ci da un vettore che va da 1 alla lunghezza di mass es 344
  print(i)
} 
                               #si possono fare le operazioni dentro print es i*i 
                               #i loop base sono lentissimi, perciò bisogna capire se serve veramente

for(i in 1:length(mass)){ #per il mio vettore che va da 1 a lunghezza del vettore mass
  
  if(is.na(mass[i])){ #se nella posizione iesima è NA allora mettiamo NA
    
    size_class[i] <- NA
    
  } else if(mass[i] > 5500){ #se invece 
    
    size_class[i] <- "large" #allora mettiamo large
    
  } else if(mass[i] > 4000){ #se invece è maggiore di 4000 allora mettiamo medium
    
    size_class[i] <- "medium"
    
  } else { #altrimenti, se non rispetta le altre condizioni, la taglia è piccola
    
    size_class[i] <- "small" 
    
  }
  
}

head(size_class)

size_class #per vedere tutto il vettore, ma è molto lungo.

# aggiungiamo la colonna

penguins$size_class_loop <- size_class
#così assumiamo che il vettore creato rispetta la setessa condizione del dataset.
#se un vettore è più piccolo della lunghezza del dataset, 
#R lo ricicla, quindi se size_class fosse lungo 10, i primi 10 pinguini avrebbero la classificazione 
#corretta, e poi si riciclerebbe da capo, e i successivi 10 pinguini avrebbero la stessa classificazione 
#dei primi 10, e così via.


############################################################
# 5 CASE_WHEN
############################################################

# case_when() è il modo tidyverse
# per fare classificazioni multiple ed è il metodo più veloce al posto di for i

pippo <- penguins |>
  mutate(
    size_class1 = case_when(           #gli stiamo dicendo quando.....
      body_mass_g > 5500 ~ "large",    #tilde ci dice se è vero allora metti large,
      body_mass_g > 4000 ~ "medium",   #se è vero allora metti medium, 
      body_mass_g <= 4000 ~ "small",   #se è vero allora metti small 
      TRUE ~ NA_character_             #TRUE significa in tutti gli altri casi
    )                                  #quando non lo rispetta mette NA character
  ) |>
  select(species, body_mass_g, size_class1) |>
  head()


############################################################
# 6 ALTRO ESEMPIO DI CLASSIFICAZIONE
############################################################

penguins |>
  mutate(
    flipper_class = case_when(
      flipper_length_mm > 220 ~ "very_long",
      flipper_length_mm > 200 ~ "long",
      flipper_length_mm > 180 ~ "medium",
      TRUE ~ "short"                      #true tilde qualcosa: in tutti gli altri casi metti short,   
    )                                     #che è maggiore di 220, neanche di 200, neanche di 180  
  ) |>                                    #allora è short
  select(species, flipper_length_mm, flipper_class) |>
  head()
#creando le classi poi non possiamo risalire al numero, 
#quindi mantenere la colonna numerica

############################################################
# 7 PIPELINE COMPLETA
############################################################

pluto<-penguins |>
  filter(!is.na(body_mass_g)) |>         #si asportano le righe dove il body_mass è NA
  mutate(
    size_class = case_when(
      body_mass_g > 5500 ~ "large",
      body_mass_g > 4000 ~ "medium",
      TRUE ~ "small"
    )
  ) |>
  select(species, island, body_mass_g, size_class) |>
  head() 
 #per interrogare le funzioni facciamo: ?case_when 
?case_when


################GRAFICI#########################################
#fai lo scatter plot body_mass_g e flipper_length_mm

paperino <- ggplot(penguins, aes(x = body_mass_g, y = flipper_length_mm)) +  #prima funzione è il data per fare i grafici                                                          #aes significa tutto quello che voglio nella tel                                                               #sulla x il peso e sulle y lunghezza ala
            geom_point(aes(col="red"))
#connette i punti con le linee
 #ci da la distribuzione del peso, se è più alta in un punto significa che ci sono più pinguini con quel peso

#per salvare
ggsave("scatter.png", 
       plot=paperino,
       width = 150 , 
       height = 60, 
       units = "mm", 
       dpi = 300) 
#per salvare il grafico, con le dimensioni e la risoluzione che vogliamo

#fare un grafico per categorie
            #aes significa tutto quello che voglio nella tela
ggplot(penguins, aes(x=size_class1, y = flipper_length)) + 
  geom_boxplot() #ci da la distribuzione del peso per ogni classe di taglia


############################################################
 # ESERCIZI --> abbinare un grafico
############################################################

# usare sempre il dataset penguins
# e il pipe nativo |>


### ESERCIZIO 1
# creare una colonna body_mass_kg
massa_Kg<-penguins |> 
  mutate(body_mass_Kg=body_mass_g/1000)

### ESERCIZIO 2
# creare una variabile bill_ratio
# = bill_length_mm / bill_depth_mm
penguins |> 
  mutate(bill_ratio=bill_length_mm/bill_depth_mm) |> 
  head()

### ESERCIZIO 3
# usare transmute per ottenere
# species e body_mass_kg
penguins |> 
  transmutate()

### ESERCIZIO 4
# creare una variabile big_penguin
# TRUE se body_mass_g > 5000
penguins |> 
  mutate(big_penguin = body_mass_g > 5000) |>
  select(species, body_mass_g, big_penguin) |>
  head()

### ESERCIZIO 5
# classificare body_mass_g
# >5500  heavy
# >4500  medium
# else   light
penguins |> 
  mutate(
    size_class = case_when(
    body_mass_g > 5500 ~ "heavy",
    body_mass_g > 4500 ~ "medium",
    TRUE ~ "light"
  ) )|>
  head()

### ESERCIZIO 6
# classificare flipper_length_mm
# >220 long
# >200 medium
# else short
penguins |> 
  mutate(
    flipper_class= case_when(
      flipper_length_mm > 220 ~ "long",
      flipper_length_mm > 200 ~ "medium",
      TRUE ~ "short"
    )) |> 
  head()

### ESERCIZIO 7
# creare una variabile bill_long
# TRUE se bill_length_mm > 45
penguins |> 
  mutate(
    bill_long = bill_length_mm > 45
  ) |> 
  select(species, bill_length_mm, bill_long) |>
  head()

### ESERCIZIO 8
# creare una variabile species_code
# Adelie = A
# Gentoo = G
# Chinstrap = C
codici_specie<-penguins |> 
  mutate(
    species_code = case_when(
      species == "Adelie" ~ "A",
      species== "Gentoo" ~ "G",
      species== "Chinstrap" ~ "C"
    )) |> 
  select(species, species_code) |>
  head()


### ESERCIZIO 9
# filtrare body_mass_g > 4500
# poi creare size_class
penguins |> 
  filter(body_mass_g>4500) |>
  mutate(
    size_class = case_when(
      body_mass_g > 4500 ~ "medium",
    )) |>
  select(species, body_mass_g, size_class) |>
  head()

### ESERCIZIO 10
# creare una variabile heavy_flipper
# body_mass_g > 5000 AND flipper_length_mm > 210
penguins |> 
  mutate(
    heavy_flipper= body_mass_g > 5000 & flipper_length_mm > 210
  ) |> 
  select(species, body_mass_g, flipper_length_mm, heavy_flipper) |> 
  head()

############################################################
# PROMEMORIA
############################################################

# mutate()      -> crea o modifica colonne
# transmute()   -> crea colonne e elimina le vecchie
# case_when()   -> alternativa leggibile a molti if
# for loop      -> metodo classico ma meno elegante