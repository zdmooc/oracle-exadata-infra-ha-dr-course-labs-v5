# Module 20 — Monitoring Other Components

## 1. Objectif du module

Ce module explique comment surveiller les composants Exadata qui ne sont pas directement visibles dans SQL : **ILOM, PDU, alimentation, ventilateurs, température, switches, capteurs et composants rack**.

L’objectif est de comprendre que la santé Exadata dépend aussi de composants matériels périphériques. Une alerte ventilateur, alimentation, température ou PDU peut annoncer un risque de dégradation ou de panne.

À la fin de ce module, le lecteur doit être capable de :

- identifier les composants matériels périphériques ;
- comprendre le rôle d’ILOM ;
- comprendre le rôle des PDU ;
- lire une alerte matérielle avec prudence ;
- relier un capteur à un risque opérationnel ;
- distinguer incident matériel, alerte informative et risque production ;
- préparer une escalade support ;
- éviter d’ignorer les signaux non SQL.

---

## 2. Pourquoi ces composants sont importants

Oracle Database peut être ouverte et fonctionner alors qu’un composant matériel est en risque.

Exemples :

```text
ventilateur dégradé
température élevée
alimentation en erreur
PDU en alerte
switch avec erreur
ILOM signalant un événement matériel
capteur instable
disque en predictive failure
```

Ces alertes peuvent précéder :

```text
throttling
arrêt serveur
perte redondance
panne Storage Cell
problème réseau
incident datacenter
ouverture SR Oracle
```

À retenir :

```text
Ce qui n’est pas visible dans SQL peut quand même menacer la disponibilité.
```

---

## 3. Composants concernés

| Composant | Rôle |
|---|---|
| ILOM | Gestion matérielle out-of-band des serveurs |
| PDU | Distribution électrique du rack |
| PSU | Bloc d’alimentation |
| Fan | Ventilation |
| Temperature Sensor | Température composant/rack |
| Switch | Connectivité réseau interne/admin/client selon design |
| Disk / Flash | Support physique |
| Rack sensors | Santé globale environnementale |
| Câblage | Connectivité physique |
| Firmware | Couche logicielle bas niveau du matériel |

---

## 4. ILOM

### 4.1 Définition

ILOM signifie **Integrated Lights Out Manager**.

Il fournit une gestion hors bande du matériel.

Il permet de consulter :

```text
état matériel
événements système
capteurs
alimentation
température
ventilation
journaux
informations serveur
```

### 4.2 Utilité

ILOM est utile quand :

```text
le serveur ne répond plus en OS
une alerte matérielle apparaît
un composant est suspect
Oracle Support demande des logs
une intervention datacenter est prévue
```

Commandes indicatives selon accès :

```bash
show /System
show /SP/logs/event/list
show /SYS
```

À adapter aux procédures du site.

---

## 5. PDU

### 5.1 Définition

Une PDU est une unité de distribution électrique du rack.

Elle distribue l’alimentation aux composants.

À surveiller :

```text
état électrique
charge
redondance
alertes
perte alimentation
déséquilibre
```

### 5.2 Risque

Une alerte PDU peut annoncer :

```text
perte d’une voie électrique
risque sur redondance
incident datacenter
panne en cascade
```

À retenir :

```text
Une alerte PDU n’est pas une alerte Oracle Database.
Mais elle peut devenir un incident Oracle majeur.
```

---

## 6. Ventilation et température

La ventilation protège les composants.

À surveiller :

```text
fan status
température CPU
température disque
température rack
alertes environnementales
```

Risques :

```text
throttling
arrêt de protection
usure prématurée
panne serveur
panne cell
```

Exemple :

```text
Une alerte ventilateur pendant charge normale peut signaler un risque matériel,
même si la base reste ouverte.
```

---

## 7. Switches et connectivité physique

Selon génération et architecture, Exadata dépend de switches pour :

```text
réseau interne
réseau administration
réseau client
réseau backup
```

À surveiller :

```text
ports down
erreurs interface
perte lien
câblage
firmware
alimentation switch
température switch
```

Symptômes possibles :

```text
latence cell
erreurs RAC
perte connectivité admin
connexion client intermittente
backup lent
```

---

## 8. Disques, flash et composants storage

Même si le module 17 traite les Storage Cells en détail, les composants physiques restent importants.

À surveiller :

```text
physical disk status
flash status
predictive failure
errormessage
remplacement
alerthistory
```

Commandes :

```bash
cellcli -e "list physicaldisk attributes name,status,errormessage"
cellcli -e "list alert history detail"
```

---

## 9. Alertes matérielles

Une alerte matérielle doit être lue avec :

```text
date
composant
sévérité
statut actif ou clear
message
répétition
impact potentiel
composant redondant ou non
besoin SR
```

Mauvaise réaction :

```text
La base fonctionne donc l’alerte est sans importance.
```

Bonne réaction :

```text
Qualifier l’alerte, vérifier la redondance, ouvrir une action ou SR si nécessaire.
```

---

## 10. Corrélation avec monitoring Exadata

Une alerte matérielle doit être corrélée avec :

```text
Enterprise Manager
CellCLI
ILOM
AHF/TFA
OS logs
CRS
ASM
timeline applicative
support Oracle
```

Exemple :

