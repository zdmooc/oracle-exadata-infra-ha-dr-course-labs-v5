# Module 02 — Architecture Exadata

## 1. Objectif du module

Ce module décrit l’architecture technique d’Oracle Exadata.

L’objectif est de comprendre comment les composants physiques et logiciels coopèrent : **Database Servers**, **Storage Cells**, **ASM**, **Grid Infrastructure**, réseau interne **RoCE / InfiniBand**, réseaux externes, sauvegarde, Data Guard et outils de supervision.

À la fin de ce module, le lecteur doit être capable de :

- décrire l’architecture globale Exadata ;
- distinguer Oracle classique, Oracle RAC sur SAN et Oracle Exadata ;
- expliquer le rôle des Database Servers ;
- expliquer le rôle des Storage Cells ;
- comprendre le rôle d’ASM et de Grid Infrastructure ;
- comprendre les réseaux client, administration, backup et interne ;
- expliquer où se placent Data Guard, Active Data Guard et ZDLRA ;
- suivre un flux SQL classique et un flux SQL Exadata ;
- comprendre la chaîne stockage : physical disk → cell disk → grid disk → ASM disk → diskgroup ;
- lire les premières commandes de diagnostic read-only ;
- éviter les conclusions rapides à partir d’une seule couche.

---

## 2. Vue d’ensemble de l’architecture Exadata

Oracle Exadata est une architecture intégrée pour Oracle Database.

Elle combine :

```text
Applications
→ SCAN / Listeners
→ Database Servers
→ Grid Infrastructure / RAC
→ ASM
→ Réseau interne RoCE ou InfiniBand
→ Storage Cells
→ Flash / Disques
→ Outils de monitoring et support
```

La différence essentielle avec une architecture Oracle classique est que le stockage Exadata n’est pas passif.

Dans Exadata, les **Storage Cells** peuvent participer à certains traitements :

```text
filtrage de lignes
projection de colonnes
réduction des données retournées
optimisation flash
priorisation I/O
métriques et alertes spécifiques
```

L’architecture Exadata doit donc se lire comme une chaîne complète :

```text
SQL → instance Oracle → ASM → réseau interne → Storage Cell → flash/disques → retour réduit ou blocs
```

---

## 3. Oracle classique vs Oracle Exadata

| Sujet | Oracle classique / RAC sur SAN | Oracle Exadata |
|---|---|---|
| Serveurs | Serveurs Oracle physiques ou virtuels | Database Servers Exadata optimisés pour Oracle |
| Stockage | SAN/NAS externe, souvent passif | Storage Cells intelligentes |
| Traitement SQL | Principalement côté Database Server | Certaines opérations peuvent être déportées vers les Storage Cells |
| Smart Scan | Non disponible | Disponible si les conditions sont réunies |
| Offload SQL | Non disponible | Filtrage/projection possibles côté Storage Cells |
| ASM | Possible selon design | Central dans le modèle de stockage Exadata |
| Réseau interne | Ethernet, Fibre Channel, SAN selon design | RoCE ou InfiniBand pour RAC, ASM et iDB |
| Flash | Dépend de la baie ou du serveur | Flash Cache et Flash Log intégrés aux Storage Cells |
| IORM | Non disponible au niveau stockage Exadata | Priorisation I/O entre bases, PDB ou workloads |
| Monitoring | Outils souvent séparés base / stockage / réseau | CellCLI, Enterprise Manager, AHF, Exachk, TFA |
| Support | Plusieurs composants et parfois plusieurs fournisseurs | Plateforme Oracle engineered supportée comme ensemble |

À retenir :

```text
Oracle classique : le stockage renvoie surtout des blocs.
Exadata : les Storage Cells peuvent traiter une partie du travail.
```

---

## 4. Composants physiques d’une architecture Exadata

### 4.1 Applications et postes clients

Les applications se connectent à Oracle via les services, SCAN listeners ou listeners locaux.

Elles ne font pas partie du rack Exadata, mais elles déclenchent les charges SQL.

### 4.2 Database Servers

