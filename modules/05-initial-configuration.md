# Module 05 — Initial Configuration Exadata

## 1. Objectif du module

Ce module explique la configuration initiale d’une plateforme Oracle Exadata.

L’objectif est de comprendre comment les informations préparées dans le site planning deviennent une configuration exploitable : noms, adresses IP, réseaux, DNS, NTP, diskgroups ASM, Oracle homes, cluster, services, bases initiales, supervision et sauvegarde.

À la fin de ce module, le lecteur doit être capable de :

- expliquer le rôle de la configuration initiale ;
- comprendre le rôle d’OEDA ;
- comprendre le rôle d’OECA ;
- lire une configuration worksheet ;
- relier les choix réseau à RAC, SCAN, listeners et services ;
- relier les choix stockage à ASM, DATA, RECO et failure groups ;
- comprendre ce qui doit être validé avant déploiement ;
- distinguer configuration initiale, installation et exploitation ;
- préparer une check-list de validation read-only.

---

## 2. Pourquoi la configuration initiale est critique

La configuration initiale est une phase d’ingénierie.

Elle transforme le design validé en paramètres concrets :

```text
noms machines
adresses IP
réseaux
SCAN
VIP
DNS
NTP
cluster
ASM
diskgroups
Oracle homes
bases initiales
services
backup
monitoring
```

Une erreur dans cette phase peut avoir des conséquences longues :

```text
SCAN mal configuré
problème de listener
mauvais VLAN
mauvais routage backup
mauvaise redondance ASM
diskgroups mal dimensionnés
base créée avec mauvais nom
services mal placés
supervision incomplète
difficulté future pour Data Guard ou ZDLRA
```

À retenir :

```text
Une configuration initiale Exadata ne se corrige pas à la légère.
Elle doit être relue, validée et documentée avant exécution.
```

---

## 3. Vue d’ensemble du processus

La configuration initiale suit généralement cette logique :

```text
Site planning validé
→ Configuration worksheet
→ OEDA / OECA
→ Génération de la configuration cible
→ Validation des prérequis
→ Déploiement initial
→ Vérifications post-installation
→ Documentation d’exploitation
```

Schéma logique :

```mermaid
flowchart LR
    A[Site planning] --> B[Configuration worksheet]
    B --> C[OEDA]
    C --> D[Configuration cible]
    D --> E[Validation OECA / prérequis]
    E --> F[Déploiement initial]
    F --> G[GI / ASM / DB / Services]
    G --> H[Vérifications read-only]
    H --> I[Documentation exploitation]
```

---

## 4. OEDA — Oracle Exadata Deployment Assistant

### 4.1 Définition

OEDA signifie **Oracle Exadata Deployment Assistant**.

C’est l’outil utilisé pour préparer et décrire la configuration cible Exadata.

Il permet de formaliser :

```text
rack
machines
réseaux
IP
noms
cluster
ASM
diskgroups
Oracle homes
bases initiales
services
paramètres de déploiement
```

### 4.2 Rôle d’OEDA

OEDA sert à passer d’un design à une configuration déployable.

Il ne remplace pas la réflexion d’architecture.

Il formalise les choix validés.

### 4.3 Ce qu’OEDA doit refléter

| Domaine | Exemples d’informations |
|---|---|
| Nommage | DB servers, cells, cluster, SCAN, VIP |
| Réseau | client, admin, backup, interne, VLAN, passerelles |
| DNS | noms directs, inverses, SCAN |
| Cluster | nom cluster, nœuds, services |
| ASM | DATA, RECO, redondance, capacité |
| Database | noms de bases, db_unique_name, homes |
| Sécurité | accès, mots de passe initiaux selon procédure |
| Backup | cible RMAN, ZDLRA si prévue |
| Monitoring | Enterprise Manager, agents, alertes |

---

## 5. OECA — Oracle Exadata Configuration Assistant

### 5.1 Définition

OECA signifie **Oracle Exadata Configuration Assistant**.

Il sert à contrôler la cohérence de certaines informations avant ou pendant la configuration.

### 5.2 Rôle d’OECA

OECA aide à détecter tôt des incohérences comme :

