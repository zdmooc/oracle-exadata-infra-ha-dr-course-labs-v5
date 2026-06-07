# Module 03 — Key Capabilities Exadata

## 1. Objectif du module

Ce module présente les capacités clés qui différencient Oracle Exadata d’une infrastructure Oracle classique.

L’objectif n’est pas seulement de lister des fonctionnalités, mais de comprendre **où elles agissent**, **quels composants sont impliqués**, **dans quelles conditions elles apportent un gain** et **quelles limites éviter**.

À la fin de ce module, le lecteur doit être capable de :

- expliquer les principales capacités Exadata ;
- comprendre le rôle de Smart Scan ;
- comprendre le rôle de l’Offload SQL ;
- comprendre le rôle de Flash Cache et Flash Log ;
- comprendre le rôle de Storage Index ;
- comprendre le rôle de Hybrid Columnar Compression ;
- comprendre le rôle d’IORM ;
- distinguer accélération réelle, simple cache et réduction de données transférées ;
- expliquer pourquoi ces capacités ne sont pas magiques ;
- savoir quelles métriques lire pour prouver un comportement Exadata.

---

## 2. Pourquoi les capacités Exadata sont importantes

Exadata apporte sa valeur parce qu’elle ne se contente pas d’héberger Oracle Database sur des serveurs puissants.

Elle ajoute des capacités spécifiques dans les **Storage Cells** et dans la coopération entre :

```text
Oracle Database
Database Servers
ASM
Réseau interne RoCE / InfiniBand
Storage Cells
Flash / disques
Exadata System Software
```

Les capacités Exadata doivent toujours être comprises dans le chemin complet d’une requête :

```text
SQL
→ Database Server
→ ASM
→ réseau interne
→ Storage Cell
→ flash/disques
→ retour vers Database Server
```

Les principales capacités sont :

| Capacité | Objectif principal |
|---|---|
| Smart Scan | Traiter une partie des grands scans dans les Storage Cells |
| Offload SQL | Déporter certains traitements SQL vers les Storage Cells |
| Predicate Filtering | Filtrer certaines lignes côté Storage Cell |
| Column Projection | Renvoyer seulement les colonnes utiles |
| Storage Index | Éviter certaines lectures inutiles |
| Flash Cache | Accélérer certaines lectures |
| Flash Log | Accélérer certaines écritures redo |
| HCC | Compresser efficacement certains usages analytiques |
| IORM | Prioriser les I/O entre workloads |
| Cell metrics | Fournir des preuves de performance côté Storage Cell |

---

## 3. Vue d’ensemble : Oracle classique vs Exadata

| Sujet | Oracle classique | Oracle Exadata |
|---|---|---|
| Lecture de données | Le stockage renvoie surtout des blocs | Les Storage Cells peuvent traiter certaines opérations |
| Filtrage SQL | Principalement côté Database Server | Certains filtres peuvent être appliqués côté Storage Cell |
| Colonnes inutiles | Peuvent remonter avec les blocs | Column Projection peut réduire les données retournées |
| Cache | Buffer Cache côté instance, cache éventuel baie | Buffer Cache + Flash Cache Exadata |
| Priorisation I/O | Limitée côté stockage classique | IORM côté Storage Cells |
| Diagnostic stockage | Souvent séparé | Métriques CellCLI / Enterprise Manager |
| Optimisation scans | Dépend du serveur et du stockage | Smart Scan + Offload + Storage Index + HCC selon conditions |

À retenir :

```text
Le plus d’Exadata vient de l’intelligence placée dans les Storage Cells
et de la coopération entre Oracle Database et le stockage.
```

---

## 4. Smart Scan

### 4.1 Définition

Smart Scan est une capacité Exadata qui permet aux Storage Cells de traiter une partie de certains grands scans.

Au lieu de renvoyer tous les blocs au Database Server, les Storage Cells peuvent :

```text
filtrer certaines lignes
ne renvoyer que certaines colonnes
réduire le volume transféré
éviter certaines lectures avec Storage Index
exploiter HCC dans certains cas analytiques
```

### 4.2 Exemple simple

Requête :

```sql
select customer_id, amount
from sales
where region = 'FR';
```

Dans une architecture classique :

```text
1. Le stockage renvoie beaucoup de blocs.
2. Le Database Server filtre region = 'FR'.
3. Le Database Server garde customer_id et amount.
```

Dans Exadata avec Smart Scan possible :

```text
1. Le Database Server envoie une demande aux Storage Cells.
2. Les Storage Cells lisent les données.
3. Elles filtrent region = 'FR' si possible.
4. Elles renvoient seulement customer_id et amount.
5. Le Database Server reçoit moins de données.
```