Les Database Servers sont les serveurs où s’exécutent Oracle Database.

Ils hébergent :

```text
Oracle Database
instances RAC ou single instance
services applicatifs
listeners
processus Oracle
Grid Infrastructure
ASM instance
agents Enterprise Manager
outils RMAN / AWR / ASH
```

Ils exécutent le SQL, gèrent la mémoire Oracle, les transactions, les sessions, les plans SQL et la cohérence des données.

### 4.3 Storage Cells

Les Storage Cells sont les serveurs de stockage intelligents Exadata.

Elles hébergent :

```text
Exadata System Software
CellCLI
disques physiques
flash devices
cell disks
grid disks
Smart Scan
Offload SQL
Storage Index
Flash Cache
Flash Log
IORM
métriques et alertes
```

Elles stockent les données, mais peuvent aussi participer à certains traitements.

### 4.4 Réseau interne RoCE ou InfiniBand

Le réseau interne relie les Database Servers et les Storage Cells.

Il transporte :

```text
trafic RAC
trafic ASM
trafic iDB
échanges entre Database Servers et Storage Cells
```

Il est critique pour la performance et la disponibilité.

### 4.5 Réseaux externes

Une architecture Exadata distingue généralement plusieurs réseaux :

| Réseau | Rôle |
|---|---|
| Réseau client | Connexions applicatives vers SCAN / listeners |
| Réseau administration | Accès d’exploitation, supervision, gestion |
| Réseau backup | Flux RMAN, sauvegarde, restauration |
| Réseau interne | RAC, ASM, iDB entre DB servers et Storage Cells |

### 4.6 Flash et disques

Les Storage Cells contiennent de la flash et des disques.

La flash est utilisée notamment pour :

```text
Flash Cache
Flash Log
accélération de lectures fréquentes
accélération de certaines écritures redo
```

Les disques fournissent la capacité persistante principale.

---

## 5. Composants logiciels dans les composants physiques

### 5.1 Dans les Database Servers

| Logiciel / service | Rôle |
|---|---|
| Oracle Database | Exécute SQL, transactions, mémoire, processus Oracle |
| RAC | Plusieurs instances accèdent à une même base |
| Grid Infrastructure | Cluster, ressources, services, VIP, SCAN, ASM |
| ASM instance | Gère les diskgroups Oracle |
| Listener / SCAN | Entrée des connexions applicatives |
| AWR / ASH | Diagnostic performance |
| RMAN | Sauvegarde et restauration |
| Enterprise Manager Agent | Supervision et remontée de métriques |

### 5.2 Dans les Storage Cells

| Logiciel / service | Rôle |
|---|---|
| Exadata System Software | Logiciel principal des Storage Cells |
| CellCLI | Interface d’administration et de diagnostic des cells |
| Smart Scan | Traitement partiel de certains scans dans les cells |
| Offload SQL | Déport d’une partie du traitement SQL vers les cells |
| Storage Index | Évite certaines lectures inutiles |
| Flash Cache | Accélère certaines lectures |
| Flash Log | Accélère certaines écritures redo |
| IORM | Priorise les I/O entre workloads |
| Cell metrics / alerts | Métriques et alertes propres aux cells |

---

## 6. Rôle des Database Servers

Les Database Servers sont la couche de calcul Oracle.

Ils sont responsables de :

```text
recevoir les connexions SQL
optimiser les requêtes
exécuter les plans SQL
gérer transactions et cohérence
héberger les instances RAC
gérer les services applicatifs
dialoguer avec ASM
envoyer les demandes I/O vers les Storage Cells
finaliser les résultats SQL
```

Même avec Exadata, Oracle Database reste le moteur principal.

Les Storage Cells aident, mais elles ne remplacent pas le Database Server.

---

## 7. Rôle des Storage Cells

Les Storage Cells sont la couche stockage intelligente.

Elles sont responsables de :

```text
stocker les données
présenter des grid disks à ASM
servir les I/O demandées par les Database Servers
utiliser flash et disques
exécuter Smart Scan si possible
appliquer certains filtres SQL si possible
réduire le volume de données retourné
prioriser les I/O avec IORM
fournir des métriques et alertes
```

