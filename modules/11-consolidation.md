# Module 11 — Consolidation Exadata

## 1. Objectif du module

Ce module explique la **consolidation sur Oracle Exadata**.

L’objectif est de comprendre comment plusieurs bases, PDB, services et workloads peuvent partager une même plateforme Exadata sans créer de conflits incontrôlés entre applications.

À la fin de ce module, le lecteur doit être capable de :

- expliquer ce qu’est la consolidation Exadata ;
- distinguer consolidation par bases, par PDB, par services et par workloads ;
- comprendre les risques de noisy neighbor ;
- définir une matrice workload / SLA / ressources ;
- utiliser les services RAC pour isoler les usages applicatifs ;
- comprendre le rôle de Database Resource Manager ;
- comprendre le rôle d’IORM côté Storage Cells ;
- relier SLA, RPO, RTO et fenêtres de maintenance ;
- surveiller CPU, mémoire, I/O, stockage, services et PDB ;
- formuler une gouvernance de consolidation prudente.

---

## 2. Pourquoi consolider sur Exadata

Exadata est souvent utilisée pour regrouper plusieurs charges Oracle sur une même plateforme.

Objectifs possibles :

```text
réduire le nombre de serveurs
augmenter le taux d’utilisation
standardiser l’exploitation
mutualiser la haute disponibilité
centraliser les sauvegardes
simplifier le monitoring
améliorer les performances analytiques
réduire la complexité datacenter
```

La consolidation peut concerner :

```text
plusieurs bases de données
plusieurs PDB
plusieurs applications
plusieurs services RAC
plusieurs environnements
plusieurs workloads
```

À retenir :

```text
La consolidation n’est pas seulement une économie d’infrastructure.
C’est une gouvernance des ressources partagées.
```

---

## 3. Risques de la consolidation

La consolidation augmente la densité, mais elle augmente aussi les interdépendances.

Risques fréquents :

```text
une application consomme trop d’I/O
un reporting ralentit l’OLTP
un batch déborde sur la journée
une sauvegarde RMAN perturbe une base critique
une PDB de test consomme trop de CPU
un service RAC est mal placé
une fenêtre de maintenance devient trop courte
une saturation RECO impacte plusieurs bases
```

Le risque central est le **noisy neighbor**.

---

## 4. Noisy Neighbor

### 4.1 Définition

Un noisy neighbor est un workload qui consomme trop de ressources partagées et dégrade les autres workloads.

Exemple :

```text
Une requête reporting scanne 20 To.
Elle consomme beaucoup d’I/O sur les Storage Cells.
Dans la même période, l’application OLTP critique voit sa latence augmenter.
```

### 4.2 Ressources concernées

```text
CPU Database Servers
mémoire
I/O Storage Cells
flash
réseau interne
ASM / diskgroups
RECO / FRA
services RAC
sessions
parallélisme
```

### 4.3 Diagnostic

On ne conclut pas à un noisy neighbor sans preuve.

Il faut identifier :

```text
qui consomme
quand
sur quelle base ou PDB
avec quel SQL_ID
via quel service
sur quelle période
avec quels wait events
avec quelles métriques cells
```

---

## 5. Modèles de consolidation

## 5.1 Consolidation par bases

Chaque application conserve sa propre base.

```text
DB_PAY
DB_REPORTING
DB_BATCH
DB_TEST
```

Avantages :

```text
isolation logique forte
sauvegarde par base
Data Guard par base
paramètres spécifiques
```

Limites :

```text
plus d’instances à administrer
plus de services à maintenir
plus de patching logique
```

---

## 5.2 Consolidation par PDB

Plusieurs applications sont hébergées dans des PDB d’une même CDB.

```text
CDB_PROD
 ├── PDB_PAY
 ├── PDB_REPORTING
 ├── PDB_BATCH
 └── PDB_TEST
```

Avantages :

```text
mutualisation plus forte
administration centralisée
moins d’instances
meilleure densité
```

Limites :

```text
gouvernance plus stricte
attention aux ressources partagées
attention aux opérations communes à la CDB
isolation à bien maîtriser
```

---

## 5.3 Consolidation par services

