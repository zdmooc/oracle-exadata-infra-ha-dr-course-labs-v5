# Oracle Exadata Database Machine Administration Workshop — Support de cours français V5

Cette version est la **V5 — finition expert Exadata**. Elle remplace l’affichage V4 précédent et rend visible le travail demandé : audit de finition, suppression des formulations génériques ciblées, renforcement des modules critiques et preuves de validation reproductibles.

## Ce que la V5 ajoute réellement

| Axe de finition V5 | Résultat livré |
|---|---|
| Version visible | README, rapport final et audit expert mentionnent explicitement la V5. |
| Audit demandé | Le fichier [`docs/98-audit-finition-expert-v5.md`](docs/98-audit-finition-expert-v5.md) documente les contrôles et les preuves. |
| Modules prioritaires | Les modules architecture, storage, ASM, IORM, Smart Scan, monitoring, backup, HA/DR, patching, support automatisé et cloud contiennent un complément expert V5. |
| Suppression du générique | Les formulations ciblées, dont celles signalées dans IORM, sont retirées des modules. |
| Sécurité | Les commandes restent orientées lecture et diagnostic ; aucune commande destructive active n’est attendue. |

## Modules V5

| Fichier | Titre |
|---|---|
| [00-introduction-au-workshop-exadata.md](modules/00-introduction-au-workshop-exadata.md) | 00 Introduction Au Workshop Exadata |
| [01-overview.md](modules/01-overview.md) | 01 Overview |
| [02-architecture.md](modules/02-architecture.md) | Read-only : inventaire cellule et métriques principales |
| [03-key-capabilities.md](modules/03-key-capabilities.md) | 03 Key Capabilities |
| [04-site-planning-et-integration-datacenter.md](modules/04-site-planning-et-integration-datacenter.md) | 04 Site Planning Et Integration Datacenter |
| [05-initial-configuration.md](modules/05-initial-configuration.md) | 05 Initial Configuration |
| [06-exadata-storage-server-configuration.md](modules/06-exadata-storage-server-configuration.md) | Read-only : chaîne cellule complète |
| [07-asm-et-modele-de-stockage.md](modules/07-asm-et-modele-de-stockage.md) | Read-only : état des diskgroups et disques ASM |
| [08-iorm.md](modules/08-iorm.md) | Read-only : configuration et métriques IORM |
| [09-performance-recommendations.md](modules/09-performance-recommendations.md) | 09 Performance Recommendations |
| [10-smart-scan.md](modules/10-smart-scan.md) | Read-only : métriques cellule associées au scan et à l’I/O |
| [11-consolidation.md](modules/11-consolidation.md) | 11 Consolidation |
| [12-migration-to-exadata.md](modules/12-migration-to-exadata.md) | 12 Migration To Exadata |
| [13-bulk-data-loading.md](modules/13-bulk-data-loading.md) | Read-only : capacité ASM et cellule pendant chargement |
| [14-platform-monitoring-introduction.md](modules/14-platform-monitoring-introduction.md) | 14 Platform Monitoring Introduction |
| [15-monitoring-exadata-system-software.md](modules/15-monitoring-exadata-system-software.md) | 15 Monitoring Exadata System Software |
| [16-enterprise-manager-cloud-control.md](modules/16-enterprise-manager-cloud-control.md) | 16 Enterprise Manager Cloud Control |
| [17-monitoring-storage-servers.md](modules/17-monitoring-storage-servers.md) | 17 Monitoring Storage Servers |
| [18-monitoring-database-servers.md](modules/18-monitoring-database-servers.md) | 18 Monitoring Database Servers |
| [19-monitoring-network.md](modules/19-monitoring-network.md) | 19 Monitoring Network |
| [20-monitoring-other-components.md](modules/20-monitoring-other-components.md) | 20 Monitoring Other Components |
| [21-other-monitoring-tools.md](modules/21-other-monitoring-tools.md) | 21 Other Monitoring Tools |
| [22-backup-and-recovery.md](modules/22-backup-and-recovery.md) | 22 Backup And Recovery |
| [23-ha-dr-et-maa.md](modules/23-ha-dr-et-maa.md) | 23 Ha Dr Et Maa |
| [24-maintenance-tasks.md](modules/24-maintenance-tasks.md) | 24 Maintenance Tasks |
| [25-patching.md](modules/25-patching.md) | 25 Patching |
| [26-automated-support-ecosystem.md](modules/26-automated-support-ecosystem.md) | 26 Automated Support Ecosystem |
| [27-exadata-cloud-service-et-cloud-customer.md](modules/27-exadata-cloud-service-et-cloud-customer.md) | Read-only : commandes locales selon droits disponibles |

## Rapports V5

| Document | Rôle |
|---|---|
| [`docs/98-audit-finition-expert-v5.md`](docs/98-audit-finition-expert-v5.md) | Audit expert V5 demandé et preuves de correction. |
| [`docs/99-rapport-completude-final.md`](docs/99-rapport-completude-final.md) | Rapport final de complétude V5. |
| [`v5_validation_report.md`](v5_validation_report.md) | Rapport technique de validation automatisée. |

