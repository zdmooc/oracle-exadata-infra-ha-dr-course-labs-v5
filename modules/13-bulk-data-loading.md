# Module 13 — Bulk Data Loading

## 1. Objectif du module

Ce module explique le **chargement massif de données** sur Oracle Exadata.

L’objectif est de comprendre comment charger de gros volumes de données en maîtrisant le débit, l’espace staging, les index, les contraintes, le redo, les statistiques, la reprise sur erreur et l’impact sur les autres workloads.

À la fin de ce module, le lecteur doit être capable de :

- expliquer les principales méthodes de chargement massif ;
- distinguer SQL*Loader, External Tables, Data Pump, direct path et insert select ;
- comprendre l’impact des index, contraintes et triggers ;
- anticiper redo, undo, archivelogs, FRA et RECO ;
- surveiller ASM, DATA, RECO et Storage Cells pendant un chargement ;
- identifier les fichiers rejetés et les lignes invalides ;
- préparer un plan de reprise ;
- vérifier les statistiques après chargement ;
- éviter de confondre vitesse de chargement et succès métier.

---

## 2. Pourquoi le chargement massif est critique

Un chargement massif peut consommer beaucoup de ressources :

```text
CPU
I/O
réseau
espace DATA
espace RECO
FRA
redo
undo
temp
parallélisme
storage cells
```

Il peut aussi perturber :

```text
OLTP
reporting
batchs
sauvegardes
Data Guard
IORM
monitoring
```

À retenir :

```text
Un chargement réussi n’est pas seulement un chargement rapide.
C’est un chargement contrôlé, vérifié et réversible.
```

---

## 3. Scénarios typiques

Exemples :

```text
chargement quotidien de fichiers partenaires
migration initiale de données
reprise historique
alimentation data warehouse
chargement de tables de référence
chargement de plusieurs To avant ouverture applicative
rechargement après purge ou correction
```

Contraintes possibles :

```text
fenêtre de chargement limitée
contrôle des rejets
traçabilité
rollback
validation métier
statistiques à jour
Data Guard à maintenir
impact minimal sur production
```

---

## 4. Méthodes principales

| Méthode | Usage | Points forts | Limites |
|---|---|---|---|
| SQL*Loader conventional path | Chargement classique | Simple, contrôlé | Moins rapide |
| SQL*Loader direct path | Gros volumes | Rapide | Contraintes / index à gérer |
| External Tables | Lire fichiers comme tables | Souple, SQL natif | Dépend fichiers/directories |
| Data Pump import | Migration logique | Complet, metadata | Peut être lourd |
| INSERT /*+ APPEND */ SELECT | Chargement direct path SQL | Simple côté SQL | À contrôler redo/index/stats |
| CTAS | Création table depuis requête | Rapide pour staging | Requiert espace |
| Partition Exchange Load | Chargement par partition | Faible impact applicatif | Modèle partitionné requis |

---

## 5. External Tables

### 5.1 Principe

Une External Table permet à Oracle de lire un fichier externe comme une table relationnelle.

Exemple logique :

```text
fichier CSV
→ DIRECTORY Oracle
→ External Table
→ SELECT / INSERT vers table cible
```

### 5.2 Usage

```text
fichier partenaire
staging de données
contrôle avant insertion
rejets lisibles
traitement SQL sur fichier
```

### 5.3 Avantages

```text
pas besoin de charger immédiatement dans une table finale
contrôle SQL possible avant insertion
séparation staging / cible
gestion des bad files
```

### 5.4 Points de vigilance

```text
droits DIRECTORY
format fichier
encodage
séparateurs
lignes invalides
bad file
log file
performance du filesystem source
```

---

## 6. SQL*Loader

SQL*Loader charge des fichiers dans des tables Oracle.

Deux modes principaux :

```text
conventional path
direct path
```

### 6.1 Conventional Path

```text
passe par le moteur SQL classique
respecte plus naturellement les mécanismes standards
moins rapide sur très gros volumes
```

### 6.2 Direct Path