Les services RAC permettent de séparer les usages.

Exemple :

```text
svc_pay_oltp
svc_pay_batch
svc_report_day
svc_report_night
svc_rman
```

Avantages :

```text
routage applicatif clair
mesure par service
placement RAC contrôlé
classification Resource Manager possible
diagnostic plus simple
```

À retenir :

```text
En consolidation, les applications ne doivent pas se connecter n’importe comment.
Elles doivent utiliser des services RAC identifiés.
```

---

## 6. Workloads à identifier

Avant de consolider, il faut qualifier les workloads.

| Workload | Profil | Risque |
|---|---|---|
| OLTP critique | Transactions courtes, latence sensible | Impact métier immédiat |
| Reporting | Scans volumineux, agrégations | Consommation I/O |
| Batch | Traitements planifiés | Débordement hors fenêtre |
| Backup RMAN | Lecture massive | Saturation backup/I/O |
| Chargement massif | Écritures, index, statistiques | Saturation CPU/I/O/RECO |
| Test / dev | Variable, non critique | Perturbation production |
| Maintenance | Rebuild, purge, patch, collecte | Impact temporaire |

---

## 7. SLA, RPO, RTO et fenêtres

La consolidation doit être alignée avec les engagements de service.

| Notion | Sens |
|---|---|
| SLA | Engagement global de service |
| RPO | Perte de données maximale acceptable |
| RTO | Durée maximale de reprise acceptable |
| Fenêtre batch | Période autorisée pour les traitements |
| Fenêtre backup | Période autorisée pour sauvegarder |
| Fenêtre maintenance | Période autorisée pour patching ou opérations techniques |

Une base critique ne doit pas partager les ressources sans règles avec un workload non critique.

Exemple de question :

```text
Le reporting peut-il consommer autant d’I/O que le paiement à 10h du matin ?
```

Réponse attendue :

```text
Non, sauf si le SLA métier le justifie.
```

---

## 8. Matrice workload / SLA / ressources

La matrice est obligatoire pour une consolidation contrôlée.

| Workload | Base/PDB | Service | Criticité | Période | Ressource sensible | Règle |
|---|---|---|---|---|---|---|
| Paiement OLTP | DB_PAY | svc_pay_oltp | Très haute | 24/7 | Latence CPU/I/O | Prioritaire |
| Reporting | DB_REP | svc_report | Moyenne | Journée | I/O scan | Contrôlé |
| Batch nuit | DB_BATCH | svc_batch | Moyenne | Nuit | CPU/I/O | Autorisé hors pic |
| RMAN | Toutes | svc_rman si applicable | Haute mais encadrée | Nuit | Backup network/I/O | Fenêtre dédiée |
| Test | PDB_TEST | svc_test | Basse | Journée | CPU/I/O | Limité |

À retenir :

```text
Sans matrice, la consolidation devient une cohabitation non gouvernée.
```

---

## 9. Database Resource Manager

Database Resource Manager agit côté base de données.

Il permet de contrôler :

```text
CPU
sessions
consumer groups
parallelisme
PDB resources
priorités internes
```

Il peut classifier les sessions selon :

```text
service
utilisateur
module
programme
PDB
règles applicatives
```

Exemple :

```text
svc_pay_oltp     → consumer group OLTP_CRITIQUE
svc_report_day   → consumer group REPORTING_CONTROLE
svc_batch_night  → consumer group BATCH
```

À retenir :

```text
Database Resource Manager agit côté Oracle Database.
Il ne remplace pas IORM côté Storage Cells.
```

---

## 10. IORM

IORM signifie **I/O Resource Management**.

Il agit côté **Storage Cells Exadata**.

Il permet de prioriser les I/O quand plusieurs bases, PDB ou workloads consomment les mêmes ressources de stockage.

Exemple :

```text
OLTP critique → priorité haute
Reporting     → priorité moyenne
Test          → priorité basse
Backup        → contrôlé selon fenêtre
```

Différence essentielle :