Une Storage Cell n’est donc pas une simple baie de disques.

Elle contient des CPU, de la mémoire, un logiciel Exadata et des fonctions d’optimisation.

---

## 8. Rôle d’ASM et de Grid Infrastructure

### 8.1 ASM

ASM organise les disques Exadata en diskgroups Oracle.

La chaîne de stockage est :

```text
Physical Disk / Flash
→ Cell Disk
→ Grid Disk
→ ASM Disk
→ ASM Diskgroup
→ Datafiles / Redo / Controlfiles / FRA
```

ASM gère :

```text
DATA
RECO
DBFS si utilisé
redondance
failure groups
répartition des extents
rebalance
capacité utilisable
```

### 8.2 Grid Infrastructure

Grid Infrastructure gère la couche cluster.

Elle fournit :

```text
Oracle Clusterware
ressources RAC
services applicatifs
VIP / SCAN
ASM
placement des services
haute disponibilité locale
```

Sur Exadata, GI est essentiel parce que la plateforme est souvent utilisée avec RAC.

---

## 9. Réseaux dans une architecture Exadata

| Réseau | Description | Risque si problème |
|---|---|---|
| Client | Flux applicatifs vers Oracle | Connexion impossible, latence applicative |
| Administration | Accès exploitation, supervision, maintenance | Difficulté d’administration |
| Backup | Flux RMAN / sauvegarde / restauration | Sauvegarde lente ou fenêtre dépassée |
| Interne RoCE / InfiniBand | RAC, ASM, iDB entre DB servers et cells | Latence I/O, symptômes RAC, ralentissements SQL |

Le réseau interne est particulièrement important.

Un problème sur ce réseau peut être vu comme :

```text
SQL lent
attentes cell
latence ASM
problème RAC
problème d’accès aux Storage Cells
```

---

## 10. Où se placent Data Guard, Active Data Guard et ZDLRA ?

### 10.1 Data Guard

Data Guard n’est pas une Storage Cell et ne fait pas partie de la chaîne de stockage interne Exadata.

C’est une solution de réplication Oracle vers une base standby.

```text
Base primaire Exadata
→ redo transport
→ base standby sur site distant
```

Rôle :

```text
reprise après sinistre
protection des données
réduction du RPO
bascule contrôlée ou automatique selon configuration
```

### 10.2 Active Data Guard

Active Data Guard est une extension de Data Guard.

Elle permet d’ouvrir la base standby en lecture pendant que la réplication continue.

Usage :

```text
reporting sur standby
lecture distante
déchargement de certains workloads
tests de lecture
```

### 10.3 ZDLRA

ZDLRA signifie **Zero Data Loss Recovery Appliance**.

Ce n’est pas une Storage Cell Exadata.

C’est une appliance Oracle dédiée à la sauvegarde et au recovery.

Elle reçoit des sauvegardes RMAN et des redo/archivelogs selon l’architecture.

```text
Base Exadata
→ RMAN / redo
→ ZDLRA
→ restauration / recovery
```

Rôle :

```text
sauvegarde centralisée
recovery
réduction de perte de données
validation des sauvegardes
historique de restauration
```

### 10.4 Résumé de placement

| Élément | Où il se place | Rôle |
|---|---|---|
| Data Guard | Entre base primaire et base standby | Réplication et reprise après sinistre |
| Active Data Guard | Sur la base standby ouverte en lecture | Reporting / lecture sur standby |
| ZDLRA | Cible de sauvegarde/recovery externe | Sauvegarde RMAN et restauration |
| Storage Cell | Dans le rack Exadata | Stockage intelligent et offload |

---

## 11. Flux SQL classique

Dans une architecture classique :

```text
Application
→ Oracle Database Server
→ Stockage SAN/NAS
→ Oracle Database Server
→ Application
```

Déroulement :

```text
1. L’application envoie une requête SQL.
2. Le serveur Oracle optimise la requête.
3. Oracle demande les blocs au stockage SAN/NAS.
4. Le stockage renvoie les blocs.
5. Oracle filtre les lignes, choisit les colonnes et exécute le plan.
6. Oracle renvoie le résultat à l’application.
```