```text
écrit plus directement dans les segments
réduit certains chemins SQL
peut être beaucoup plus rapide
nécessite de maîtriser index, contraintes et redo
```

### 6.3 Fichiers importants

```text
control file
data file
log file
bad file
discard file
```

À retenir :

```text
Le bad file n’est pas un détail.
Il fait partie de la preuve de qualité du chargement.
```

---

## 7. Data Pump Import

Data Pump est utile pour charger des données déjà exportées depuis Oracle.

Usage :

```text
migration logique
chargement schéma complet
chargement tables
chargement metadata
transport entre environnements
```

Avantages :

```text
parallélisme
metadata
remap schema
remap tablespace
filtrage
logs détaillés
```

Points de vigilance :

```text
taille dump
emplacement DIRECTORY
parallélisme
index
contraintes
objets invalides
statistiques
tablespaces cible
```

---

## 8. Direct Path et APPEND

`INSERT /*+ APPEND */` peut utiliser un chargement direct path.

Exemple :

```sql
insert /*+ append */ into sales_target
select *
from sales_staging;
```

Intérêt :

```text
chargement rapide
utile pour tables de staging ou partitions
peut limiter certains chemins classiques
```

Points de vigilance :

```text
verrouillage segment/table selon cas
redo/undo selon configuration
index à maintenir
statistiques à recalculer
commit à gérer
espace disponible
```

---

## 9. Partition Exchange Load

Partition Exchange Load consiste à charger les données dans une table de staging, puis à échanger cette table avec une partition.

Schéma :

```text
1. Charger table STG_SALES_202601
2. Contrôler les données
3. Créer / vérifier index
4. Échanger avec partition SALES_202601
5. Valider statistiques
```

Avantages :

```text
faible interruption applicative
contrôle avant publication
adapté aux gros volumes périodiques
bon modèle data warehouse
```

Limites :

```text
nécessite table partitionnée
structures compatibles
contraintes à respecter
processus plus complexe
```

---

## 10. Index, contraintes et triggers

Les index, contraintes et triggers peuvent fortement impacter le chargement.

### 10.1 Index

Pendant un chargement massif :

```text
maintenir les index peut ralentir le chargement
reconstruire après peut être plus efficace selon cas
les index locaux/globaux changent la stratégie
```

### 10.2 Contraintes

Contraintes à contrôler :

```text
primary key
unique
foreign key
check
not null
```

Stratégies possibles :

```text
valider avant chargement
charger en staging
activer/valider après contrôle
utiliser exceptions table selon procédure
```

### 10.3 Triggers

Les triggers peuvent :

```text
ralentir fortement
générer des effets de bord
modifier les données
ajouter du redo
```

À retenir :

```text
On ne désactive jamais index, contraintes ou triggers sans procédure validée.
```

---

## 11. Redo, Undo, Archivelogs, FRA et RECO

Un chargement massif peut produire beaucoup de redo.

Impacts :

```text
archivelogs volumineux
FRA saturée
RECO rempli
Data Guard lag
backup plus long
réplication impactée
```

À surveiller :

```sql
select * from v$recovery_file_dest;
```

```sql
select name, total_mb, free_mb, usable_file_mb, type, state
from v$asm_diskgroup
order by name;
```

Si Data Guard existe :

```sql
select name, value, unit
from v$dataguard_stats;
```

À retenir :

```text
Un chargement massif ne doit pas être validé seulement par le nombre de lignes chargées.
Il faut vérifier DATA, RECO, archivelogs et Data Guard.
```

---

## 12. Staging

Le staging est une zone intermédiaire.

Rôle :

```text
recevoir les fichiers
contrôler le format
filtrer les erreurs
dédupliquer
valider les règles métier
préparer l’insertion cible
```

Architecture logique :

```mermaid
flowchart LR
    A[Fichier source] --> B[Staging filesystem / object storage]
    B --> C[External Table ou SQL*Loader]
    C --> D[Table staging]
    D --> E[Contrôles techniques]
    E --> F[Contrôles métier]
    F --> G[Table cible]
    G --> H[Statistiques / validation]
```