| Sujet | Database Resource Manager | IORM |
|---|---|---|
| Où ? | Database Server / Oracle Database | Storage Cells |
| Ressource | CPU, sessions, consumer groups, PDB | I/O disque / flash |
| But | Classifier et contrôler les sessions | Prioriser les I/O |
| Exemple | Limiter reporting dans la base | Protéger OLTP côté cells |

---

## 11. Services RAC en consolidation

Les services RAC sont essentiels.

Ils permettent :

```text
connexion logique par application
placement sur instances préférées
failover contrôlé
load balancing
diagnostic par service
classification Resource Manager
séparation OLTP / batch / reporting
```

Commandes read-only :

```bash
srvctl config service -d <db_unique_name>
srvctl status service -d <db_unique_name>
```

Vue SQL :

```sql
select inst_id, name, network_name
from gv$services
order by inst_id, name;
```

Erreur fréquente :

```text
Laisser toutes les applications utiliser le service par défaut de la base.
```

---

## 12. Capacité CPU, mémoire, I/O et stockage

La consolidation doit être dimensionnée.

### CPU

```text
charge moyenne
pics
batch
parallelisme
Resource Manager
```

### Mémoire

```text
SGA
PGA
PDB memory
processes
sessions
```

### I/O

```text
latence
débit
Smart Scan
Flash Cache
IORM
métriques cells
```

### Stockage

```text
DATA
RECO
FRA
archivelogs
backups
croissance
rebalance
capacité utile
```

À retenir :

```text
La capacité libre brute ne suffit pas.
Il faut lire la capacité utile, les tendances et les pics.
```

---

## 13. Monitoring de la consolidation

À surveiller :

```text
services RAC
sessions par service
CPU par base/PDB
I/O par base/PDB
wait events cell
AWR/ASH
DATA / RECO
FRA
RMAN
Data Guard lag
IORM
alertes cells
rebalance ASM
```

Vues utiles :

```sql
select inst_id, service_name, count(*) as sessions
from gv$session
where type = 'USER'
group by inst_id, service_name
order by sessions desc;
```

```sql
select inst_id, sql_id, event, count(*) as samples
from gv$active_session_history
where sample_time > systimestamp - interval '1' hour
group by inst_id, sql_id, event
order by samples desc;
```

```sql
select name, total_mb, free_mb, usable_file_mb, type, state
from v$asm_diskgroup
order by name;
```

CellCLI :

```bash
cellcli -e "list metriccurrent"
cellcli -e "list alert history"
cellcli -e "list iormplan detail"
```

---

## 14. Gouvernance de consolidation

La consolidation doit être gouvernée.

Documents attendus :

```text
catalogue des bases/PDB
catalogue des services RAC
matrice workload / SLA / priorité
matrice RPO/RTO
plan de capacité
plan de sauvegarde
plan Data Guard
plan IORM
plan Resource Manager
fenêtres batch / backup / maintenance
règles de monitoring
procédures d’escalade
```

Règles simples :

```text
1. Pas de nouvelle application sans qualification workload.
2. Pas de service applicatif non documenté.
3. Pas de reporting lourd sans fenêtre ou priorité définie.
4. Pas de backup hors fenêtre sans validation.
5. Pas de consolidation sans monitoring par service/PDB.
```

---

## 15. Commandes read-only utiles

### 15.1 RAC et services

```bash
crsctl stat res -t
srvctl config database
srvctl status database -d <db_unique_name> -v
srvctl config service -d <db_unique_name>
srvctl status service -d <db_unique_name>
```

### 15.2 Sessions par service

```sql
select inst_id, service_name, count(*) as sessions
from gv$session
where type = 'USER'
group by inst_id, service_name
order by sessions desc;
```

### 15.3 Instances

```sql
select inst_id, instance_name, host_name, status
from gv$instance
order by inst_id;
```

### 15.4 ASH

```sql
select inst_id, sql_id, service_hash, event, count(*) as samples
from gv$active_session_history
where sample_time > systimestamp - interval '1' hour
group by inst_id, sql_id, service_hash, event
order by samples desc;
```

### 15.5 ASM

```bash
asmcmd lsdg
```

```sql
select name, total_mb, free_mb, usable_file_mb, type, state
from v$asm_diskgroup
order by name;
```

