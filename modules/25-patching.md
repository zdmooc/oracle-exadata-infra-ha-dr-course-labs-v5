# Module 25 — Patching

## 1. Objectif du module

Ce module explique la logique du **patching Oracle Exadata**.

L’objectif est de comprendre le patching comme une opération coordonnée et risquée, qui touche plusieurs couches : Exadata System Software, Storage Cells, Database Servers, Grid Infrastructure, Oracle Homes, firmware, outils support et monitoring.

À la fin de ce module, le lecteur doit être capable de :

- distinguer les couches de patching ;
- comprendre rolling patch et non-rolling patch ;
- préparer des pré-checks ;
- définir des critères go/no-go ;
- comprendre le rôle d’Exachk ;
- vérifier backups et Data Guard avant patch ;
- préparer un rollback ;
- organiser les post-checks ;
- éviter les commandes destructrices hors procédure officielle.

---

## 2. Pourquoi le patching Exadata est sensible

Le patching peut impacter :

```text
disponibilité
services RAC
Storage Cells
ASM
réseau interne
performances
compatibilité
support Oracle
sécurité
```

Risque principal :

```text
interruption non prévue ou incohérence de version.
```

À retenir :

```text
Un patch réussi techniquement n’est complet que si les validations post-change sont réussies.
```

---

## 3. Couches concernées

| Couche | Exemple |
|---|---|
| Oracle Database Home | RU/RUR, one-off patches |
| Grid Infrastructure | Clusterware, ASM |
| Exadata System Software | Storage Cells / DB nodes image |
| OS / firmware | Drivers, firmware selon bundle |
| Enterprise Manager Agent | Supervision |
| AHF / Exachk / TFA | Outils support |
| Application | Validation métier après patch |

---

## 4. Rolling vs non-rolling

| Type | Principe | Impact |
|---|---|---|
| Rolling | Composants patchés progressivement | Réduit indisponibilité |
| Non-rolling | Arrêt plus large requis | Fenêtre plus importante |

Attention :

```text
Rolling ne veut pas dire sans risque.
Les services, connexions et performances doivent être validés.
```

---

## 5. Pré-checks

Avant patching :

```text
état CRS
état services
état ASM
état cells
alertes actives
backup récent
restore validate si requis
Data Guard état OK
versions actuelles
imageinfo/imagehistory
opatch inventory
Exachk
fenêtre validée
rollback prévu
```

Commandes :

```bash
crsctl stat res -t
srvctl status database -d <db_unique_name> -v
srvctl status service -d <db_unique_name>
asmcmd lsdg
cellcli -e "list alert history detail"
imageinfo
imagehistory
opatch lsinventory
exachk
```

---

## 6. Backup et récupérabilité avant patch

Avant patch :

```bash
rman target / <<EOF
show all;
list backup summary;
report schema;
EOF
```

À vérifier :

```text
backup exploitable
archivelogs disponibles
FRA/RECO OK
controlfile autobackup
restore validate selon procédure
plan rollback
```

---

## 7. Data Guard avant patch

Si Data Guard existe :

```sql
select database_role, open_mode, protection_mode, switchover_status
from v$database;

select name, value, unit
from v$dataguard_stats;
```

```bash
dgmgrl / "show configuration"
```

Critères :

```text
configuration saine
lag acceptable
standby disponible
rôle clair
procédure de bascule connue
```

---

## 8. Exachk pré-patch

Exachk peut identifier :

```text
versions incohérentes
paramètres non recommandés
patchs manquants
alertes connues
risques configuration
```

À retenir :

```text
Un rapport Exachk doit être lu et priorisé.
Il ne suffit pas de le générer.
```

---

## 9. Runbook de patching

Un runbook doit contenir :

```text
périmètre
versions actuelles
versions cibles
ordre des composants
responsables
pré-checks
sauvegarde
go/no-go
étapes patch
post-checks
rollback
communication
fenêtre
critères de succès
```

---

## 10. Go / No-Go