---

## 13. Qualité des données et rejets

Un chargement massif doit traiter les anomalies.

À prévoir :

```text
bad file
discard file
reject table
logs SQL*Loader
logs Data Pump
contrôle nombre lignes attendues / chargées
contrôle doublons
contrôle formats
contrôle clés
contrôle dates
contrôle montants
```

Exemple de contrôle :

```sql
select count(*) from table_staging;
select count(*) from table_cible;
select count(*) from table_rejets;
```

---

## 14. Statistiques après chargement

Après chargement massif, les statistiques peuvent être obsolètes.

À vérifier :

```text
statistiques table
statistiques index
histogrammes si nécessaires
partition statistics
global statistics
stale stats
```

Vue utile :

```sql
select owner, table_name, stale_stats, last_analyzed
from dba_tab_statistics
where owner = '<OWNER>'
order by last_analyzed desc;
```

Opération possible selon procédure :

```sql
exec dbms_stats.gather_table_stats('<OWNER>', '<TABLE_NAME>');
```

Attention :

```text
Dans ce module, les commandes de modification sont données comme exemples conceptuels.
En production, elles exigent procédure, fenêtre et validation.
```

---

## 15. Exadata : ce qui change

Exadata peut aider par :

```text
débit élevé
Smart Scan pour contrôles et lectures
Flash Cache selon profil
I/O parallèle
Storage Cells
réseau interne rapide
ASM
IORM si concurrence
```

Mais Exadata ne corrige pas :

```text
fichier mal formé
clés en doublon
tablespace insuffisant
FRA saturée
index mal conçus
contraintes incohérentes
statistiques absentes
plan de reprise inexistant
```

---

## 16. Monitoring pendant chargement

À surveiller :

```text
nombre de lignes chargées
débit
rejets
erreurs
temps par étape
DATA
RECO
FRA
TEMP
UNDO
archivelogs
Data Guard lag
wait events
cell metrics
IORM
```

Commandes read-only :

```sql
select * from v$recovery_file_dest;
```

```sql
select name, total_mb, free_mb, usable_file_mb, type, state
from v$asm_diskgroup
order by name;
```

```sql
select event, total_waits, time_waited
from v$system_event
where event like 'cell%'
order by time_waited desc;
```

```bash
cellcli -e "list metriccurrent"
cellcli -e "list alert history"
```

---

## 17. Plan de reprise

Un chargement massif doit avoir un plan de reprise.

Questions :

```text
Peut-on relancer le chargement ?
Le chargement est-il idempotent ?
Faut-il purger la table cible ?
Les rejets sont-ils isolés ?
Peut-on reprendre au fichier suivant ?
Le batch sait-il éviter les doublons ?
Le rollback est-il possible ?
La source est-elle conservée ?
```

Stratégies :

```text
staging persistant
table de contrôle
batch_id
fichier de suivi
commit par lot
partition exchange
sauvegarde avant chargement
```

---

## 18. Méthode de chargement contrôlé

Méthode recommandée :

```text
1. Définir le périmètre.
2. Vérifier espace DATA / RECO / FRA.
3. Vérifier fenêtre de chargement.
4. Charger en staging.
5. Contrôler nombre de lignes.
6. Isoler les rejets.
7. Charger la cible.
8. Contrôler index/contraintes.
9. Collecter statistiques.
10. Vérifier Data Guard / backup si concernés.
11. Valider métier.
12. Documenter résultat.
```

---

## 19. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Charger directement en cible | Risque qualité et rollback | Utiliser staging |
| Ignorer bad file | Données perdues ou non expliquées | Contrôler rejets |
| Oublier RECO/FRA | Saturation archivelogs | Vérifier capacité |
| Oublier Data Guard | Lag ou rupture de synchro | Surveiller apply/transport lag |
| Garder tous les index sans réflexion | Chargement ralenti | Analyser stratégie index |
| Désactiver contraintes sans procédure | Données incohérentes | Runbook validé |
| Oublier stats | Plans SQL dégradés | Collecte stats post-load |
| Ne pas prévoir reprise | Relance impossible | Plan idempotent |