### 15.6 IORM / cells

```bash
cellcli -e "list iormplan"
cellcli -e "list iormplan detail"
cellcli -e "list metriccurrent"
cellcli -e "list alert history"
```

---

## 16. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Consolider sans matrice SLA | Les priorités deviennent politiques et non techniques | Créer matrice workload / SLA |
| Utiliser un seul service | Impossible de diagnostiquer par usage | Créer services RAC par workload |
| Ignorer IORM | Noisy neighbor I/O non contrôlé | Définir règles I/O |
| Ignorer Resource Manager | CPU/sessions non gouvernés | Classifier les sessions |
| Oublier RECO/FRA | Archivelogs ou flashback bloqués | Surveiller RECO |
| Mélanger prod et test sans limite | Test peut perturber prod | Priorité basse et quotas |
| Ne pas suivre les tendances | Saturation découverte trop tard | Mettre baseline et capacity planning |

---

## 17. Exercice pratique

Une plateforme Exadata héberge déjà :

```text
DB_PAY      : paiement OLTP critique
DB_REPORT   : reporting décisionnel
DB_BATCH    : batch financier
PDB_TEST    : environnement test
RMAN        : sauvegardes nocturnes
```

Une nouvelle application analytique doit être ajoutée.

Répondez :

1. Quelles informations devez-vous demander avant d’accepter la consolidation ?
2. Quels risques de noisy neighbor voyez-vous ?
3. Quels services RAC proposer ?
4. Quelle matrice workload / SLA établir ?
5. Quel rôle pour Resource Manager ?
6. Quel rôle pour IORM ?
7. Quelles commandes read-only utiliser pour vérifier l’état existant ?

---

## 18. Corrigé indicatif

Avant d’accepter la consolidation, il faut demander :

```text
criticité métier
SLA
RPO/RTO
périodes de charge
volumes de données
type de requêtes
besoin CPU
besoin I/O
fenêtre batch
besoin backup
besoin Data Guard
service applicatif prévu
owner applicatif
```

Risques :

```text
reporting analytique consommant les I/O
batch qui déborde
RMAN qui chevauche une période métier
PDB_TEST non limitée
RECO/FRA saturée
services mal placés
```

Services RAC possibles :

```text
svc_pay_oltp
svc_report_day
svc_batch_night
svc_analytics
svc_test
```

Resource Manager doit classifier et contrôler les sessions côté base.

IORM doit protéger les I/O des workloads critiques côté Storage Cells.

Commandes read-only :

```bash
srvctl status service -d <db_unique_name>
crsctl stat res -t
asmcmd lsdg
cellcli -e "list metriccurrent"
cellcli -e "list iormplan detail"
```

Conclusion prudente :

```text
La nouvelle application ne doit être consolidée qu’après qualification workload,
définition de services RAC, règles Resource Manager/IORM, vérification capacité
et validation des fenêtres backup/batch/maintenance.
```

---

## 19. À retenir

```text
À retenir
- La consolidation Exadata est une gouvernance des ressources partagées.
- Les modèles possibles sont bases, PDB, services et workloads.
- Le risque principal est le noisy neighbor.
- Les services RAC sont indispensables pour isoler les usages.
- Resource Manager agit côté database.
- IORM agit côté Storage Cells.
- La matrice workload / SLA / ressources est obligatoire.
- La capacité doit être suivie en CPU, mémoire, I/O, stockage et RECO.
- Une consolidation non monitorée devient un risque production.
```

---

## 20. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Consolidation Exadata, Storage Cells, IORM, monitoring. |
| [Oracle Database Resource Manager Documentation](https://docs.oracle.com/en/database/) | Consumer groups, plans de ressources, gestion PDB. |
| [Oracle Real Application Clusters Documentation](https://docs.oracle.com/en/database/) | Services RAC, placement, failover, load balancing. |
| [Oracle ASM Documentation](https://docs.oracle.com/en/database/) | DATA, RECO, capacité, redondance, rebalance. |
| [Oracle Database Performance Tuning Guide](https://docs.oracle.com/en/database/) | AWR, ASH, services, wait events, diagnostic workload. |
