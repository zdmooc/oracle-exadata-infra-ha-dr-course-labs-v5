# Module 21 — Other Monitoring Tools

## 1. Objectif du module

Ce module présente les **outils complémentaires de monitoring et de diagnostic Exadata** : AHF, TFA, Exachk, ORAchk, OSWatcher, logs système, rapports de santé et collectes support.

L’objectif est de comprendre que ces outils ne remplacent pas le raisonnement technique. Ils permettent d’accélérer la collecte, de structurer les preuves et de préparer un dossier Oracle Support exploitable.

À la fin de ce module, le lecteur doit être capable de :

- expliquer le rôle d’AHF ;
- distinguer TFA, Exachk, ORAchk et OSWatcher ;
- savoir quand utiliser un rapport de santé ;
- savoir quand collecter des traces ;
- construire une collecte ciblée autour d’une timeline ;
- éviter d’envoyer des logs massifs sans contexte ;
- relier rapport outil, symptôme, composant et impact métier ;
- préparer une synthèse courte pour Oracle Support.

---

## 2. Pourquoi ces outils sont importants

Exadata produit beaucoup de signaux :

```text
alertes database
alertes Grid Infrastructure
alertes ASM
alertes Storage Cells
métriques réseau
logs OS
logs listeners
logs ILOM
rapports Exachk
collectes TFA
incidents Enterprise Manager
```

Sans méthode, ces signaux deviennent du bruit.

Les outils complémentaires aident à :

```text
collecter rapidement
filtrer par période
contrôler la santé
identifier les écarts de configuration
préparer une SR Oracle
comparer avant/après maintenance
documenter une preuve
```

À retenir :

```text
Un outil de diagnostic n’est pas un verdict.
Il fournit des éléments à interpréter.
```

---

## 3. Vue d’ensemble des outils

| Outil | Rôle principal | Usage typique |
|---|---|---|
| AHF | Framework de santé et diagnostic Oracle | Regrouper TFA, Exachk, ORAchk |
| TFA | Trace File Analyzer | Collecter traces autour d’un incident |
| Exachk | Contrôle santé Exadata | Pré-check, post-check, audit |
| ORAchk | Contrôle santé Oracle général | Bonnes pratiques DB/GI |
| OSWatcher | Historique OS | CPU, mémoire, I/O, réseau |
| EM | Supervision centralisée | Incidents, targets, métriques |
| CellCLI | Lecture Storage Cells | Alerts, metrics, disks |
| Logs OS / GI / DB | Preuves détaillées | Diagnostic profond |

---

## 4. AHF — Autonomous Health Framework

### 4.1 Définition

AHF est le framework Oracle qui regroupe plusieurs outils de santé et de diagnostic.

Il peut inclure :

```text
TFA
ORAchk
Exachk
outils de collecte
diagnostics automatisés
```

Commande utile :

```bash
ahfctl status
```

### 4.2 Utilisation

AHF sert à :

```text
vérifier l’état des outils
préparer des collectes
générer des rapports
centraliser certaines fonctions support
```

À retenir :

```text
AHF est le cadre.
TFA et Exachk sont des outils spécialisés dans ce cadre.
```

---

## 5. TFA — Trace File Analyzer

### 5.1 Définition

TFA collecte les traces utiles autour d’un incident.

Il peut collecter :

```text
alert logs database
traces Grid Infrastructure
logs CRS
logs ASM
logs listener
logs OS
diagnostics par période
```

Commandes utiles :

```bash
tfactl print status
tfactl diagcollect -help
```

### 5.2 Méthode correcte

Une collecte TFA doit être ciblée.

À fournir :

```text
période exacte
nœuds concernés
composants concernés
symptôme
impact métier
timezone
```

Mauvaise pratique :

```text
Collecter tout sans période ni description.
```

Bonne pratique :

```text
Collecter autour de la fenêtre d’incident et joindre une timeline.
```

---

## 6. Exachk

### 6.1 Définition

Exachk vérifie la santé et les bonnes pratiques d’une plateforme Exadata.

Il peut signaler :

```text
écarts de configuration
versions à risque
patchs manquants
problèmes de bonnes pratiques
paramètres non recommandés
alertes préventives
```

Commandes utiles :

```bash
exachk -v
exachk
```

### 6.2 Utilisation

Cas d’usage :

```text
pré-check patching
post-check patching
audit santé
préparation SR
revue périodique
validation avant changement
```

À retenir :

```text
Un rapport Exachk doit être lu, priorisé et relié au risque réel.
```

---

## 7. ORAchk

ORAchk est proche d’Exachk mais plus général Oracle.

Il peut être utilisé pour :

```text
database
Grid Infrastructure
RAC
ASM
bonnes pratiques Oracle
```

Différence simplifiée :

| Outil | Orientation |
|---|---|
| Exachk | Spécifique Exadata |
| ORAchk | Oracle Database / GI plus général |

---

## 8. OSWatcher

OSWatcher conserve des métriques OS dans le temps.

Il aide à analyser :

```text
CPU
mémoire
swap
I/O
réseau
load average
pics système
```

Utilité :

```text
incident intermittent
CPU élevé
mémoire saturée
backup lent
erreur réseau
comparaison avant/après
```

À retenir :

```text
OSWatcher est utile quand l’incident est passé et que les métriques instantanées ne suffisent plus.
```

---

## 9. Logs à connaître