### 4.3 Conditions favorables

Smart Scan est surtout utile pour :

```text
grands scans
full table scan
fast full index scan
direct path read
requêtes analytiques
tables volumineuses
projection de colonnes
prédicats simples et compatibles
```

### 4.4 Limites

Smart Scan ne s’applique pas toujours.

Il peut ne pas être utilisé si :

```text
la requête utilise un index très sélectif
les données sont déjà lues via buffer cache
le plan ne choisit pas un accès compatible
les fonctions SQL ne sont pas offloadables
les statistiques sont mauvaises
le volume lu est faible
la requête n’a pas de filtre utile
```

---

## 5. Offload SQL

### 5.1 Définition

Offload SQL signifie déporter une partie du traitement SQL vers les Storage Cells.

Le Database Server reste responsable du moteur SQL, des transactions, de la cohérence et du résultat final.  
Mais certaines opérations peuvent être faites au plus près des données.

### 5.2 Ce qui peut être déporté

| Mécanisme | Rôle |
|---|---|
| Predicate Filtering | Filtrer certaines lignes dans les Storage Cells |
| Column Projection | Ne renvoyer que les colonnes nécessaires |
| Storage Index | Éviter des régions de stockage inutiles |
| HCC Scan | Lire efficacement des données compressées |
| Some function offload | Certaines fonctions simples peuvent être traitées côté cell selon compatibilité |

### 5.3 Image mentale

```text
Sans offload :
Storage → blocs → Database Server → filtre / projection

Avec offload :
Storage Cell → filtre / projection → données réduites → Database Server
```

### 5.4 Preuve à chercher

Un gain d’offload se prouve par des métriques, pas par impression.

Métriques typiques :

```text
cell_offload_eligible_bytes
cell_offload_returned_bytes
physical_read_bytes
cell physical IO interconnect bytes
cell smart table scan
```

---

## 6. Predicate Filtering

### 6.1 Définition

Predicate Filtering signifie que certains filtres `WHERE` peuvent être appliqués dans la Storage Cell.

Exemple :

```sql
select *
from sales
where amount > 1000;
```

Si le filtre est compatible, la Storage Cell peut éliminer certaines lignes avant de renvoyer les données au Database Server.

### 6.2 Apport

```text
moins de lignes retournées
moins de trafic sur le réseau interne
moins de travail côté Database Server
meilleure efficacité sur grands volumes
```

### 6.3 Limites

Tous les prédicats ne sont pas forcément offloadables.

Exemple moins favorable :

```sql
where trunc(sale_date) = date '2026-01-01'
```

Souvent, une écriture plus favorable est :

```sql
where sale_date >= date '2026-01-01'
and sale_date < date '2026-01-02'
```

---

## 7. Column Projection

### 7.1 Définition

Column Projection signifie que la Storage Cell ne renvoie que les colonnes nécessaires.

Exemple :

```sql
select customer_id, amount
from sales
where region = 'FR';
```

Si la table contient 100 colonnes, mais que la requête n’en demande que 2, Exadata peut éviter de renvoyer inutilement les colonnes non demandées dans certains chemins compatibles.

### 7.2 Apport

```text
moins de données transférées
moins de mémoire consommée côté Database Server
meilleure efficacité sur tables larges
```

---

## 8. Storage Index

### 8.1 Définition

Storage Index est un mécanisme Exadata côté Storage Cell.

Il permet d’éviter certaines lectures inutiles grâce à des métadonnées sur les valeurs stockées dans des régions de stockage.

Ce n’est pas un index Oracle B-tree.

### 8.2 Exemple

Si une région de stockage contient des dates entre janvier et mars, et que la requête demande décembre, la Storage Cell peut éviter de lire cette région.

```text
Requête : where sale_date >= date '2026-12-01'
Région de stockage : dates entre janvier et mars
Résultat : région ignorée si les métadonnées le permettent
```

### 8.3 Limites

Storage Index n’est pas créé manuellement comme un index classique.  
Il dépend des données, des accès et des métadonnées maintenues par les Storage Cells.

---

## 9. Flash Cache

### 9.1 Définition

Flash Cache est une couche de cache flash dans les Storage Cells.

Elle accélère certaines lectures en servant les blocs depuis la flash plutôt que depuis les disques.

### 9.2 Apport

Flash Cache est utile pour :

```text
blocs chauds
accès répétés
OLTP
lectures sensibles à la latence
charges mixtes
```

### 9.3 Différence avec Smart Scan

