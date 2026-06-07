# Module 15 — Monitoring Exadata System Software

## 1. Objectif du module

Ce module explique comment surveiller **Exadata System Software** sur une plateforme Oracle Exadata.

L’objectif est de comprendre que la santé Exadata ne dépend pas uniquement d’Oracle Database. Les versions logicielles, les images installées, les alertes CellCLI, les historiques de patching, les firmwares, les composants Storage Server et la cohérence entre nœuds doivent être suivis régulièrement.

À la fin de ce module, le lecteur doit être capable de :

- expliquer le rôle d’Exadata System Software ;
- vérifier les versions installées sur DB servers et Storage Cells ;
- lire `imageinfo` et `imagehistory` ;
- identifier les incohérences de version ;
- lire les alertes Exadata System Software ;
- comprendre les liens entre version, patching, support et diagnostic ;
- utiliser CellCLI pour lire les informations système ;
- préparer une vérification avant patching ;
- éviter de confondre version Oracle Database et version Exadata System Software.

---

## 2. Pourquoi ce sujet est important

Exadata System Software fournit une partie essentielle des capacités Exadata :

```text
Smart Scan
SQL Offload
Storage Index
Flash Cache
Flash Log
IORM
CellCLI
métriques cells
alerthistory
gestion des griddisks
surveillance des physical disks
intégration support Oracle
```

Un problème de version ou d’image peut avoir des impacts sur :

```text
support Oracle
patching
fonctionnalités disponibles
diagnostic
compatibilité
sécurité
performance
stabilité
```

À retenir :

```text
Exadata System Software est aussi important que le matériel.
Une plateforme Exadata saine doit avoir des versions connues, cohérentes et documentées.
```

---

## 3. Exadata System Software — définition

Exadata System Software est l’ensemble logiciel Oracle utilisé sur les composants Exadata pour fournir les fonctions spécifiques à la machine.

Il est principalement visible côté Storage Cells, mais son suivi concerne toute la plateforme.

Composants concernés :

```text
Storage Cells
Database Servers
firmware
drivers
outils Exadata
CellCLI
services système
images logicielles
patch bundles
```

Différence importante :

| Élément | Rôle |
|---|---|
| Oracle Database | Moteur SQL, transactions, instances |
| Grid Infrastructure | Cluster, ASM, ressources RAC |
| Exadata System Software | Fonctionnalités Exadata côté infrastructure et Storage Cells |
| Firmware | Couche matérielle bas niveau |
| OS Image | Image système des nœuds/cells |

---

## 4. Ce qu’il faut surveiller

| Domaine | Ce qu’on vérifie |
|---|---|
| Version | version installée sur chaque composant |
| Image | image courante via `imageinfo` |
| Historique | anciennes images via `imagehistory` |
| Cohérence | mêmes niveaux attendus selon composants |
| Alertes | `alerthistory`, alertes hardware/software |
| Fonctionnalités | Smart Scan, flash, IORM, metrics |
| Support | version supportée, recommandée, compatible |
| Patching | état avant/après patch |
| Firmware | cohérence avec image Exadata |
| Santé cells | statut cell, disks, grid disks, flash |

---

## 5. imageinfo

### 5.1 Rôle

`imageinfo` affiche l’image logicielle installée sur un composant Exadata.

Il permet d’identifier :

```text
version de l’image
date d’installation
type d’image
build
informations système
niveau logiciel courant
```

Commande :

```bash
imageinfo
```

À utiliser sur :

```text
DB servers
Storage Cells
selon droits et procédures du site
```

### 5.2 Lecture attendue

Une sortie `imageinfo` doit être conservée comme preuve dans :

```text
inventaire plateforme
pré-check patching
post-check patching
dossier support
audit de version
```

À retenir :

```text
imageinfo donne l’état courant.
imagehistory donne l’historique.
```

---

## 6. imagehistory

### 6.1 Rôle

`imagehistory` affiche les images précédemment installées.

Il aide à comprendre :

```text
quand une image a été appliquée
quel niveau était installé avant
quelle opération de patching a eu lieu
si plusieurs composants ont été patchés de manière cohérente
```

Commande :

```bash
imagehistory
```

### 6.2 Utilisation

Cas d’usage :

