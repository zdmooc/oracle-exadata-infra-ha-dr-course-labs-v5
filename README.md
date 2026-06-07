# Oracle Exadata Database Machine Administration Workshop — Support de cours français V5

Cette version est la **V5 — finition expert Exadata** du support de cours français consacré à **Oracle Exadata Database Machine Administration Workshop**.

L’objectif du dépôt est de fournir un parcours pédagogique complet, aligné avec l’esprit du workshop officiel Oracle : comprendre les concepts, mais aussi savoir raisonner comme un DBA / exploitant Exadata sur la configuration, le stockage, la performance, la migration, le monitoring, la sauvegarde, la haute disponibilité, la maintenance, le patching et l’écosystème de support.

Cette V5 corrige les limites des versions précédentes :
- suppression des formulations trop génériques ;
- réécriture des modules critiques ;
- structuration du README comme vrai plan de cours ;
- clarification des objectifs opérationnels ;
- maintien d’une approche prudente avec commandes de lecture et de diagnostic ;
- ajout de rapports de validation et d’audit.

Le dépôt tiers suivant reste séparé et peut être utilisé comme complément d’architecture infrastructure / HA / DR :

```text
https://github.com/zdmooc/oracle-infra-architecture-ha-dr-labs
```

---

## 1. Objectif général du cours

À la fin du parcours, le lecteur doit être capable de :

- expliquer ce qu’est Oracle Exadata Database Machine ;
- distinguer une architecture Oracle classique d’une architecture Exadata ;
- comprendre le rôle des Database Servers, Storage Cells, ASM, Grid Infrastructure et du réseau interne RoCE / InfiniBand ;
- comprendre les mécanismes Exadata : Smart Scan, IORM, Storage Index, Flash Cache, Flash Log, HCC ;
- concevoir une lecture technique de la chaîne stockage : physical disk → cell disk → grid disk → ASM disk → diskgroup → fichiers Oracle ;
- lire les principales vues Oracle et commandes CellCLI / ASM en mode diagnostic ;
- comprendre et interpréter les métriques Exadata ;
- comprendre les principes de configuration initiale ;
- comprendre les choix de redondance, layout, capacity planning et sécurité des Storage Cells ;
- concevoir une stratégie de consolidation et de priorisation I/O avec IORM ;
- identifier les principales méthodes de migration vers Exadata ;
- comprendre les méthodes de bulk data loading performantes ;
- surveiller Exadata avec Enterprise Manager, CellCLI, AWR, ASH, AHF, Exachk, TFA, OSWatcher et outils associés ;
- expliquer les enjeux de sauvegarde, recovery, HA/DR et Maximum Availability Architecture ;
- comprendre les opérations de maintenance et de patching multi-couches ;
- comprendre l’Automated Support Ecosystem Oracle ;
- situer Exadata on-premises, Exadata Database Service et Exadata Cloud@Customer.

---

## 2. Positionnement pédagogique

Ce dépôt n’est pas seulement une collection de commandes.

Chaque module doit être lu comme un chapitre de cours structuré :

1. comprendre le concept ;
2. identifier les composants concernés ;
3. comprendre les décisions de configuration ;
4. lire les commandes et vues utiles ;
5. interpréter les résultats ;
6. identifier les erreurs fréquentes ;
7. appliquer le raisonnement à un scénario ;
8. produire une conclusion technique prudente.

Le cours vise deux niveaux complémentaires :

| Niveau | Objectif |
|---|---|
| Compréhension architecture | Savoir expliquer Exadata, ses composants et ses mécanismes. |
| Compétence opérationnelle | Savoir diagnostiquer, vérifier, configurer prudemment, surveiller et choisir une approche adaptée. |

Les commandes fournies sont principalement orientées **lecture**, **diagnostic** et **compréhension**.  
Les actions destructives, de changement ou de production réelle doivent toujours être encadrées par un runbook, une validation d’équipe, une fenêtre de maintenance et les procédures Oracle adaptées.

---

## 3. Compétences visées

### 3.1 Architecture et concepts

Le lecteur doit savoir :

- décrire l’architecture Exadata ;
- expliquer la différence entre compute nodes et storage cells ;
- comprendre le rôle d’ASM et Grid Infrastructure ;
- comprendre le rôle du réseau interne RoCE / InfiniBand ;
- expliquer pourquoi Exadata permet l’offload SQL et Smart Scan.

### 3.2 Configuration initiale et stockage

Le lecteur doit savoir :

- comprendre les décisions de configuration initiale ;
- expliquer le découpage physical disks → cell disks → grid disks ;
- comprendre la relation grid disks → ASM disks → ASM diskgroups ;
- expliquer les choix de redondance NORMAL / HIGH ;
- comprendre les notions de DATA, RECO, DBFS et sparse diskgroup si applicable ;
- comprendre les impacts capacity, performance et résilience.