| Sujet | Smart Scan | Flash Cache |
|---|---|---|
| But | Réduire les données retournées | Accélérer certaines lectures |
| Où ? | Storage Cells | Storage Cells |
| Type de gain | Moins de volume remonté | Lecture plus rapide |
| Cas typique | Scan analytique | Blocs chauds / OLTP / lectures répétées |

À retenir :

```text
Smart Scan réduit ce qui remonte.
Flash Cache accélère certaines lectures.
```

---

## 10. Flash Log

### 10.1 Définition

Flash Log utilise la flash des Storage Cells pour accélérer certaines écritures redo.

Le redo est critique car Oracle doit sécuriser les transactions.

### 10.2 Apport

Flash Log peut aider à réduire la latence des écritures redo dans certains scénarios.

Il est particulièrement important pour :

```text
OLTP
transactions fréquentes
commits sensibles à la latence
charges d’écriture
```

### 10.3 Limite

Flash Log n’est pas une solution magique à toute lenteur d’écriture.  
Il faut toujours vérifier :

```text
latence redo
log file sync
log file parallel write
activité disque / flash
charge globale
```

---

## 11. Hybrid Columnar Compression — HCC

### 11.1 Définition

HCC signifie **Hybrid Columnar Compression**.

C’est un mécanisme de compression souvent utilisé pour des données analytiques ou historiques.

### 11.2 Apport

HCC peut réduire :

```text
volume de stockage
volume de données lues
coût I/O de certains scans
```

Il est utile surtout pour :

```text
tables historiques
data warehouse
reporting
données peu modifiées
```

### 11.3 Limite

HCC n’est pas adapté à tous les workloads.

Il faut éviter de l’appliquer sans analyse sur :

```text
tables très transactionnelles
données fortement mises à jour
charges OLTP sensibles aux modifications fréquentes
```

---

## 12. IORM — I/O Resource Management

### 12.1 Définition

IORM permet de prioriser les I/O entre plusieurs bases, PDB ou workloads qui partagent les mêmes Storage Cells.

### 12.2 Pourquoi c’est important

En consolidation, plusieurs charges peuvent tourner en même temps :

```text
OLTP critique
reporting
batch
sauvegarde RMAN
PDB de test
PDB de recette
```

Sans IORM, un workload secondaire peut consommer trop d’I/O et ralentir une application critique.

### 12.3 Exemple

```text
Paiement OLTP : priorité haute
Reporting : priorité moyenne
Batch nocturne : priorité contrôlée
Test/dev : priorité basse
Backup : priorité encadrée
```

### 12.4 Différence avec Database Resource Manager

| Sujet | Database Resource Manager | IORM |
|---|---|---|
| Où agit-il ? | Côté Oracle Database | Côté Storage Cells |
| Objet principal | Sessions, consumer groups, CPU, parallélisme | Ressources I/O |
| But | Classifier et contrôler les sessions | Prioriser les I/O entre workloads |
| Usage | Gouvernance database | Gouvernance I/O Exadata |

---

## 13. Métriques et preuves de fonctionnement

Pour prouver qu’une capacité Exadata fonctionne, il faut lire des métriques.

### 13.1 Smart Scan / Offload

```sql
select name, value
from v$sysstat
where name like 'cell%';
```

Métriques utiles :

```text
cell physical IO bytes eligible for predicate offload
cell physical IO interconnect bytes
cell smart IO session cache lookups
cell scans
```

### 13.2 Wait events

```sql
select event, total_waits, time_waited
from v$system_event
where event like 'cell%'
order by time_waited desc;
```

Exemples :

```text
cell smart table scan
cell single block physical read
cell multiblock physical read
```

### 13.3 Plan SQL

```sql
select *
from table(dbms_xplan.display_cursor(null, null, 'ALLSTATS LAST +PREDICATE'));
```

Indicateurs utiles :

```text
TABLE ACCESS STORAGE FULL
storage predicates
predicate information
bytes returned
actual rows
```

### 13.4 CellCLI

```bash
cellcli -e "list cell detail"
cellcli -e "list metriccurrent where name like '.*IO.*'"
cellcli -e "list griddisk attributes name,status,asmmodestatus,asmdeactivationoutcome"
```

---

## 14. Exemple complet de raisonnement

### Situation

Une requête de reporting est plus rapide après migration Exadata, mais seulement pour certaines tables.

### Hypothèses possibles

```text
Smart Scan fonctionne sur les grandes tables
Flash Cache sert certains blocs
Storage Index évite certaines régions
HCC réduit le volume lu
le plan SQL a changé
les statistiques ont été recalculées
```