```text
erreur IP
erreur de masque réseau
DNS incomplet
SCAN incorrect
incohérence de noms
problème de routage
prérequis non respecté
```

### 5.3 À retenir

```text
OEDA décrit la cible.
OECA aide à contrôler la cohérence.
La worksheet reste le document de référence entre équipes.
```

---

## 6. Configuration worksheet

La configuration worksheet est le document central de préparation.

Elle doit être partagée entre :

```text
DBA
architectes
équipe réseau
équipe système
équipe sécurité
équipe sauvegarde
équipe supervision
équipe datacenter
support / exploitation
```

Elle doit contenir au minimum :

| Partie | Contenu |
|---|---|
| Identification | nom du projet, environnement, site, contacts |
| Rack | modèle, emplacement, contraintes datacenter |
| Réseau client | IP, VLAN, passerelle, SCAN, VIP |
| Réseau admin | IP admin, accès SSH, bastion |
| Réseau backup | IP backup, cible RMAN, débit prévu |
| DNS | entrées directes et inverses |
| NTP/Chrony | serveurs temps |
| ASM | DATA, RECO, redondance, capacité |
| Bases | db_name, db_unique_name, services |
| Data Guard | primary, standby, réseau redo |
| ZDLRA | cible RMAN/recovery si utilisée |
| Monitoring | EM, agents, alertes |
| Sécurité | accès, comptes, flux firewall |

---

## 7. Nommage et conventions

Le nommage doit être défini avant déploiement.

Éléments à nommer :

```text
rack
cluster
Database Servers
Storage Cells
SCAN
VIP
listeners
bases
db_unique_name
services
diskgroups
réseaux
interfaces
```

Exemple de convention :

```text
exa-prod-db01
exa-prod-db02
exa-prod-cell01
exa-prod-cell02
exa-prod-scan
exa-prod-clu
PAYPROD
PAYPROD_DG
```

Risques d’un mauvais nommage :

```text
confusion exploitation
scripts difficiles à maintenir
erreurs dans Data Guard
supervision difficile
documentation incohérente
```

---

## 8. Configuration réseau initiale

Les réseaux doivent être cohérents avec le site planning.

### 8.1 Réseau client

Utilisé pour :

```text
connexions applicatives
SCAN
listeners
services RAC
```

Points à valider :

```text
SCAN résolu par DNS
VIP accessibles
ports listeners ouverts
routage correct
latence acceptable
```

### 8.2 Réseau administration

Utilisé pour :

```text
SSH
supervision
gestion OS
accès DBA / système
support
```

Points à valider :

```text
bastion ou rebond
droits d’accès
journalisation
flux Enterprise Manager
```

### 8.3 Réseau backup

Utilisé pour :

```text
RMAN
ZDLRA
média manager
NFS backup si utilisé
restauration
```

Points à valider :

```text
débit
routage
firewall
DNS cible
fenêtre de sauvegarde
tests restore validate
```

### 8.4 Réseau interne RoCE / InfiniBand

Utilisé pour :

```text
RAC
ASM
iDB
échanges DB servers / Storage Cells
```

Il est critique pour la performance Exadata.

---

## 9. Configuration ASM initiale

ASM est au cœur du stockage Oracle sur Exadata.

La configuration initiale doit prévoir :

```text
diskgroups DATA
diskgroups RECO
redondance
failure groups
capacité utilisable
répartition sur cells
rebalance
compatibilité ASM
```

### 9.1 DATA

DATA contient généralement les fichiers de données principaux :

```text
datafiles
tempfiles
certains controlfiles selon design
```

### 9.2 RECO

RECO contient souvent la zone de récupération :

```text
archivelogs
backups locaux selon design
flashback logs
controlfile backups
FRA selon architecture
```

### 9.3 Redondance

La redondance ASM doit être pensée avec les failure groups.

À éviter :

```text
raisonner uniquement en capacité brute
ignorer le niveau de redondance
ignorer les conséquences d’une cell indisponible
oublier la capacité réellement utilisable
```

---

## 10. Configuration Oracle homes et bases initiales