### 3.3 Storage Servers

Le lecteur doit savoir :

- décrire Exadata Storage Server ;
- expliquer en quoi il diffère d’un stockage traditionnel ;
- utiliser CellCLI en lecture et diagnostic ;
- comprendre physical disk, flash device, cell disk, grid disk, flash cache, flash log ;
- interpréter les états et alertes de Storage Cell ;
- comprendre les bases de sécurité et de gouvernance autour des cells.

### 3.4 Performance Exadata

Le lecteur doit savoir :

- expliquer Smart Scan ;
- lire un plan SQL avec `DBMS_XPLAN`;
- interpréter `cell_offload_eligible_bytes` et `cell_offload_returned_bytes`;
- comprendre Storage Index, HCC, Flash Cache et Direct Path Read ;
- diagnostiquer pourquoi Smart Scan ne s’active pas ;
- comprendre IORM et sa relation avec Database Resource Manager ;
- concevoir une matrice workload / priorité / justification.

### 3.5 Consolidation

Le lecteur doit savoir :

- identifier les options de consolidation ;
- comprendre les risques de noisy neighbor ;
- expliquer l’impact des services, PDB, bases, workloads et fenêtres batch ;
- relier consolidation, IORM, RAC, MAA, monitoring et sauvegarde.

### 3.6 Migration et bulk data loading

Le lecteur doit savoir :

- identifier les approches de migration vers Exadata ;
- comparer RMAN, Data Pump, transportable tablespaces, Data Guard, GoldenGate selon le contexte ;
- choisir une méthode selon volume, downtime, version, criticité et rollback ;
- comprendre le chargement massif avec direct path, external tables, Data Pump, SQL*Loader et DBFS selon les cas.

### 3.7 Monitoring et diagnostic

Le lecteur doit savoir :

- utiliser les métriques internes Exadata ;
- comprendre Enterprise Manager Cloud Control pour Exadata ;
- lire les alertes cells, métriques I/O, réseau et composants ;
- utiliser AWR, ASH, CellCLI, AHF, Exachk, TFA, OSWatcher, imageinfo et imagehistory ;
- produire un diagnostic argumenté.

### 3.8 Backup, HA/DR et MAA

Le lecteur doit savoir :

- comprendre RMAN sur Exadata ;
- comprendre FRA, restore, recovery, validation et tests de restauration ;
- expliquer RAC, Data Guard, Active Data Guard, Broker, FSFO et MAA ;
- relier RPO / RTO aux choix d’architecture.

### 3.9 Maintenance, patching et support

Le lecteur doit savoir :

- comprendre le patching multi-couches : database, Grid Infrastructure, OS, firmware, Exadata System Software ;
- comprendre les prechecks, fenêtres, rollback, validation post-patch ;
- comprendre l’Automated Support Ecosystem ;
- préparer un dossier support Oracle avec preuves, collectes et diagnostics.

### 3.10 Cloud

Le lecteur doit savoir :

- distinguer Exadata on-premises, Exadata Database Service et Exadata Cloud@Customer ;
- comprendre les différences de responsabilité ;
- comprendre ce qui reste commun : architecture, stockage, performance, monitoring, backup et HA/DR.

---

## 4. Parcours recommandé

L’ordre numérique des fichiers est conservé, mais l’ordre pédagogique conseillé est le suivant.

### Bloc 1 — Fondations Exadata

| Module | Fichier | Objectif |
|---:|---|---|
| 00 | `modules/00-introduction-au-workshop-exadata.md` | Comprendre le cadre du workshop et les objectifs généraux. |
| 01 | `modules/01-overview.md` | Obtenir une vue d’ensemble d’Exadata, des cas d’usage et du positionnement. |
| 02 | `modules/02-architecture.md` | Comprendre l’architecture globale : Database Servers, Storage Cells, réseau interne, ASM et Grid Infrastructure. |
| 03 | `modules/03-key-capabilities.md` | Identifier les capacités clés : Smart Scan, offload, IORM, Flash Cache, Storage Index, HCC. |

### Bloc 2 — Planification et configuration initiale

| Module | Fichier | Objectif |
|---:|---|---|
| 04 | `modules/04-site-planning-et-integration-datacenter.md` | Comprendre les prérequis datacenter : réseau, alimentation, racks, intégration et contraintes d’exploitation. |
| 05 | `modules/05-initial-configuration.md` | Comprendre la configuration initiale : choix structurants, réseau, stockage, redondance, layout et décisions amont. |

### Bloc 3 — Stockage Exadata