### Ce qu’il faut vérifier

```text
plan SQL
présence de TABLE ACCESS STORAGE FULL
cell_offload_eligible_bytes
cell physical IO interconnect bytes
wait event cell smart table scan
projection de colonnes
prédicats compatibles
partition pruning
statistiques objets
```

### Conclusion prudente

On ne dit pas :

```text
Exadata est plus rapide parce que Smart Scan marche.
```

On dit :

```text
Les métriques montrent que la requête est éligible à l’offload,
que le volume retourné au Database Server est inférieur au volume lu,
et que le plan utilise un accès compatible Storage Full.
Le gain est donc probablement lié à Smart Scan / Offload,
à confirmer avec les métriques SQL Monitor ou AWR/ASH.
```

---

## 15. Erreurs fréquentes

| Erreur | Pourquoi c’est faux ou dangereux | Correction |
|---|---|---|
| Dire que Smart Scan accélère tout | Toutes les requêtes ne sont pas éligibles | Vérifier plan et métriques |
| Confondre Flash Cache et Smart Scan | L’un accélère les lectures, l’autre réduit le volume retourné | Séparer les mécanismes |
| Croire que Storage Index est un index classique | Il est géré par les Storage Cells | Ne pas le traiter comme un B-tree |
| Ignorer IORM en consolidation | Un batch peut ralentir l’OLTP | Définir une politique I/O |
| Interpréter une seule métrique | Une valeur isolée peut tromper | Croiser plan, AWR, ASH, CellCLI |
| Croire qu’Exadata corrige le mauvais SQL | Un mauvais plan reste un mauvais plan | Revoir SQL, stats, modèle et indexation |

---

## 16. Exercice pratique

Une requête analytique est exécutée sur une grande table de ventes.

Elle sélectionne seulement 3 colonnes sur 80 et filtre sur une région et une période.

Après migration vers Exadata, elle est plus rapide.

Répondez aux questions :

1. Quelle capacité Exadata peut expliquer le gain ?
2. Quel rôle joue Predicate Filtering ?
3. Quel rôle joue Column Projection ?
4. Quel rôle peut jouer Storage Index ?
5. Quelle différence avec Flash Cache ?
6. Quelles métriques faut-il lire ?
7. Quelle conclusion prudente formuler ?

---

## 17. Corrigé indicatif

La capacité principale peut être **Smart Scan** avec **Offload SQL**.

Predicate Filtering peut permettre aux Storage Cells d’éliminer les lignes qui ne correspondent pas à la région et à la période.

Column Projection peut éviter de retourner les 77 colonnes inutiles.

Storage Index peut éviter certaines régions de stockage si les métadonnées montrent qu’elles ne contiennent pas la période demandée.

Flash Cache peut accélérer les lectures si les blocs sont servis depuis la flash, mais ce n’est pas la même chose que Smart Scan.

Les métriques à lire :

```text
plan SQL avec TABLE ACCESS STORAGE FULL
cell physical IO bytes eligible for predicate offload
cell physical IO interconnect bytes
cell smart table scan
physical read bytes
SQL Monitor
AWR / ASH
```

Conclusion prudente :

```text
Le gain peut être attribué à Smart Scan / Offload seulement si le plan SQL,
les prédicats, la projection et les métriques cell confirment une réduction
du volume retourné au Database Server.
```

---

## 18. À retenir

```text
À retenir
- Les capacités Exadata ne sont pas magiques.
- Smart Scan aide certains grands scans éligibles.
- Offload SQL déporte une partie du traitement vers les Storage Cells.
- Predicate Filtering réduit les lignes retournées.
- Column Projection réduit les colonnes retournées.
- Storage Index peut éviter certaines lectures inutiles.
- Flash Cache accélère certaines lectures.
- Flash Log aide certaines écritures redo.
- HCC aide certains usages analytiques et historiques.
- IORM protège les workloads critiques en consolidation.
- Toute conclusion doit être prouvée par le plan SQL et les métriques.
```

---

## 19. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Capacités Exadata, Storage Cells, Smart Scan, IORM, monitoring. |
| [Oracle Database Documentation](https://docs.oracle.com/en/database/) | Plans SQL, AWR, ASH, vues dynamiques, statistiques. |
| [Oracle Exadata System Software Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/sagug/) | CellCLI, métriques cells, offload, storage server. |
| [Oracle Maximum Availability Architecture](https://www.oracle.com/database/technologies/high-availability/maa.html) | Bonnes pratiques de disponibilité et exploitation Oracle. |