La configuration initiale peut inclure les Oracle homes et les premières bases.

À définir :

```text
version Oracle Database
Oracle home
Grid home
nom de base
db_unique_name
CDB / non-CDB selon version et choix
PDB éventuelles
services RAC
paramètres initiaux
```

Attention :

```text
Le nom db_unique_name est important pour Data Guard.
Les services RAC sont importants pour le routage applicatif.
Les choix CDB/PDB influencent la consolidation.
```

---

## 11. Services RAC et SCAN

SCAN signifie **Single Client Access Name**.

Il permet aux applications de se connecter au cluster sans connaître chaque nœud.

Flux simplifié :

```text
Application
→ SCAN
→ Listener
→ Service RAC
→ Instance disponible
```

À définir :

```text
noms SCAN
IP SCAN
VIP
listeners
services applicatifs
politique de placement
failover
load balancing
```

Erreur fréquente :

```text
Créer une base sans réfléchir aux services applicatifs.
```

Le service est souvent plus important pour l’application que le nom physique du serveur.

---

## 12. Data Guard dans la configuration initiale

Data Guard doit être anticipé dès la configuration.

À prévoir :

```text
db_unique_name primaire
db_unique_name standby
réseau redo transport
listeners
TNS
ports firewall
mode de protection
RPO / RTO
Fast-Start Failover si prévu
Active Data Guard si prévu
```

À retenir :

```text
Data Guard n’est pas un détail à ajouter à la fin.
Il influence nommage, réseau, services et sauvegarde.
```

---

## 13. ZDLRA et sauvegarde dans la configuration initiale

ZDLRA est une appliance de sauvegarde/recovery.

Elle doit être pensée dans la configuration initiale si elle est utilisée.

À prévoir :

```text
réseau backup
nom DNS ZDLRA
routage
firewall
catalogue RMAN si utilisé
politique de sauvegarde
temps de conservation
tests restore validate
```

Différence importante :

```text
Data Guard = réplication vers standby.
ZDLRA = sauvegarde et recovery RMAN.
```

---

## 14. Supervision initiale

La supervision doit être activée dès le départ.

À intégrer :

```text
Enterprise Manager
agents
alertes Exadata
CellCLI
AHF
Exachk
ORAchk
TFA
OSWatcher
journaux OS
alert logs
```

À surveiller :

```text
Database Servers
Storage Cells
ASM
RAC
réseau interne
flash
disques
backup
Data Guard
capacité
latence
alertes matériel
```

---

## 15. Validations avant déploiement

Avant de lancer le déploiement, il faut valider :

| Domaine | Validation |
|---|---|
| Worksheet | Complète, relue et signée |
| Noms | Cohérents avec conventions |
| IP | Uniques, routables, documentées |
| DNS | Direct et inverse validés |
| NTP | Source temps disponible |
| Réseaux | Client, admin, backup, interne prêts |
| Firewall | Flux applicatifs, admin, backup, DR, monitoring ouverts |
| ASM | DATA/RECO, redondance, capacité validées |
| Bases | noms, versions, CDB/PDB, services validés |
| Data Guard | db_unique_name, réseau DR, ports prévus |
| ZDLRA | cible backup/recovery prévue |
| Monitoring | EM, alerting, support prévus |
| Sécurité | comptes, accès, bastion, journaux validés |

---

## 16. Commandes read-only de vérification après configuration

### 16.1 Réseau et nommage

```bash
hostname -f
ip addr
ip route
nslookup <scan_name>
nslookup <ip>
getent hosts <hostname>
chronyc tracking
```

### 16.2 Cluster et SCAN

```bash
olsnodes -n
crsctl stat res -t
srvctl config scan
srvctl status scan
srvctl status listener
```

### 16.3 Base et services

```bash
srvctl config database
srvctl status database -d <db_unique_name> -v
srvctl status service -d <db_unique_name>
```

```sql
select inst_id, instance_name, host_name, status
from gv$instance
order by inst_id;

select name, value
from v$parameter
where name in ('db_name','db_unique_name','cluster_database');
```

### 16.4 ASM

```bash
asmcmd lsdg
asmcmd lsdsk -p
```