| Module | Fichier | Objectif |
|---:|---|---|
| 06 | `modules/06-exadata-storage-server-configuration.md` | Comprendre les Storage Cells, CellCLI, physical disks, cell disks, grid disks, Flash Cache, Flash Log, alertes et sécurité. |
| 07 | `modules/07-asm-et-modele-de-stockage.md` | Comprendre ASM sur Exadata : ASM disks, diskgroups, DATA, RECO, DBFS, redondance, failure groups et rebalance. |

### Bloc 4 — Performance, optimisation et consolidation

| Module | Fichier | Objectif |
|---:|---|---|
| 09 | `modules/09-performance-recommendations.md` | Comprendre les recommandations de performance et les points d’attention. |
| 10 | `modules/10-smart-scan.md` | Comprendre Smart Scan, offload SQL, predicate filtering, column projection, Direct Path Read, Storage Index et HCC. |
| 08 | `modules/08-iorm.md` | Comprendre et concevoir IORM : Database Resource Manager, consumer groups, noisy neighbor, priorisation I/O. |
| 11 | `modules/11-consolidation.md` | Comprendre les options de consolidation, les risques et les bonnes pratiques Exadata. |

### Bloc 5 — Migration et chargement massif

| Module | Fichier | Objectif |
|---:|---|---|
| 12 | `modules/12-migration-to-exadata.md` | Comparer les stratégies de migration : RMAN, Data Pump, transportable, Data Guard, GoldenGate, contraintes de downtime et rollback. |
| 13 | `modules/13-bulk-data-loading.md` | Comprendre le chargement massif : direct path, external tables, SQL*Loader, Data Pump, DBFS et impact sur ASM / cells. |

### Bloc 6 — Monitoring et exploitation

| Module | Fichier | Objectif |
|---:|---|---|
| 14 | `modules/14-platform-monitoring-introduction.md` | Poser les bases du monitoring Exadata. |
| 15 | `modules/15-monitoring-exadata-system-software.md` | Surveiller Exadata System Software et les composants logiciels Exadata. |
| 16 | `modules/16-enterprise-manager-cloud-control.md` | Comprendre l’intégration et l’usage d’Enterprise Manager Cloud Control pour Exadata. |
| 17 | `modules/17-monitoring-storage-servers.md` | Diagnostiquer les Storage Servers : cells, disks, flash, alerts, metrics. |
| 18 | `modules/18-monitoring-database-servers.md` | Diagnostiquer les Database Servers, services, CRS, listeners et instances. |
| 19 | `modules/19-monitoring-network.md` | Comprendre le monitoring réseau : client, admin, backup, RoCE / InfiniBand. |
| 20 | `modules/20-monitoring-other-components.md` | Surveiller les autres composants : ILOM, switches, PDU, firmware. |
| 21 | `modules/21-other-monitoring-tools.md` | Utiliser les outils complémentaires : AHF, Exachk, TFA, OSWatcher, AWR, ASH, imageinfo, imagehistory. |

### Bloc 7 — Sauvegarde, continuité et maintenance

| Module | Fichier | Objectif |
|---:|---|---|
| 22 | `modules/22-backup-and-recovery.md` | Comprendre RMAN, FRA, recovery, validation, restore test et RPO/RTO. |
| 23 | `modules/23-ha-dr-et-maa.md` | Comprendre RAC, Data Guard, Active Data Guard, Broker, FSFO et Maximum Availability Architecture. |
| 24 | `modules/24-maintenance-tasks.md` | Comprendre les tâches courantes de maintenance Exadata. |
| 25 | `modules/25-patching.md` | Comprendre le patching Exadata multi-couches, patchmgr, precheck, rollback et validation. |
| 26 | `modules/26-automated-support-ecosystem.md` | Comprendre AHF, Exachk, ORAchk, TFA, ASR et la préparation d’un dossier support Oracle. |

### Bloc 8 — Exadata Cloud

| Module | Fichier | Objectif |
|---:|---|---|
| 27 | `modules/27-exadata-cloud-service-et-cloud-customer.md` | Comparer Exadata on-premises, Exadata Database Service et Exadata Cloud@Customer. |

---

## 5. Modules du dépôt