| Log / source | Utilité |
|---|---|
| alert.log database | erreurs DB, ORA, événements |
| CRS logs | cluster, ressources, failover |
| ASM logs | diskgroups, rebalance |
| listener logs | connexions, erreurs TNS |
| Cell alert history | alertes Storage Cells |
| OS logs | erreurs système |
| ILOM logs | matériel |
| EM incidents | supervision centralisée |

À retenir :

```text
Les logs doivent être reliés à une timeline.
Sans heure précise, ils sont difficiles à exploiter.
```

---

## 10. Choisir le bon outil

| Situation | Outil prioritaire |
|---|---|
| Préparer patching Exadata | Exachk |
| Incident RAC intermittent | TFA + CRS logs |
| Suspicion storage cell | CellCLI + TFA |
| Incident passé OS | OSWatcher |
| Alerte matériel | EM + ILOM + TFA selon procédure |
| Préparer SR Oracle | TFA + Exachk + synthèse |
| Audit santé périodique | Exachk / ORAchk |
| Supervision continue | Enterprise Manager |

---

## 11. Méthode de diagnostic avec outils

Méthode recommandée :

```text
1. Décrire le symptôme.
2. Définir la période.
3. Identifier les composants.
4. Choisir l’outil adapté.
5. Collecter en read-only.
6. Lire les alertes et métriques.
7. Corréler avec timeline.
8. Séparer faits, hypothèses et décisions.
9. Préparer une recommandation.
10. Ouvrir SR si nécessaire.
```

---

## 12. Préparer un dossier Oracle Support

Un bon dossier contient :

```text
titre clair
impact métier
urgence
période exacte
timezone
composants impactés
versions
symptômes
commandes exécutées
résultats importants
collectes TFA/AHF
rapport Exachk si utile
actions déjà tentées
attente vis-à-vis du support
```

Exemple de résumé :

```text
Entre 22h05 et 22h30 CET, l’application paiement a subi une latence élevée.
Les services RAC sont restés online. ASH montre des attentes cell.
CellCLI indique une latence élevée sur cell02 pendant la même période.
TFA collecté sur dbnode01/dbnode02 pour 21h50-22h45.
Impact : dégradation paiement, pas d’indisponibilité complète.
```

---

## 13. Sanitization

Avant de partager des logs, il peut être nécessaire de masquer :

```text
noms clients
adresses IP publiques
tokens
mots de passe
chaînes de connexion sensibles
noms d’applications confidentiels
données métier
```

À retenir :

```text
La sanitization ne doit pas détruire les informations techniques nécessaires.
```

---

## 14. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Envoyer logs sans contexte | Support inefficace | Ajouter synthèse |
| Collecter toute la machine | Trop de bruit | Cibler période/composants |
| Croire Exachk automatique | Mauvaise priorisation | Lire et interpréter |
| Ignorer timeline | Corrélation impossible | Construire chronologie |
| Confondre outil et diagnostic | Conclusion non prouvée | Relier preuve au symptôme |
| Ne pas masquer données sensibles | Risque sécurité | Sanitization |
| Oublier impact métier | Priorité mal comprise | Décrire impact |

---

## 15. Commandes read-only utiles

### AHF

```bash
ahfctl status
```

### TFA

```bash
tfactl print status
tfactl diagcollect -help
```

### Exachk / ORAchk

```bash
exachk -v
orachk -v
```

### CellCLI

```bash
cellcli -e "list alert history detail"
cellcli -e "list metriccurrent"
```

### CRS

```bash
crsctl stat res -t
```

---

## 16. Exercice pratique

Oracle Support demande des diagnostics après un incident intermittent RAC/storage.

Contexte :

```text
incident entre 02h10 et 02h25
lenteur applicative
attentes cell visibles dans ASH
une alerte cell ancienne existe
pas de panne complète
```

Répondez :

1. Quelle timeline préparez-vous ?
2. Quels outils utilisez-vous ?
3. Que collectez-vous avec TFA ?
4. Quel rôle pour Exachk ?
5. Comment éviter une collecte inutile ?
6. Que mettez-vous dans la SR ?

---

## 17. Corrigé indicatif

Timeline :

```text
02h10 début symptôme
02h12 hausse attentes cell
02h15 batch concurrent éventuel
02h25 retour normal
```

Outils :

```text
TFA pour traces ciblées
CellCLI pour alertes/métriques cells
ASH/AWR pour activité DB
Exachk pour état santé si demandé
OSWatcher pour historique OS si pertinent
```

SR :

```text
impact métier
période
timezone
composants
hypothèses
preuves
collectes jointes
question précise au support
```

Conclusion :

```text
La collecte doit être ciblée sur la période et les nœuds concernés.
TFA accélère la collecte, mais la timeline et l’analyse restent indispensables.
```

---

## 18. À retenir

```text
À retenir
- AHF est le cadre de santé Oracle.
- TFA collecte les traces.
- Exachk contrôle la santé Exadata.
- ORAchk est plus général Oracle.
- OSWatcher aide sur les incidents OS passés.
- Un outil ne remplace pas une hypothèse technique.
- Une SR efficace contient impact, période, preuves et collectes ciblées.
- Les logs doivent être horodatés, contextualisés et éventuellement sanitizés.
```

---

## 19. Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle Autonomous Health Framework Documentation](https://docs.oracle.com/en/engineered-systems/health-diagnostics/autonomous-health-framework/) | AHF, TFA, ORAchk, Exachk. |
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Diagnostic Exadata, CellCLI, support. |
| [Oracle Enterprise Manager Documentation](https://docs.oracle.com/en/enterprise-manager/) | Incidents, métriques, supervision. |