```text
analyse post-incident
préparation rollback
audit patching
comparaison avant/après
vérification de campagne
```

Erreur fréquente :

```text
Regarder uniquement la version actuelle sans vérifier l’historique.
```

---

## 7. Cohérence de version

Une plateforme Exadata doit avoir une cohérence de version selon les règles Oracle et la génération concernée.

À vérifier :

```text
DB servers au niveau attendu
Storage Cells au niveau attendu
patch GI compatible
patch Oracle Home compatible
firmware cohérent
drivers réseau cohérents
outils support à jour
```

Attention :

```text
La cohérence ne veut pas toujours dire que tous les composants ont exactement le même numéro.
Elle signifie que les versions sont compatibles et supportées ensemble.
```

---

## 8. CellCLI et Exadata System Software

CellCLI permet de lire les informations des Storage Cells.

Commandes utiles :

```bash
cellcli -e "list cell detail"
cellcli -e "list cell attributes name,releaseVersion"
cellcli -e "list alert history"
cellcli -e "list metriccurrent"
cellcli -e "list griddisk attributes name,status,asmmodestatus,asmdeactivationoutcome"
cellcli -e "list physicaldisk attributes name,status,errormessage"
```

Ce qu’on cherche :

```text
version cell
statut cell
alertes actives ou historiques
métriques anormales
griddisks dégradés
physical disks en erreur
flash cache dégradé
```

---

## 9. Alert history

### 9.1 Rôle

`alert history` contient les alertes connues par les Storage Cells.

Commande :

```bash
cellcli -e "list alert history detail"
```

À lire :

```text
date
sévérité
composant
message
état
répétition
corrélation avec incident
```

### 9.2 Interprétation

Une alerte peut être :

```text
critique
warning
informative
transitoire
déjà clear
persistante
```

À retenir :

```text
Une alerte historique n’est pas forcément une alerte active.
Mais elle peut expliquer une période d’incident.
```

---

## 10. MetricCurrent et MetricHistory

### 10.1 MetricCurrent

`metriccurrent` donne l’état actuel.

Commande :

```bash
cellcli -e "list metriccurrent"
```

Utilité :

```text
voir les métriques instantanées
identifier une anomalie en cours
croiser avec symptôme immédiat
```

### 10.2 MetricHistory

`metrichistory` permet de regarder l’évolution.

Commande indicative :

```bash
cellcli -e "list metrichistory"
```

Utilité :

```text
analyser une période passée
comparer avec timeline
identifier une anomalie temporaire
```

À retenir :

```text
MetricCurrent répond à “que se passe-t-il maintenant ?”
MetricHistory répond à “que s’est-il passé pendant l’incident ?”
```

---

## 11. Exadata Software et patching

Avant patching, il faut connaître :

```text
image actuelle
historique image
versions Oracle Homes
version GI
état cluster
état cells
alertes existantes
backup disponible
Data Guard si présent
fenêtre validée
plan rollback
```

Commandes read-only utiles :

```bash
imageinfo
imagehistory
opatch lsinventory
crsctl stat res -t
cellcli -e "list cell detail"
cellcli -e "list alert history"
```

À retenir :

```text
On ne prépare pas un patch Exadata sans inventaire logiciel fiable.
```

---

## 12. Exadata Software et support Oracle

Oracle Support peut demander :

```text
imageinfo
imagehistory
exachk
tfactl diagcollect
alerthistory
metric history
opatch lsinventory
logs GI / DB / cell
```

Un bon dossier support contient :

```text
symptôme
impact métier
période
versions
composants concernés
alertes
métriques
actions déjà tentées
logs ciblés
```

---

## 13. Diagnostic de version incohérente

Méthode :

```text
1. Lister les DB servers.
2. Lister les Storage Cells.
3. Exécuter imageinfo selon procédure.
4. Exécuter imagehistory selon procédure.
5. Comparer les niveaux attendus.
6. Vérifier alertes cells.
7. Vérifier GI / Oracle Home.
8. Croiser avec exachk.
9. Documenter les écarts.
10. Ne rien corriger sans procédure de patching.
```

---

## 14. Exemple concret

Situation :

```text
Avant une campagne de patching, l’équipe doit inventorier les images DB nodes et Storage Cells.
```

Démarche :

