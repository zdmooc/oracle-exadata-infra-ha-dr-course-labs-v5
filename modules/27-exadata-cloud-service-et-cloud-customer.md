# Module 27 — Exadata Cloud Service et Cloud@Customer

## 1. Objectif du module

Ce module compare **Exadata on-premises**, **Exadata Database Service** et **Exadata Cloud@Customer**.

L’objectif est de comprendre que le savoir-faire Exadata reste utile, mais que les modèles cloud changent les responsabilités, les droits, les outils, la gouvernance IAM, le réseau, le patching et l’escalade support.

À la fin de ce module, le lecteur doit être capable de :

- distinguer Exadata on-prem, Exadata Cloud Service et Cloud@Customer ;
- comprendre le modèle de responsabilité partagée ;
- expliquer VM Cluster, infrastructure Exadata, OCI, IAM et compartiments ;
- identifier ce qui relève du client et ce qui relève d’Oracle ;
- comprendre les impacts sur monitoring, patching et support ;
- préparer une comparaison architecture/exploitation ;
- éviter de raisonner Cloud@Customer comme un simple Exadata on-prem.

---

## 2. Les trois modèles

| Modèle | Description |
|---|---|
| Exadata on-premises | Machine Exadata installée et exploitée chez le client |
| Exadata Database Service | Service Exadata dans OCI |
| Exadata Cloud@Customer | Exadata dans le datacenter client, opéré avec modèle cloud Oracle |

---

## 3. Pourquoi le modèle cloud change l’exploitation

En cloud, il faut tenir compte de :

```text
OCI
IAM
compartiments
policies
VM Cluster
maintenance cloud
fenêtres Oracle
responsabilité partagée
service limits
réseau cloud
monitoring OCI/EM
support Oracle
```

À retenir :

```text
La technologie Exadata reste présente, mais les droits et responsabilités changent.
```

---

## 4. Responsabilité partagée

Le modèle dépend du service, mais la logique générale est :

| Domaine | Client | Oracle |
|---|---|---|
| Données | Responsable | Non propriétaire |
| Schémas/applications | Responsable | Non responsable |
| Comptes DB | Responsable selon modèle | Support selon service |
| Patching infrastructure | Selon modèle | Souvent orchestré par Oracle |
| Infrastructure physique | On-prem : client / Cloud : Oracle | Selon modèle |
| Support hardware | Selon contrat | Oracle |
| IAM OCI | Client | Plateforme OCI |
| Réseau client | Client | Selon frontière |

À retenir :

```text
Avant diagnostic, il faut savoir qui a le droit d’agir sur la couche concernée.
```

---

## 5. VM Cluster

Un VM Cluster représente un cluster de VMs Exadata dans OCI.

Il est lié à :

```text
infrastructure Exadata
réseau
compartiment
DB homes
databases
shape / ressources
maintenance
```

Commandes OCI indicatives :

```bash
oci db cloud-vm-cluster get --cloud-vm-cluster-id <ocid>
oci db vm-cluster list --compartment-id <ocid>
```

---

## 6. IAM OCI

IAM contrôle les accès.

Objets :

```text
users
groups
dynamic groups
policies
compartments
tenancy
permissions
```

Exemple de problème :

```text
Un DBA ne voit pas le VM Cluster parce que la policy IAM ne lui donne pas accès au compartiment.
```

À retenir :

```text
En cloud, un problème d’exploitation peut être un problème de permissions IAM.
```

---

## 7. Réseau en Exadata Cloud

À considérer :

```text
VCN
subnets
security lists
NSG
routing
DNS
FastConnect/VPN
réseau applicatif
réseau backup
Data Guard
```

Symptômes possibles :

```text
application ne se connecte pas
backup lent
Data Guard lag
accès OCI impossible
monitoring incomplet
```

---

## 8. Monitoring

Selon modèle, on peut utiliser :

```text
OCI Console
OCI Monitoring
Enterprise Manager
Database views
Cloud tooling
AHF/TFA selon accès
Service metrics
```

À vérifier :

```text
qui voit quoi
qui administre quoi
où sont les alertes
quels logs sont accessibles
comment ouvrir SR
quelles métriques sont exposées
```

---

## 9. Patching et maintenance

En cloud, les patchs peuvent être :

```text
orchestrés par Oracle
planifiés par fenêtre cloud
déclenchés via console/API selon cas
soumis à contraintes de service
validés par le client côté application
```

Le client doit toujours gérer :

```text
validation applicative
fenêtres métier
tests de connexion
backup logique/métier selon besoin
communication
go/no-go côté métier
```

---

## 10. Cloud@Customer

Cloud@Customer place Exadata dans le datacenter client avec un modèle cloud.

Intérêt :

```text
données sur site
modèle service cloud
latence locale
contraintes réglementaires
opérations partagées
```

Points de vigilance :

```text
frontière responsabilité
réseau client
sécurité physique
connectivité Oracle
fenêtres maintenance
supervision
support
```

---

## 11. Exadata Cloud Service

Exadata Database Service dans OCI apporte :

```text
Exadata dans OCI
provisionnement cloud
VM Cluster
DB homes
bases gérées via OCI
intégration IAM
monitoring OCI
maintenance cloud
```

Points de vigilance :

