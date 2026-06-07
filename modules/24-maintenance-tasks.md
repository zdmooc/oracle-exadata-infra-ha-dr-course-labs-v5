# Module 24 — Maintenance Tasks

## 1. Objectif du module

Ce module explique les **tâches de maintenance régulières** sur Oracle Exadata.

L’objectif est de distinguer maintenance, monitoring et patching. La maintenance régulière maintient la plateforme lisible, saine, documentée et prévisible. Elle permet de détecter les dérives avant qu’elles deviennent des incidents.

À la fin de ce module, le lecteur doit être capable de :

- organiser une revue de capacité ;
- surveiller DATA, RECO, FRA et croissance ;
- suivre versions, agents, certificats, comptes et accès ;
- vérifier les journaux et collectes ;
- produire un tableau de maintenance mensuelle ;
- préparer les preuves avant CAB ou patching ;
- éviter les dérives silencieuses.

---

## 2. Maintenance ≠ Patching

| Sujet | Objectif |
|---|---|
| Monitoring | Détecter et diagnostiquer |
| Maintenance | Maintenir la plateforme saine |
| Patching | Appliquer des correctifs |
| Support | Traiter un incident ou une demande Oracle |

La maintenance inclut :

```text
revue capacité
revue santé
revue versions
revue comptes
revue certificats
revue agents
revue logs
revue sauvegardes
revue Data Guard
revue documentation
```

---

## 3. Revue capacité

À vérifier :

```text
DATA
RECO
FRA
TEMP
UNDO
croissance mensuelle
archivelogs
backups
flashback logs
tablespaces critiques
```

Commandes :

```bash
asmcmd lsdg
```

```sql
select name, total_mb, free_mb, usable_file_mb, type, state
from v$asm_diskgroup
order by name;

select * from v$recovery_file_dest;
```

Questions :

```text
Quelle est la croissance ?
Quand atteindra-t-on le seuil critique ?
Quel workload consomme ?
Quelle action prévoir ?
```

---

## 4. Revue santé

À vérifier :

```text
CRS resources
services RAC
instances
ASM
Storage Cells
alert history
physical disks
agents EM
AHF/TFA
```

Commandes :

```bash
crsctl stat res -t
srvctl status database -d <db_unique_name> -v
srvctl status service -d <db_unique_name>
cellcli -e "list alert history detail"
cellcli -e "list physicaldisk attributes name,status,errormessage"
```

---

## 5. Revue versions

À vérifier :

```text
Oracle Database
Grid Infrastructure
Oracle Homes
Exadata System Software
firmware selon procédure
EM agent
AHF
TFA
Exachk
```

Commandes :

```bash
opatch lsinventory
imageinfo
imagehistory
ahfctl status
exachk -v
```

But :

```text
connaître l’état avant patching
préparer support
éviter les incohérences
documenter la plateforme
```

---

## 6. Revue sauvegarde et récupération

À vérifier :

```text
backup récent
archivelogs disponibles
controlfile autobackup
restore validate
FRA/RECO
Data Guard si présent
RPO/RTO
```

Commandes :

```bash
rman target / <<EOF
show all;
list backup summary;
report schema;
EOF
```

```sql
select log_mode, force_logging, database_role from v$database;
select * from v$recovery_file_dest;
```

---

## 7. Revue Data Guard

Si Data Guard existe :

```text
configuration Broker
database role
open mode
transport lag
apply lag
protection mode
services standby
tests de bascule
```

Commandes :

```bash
dgmgrl / "show configuration"
```

```sql
select database_role, open_mode, protection_mode from v$database;
select name, value, unit from v$dataguard_stats;
```

---

## 8. Revue comptes et accès

À vérifier selon politique sécurité :

```text
comptes DBA
comptes applicatifs
comptes techniques
comptes OS
comptes EM
droits OCI si cloud
mots de passe expirés
comptes inutilisés
```

SQL indicatif :

```sql
select username, account_status, lock_date, expiry_date
from dba_users
order by username;
```

Attention :

```text
Toute modification de compte doit suivre la procédure sécurité.
```

---

## 9. Revue certificats

À vérifier :

```text
certificats listeners / wallets selon design
certificats EM
certificats agents
certificats API ou intégrations
certificats cloud selon contexte
dates d’expiration
```

Objectif :

```text
éviter l’interruption d’une intégration ou d’une supervision.
```

---

## 10. Revue logs

À vérifier :

```text
alert logs database
logs GI/CRS
logs listener
logs ASM
logs cells
logs OS
taille des fichiers
rotation
rétention
filesystem plein
```

Commandes OS read-only :

```bash
df -h
du -sh <répertoire_log>
```