```sql
select name, total_mb, free_mb, type, state
from v$asm_diskgroup
order by name;
```

### 16.5 Storage Cells

```bash
cellcli -e "list cell detail"
cellcli -e "list griddisk"
cellcli -e "list alert history"
```

---

## 17. Erreurs fréquentes

| Erreur | Conséquence | Correction |
|---|---|---|
| Worksheet incomplète | Déploiement bloqué ou incohérent | Relire avant exécution |
| SCAN mal résolu | Connexions RAC instables | Vérifier DNS direct/inverse |
| Réseau backup oublié | Sauvegarde impossible ou lente | Prévoir VLAN et débit backup |
| db_unique_name mal choisi | Data Guard compliqué | Définir primary/standby dès le départ |
| DATA/RECO mal dimensionnés | Capacité ou FRA insuffisante | Valider capacité utile et redondance |
| Services RAC non pensés | Routage applicatif fragile | Définir services par application |
| Supervision reportée | Incidents non détectés | Activer monitoring dès le départ |
| ZDLRA oublié | Recovery mal intégré | Prévoir cible et tests RMAN |

---

## 18. Exercice pratique

Une équipe prépare la configuration initiale d’un Exadata de production.

La worksheet contient :

```text
noms des DB servers
noms des Storage Cells
IP client
IP admin
SCAN
DATA et RECO
nom de base
```

Mais elle ne contient pas :

```text
DNS inverse
réseau backup
flux Data Guard
cible ZDLRA
services applicatifs
plan de supervision
```

Répondez aux questions :

1. Quels risques cette worksheet crée-t-elle ?
2. Quels éléments doivent être ajoutés avant déploiement ?
3. Pourquoi db_unique_name est important ?
4. Pourquoi les services RAC doivent être définis tôt ?
5. Quelle recommandation formuler ?

---

## 19. Corrigé indicatif

La worksheet est insuffisante.

Les risques principaux sont :

```text
problèmes d’installation liés au DNS
backup RMAN non opérationnel
Data Guard impossible ou retardé
ZDLRA non intégré
applications connectées sans services propres
supervision absente au démarrage
```

Éléments à ajouter :

```text
DNS direct et inverse
réseau backup
routage et firewall backup
flux Data Guard
db_unique_name primaire et standby
services applicatifs RAC
cible ZDLRA
Enterprise Manager / AHF / Exachk / TFA
procédures de validation
```

db_unique_name est important parce qu’il identifie chaque base dans une architecture Data Guard.

Les services RAC doivent être définis tôt parce que les applications doivent se connecter à des services logiques, pas à des serveurs physiques.

Recommandation :

```text
Ne pas lancer le déploiement tant que la worksheet n’est pas complète,
relue par DBA, réseau, sécurité, sauvegarde, supervision et exploitation.
```

---

## 20. À retenir

```text
À retenir
- La configuration initiale transforme le site planning en configuration réelle.
- OEDA décrit la cible de déploiement.
- OECA aide à contrôler la cohérence.
- La worksheet est le document central entre équipes.
- Les choix IP, DNS, NTP, ASM, services et backup doivent être validés avant exécution.
- Data Guard, ZDLRA et supervision doivent être anticipés dès le début.
- Une mauvaise configuration initiale coûte cher à corriger plus tard.
```

---

## 21. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Déploiement, configuration, administration Exadata. |
| [Oracle Exadata Deployment Assistant Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | OEDA, configuration cible, déploiement. |
| [Oracle Grid Infrastructure Documentation](https://docs.oracle.com/en/database/) | Cluster, SCAN, services, listeners, ASM. |
| [Oracle ASM Documentation](https://docs.oracle.com/en/database/) | Diskgroups, redondance, failure groups, rebalance. |
| [Oracle Data Guard Documentation](https://docs.oracle.com/en/database/) | db_unique_name, redo transport, standby, protection modes. |
| [Oracle Zero Data Loss Recovery Appliance Documentation](https://docs.oracle.com/en/engineered-systems/zero-data-loss-recovery-appliance/) | ZDLRA, RMAN, sauvegarde et recovery. |
