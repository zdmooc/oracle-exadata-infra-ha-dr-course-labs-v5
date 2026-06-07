# Module 26 — Automated Support Ecosystem

## 1. Objectif du module

Ce module explique l’**écosystème de support automatisé Oracle Exadata** : AHF, TFA, Exachk, ORAchk, ASR, SRDC, Service Request, collectes, sanitization et préparation d’un dossier support.

L’objectif est de transformer un incident technique en dossier support clair, horodaté, contextualisé et exploitable.

À la fin de ce module, le lecteur doit être capable de :

- expliquer le rôle d’AHF/TFA/Exachk/ORAchk ;
- comprendre ASR ;
- préparer une Service Request Oracle ;
- collecter les bons logs ;
- formuler impact, symptômes et période ;
- masquer les informations sensibles ;
- éviter une SR sans contexte ;
- relier outils support et diagnostic technique.

---

## 2. Pourquoi cet écosystème est important

Exadata est une plateforme intégrée. En incident, Oracle Support peut demander :

```text
versions
logs database
logs GI
logs ASM
logs cells
alert history
metric history
Exachk
TFA collection
SRDC
impact métier
timeline
```

Un dossier incomplet provoque :

```text
allers-retours
perte de temps
mauvaise priorité
diagnostic retardé
collectes inutiles
```

À retenir :

```text
Le support automatisé accélère le diagnostic seulement si le contexte est clair.
```

---

## 3. Outils et rôles

| Outil | Rôle |
|---|---|
| AHF | Framework de diagnostic Oracle |
| TFA | Collecte traces/logs |
| Exachk | Contrôle santé Exadata |
| ORAchk | Contrôle santé Oracle général |
| ASR | Auto Service Request matériel selon configuration |
| SRDC | Collecte orientée type d’incident |
| EM | Incidents et métriques |
| CellCLI | Alertes et métriques cells |

---

## 4. ASR — Auto Service Request

ASR peut automatiser certaines demandes support matérielles.

Il concerne surtout :

```text
incidents matériels
composants défaillants
signaux automatisés vers support
```

À vérifier :

```text
ASR configuré
connectivité
statut
composants couverts
contacts support
```

Commande indicative selon environnement :

```bash
asr show_status
```

Attention :

```text
ASR ne remplace pas l’analyse d’impact métier.
```

---

## 5. Service Request

Une SR doit contenir :

```text
titre clair
impact métier
sévérité demandée
heure de début
timezone
composants impactés
symptômes observés
changements récents
versions
preuves
logs joints
actions déjà tentées
question posée à Oracle
```

Mauvais exemple :

```text
Exadata lent, merci d’analyser.
```

Bon exemple :

```text
Depuis 22h10 CET, latence paiement x3.
ASH montre attentes cell single block physical read.
cell02 a une alerte disk warning à 22h08.
TFA collecté de 21h50 à 22h40.
Impact : dégradation paiement, pas de panne totale.
```

---

## 6. SRDC

SRDC signifie Service Request Data Collection.

Il s’agit de collectes guidées selon un type de problème.

Exemples :

```text
RAC issue
ASM issue
Data Guard issue
performance issue
backup issue
storage issue
```

Intérêt :

```text
collecte plus ciblée
format attendu par support
moins d’oubli
meilleure qualification
```

---

## 7. TFA dans une SR

TFA doit être ciblé.

À fournir :

```text
période
nœuds
composants
symptôme
timezone
```

Commande d’aide :

```bash
tfactl diagcollect -help
```

Statut :

```bash
tfactl print status
```

À retenir :

```text
Une collecte TFA sans période claire est moins utile.
```

---

## 8. Exachk dans le support

Exachk est utile pour :

```text
état santé Exadata
écarts de bonnes pratiques
pré-check patching
post-check
support case
```

Commande :

```bash
exachk
exachk -v
```

Interprétation :

```text
prioriser les findings
relier chaque finding au risque réel
distinguer critique, warning, information
```

---

## 9. Sanitization

Avant partage externe, vérifier :

```text
mots de passe
tokens
adresses sensibles
noms clients
données métier
chaînes de connexion
certificats
clés privées
```

Principe :

```text
masquer le sensible sans détruire la preuve technique.
```

---

## 10. Préparer une timeline support

La timeline doit contenir :

```text
heure début symptôme
heure fin symptôme
alertes
changements
batchs
backup
bascule
collecte
actions
impact
```

Exemple :

```text
21:55 RMAN start
22:05 début lenteur
22:08 alerte cell02
22:10 hausse waits cell
22:30 retour normal
22:45 TFA collecté
```

---

## 11. Preuves minimales

Une preuve exploitable contient :

```text
commande ou outil
heure
composant
résultat
interprétation
lien avec impact
```

Exemple :

```text
cellcli alert history montre warning cell02 à 22h08.
La lenteur applicative commence à 22h05.
La corrélation temporelle est possible mais pas suffisante :
il faut lire ASH et metrics cells.
```

---

## 12. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| SR sans impact métier | Mauvaise priorisation | Décrire impact |
| Logs sans timeline | Analyse lente | Ajouter chronologie |
| TFA trop large | Trop de bruit | Cibler période |
| Exachk non lu | Findings ignorés | Prioriser |
| ASR considéré suffisant | Pas d’analyse métier | Ajouter contexte |
| Données sensibles non masquées | Risque sécurité | Sanitization |
| Absence de question claire | Support flou | Formuler demande |

---

## 13. Commandes read-only utiles

```bash
ahfctl status
tfactl print status
tfactl diagcollect -help
exachk -v
orachk -v
asr show_status
cellcli -e "list alert history detail"
cellcli -e "list metriccurrent"
crsctl stat res -t
```

---

## 14. Exercice pratique

Un incident storage intermittent doit être transformé en SR Oracle.

Contexte :

```text
lenteur applicative
alertes cell intermittentes
pas de panne complète
incident entre 14h10 et 14h35
impact métier modéré
```

Répondez :

1. Quelle timeline préparez-vous ?
2. Quels outils utilisez-vous ?
3. Quelles preuves joignez-vous ?
4. Que masquez-vous ?
5. Quelle question posez-vous à Oracle Support ?
6. Quelle conclusion prudente formulez-vous ?

---

## 15. Corrigé indicatif

Outils :

```text
TFA
Exachk
CellCLI
ASH/AWR
EM incidents
```

SR :

```text
impact métier
période
timezone
cell concernée
logs joints
alerthistory
metric history
actions réalisées
question au support
```

Question Oracle :

```text
Pouvez-vous confirmer si les alertes cell observées sur la période
sont compatibles avec une dégradation matérielle ou logicielle connue,
et indiquer les actions recommandées ?
```

Conclusion :

```text
La SR doit contenir une hypothèse, des preuves et une demande claire.
Les outils support accélèrent le diagnostic mais ne remplacent pas l’analyse.
```

---

## 16. À retenir

```text
À retenir
- AHF regroupe des outils de diagnostic.
- TFA collecte les traces.
- Exachk contrôle la santé Exadata.
- ASR peut automatiser certains signaux matériels.
- Une SR doit contenir impact, période, preuve et question claire.
- Sanitization protège les informations sensibles.
- Le support automatisé ne remplace pas le raisonnement technique.
```

---

## 17. Références officielles

| Référence | Utilisation |
|---|---|
| [Oracle AHF Documentation](https://docs.oracle.com/en/engineered-systems/health-diagnostics/autonomous-health-framework/) | AHF, TFA, ORAchk, Exachk. |
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Diagnostic Exadata, support. |
| [Oracle Support](https://support.oracle.com/) | Service Request, SRDC, support workflow. |
