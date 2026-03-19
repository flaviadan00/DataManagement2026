############################################################
# arrange(), group_by(), summarise(), count(), across()
############################################################

library(tidyverse)
library(palmerpenguins)

data(penguins)

# Guardiamo rapidamente il dataset
glimpse(penguins)


############################################################
# 1) ARRANGE
############################################################

# arrange() serve per ordinare le righe dal minore al maggiore o viceversa

penguins |>
  arrange(body_mass_g) |>   
  head()                   
#la funzione head() mostra sulla console solo le prime righe del risultato

penguins |>
  arrange(desc(body_mass_g)) |>
  head()
#se vogliamo ordinare in ordine decrescente, usiamo desc() dentro arrange()
#desc() può essere utilizzata anche separatamente
############################################################
# 2) GROUP BY + SUMMARISE
############################################################

# group_by() definisce i gruppi
# summarise() calcola un riassunto per ciascun gruppo
 
# Esempio 1: peso medio per specie
penguins |>
  group_by(species) |>
  summarise(
    mean_mass = mean(body_mass_g, na.rm = TRUE) # na.rm=TRUE è per togliere gli NA dal calcolo della media
  )

# Esempio 2: più statistiche per specie
penguins |>
  group_by(species) |>
  summarise(
    mean_mass = mean(body_mass_g, na.rm = TRUE),
    sd_mass = sd(body_mass_g, na.rm = TRUE),
    n = n()    #conto quanti individui ho per specie
  )

# Esempio 3: riassunto per specie e isola, e si può fare anche per altre variabili
penguins |>
  group_by(species, island) |>
  summarise(
    mean_mass = mean(body_mass_g, na.rm = TRUE),
    n = n()
  )

############################################################
# 3) COUNT
############################################################

# count() è una scorciatoia molto utile per contare osservazioni

penguins |>
  count(species)

penguins |>
  count(species, island) #si possono contare più variabili contemporaneamente


############################################################
# 4) TANTE VARIABILI STESSA FUNZIONE
############################################################

# Immaginiamo di voler calcolare la media di più variabili
# numeriche per ciascuna specie

# Possiamo farlo "a mano", scrivendo una riga per ogni colonna

penguins |>
  group_by(species) |>
  summarise(
    mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
    mean_bill_depth = mean(bill_depth_mm, na.rm = TRUE),
    mean_flipper_length = mean(flipper_length_mm, na.rm = TRUE),
    mean_body_mass = mean(body_mass_g, na.rm = TRUE)
  )

# Questo approccio funziona bene con poche colonne,
# ma diventa lungo e ripetitivo quando le colonne aumentano

#si può creare un cursore lungo con ctrl alt e frecce alto e basso e selezioniamo 
#tutte le righe
############################################################
# 5) ACROSS
############################################################

# across() serve per applicare la stessa funzione
# a più colonne contemporaneamente

# Esempio 1: stessa cosa di prima, ma più compatta
penguins |>
  group_by(species) |>
  summarise(
    across(
      c(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g), 
      # c() sta per combine e mi crea un vettore dove inserisco tutte le colonne
      mean, #across mette mean fuori dalla funzione
      na.rm = TRUE
    )
  )
#però bisogna scrivere tutte le colonne

# Esempio 2: rinominare le nuove colonne in modo più chiaro
penguins |>
  group_by(species) |>
  summarise(
    across(
      c(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g),
      mean,
      na.rm = TRUE,
      .names = "mean_{.col}" 
# .names è un argomento di across() che permette di specificare il nome delle nuove colonne, 
#praticamente rinomina le colonne
    )
  )

# Esempio 3: più funzioni sulle stesse colonne
penguins |>
  group_by(species) |>
  summarise(
    across(
      c(bill_length_mm, body_mass_g),
      list(mean = mean, sd = sd), #può contenere tutto, è il corrispettivo di c ma più capiente
      na.rm = TRUE
    )
  )
#alle colonne viene aggiunta _mean e _sd a seconda della funzione che viene applicata

# Esempio 4: tutte le colonne numeriche
penguins |>
  group_by(species) |>
  summarise(
    across(
      where(is.numeric), #prendi tutte le colonne numeriche del dataset e fai la media
      mean,
      na.rm = TRUE,
      .names = "mean_{.col}"
    )
  )
#where si può usare anche dentro select

penguins |> 
  select(where(is.numeric)) #fa la media di tutte le colonne numeriche

# Esempio 5: combinare across() con n()
penguins |>
 mutate(year= as.factor(year)) |> #così non fa la media di year e si trasforma il factor oppure caracter
   group_by(species) |>
  summarise(
    n = n(),
    across(
      where(is.numeric),
      mean,
      na.rm = TRUE,
      .names = "mean_{.col}"
    )
  )
#in summarise() posso mettere più cose, non solo across(), ma anche n() o altre funzioni

############################################################
# 6) ESEMPIO DIDATTICO
############################################################

# Versione manuale
penguins |>
  group_by(species) |>
  summarise(
    mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
    mean_body_mass = mean(body_mass_g, na.rm = TRUE)
  )

# Versione con across()
penguins |>
  group_by(species) |>
  summarise(
    across(
      c(bill_length_mm, body_mass_g),
      mean,
      na.rm = TRUE,
      .names = "mean_{.col}"
    )
  )

# across() è particolarmente utile quando:
# - le colonne sono molte
# - la funzione è la stessa
# - vogliamo evitare codice ripetitivo


############################################################
# ESERCIZI
############################################################

# Usare sempre il dataset penguins
# e il pipe nativo |>


### ESERCIZIO 1
# Ordinare il dataset in ordine crescente di bill_length_mm


### ESERCIZIO 2
# Ordinare il dataset in ordine decrescente di flipper_length_mm


### ESERCIZIO 3
# Calcolare il peso medio (body_mass_g) per specie


### ESERCIZIO 4
# Calcolare media e deviazione standard di body_mass_g per specie


### ESERCIZIO 5
# Contare quante osservazioni ci sono per ciascuna specie


### ESERCIZIO 6
# Contare quante osservazioni ci sono per specie e isola


### ESERCIZIO 7
# Calcolare, in modo manuale, la media di:
# bill_length_mm, bill_depth_mm e body_mass_g
# per ciascuna specie


### ESERCIZIO 8
# Usare across() per calcolare la media di:
# bill_length_mm, bill_depth_mm e body_mass_g
# per ciascuna specie


### ESERCIZIO 9
# Usare across() per calcolare la media
# di tutte le colonne numeriche per specie


### ESERCIZIO 10
# Usare across() per calcolare media e sd
# di bill_length_mm e flipper_length_mm per specie


### ESERCIZIO 11
# Calcolare il numero di osservazioni e la media di body_mass_g
# per specie e isola


### ESERCIZIO 12
# Calcolare il numero di osservazioni e la media
# di tutte le colonne numeriche per specie


### ESERCIZIO 13
# Calcolare la media di tutte le colonne numeriche
# per specie e isola


### ESERCIZIO 14
# Ordinare il risultato dell'esercizio precedente
# in ordine decrescente di mean_body_mass_g
# (suggerimento: usare .names in across())


### ESERCIZIO 15
# Creare una tabella riassuntiva per specie con:
# - n
# - media di bill_length_mm
# - media di bill_depth_mm
# - media di flipper_length_mm
# - media di body_mass_g

############################################################
# PROMEMORIA FINALE
############################################################

# arrange()   -> ordina le righe
# group_by()  -> definisce i gruppi
# summarise() -> riassume i gruppi
# count()     -> conta osservazioni
# across()    -> applica la stessa funzione a più colonne