```text
collecter imageinfo
collecter imagehistory
collecter opatch lsinventory
collecter état cluster
collecter état cells
collecter alert history
exécuter exachk si procédure autorisée
préparer matrice versions / composants
```

Matrice attendue :

| Composant | Hôte | Image actuelle | Historique récent | Alerte | Statut |
|---|---|---|---|---|---|
| DB Server | dbnode01 | à relever | à relever | à relever | OK/KO |
| DB Server | dbnode02 | à relever | à relever | à relever | OK/KO |
| Storage Cell | cell01 | à relever | à relever | à relever | OK/KO |
| Storage Cell | cell02 | à relever | à relever | à relever | OK/KO |

---

## 15. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Confondre version DB et version Exadata Software | Diagnostic faux | Séparer Database, GI, Exadata Software |
| Regarder une seule cell | Incohérence non détectée | Comparer toutes les cells |
| Oublier imagehistory | Perte contexte patch | Lire historique |
| Ignorer alert history | Incident passé invisible | Lire alertes |
| Patcher sans état initial | Pas de preuve avant/après | Capturer pré-check |
| Croire EM suffisant | Agent/target peut masquer | Vérifier localement |
| Corriger sans procédure | Risque production | CAB/runbook Oracle |

---

## 16. Commandes read-only utiles

### Image

```bash
imageinfo
imagehistory
```

### Oracle Home

```bash
opatch lsinventory
```

### Cluster

```bash
crsctl stat res -t
```

### Storage Cells

```bash
cellcli -e "list cell detail"
cellcli -e "list cell attributes name,releaseVersion"
cellcli -e "list alert history detail"
cellcli -e "list metriccurrent"
cellcli -e "list griddisk attributes name,status,asmmodestatus,asmdeactivationoutcome"
cellcli -e "list physicaldisk attributes name,status,errormessage"
```

### AHF / Exachk

```bash
ahfctl status
exachk -v
```

---

## 17. Exercice pratique

Avant une campagne de patching, vous devez vérifier la cohérence logicielle d’une plateforme Exadata.

Répondez :

1. Quelles informations collectez-vous ?
2. Pourquoi `imageinfo` ne suffit pas ?
3. Pourquoi `imagehistory` est utile ?
4. Quelles commandes CellCLI utilisez-vous ?
5. Quelles erreurs faut-il éviter ?
6. Quelle recommandation formulez-vous avant le Go patching ?

---

## 18. Corrigé indicatif

Informations à collecter :

```text
imageinfo sur DB servers et Storage Cells
imagehistory
opatch lsinventory
état CRS
état cells
alert history
métriques cells si incident récent
exachk si autorisé
```

`imageinfo` ne suffit pas parce qu’il donne surtout l’état courant. L’historique permet de comprendre les patchs précédents et les éventuelles incohérences.

CellCLI :

```bash
cellcli -e "list cell detail"
cellcli -e "list cell attributes name,releaseVersion"
cellcli -e "list alert history detail"
cellcli -e "list metriccurrent"
```

Recommandation :

```text
Le Go patching ne doit être donné qu’après inventaire complet,
absence d’alerte bloquante, cohérence de versions, backup validé,
état cluster sain, rapport de pré-check acceptable et rollback documenté.
```

---

## 19. À retenir

```text
À retenir
- Exadata System Software fournit les fonctions spécifiques Exadata.
- imageinfo donne l’image courante.
- imagehistory donne l’historique des images.
- Les versions doivent être cohérentes et supportées ensemble.
- CellCLI permet de lire les informations des Storage Cells.
- Alert history et metrics doivent être reliés à une timeline.
- Un patching fiable commence par un inventaire logiciel fiable.
- EM aide, mais ne remplace pas les vérifications locales.
```

---

## 20. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle Exadata System Software Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/sagug/) | Exadata System Software, CellCLI, metrics, alerts. |
| [Oracle Exadata Database Machine Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Architecture, patching, administration Exadata. |
| [Oracle OPatch Documentation](https://docs.oracle.com/en/enterprise-manager/) | Inventaire Oracle Home et patching. |
| [Oracle Autonomous Health Framework Documentation](https://docs.oracle.com/en/engineered-systems/health-diagnostics/autonomous-health-framework/) | AHF, Exachk, TFA. |