Limite :

```text
Le stockage renvoie souvent beaucoup de blocs.
Le serveur Oracle fait ensuite le tri.
```

---

## 12. Flux SQL Exadata

Dans Exadata :

```text
Application
→ Database Server
→ ASM
→ Storage Cell
→ Flash / Disques
→ Storage Cell
→ Database Server
→ Application
```

Déroulement :

```text
1. L’application envoie une requête SQL.
2. Le Database Server optimise le plan SQL.
3. ASM localise les extents et diskgroups.
4. Le Database Server envoie une demande iDB aux Storage Cells.
5. Les Storage Cells lisent flash ou disques.
6. Si possible, elles filtrent certaines lignes et projettent certaines colonnes.
7. Elles renvoient moins de données au Database Server.
8. Le Database Server finalise le traitement SQL.
9. Le résultat revient à l’application.
```

Plus Exadata :

```text
Smart Scan
Offload SQL
Storage Index
Flash Cache
IORM
métriques CellCLI
```

---

## 13. Chaîne de stockage Exadata

La chaîne stockage est fondamentale :

```text
Physical Disk / Flash
→ Cell Disk
→ Grid Disk
→ ASM Disk
→ ASM Diskgroup
→ Fichiers Oracle
```

| Niveau | Description |
|---|---|
| Physical Disk / Flash | Support réel dans la Storage Cell |
| Cell Disk | Objet créé dans la cell à partir du support physique |
| Grid Disk | Portion de cell disk présentée au cluster |
| ASM Disk | Disque vu par ASM |
| ASM Diskgroup | Groupe logique ASM comme DATA ou RECO |
| Fichiers Oracle | Datafiles, redo logs, controlfiles, FRA selon design |

Cette chaîne relie la couche physique à Oracle Database.

---

## 14. Commandes read-only utiles

### 14.1 Cluster et RAC

```bash
crsctl stat res -t
olsnodes -n
srvctl config database
srvctl status database -d <db_unique_name> -v
```

### 14.2 ASM

```bash
asmcmd lsdg
asmcmd lsdsk -p
```

```sql
select name, total_mb, free_mb, type, state
from v$asm_diskgroup
order by name;
```

### 14.3 Instances Oracle

```sql
select inst_id, instance_name, host_name, status
from gv$instance
order by inst_id;

select name, value
from v$parameter
where name in ('db_name','db_unique_name','cluster_database');
```

### 14.4 Storage Cells

```bash
cellcli -e "list cell detail"
cellcli -e "list physicaldisk"
cellcli -e "list celldisk"
cellcli -e "list griddisk"
cellcli -e "list griddisk attributes name,status,asmmodestatus,asmdeactivationoutcome"
cellcli -e "list alert history"
```

### 14.5 Data Guard

```sql
select database_role, open_mode, protection_mode, switchover_status
from v$database;

select name, value, unit
from v$dataguard_stats;
```

### 14.6 RMAN / ZDLRA

```bash
rman target /
```

```rman
list backup summary;
report obsolete;
restore database validate;
```

Ces commandes sont des exemples read-only ou de validation. Elles doivent être adaptées aux procédures internes.

---

## 15. Interprétation d’un incident

Une requête lente sur Exadata peut venir de plusieurs couches :

```text
plan SQL
statistiques obsolètes
absence de Smart Scan
Storage Cell saturée
Flash Cache inefficace
réseau interne lent
ASM rebalance
service RAC mal placé
batch concurrent
sauvegarde RMAN en cours
```

Méthode :

```text
1. Identifier le symptôme.
2. Localiser la couche possible.
3. Lire les métriques.
4. Croiser database, ASM, cells et réseau.
5. Distinguer observation et décision.
6. Proposer une action seulement avec preuve.
```

---

