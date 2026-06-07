# Module 19 — Monitoring Network

## 1. Objectif du module

Ce module explique comment surveiller les réseaux d’une plateforme Oracle Exadata.

L’objectif est de comprendre qu’Exadata n’utilise pas un seul réseau. Les flux client, administration, backup, Data Guard et réseau interne RoCE/InfiniBand ont des rôles différents, des symptômes différents et des méthodes de diagnostic différentes.

À la fin de ce module, le lecteur doit être capable de :

- distinguer les réseaux Exadata ;
- relier un symptôme à un type de réseau ;
- comprendre le rôle du réseau interne RDMA/RoCE/InfiniBand ;
- diagnostiquer une lenteur backup sans l’attribuer au SQL ;
- vérifier SCAN, DNS, listeners et services ;
- identifier les erreurs d’interface ;
- construire une timeline réseau ;
- utiliser des commandes read-only adaptées.

---

## 2. Les réseaux Exadata

Réseaux à distinguer :

```text
réseau client
réseau administration
réseau backup
réseau interne RoCE / InfiniBand
réseau Data Guard selon architecture
réseau supervision selon design
```

Chaque réseau a son rôle.

| Réseau | Rôle |
|---|---|
| Client | Connexions applications vers services Oracle |
| Administration | SSH, gestion, supervision, administration |
| Backup | RMAN, transferts, appliance backup |
| Interne RoCE/InfiniBand | RAC, ASM, iDB, Storage Cells |
| Data Guard | Transport redo vers standby |
| Supervision | EM, agents, collecte selon architecture |

---

## 3. Pourquoi le réseau est critique

Un problème réseau peut apparaître comme :

```text
connexion application impossible
connexion lente
RMAN lent
Data Guard lag
latence cell
instabilité RAC
erreur listener
métriques EM absentes
```

Erreur fréquente :

```text
Diagnostiquer une sauvegarde lente comme un problème SQL.
```

Correction :

```text
Identifier d’abord le chemin réseau réellement utilisé.
```

---

## 4. Réseau client

Le réseau client transporte les connexions applicatives.

Composants :

```text
SCAN
SCAN listeners
VIP
listeners
services RAC
DNS
firewall
load balancer éventuel
```

Commandes :

```bash
srvctl status scan
srvctl status scan_listener
srvctl status listener
srvctl status service -d <db_unique_name>
lsnrctl status
```

SQL :

```sql
select inst_id, name, network_name
from gv$services
order by inst_id, name;
```

Symptômes :

```text
ORA-12154
ORA-12514
ORA-12541
connexion lente
service introuvable
bascule non prise en compte
```

---

## 5. Réseau administration

Le réseau administration sert à :

```text
SSH
monitoring
accès EM agent/OMS selon design
gestion OS
transfert logs
AHF/TFA selon scénario
```

Symptômes :

```text
SSH lent ou impossible
agents EM injoignables
collecte impossible
administration partielle
```

À surveiller :

```text
connectivité
DNS
latence
routes
firewall
accès bastion
```

---

## 6. Réseau backup

Le réseau backup peut transporter :

```text
RMAN vers appliance
RMAN vers ZDLRA
backup vers stockage externe
restore
duplication
transferts massifs
```

Symptômes :

```text
backup lent
restore lent
débit inférieur à la baseline
fenêtre RMAN dépassée
saturation interface
```

Commandes utiles côté base :

```bash
rman target / <<EOF
list backup summary;
show all;
EOF
```

Côté OS selon droits :

```bash
ip addr
ip route
netstat -i
```

À retenir :

```text
Une lenteur RMAN peut venir du réseau backup, pas de la database.
```

---

## 7. Réseau interne RoCE / InfiniBand

Le réseau interne est critique.

Il transporte :

```text
trafic RAC
trafic ASM
trafic iDB vers Storage Cells
Smart Scan / retours cells
coordination cluster
```

Symptômes possibles :

```text
latence cell
attentes I/O
instabilité cluster
problèmes ASM
messages GI
performance SQL dégradée
```

Attention :

```text
Ce réseau doit être diagnostiqué selon les procédures Oracle et du site.
```

---

## 8. Data Guard et réseau

Data Guard dépend du réseau entre primaire et standby.

Symptômes :

```text
transport lag
apply lag indirect
redo transport lent
archive gap
erreurs de connexion standby
```

Commandes :

```sql
select database_role, open_mode, protection_mode
from v$database;

select name, value, unit
from v$dataguard_stats;
```

```bash
dgmgrl / "show configuration"
```

À retenir :

```text
Un transport lag est souvent un sujet réseau, redo, charge ou standby.
Il ne faut pas le confondre avec apply lag.
```

---

## 9. DNS, SCAN et résolution

DNS/SCAN sont essentiels aux connexions client.

À vérifier :

```text
noms SCAN
résolution directe
résolution inverse si requise
adresses attendues
TTL
cohérence avec srvctl
```

Commandes :

```bash
srvctl config scan
srvctl status scan
nslookup <scan_name>
```

Selon environnement :

```bash
dig <scan_name>
getent hosts <scan_name>
```

Erreur fréquente :

```text
Modifier un service alors que le problème vient de DNS/SCAN.
```

---

## 10. Interfaces et erreurs réseau

Selon droits et OS :

```bash
ip addr
ip route
netstat -i
ethtool <interface>
```

À lire :

```text
interface up/down
erreurs RX/TX
drops
collisions si exposées
MTU
routes
débit négocié
```