```text
réseau OCI
compartiments
policies
service limits
coûts
backup
Data Guard
accès admin
```

---

## 12. Comparatif opérationnel

| Sujet | On-prem | Exadata Cloud Service | Cloud@Customer |
|---|---|---|---|
| Localisation | Datacenter client | OCI | Datacenter client |
| IAM OCI | Non central | Oui | Oui |
| Hardware | Client/Oracle selon contrat | Oracle | Oracle selon modèle |
| Réseau | Client | OCI + client | Client + Oracle |
| Patching infra | Client/Oracle selon contrat | Modèle cloud | Modèle cloud |
| Données | Client | Client | Client |
| Supervision | EM/outils client | OCI/EM | OCI/EM selon design |
| Contraintes réglementaires | Fort contrôle local | Cloud public | Données sur site |

---

## 13. Diagnostic : commencer par la frontière

Avant toute analyse, répondre :

```text
le problème est-il database ?
le problème est-il VM Cluster ?
le problème est-il OCI/IAM ?
le problème est-il réseau client ?
le problème est-il infrastructure Oracle ?
le client peut-il agir ?
faut-il ouvrir SR ?
```

Mauvais réflexe :

```text
Chercher une commande OS alors que le problème relève d’OCI/IAM ou d’Oracle.
```

---

## 14. Cas concret

Situation :

```text
Une entreprise hésite entre Exadata on-prem et Cloud@Customer
pour conserver les données sur site tout en déléguant certaines opérations.
```

Analyse :

```text
besoin de souveraineté / localisation
contraintes réseau
modèle opérationnel souhaité
compétences internes
responsabilité patching
monitoring
support
coûts
SLA
sécurité physique
```

Recommandation prudente :

```text
Cloud@Customer est pertinent si les données doivent rester sur site
tout en adoptant un modèle d’exploitation cloud, mais il faut clarifier
les responsabilités Oracle/client et les contraintes de connectivité.
```

---

## 15. Erreurs fréquentes

| Erreur | Pourquoi c’est dangereux | Correction |
|---|---|---|
| Penser cloud = plus rien à gérer | Responsabilités client restantes | Matrice RACI |
| Ignorer IAM | Accès impossible | Vérifier policies |
| Ignorer réseau OCI | Connexions KO | Lire VCN/subnets/routes |
| Confondre C@C et on-prem | Mauvaise gouvernance | Clarifier modèle |
| Oublier validation applicative | Patch infra OK mais métier KO | Tests |
| Oublier support boundary | Perte de temps | Identifier propriétaire |
| Ne pas vérifier coûts/limits | Blocage projet | Capacity/limits |

---

## 16. Commandes read-only utiles

### OCI CLI

```bash
oci db cloud-vm-cluster get --cloud-vm-cluster-id <ocid>
oci db vm-cluster list --compartment-id <ocid>
oci db database list --compartment-id <ocid>
```

### Database / RAC

```bash
crsctl stat res -t
srvctl status database -d <db_unique_name> -v
srvctl status service -d <db_unique_name>
```

### SQL

```sql
select name, open_mode, database_role from v$database;
select inst_id, instance_name, host_name, status from gv$instance;
```

---

## 17. Exercice pratique

Une entreprise veut choisir entre Exadata on-prem, Exadata Cloud Service et Cloud@Customer.

Contraintes :

```text
données sensibles
latence faible avec applications sur site
besoin de déléguer une partie des opérations
équipe DBA réduite
fortes contraintes réseau
```

Répondez :

1. Quels critères comparez-vous ?
2. Quel modèle semble le plus adapté ?
3. Quels risques IAM/réseau identifiez-vous ?
4. Quelle matrice de responsabilité préparez-vous ?
5. Quels points doivent être validés avant décision ?

---

## 18. Corrigé indicatif

Critères :

```text
localisation données
responsabilité patching
réseau
latence
IAM
support
monitoring
coûts
compétences internes
SLA
```

Modèle probable :

```text
Cloud@Customer peut être pertinent si les données doivent rester sur site
et si l’entreprise veut déléguer une partie des opérations.
```

Points à valider :

```text
connectivité Oracle
responsabilités exactes
IAM
monitoring
backup
DR
fenêtres maintenance
coûts
contrats support
```

---

## 19. À retenir

```text
À retenir
- Exadata Cloud ne supprime pas le besoin de comprendre Exadata.
- Le modèle cloud change les responsabilités et les droits.
- IAM OCI devient central.
- VM Cluster est une ressource clé.
- Cloud@Customer garde les données sur site avec modèle cloud.
- Avant diagnostic, identifier la frontière Oracle/client.
- Patching, monitoring et support doivent être clarifiés contractuellement.
```

---

## 20. Références officielles

| Référence | Utilisation |
|---|---|
| [Oracle Exadata Database Service Documentation](https://docs.oracle.com/en-us/iaas/exadatacloud/) | Exadata Database Service, VM Cluster, OCI. |
| [Oracle Exadata Cloud@Customer Documentation](https://docs.oracle.com/en-us/iaas/exadatacloud/index.html) | Cloud@Customer, responsabilités, opérations. |
| [Oracle Cloud Infrastructure IAM Documentation](https://docs.oracle.com/en-us/iaas/Content/Identity/home.htm) | IAM, policies, compartments. |
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Concepts Exadata communs. |