```text
Alerte ventilateur
→ vérifier ILOM
→ vérifier EM incident
→ vérifier température
→ vérifier impact OS/cell
→ ouvrir SR si risque matériel
```

---

## 11. Escalade support

Un dossier support doit contenir :

```text
symptôme
impact métier
composant concerné
heure de début
alerte exacte
logs ou capture
état actuel
actions déjà réalisées
urgence
redondance impactée ou non
```

Outils possibles :

```bash
tfactl diagcollect
ahfctl status
exachk
```

Selon procédure, Oracle Support peut demander des collectes spécifiques.

---

## 12. Cas concret : alerte ventilateur

Situation :

```text
Une alerte ventilateur apparaît sur un composant rack pendant une période de charge normale.
```

Hypothèses :

```text
ventilateur dégradé
capteur défaillant
température locale élevée
incident datacenter
alerte transitoire
risque de throttling
```

Vérifications :

```text
alerte EM
ILOM logs
température
état composant
alert history
événements répétés
impact sur service
```

Conclusion prudente :

```text
Même sans impact applicatif immédiat, une alerte ventilateur doit être qualifiée,
documentée et escaladée selon criticité.
```

---

## 13. Matrice d’impact

| Alerte | Impact potentiel | Action |
|---|---|---|
| Fan warning | Risque thermique | Vérifier ILOM/température |
| PSU failed | Redondance électrique réduite | Escalade matérielle |
| PDU warning | Risque alimentation rack | Vérifier datacenter/support |
| Temperature high | Risque throttling/arrêt | Action urgente |
| Switch port errors | Risque réseau | Corréler réseau/cluster |
| Disk predictive failure | Risque storage | Suivi remplacement |
| ILOM critical | Risque serveur | Ouvrir SR/procédure |

---

## 14. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Ignorer car SQL fonctionne | Risque matériel caché | Qualifier alerte |
| Ne pas distinguer warning/critical | Mauvaise priorité | Lire sévérité |
| Oublier redondance | Risque sous-estimé | Vérifier composant doublé |
| Ne pas horodater | Impossible de corréler | Timeline |
| Ne pas collecter logs | SR incomplet | ILOM/AHF/TFA |
| Confondre capteur et cause | Faux diagnostic | Vérifier composant réel |
| Attendre l’impact applicatif | Trop tard | Traiter préventivement |

---

## 15. Commandes read-only utiles

### ILOM, selon accès

```bash
show /System
show /SP/logs/event/list
show /SYS
```

### CellCLI

```bash
cellcli -e "list alert history detail"
cellcli -e "list physicaldisk attributes name,status,errormessage"
cellcli -e "list cell detail"
```

### Cluster / base

```bash
crsctl stat res -t
asmcmd lsdg
```

### AHF / TFA

```bash
ahfctl status
tfactl print status
tfactl diagcollect -help
```

### OS, selon politique du site

```bash
uptime
date
dmesg | tail
```

---

## 16. Exercice pratique

Une alerte PDU apparaît dans Enterprise Manager.

La base est ouverte, les applications fonctionnent et aucune erreur SQL n’est visible.

Répondez :

1. Pourquoi l’alerte reste importante ?
2. Quels composants vérifiez-vous ?
3. Quelles informations mettez-vous dans la timeline ?
4. Quels outils utilisez-vous ?
5. Quand ouvrez-vous un SR ?
6. Quelle conclusion prudente formulez-vous ?

---

## 17. Corrigé indicatif

L’alerte reste importante car elle peut indiquer une perte de redondance électrique ou un risque datacenter.

Composants à vérifier :

```text
PDU
alimentation
ILOM
EM incident
capteurs
éventuels logs système
```

Timeline :

```text
heure alerte
composant concerné
sévérité
impact ou non
répétition
actions réalisées
```

Outils :

```text
Enterprise Manager
ILOM
AHF/TFA selon procédure
support Oracle
```

Conclusion :

```text
L’absence d’impact SQL ne suffit pas à fermer l’incident.
L’alerte doit être qualifiée avec les preuves matérielles et escaladée
si la redondance ou la sécurité du rack est concernée.
```

---

## 18. À retenir

```text
À retenir
- Exadata dépend aussi de composants non SQL.
- ILOM surveille le matériel serveur.
- PDU et alimentations protègent la disponibilité électrique.
- Ventilation et température peuvent annoncer une panne.
- Les switches et câbles peuvent impacter RAC, cells ou backup.
- Une alerte matérielle doit être horodatée, qualifiée et corrélée.
- La base ouverte ne prouve pas que le rack est sain.
- Les alertes matérielles doivent être traitées préventivement.
```

---

## 19. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle Exadata Database Machine Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Composants rack, administration, surveillance matérielle. |
| [Oracle ILOM Documentation](https://docs.oracle.com/en/servers/management/ilom/) | Gestion out-of-band, logs matériels, capteurs. |
| [Oracle Enterprise Manager Documentation](https://docs.oracle.com/en/enterprise-manager/) | Incidents matériels, targets, alertes. |
| [Oracle Autonomous Health Framework Documentation](https://docs.oracle.com/en/engineered-systems/health-diagnostics/autonomous-health-framework/) | Collecte diagnostic, TFA, Exachk. |