Selon procédure :

```bash
tfactl print status
```

---

## 11. Revue documentation

La documentation doit contenir :

```text
architecture
noms serveurs
versions
services RAC
bases/PDB
DATA/RECO
réseaux
backup
Data Guard
contacts
runbooks
procédures escalade
historique patching
```

À retenir :

```text
Une plateforme non documentée devient difficile à maintenir en incident.
```

---

## 12. Fréquence recommandée

| Fréquence | Tâches |
|---|---|
| Quotidien | alertes critiques, backup, Data Guard lag |
| Hebdomadaire | capacité, services, cells, incidents |
| Mensuel | versions, comptes, certificats, documentation |
| Trimestriel | Exachk, patch readiness, exercice restore/bascule |
| Avant changement | pré-check complet |
| Après changement | post-check complet |

---

## 13. Tableau de maintenance mensuelle

| Contrôle | Preuve | Statut | Action |
|---|---|---|---|
| ASM DATA/RECO | asmcmd lsdg | OK/KO | capacité |
| FRA | v$recovery_file_dest | OK/KO | purge/backup |
| CRS | crsctl stat res -t | OK/KO | analyse |
| Services | srvctl status service | OK/KO | correction |
| Cells | alert history | OK/KO | SR/action |
| RMAN | list backup summary | OK/KO | backup |
| Data Guard | v$dataguard_stats | OK/KO | analyse |
| Versions | imageinfo/opatch | OK/KO | patch plan |
| EM Agent | emctl status agent | OK/KO | correction |
| Documentation | revue doc | OK/KO | mise à jour |

---

## 14. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Maintenance non planifiée | Dérives invisibles | calendrier |
| Confondre patching et maintenance | Revue insuffisante | séparer activités |
| Ignorer capacité RECO | blocage archivelogs | suivi FRA |
| Oublier documentation | incident difficile | mise à jour mensuelle |
| Ne pas vérifier restore | backup théorique | restore validate |
| Ignorer certificats | rupture supervision | revue expiration |
| Pas de preuve | CAB faible | conserver sorties |

---

## 15. Commandes read-only utiles

```bash
crsctl stat res -t
srvctl status database -d <db_unique_name> -v
srvctl status service -d <db_unique_name>
asmcmd lsdg
cellcli -e "list alert history detail"
cellcli -e "list physicaldisk attributes name,status,errormessage"
imageinfo
imagehistory
opatch lsinventory
ahfctl status
emctl status agent
```

```sql
select * from v$recovery_file_dest;
select name, total_mb, free_mb, usable_file_mb from v$asm_diskgroup;
select name, value, unit from v$dataguard_stats;
select username, account_status, expiry_date from dba_users;
```

---

## 16. Exercice pratique

La revue mensuelle détecte :

```text
croissance FRA anormale
agent monitoring en retard de version
quelques alertes cell anciennes
documentation non mise à jour
```

Répondez :

1. Quels risques identifiez-vous ?
2. Quelles preuves collectez-vous ?
3. Quelles actions sont immédiates ?
4. Quelles actions demandent CAB ?
5. Quelle synthèse envoyez-vous à l’équipe ?

---

## 17. Corrigé indicatif

Risques :

```text
FRA saturation
perte supervision fiable
alertes anciennes non qualifiées
documentation non fiable
```

Preuves :

```text
v$recovery_file_dest
asmcmd lsdg
emctl status agent
cellcli alert history
imageinfo/opatch selon besoin
```

Conclusion :

```text
La maintenance doit produire des preuves, une priorisation et des actions.
La croissance FRA doit être traitée avant blocage archivelogs.
L’agent monitoring doit être remis à niveau selon procédure.
```

---

## 18. À retenir

```text
À retenir
- La maintenance prévient les incidents.
- Elle est différente du patching.
- Capacité DATA/RECO/FRA est prioritaire.
- RMAN, Data Guard et restore doivent être vérifiés.
- Versions, agents, comptes et certificats doivent être suivis.
- La documentation fait partie de l’exploitation.
- Une bonne maintenance produit des preuves et des actions.
```

---

## 19. Références officielles

| Référence | Utilisation |
|---|---|
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Maintenance, administration, monitoring. |
| [Oracle Database Administration Guide](https://docs.oracle.com/en/database/) | Comptes, vues DBA, maintenance DB. |
| [Oracle Backup and Recovery Documentation](https://docs.oracle.com/en/database/) | RMAN, restore, recovery. |
| [Oracle AHF Documentation](https://docs.oracle.com/en/engineered-systems/health-diagnostics/autonomous-health-framework/) | Exachk, TFA, santé plateforme. |