Critères Go :

```text
backup OK
FRA/RECO OK
Data Guard OK si utilisé
CRS sain
services documentés
pas d’alerte bloquante
Exachk acceptable
rollback prêt
équipes disponibles
validation métier planifiée
```

Critères No-Go :

```text
backup absent
lag Data Guard non maîtrisé
alerte cell critique
CRS instable
services déjà dégradés
rollback absent
fenêtre insuffisante
```

---

## 11. Post-checks

Après patch :

```text
versions nouvelles
imageinfo
opatch lsinventory
CRS online
services online
ASM OK
cells OK
alert history propre
EM targets OK
backup post-patch si requis
tests applicatifs
AWR/baseline si besoin
```

Commandes :

```bash
crsctl stat res -t
srvctl status service -d <db_unique_name>
asmcmd lsdg
cellcli -e "list alert history detail"
imageinfo
opatch lsinventory
```

---

## 12. Rollback

Le rollback dépend de la couche.

À définir :

```text
rollback DB home
rollback GI
rollback image Exadata
restauration backup
retour Data Guard
retour applicatif
DNS/services
critères de déclenchement
durée maximale
```

À retenir :

```text
Le rollback doit être écrit avant le patch.
```

---

## 13. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Patcher sans backup prouvé | Retour impossible | vérifier RMAN |
| Ignorer Data Guard | DR en risque | lire lag/Broker |
| Ne pas lire Exachk | Risque connu ignoré | pré-check |
| Pas de post-check | Patch supposé OK | validation |
| Pas de rollback | décision improvisée | runbook |
| Confondre rolling et sans impact | service peut bouger | tester application |
| Versions non documentées | support difficile | inventaire |

---

## 14. Commandes read-only utiles

```bash
imageinfo
imagehistory
opatch lsinventory
crsctl stat res -t
srvctl status database -d <db_unique_name> -v
srvctl status service -d <db_unique_name>
asmcmd lsdg
cellcli -e "list alert history detail"
cellcli -e "list cell detail"
exachk -v
ahfctl status
```

```sql
select database_role, open_mode, protection_mode from v$database;
select name, value, unit from v$dataguard_stats;
select * from v$recovery_file_dest;
```

---

## 15. Exercice pratique

Une campagne patch trimestrielle doit être préparée pour une base critique.

Répondez :

1. Quelles couches sont concernées ?
2. Quels pré-checks réalisez-vous ?
3. Quels critères go/no-go définissez-vous ?
4. Quel rôle pour Exachk ?
5. Quel rollback prévoyez-vous ?
6. Quels post-checks sont obligatoires ?

---

## 16. Corrigé indicatif

Couches :

```text
DB home
GI
Exadata System Software
Storage Cells
agents
outils support
application
```

Pré-checks :

```text
backup
Data Guard
CRS
services
ASM
cells
versions
Exachk
alertes
```

Conclusion :

```text
Le Go patching ne peut être donné que si la plateforme est saine,
la récupérabilité prouvée, les risques connus acceptés et les validations
post-change planifiées.
```

---

## 17. À retenir

```text
À retenir
- Le patching Exadata touche plusieurs couches.
- Rolling ne signifie pas sans risque.
- Les pré-checks protègent la fenêtre.
- Exachk aide à identifier les risques.
- Backup, Data Guard et rollback sont indispensables.
- Les post-checks prouvent le succès réel.
- Un patch sans preuve avant/après est incomplet.
```

---

## 18. Références officielles

| Référence | Utilisation |
|---|---|
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Patching Exadata, administration. |
| [Oracle OPatch Documentation](https://docs.oracle.com/en/enterprise-manager/) | Inventaire Oracle Home. |
| [Oracle AHF / Exachk Documentation](https://docs.oracle.com/en/engineered-systems/health-diagnostics/autonomous-health-framework/) | Pré-check, santé plateforme. |
| [Oracle RAC Documentation](https://docs.oracle.com/en/database/) | Rolling, services, GI. |