Attention :

```text
Certaines commandes réseau doivent être exécutées uniquement selon les règles du site.
```

---

## 11. Corrélation réseau avec database

Côté database, certains symptômes peuvent orienter.

Exemples :

| Symptôme DB | Hypothèse réseau possible |
|---|---|
| connexions lentes | client/SCAN/listener |
| Data Guard transport lag | réseau DG |
| RMAN lent | réseau backup |
| cell waits élevés | réseau interne ou cells |
| EM sans métriques | réseau supervision/admin |

Mais il faut prouver.

Commandes SQL utiles :

```sql
select event, total_waits, time_waited
from v$system_event
order by time_waited desc;
```

```sql
select name, value, unit
from v$dataguard_stats;
```

---

## 12. Timeline réseau

Une timeline réseau doit contenir :

```text
heure du symptôme
interface concernée
changement réseau
début backup
début Data Guard lag
alerte listener
alerte switch si disponible
erreurs OS
alerte cell
collecte TFA/AHF
```

Exemple :

```text
21:55 début RMAN
22:00 baisse débit backup
22:05 erreurs interface backup
22:10 fenêtre RMAN dépassée
22:15 OLTP normal
```

Conclusion :

```text
Le réseau backup est suspect, pas le SQL OLTP.
```

---

## 13. Cas concret : backup lent

Situation :

```text
Une sauvegarde ralentit fortement alors que les requêtes OLTP restent correctes.
```

Hypothèses :

```text
réseau backup saturé
appliance backup lente
RMAN channels insuffisants
cible backup saturée
RECO/FRA problématique
Storage Cells occupées
```

Vérifications :

```text
débit RMAN
logs RMAN
réseau backup
cell metrics
FRA/RECO
baseline backup
```

Commandes :

```bash
rman target / <<EOF
list backup summary;
show all;
EOF
```

```sql
select * from v$recovery_file_dest;
```

```bash
cellcli -e "list metriccurrent"
```

---

## 14. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Parler du réseau sans dire lequel | Diagnostic flou | Nommer client/admin/backup/RDMA |
| Confondre backup lent et SQL lent | Mauvaise couche | Vérifier chemin RMAN |
| Ignorer SCAN/DNS | Connexion mal diagnostiquée | srvctl/nslookup |
| Ignorer Data Guard network | Lag mal interprété | Lire transport/apply lag |
| Conclure sans timeline | Faux lien causal | Corréler horaires |
| Lire une seule interface | Vue incomplète | Lire chemin complet |
| Modifier sans preuve | Risque production | Read-only puis runbook |

---

## 15. Commandes read-only utiles

### SCAN / listeners

```bash
srvctl config scan
srvctl status scan
srvctl status scan_listener
srvctl status listener
lsnrctl status
```

### Services

```bash
srvctl status service -d <db_unique_name>
```

```sql
select inst_id, name, network_name
from gv$services
order by inst_id, name;
```

### OS réseau

```bash
ip addr
ip route
netstat -i
```

### DNS

```bash
nslookup <scan_name>
getent hosts <scan_name>
```

### Data Guard

```sql
select name, value, unit
from v$dataguard_stats;
```

```bash
dgmgrl / "show configuration"
```

### Cell / I/O

```bash
cellcli -e "list metriccurrent"
cellcli -e "list alert history detail"
```

---

## 16. Exercice pratique

Une sauvegarde RMAN dépasse sa fenêtre habituelle.

Contexte :

```text
OLTP normal
reporting normal
RMAN très lent
Data Guard sans lag
pas d’alerte database majeure
```

Répondez :

1. Quel réseau suspectez-vous en premier ?
2. Quelles autres causes restent possibles ?
3. Quelles commandes utilisez-vous ?
4. Comment évitez-vous de conclure trop vite ?
5. Quelle recommandation prudente formulez-vous ?

---

## 17. Corrigé indicatif

Le réseau backup est suspect en premier, car l’OLTP et le reporting restent normaux.

Causes possibles :

```text
réseau backup saturé
cible backup lente
RMAN mal parallélisé
Storage Cells occupées
FRA/RECO sous pression
```

Commandes :

```bash
rman target / <<EOF
list backup summary;
show all;
EOF

ip addr
ip route
netstat -i
cellcli -e "list metriccurrent"
```

Conclusion :

```text
Le diagnostic doit comparer le débit RMAN à la baseline,
vérifier le réseau backup et exclure les autres causes avant toute modification.
```

---

## 18. À retenir

```text
À retenir
- Exadata utilise plusieurs réseaux.
- Il faut toujours nommer le réseau analysé.
- Le réseau client concerne les connexions applicatives.
- Le réseau backup concerne RMAN et les gros transferts.
- Le réseau interne RoCE/InfiniBand porte RAC, ASM et iDB.
- Data Guard dépend fortement du réseau redo.
- SCAN/DNS/listeners sont critiques pour les connexions.
- Une timeline évite les faux diagnostics.
```

---

## 19. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Réseaux Exadata, administration machine. |
| [Oracle RAC Documentation](https://docs.oracle.com/en/database/) | SCAN, listeners, VIP, interconnect. |
| [Oracle Data Guard Documentation](https://docs.oracle.com/en/database/) | Transport redo, lag, réseau Data Guard. |
| [Oracle RMAN Documentation](https://docs.oracle.com/en/database/) | Backup, restore, channels, performance RMAN. |