---

## 20. Commandes read-only utiles

### External Tables

```sql
select owner, table_name, type_name, default_directory_name
from dba_external_tables
order by owner, table_name;
```

### Index

```sql
select owner, index_name, table_name, status, degree
from dba_indexes
where table_name = '<TABLE_NAME>'
order by owner, index_name;
```

### Statistiques

```sql
select owner, table_name, stale_stats, last_analyzed
from dba_tab_statistics
where table_name = '<TABLE_NAME>'
order by owner, table_name;
```

### ASM / capacité

```bash
asmcmd lsdg
```

```sql
select name, total_mb, free_mb, usable_file_mb, type, state
from v$asm_diskgroup
order by name;
```

### FRA

```sql
select * from v$recovery_file_dest;
```

### Cell metrics

```bash
cellcli -e "list metriccurrent"
cellcli -e "list alert history"
```

---

## 21. Exercice pratique

Un fichier de **800 Go** doit être chargé avant 6h.

Contraintes :

```text
contrôle des rejets obligatoire
reprise possible en cas d’erreur
pas d’impact OLTP en journée
Data Guard actif
statistiques obligatoires avant ouverture métier
```

Répondez :

1. Quelle architecture de chargement proposez-vous ?
2. Pourquoi utiliser une zone de staging ?
3. Quels risques sur RECO/FRA et Data Guard ?
4. Que vérifier côté index et contraintes ?
5. Quelles commandes read-only utiliser ?
6. Quelle conclusion prudente formuler ?

---

## 22. Corrigé indicatif

Architecture proposée :

```text
fichier source
→ staging
→ external table ou SQL*Loader
→ table staging
→ contrôles techniques
→ contrôles métier
→ table cible ou partition exchange
→ statistiques
→ validation
```

Staging utile pour :

```text
contrôle qualité
reprise
isolation des rejets
éviter corruption logique de la cible
traçabilité
```

Risques :

```text
redo massif
archivelogs volumineux
FRA saturée
RECO rempli
Data Guard lag
impact backup
```

Index et contraintes :

```text
vérifier index existants
contrôler contraintes
éviter désactivation sans procédure
valider après chargement
```

Commandes read-only :

```sql
select * from v$recovery_file_dest;
select name, total_mb, free_mb, usable_file_mb from v$asm_diskgroup;
select owner, index_name, status from dba_indexes where table_name = '<TABLE_NAME>';
select owner, table_name, stale_stats, last_analyzed from dba_tab_statistics where table_name = '<TABLE_NAME>';
```

Conclusion prudente :

```text
Le chargement peut être lancé seulement si l’espace DATA/RECO/FRA,
la stratégie de reprise, le contrôle des rejets, la surveillance Data Guard
et les statistiques post-load sont prêts et validés.
```

---

## 23. À retenir

```text
À retenir
- Le chargement massif doit être contrôlé, pas seulement rapide.
- Le staging protège la qualité et la reprise.
- SQL*Loader, External Tables, Data Pump et direct path répondent à des besoins différents.
- Les index, contraintes et triggers peuvent dominer le temps de chargement.
- RECO, FRA, redo et Data Guard doivent être surveillés.
- Les statistiques post-load sont indispensables.
- Exadata apporte du débit, mais ne corrige pas une mauvaise méthode.
- Un chargement sans plan de reprise est un risque production.
```

---

## 24. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle Database Utilities Documentation](https://docs.oracle.com/en/database/) | SQL*Loader, Data Pump, External Tables. |
| [Oracle Database Administrator’s Guide](https://docs.oracle.com/en/database/) | Direct path, contraintes, tablespaces, chargement. |
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Storage Cells, métriques, performance Exadata. |
| [Oracle ASM Documentation](https://docs.oracle.com/en/database/) | DATA, RECO, capacité, diskgroups. |
| [Oracle Data Guard Documentation](https://docs.oracle.com/en/database/) | Lag, redo transport, impact des chargements. |