## 16. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Confondre Storage Cell et baie SAN | On rate l’intelligence Exadata | Lire CellCLI et comprendre offload/flash/IORM |
| Penser que RAC suffit pour le DR | RAC protège localement, pas forcément le site | Ajouter Data Guard selon besoin RPO/RTO |
| Confondre Data Guard et ZDLRA | L’un réplique, l’autre sauvegarde/recover | Séparer DR et backup/recovery |
| Lire uniquement côté base | La cause peut venir des cells ou du réseau interne | Croiser DB, ASM, CellCLI, AWR/ASH |
| Croire que Smart Scan marche toujours | Certaines requêtes ne sont pas éligibles | Vérifier plan SQL et métriques cell |
| Modifier sans preuve | Risque d’aggraver l’incident | Diagnostic read-only puis runbook |

---

## 17. Exercice pratique

Vous analysez une plateforme Exadata de production.

Une application signale des lenteurs intermittentes sur certaines requêtes.

Rédigez une analyse en répondant aux questions suivantes :

1. Quels composants physiques faut-il vérifier ?
2. Quels composants logiciels sont impliqués ?
3. Quel est le chemin SQL possible ?
4. Comment distinguer un problème SQL, ASM, Storage Cell ou réseau ?
5. Où Data Guard intervient-il ?
6. Où ZDLRA intervient-il ?
7. Quelles commandes read-only utiliser ?
8. Quelle conclusion prudente formuler ?

---

## 18. Corrigé indicatif

Une bonne réponse doit identifier les couches suivantes :

```text
Application
SCAN / listener
Database Server
RAC / Grid Infrastructure
ASM
réseau interne RoCE ou InfiniBand
Storage Cells
Flash / disques
monitoring
backup / Data Guard si concernés
```

Elle doit expliquer que le flux SQL peut être classique ou bénéficier d’Exadata :

```text
SQL classique : blocs renvoyés puis filtrés côté Database Server.
SQL Exadata : demande iDB vers Storage Cells, filtrage/projection possible côté cell.
```

Elle doit séparer Data Guard et ZDLRA :

```text
Data Guard = réplication vers une standby pour DR.
Active Data Guard = standby ouverte en lecture.
ZDLRA = appliance de sauvegarde/recovery RMAN.
```

Elle doit proposer des commandes read-only :

```bash
crsctl stat res -t
olsnodes -n
asmcmd lsdg
cellcli -e "list cell detail"
cellcli -e "list alert history"
```

La conclusion doit rester prudente :

```text
À ce stade, on ne modifie pas la plateforme.
On collecte les preuves, on compare à une période saine,
on identifie la couche dominante,
puis on propose une action avec runbook.
```

---

## 19. À retenir

```text
À retenir
- Exadata est une architecture intégrée : Database Servers + Storage Cells + ASM + GI + réseau interne.
- Les Database Servers exécutent Oracle Database, RAC, services et SQL.
- Les Storage Cells stockent les données et peuvent exécuter Smart Scan / Offload.
- ASM relie les grid disks aux fichiers Oracle.
- Le réseau interne transporte RAC, ASM et iDB.
- Data Guard protège par réplication vers une standby.
- Active Data Guard permet la lecture sur standby.
- ZDLRA sert au backup et au recovery RMAN.
- Un incident Exadata doit toujours être replacé dans la chaîne complète.
```

---

## 20. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle University — Exadata Database Machine Administration Workshop](https://education.oracle.com/exadata-database-machine-administration-workshop/courP_4599) | Cadre pédagogique général du workshop. |
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Architecture, Storage Server, CellCLI, maintenance et monitoring. |
| [Oracle Database Documentation](https://docs.oracle.com/en/database/) | Vues dynamiques, SQL, RAC, ASM, RMAN, Data Guard, AWR/ASH. |
| [Oracle Maximum Availability Architecture](https://www.oracle.com/database/technologies/high-availability/maa.html) | RAC, Data Guard, Active Data Guard, MAA et continuité de service. |
| [Oracle Zero Data Loss Recovery Appliance Documentation](https://docs.oracle.com/en/engineered-systems/zero-data-loss-recovery-appliance/) | ZDLRA, sauvegarde, recovery et protection des données. |