| Module | Fichier | Titre pédagogique |
|---:|---|---|
| 00 | `modules/00-introduction-au-workshop-exadata.md` | Introduction au workshop Exadata |
| 01 | `modules/01-overview.md` | Vue d’ensemble d’Oracle Exadata |
| 02 | `modules/02-architecture.md` | Architecture Oracle Exadata |
| 03 | `modules/03-key-capabilities.md` | Capacités clés d’Exadata |
| 04 | `modules/04-site-planning-et-integration-datacenter.md` | Site planning et intégration datacenter |
| 05 | `modules/05-initial-configuration.md` | Configuration initiale |
| 06 | `modules/06-exadata-storage-server-configuration.md` | Exadata Storage Server Configuration |
| 07 | `modules/07-asm-et-modele-de-stockage.md` | ASM et modèle de stockage Exadata |
| 08 | `modules/08-iorm.md` | IORM — I/O Resource Management |
| 09 | `modules/09-performance-recommendations.md` | Recommandations de performance |
| 10 | `modules/10-smart-scan.md` | Smart Scan et offload SQL |
| 11 | `modules/11-consolidation.md` | Consolidation sur Exadata |
| 12 | `modules/12-migration-to-exadata.md` | Migration vers Exadata |
| 13 | `modules/13-bulk-data-loading.md` | Chargement massif de données |
| 14 | `modules/14-platform-monitoring-introduction.md` | Introduction au monitoring Exadata |
| 15 | `modules/15-monitoring-exadata-system-software.md` | Monitoring Exadata System Software |
| 16 | `modules/16-enterprise-manager-cloud-control.md` | Enterprise Manager Cloud Control |
| 17 | `modules/17-monitoring-storage-servers.md` | Monitoring des Storage Servers |
| 18 | `modules/18-monitoring-database-servers.md` | Monitoring des Database Servers |
| 19 | `modules/19-monitoring-network.md` | Monitoring réseau |
| 20 | `modules/20-monitoring-other-components.md` | Monitoring des autres composants |
| 21 | `modules/21-other-monitoring-tools.md` | Autres outils de monitoring |
| 22 | `modules/22-backup-and-recovery.md` | Backup and Recovery |
| 23 | `modules/23-ha-dr-et-maa.md` | HA/DR et Maximum Availability Architecture |
| 24 | `modules/24-maintenance-tasks.md` | Tâches de maintenance |
| 25 | `modules/25-patching.md` | Patching Exadata |
| 26 | `modules/26-automated-support-ecosystem.md` | Automated Support Ecosystem |
| 27 | `modules/27-exadata-cloud-service-et-cloud-customer.md` | Exadata Cloud Service et Cloud@Customer |

---

## 6. Rapports et contrôles V5

| Document | Rôle |
|---|---|
| `docs/98-audit-finition-expert-v5.md` | Audit de finition expert V5 et preuves de correction. |
| `docs/99-rapport-completude-final.md` | Rapport final de complétude V5. |
| `v5_validation_report.md` | Rapport technique de validation automatisée. |

---

## 7. Scripts de contrôle

Les scripts doivent rester prudents et orientés diagnostic.

```bash
bash scripts/completeness-check.sh
bash scripts/dangerous-command-detector.sh
```

Selon les besoins, d’autres scripts read-only peuvent être utilisés pour inventorier ou vérifier l’environnement, sans effectuer d’action destructive.

---

## 8. Contrôles recommandés après modification

Après modification d’un module ou du README :

```bash
git status
git diff -- README.md
git diff -- modules/<module>.md
```

Avant commit :

```bash
bash scripts/completeness-check.sh
bash scripts/dangerous-command-detector.sh
```

Commit type :

```bash
git add README.md
git commit -m "docs: rewrite README as operational V5 course plan"
```

---

## 9. Règle de travail interactive

La méthode de travail retenue pour cette V5 est :

```text
1. Lire un fichier.
2. Comprendre son rôle dans le cours.
3. Identifier ce qui est bon.
4. Identifier ce qui est faible.
5. Corriger uniquement le fichier ciblé.
6. Vérifier le diff.
7. Committer.
8. Passer au fichier suivant.
```

Priorité de reprise :

```text
README.md
modules/02-architecture.md
modules/05-initial-configuration.md
modules/06-exadata-storage-server-configuration.md
modules/07-asm-et-modele-de-stockage.md
modules/10-smart-scan.md
modules/08-iorm.md
modules/11-consolidation.md
modules/12-migration-to-exadata.md
modules/13-bulk-data-loading.md
modules/16-enterprise-manager-cloud-control.md
modules/21-other-monitoring-tools.md
modules/22-backup-and-recovery.md
modules/23-ha-dr-et-maa.md
modules/25-patching.md
modules/26-automated-support-ecosystem.md
modules/27-exadata-cloud-service-et-cloud-customer.md
```

---

## 10. État actuel de la V5

Les modules suivants ont déjà été réécrits comme chapitres experts propres :

| Module | Statut |
|---:|---|
| 08 — IORM | Réécriture V5 propre validée |
| 10 — Smart Scan | Réécriture V5 propre validée |

Les autres modules doivent être relus progressivement selon la méthode interactive.

---

## 11. Licence et usage

Ce dépôt est un support de travail pédagogique.  
Les commandes doivent être adaptées à l’environnement réel, à la version Oracle, aux règles d’exploitation, aux licences et aux procédures internes.

Toute opération de production doit être validée par l’équipe DBA, infrastructure, sécurité, production et support Oracle si nécessaire.
