    # Module 25 — Patching

    ## 1. Objectif pédagogique

    Comprendre le patching Exadata : couches, rolling, pré-check, post-check, rollback et responsabilités. Le chapitre vise une compréhension opérationnelle et théorique : l’étudiant doit pouvoir expliquer le mécanisme, reconnaître les composants impliqués, lire les principales vues ou commandes et résoudre un cas d’école sans modifier l’environnement.

    ## 2. Pourquoi ce sujet est important

    Le patching Exadata couvre plusieurs couches. Un bon chapitre enseigne la logique de séquence et de risque sans fournir de commande destructrice hors procédure officielle.

    Le patching Exadata est une opération de maintenance coordonnée entre database servers, storage cells, Grid Infrastructure, firmware et outils Oracle. Son risque principal est l’incohérence de version ou l’interruption non prévue du service.

    ## 3. Concepts clés expliqués

    | Concept | Définition claire | Exemple concret |
    |---|---|---|
    | **Rolling patch** | Mise à jour progressive limitant l’indisponibilité en traitant les composants un par un lorsque supporté. | Un patch GI rolling garde certains services disponibles. |
| **Pre-check** | Contrôle avant patch : santé cluster, backup, Data Guard, versions et compatibilité. | Un exachk pré-patch révèle un risque à corriger avant Go. |
| **Rollback** | Plan de retour arrière prévu si le patch échoue ou dégrade le service. | La stratégie diffère entre patch DB, GI, OS et image Exadata. |

    Ces concepts doivent être étudiés ensemble. Par exemple, **Rolling patch** n’a pas la même signification isolément que dans une architecture RAC, ASM et storage cells. La compréhension vient de la relation entre objet Oracle, ressource Exadata et workload applicatif.

    ## 4. Architecture concernée

    | Composant | Rôle dans ce chapitre |
    |---|---|
    | Database servers | Exécutent les instances, services, agents et outils Oracle liés au module. |
| Storage cells | Apportent stockage intelligent, flash, offload, alertes ou métriques lorsque le sujet touche les I/O. |
| ASM / Grid Infrastructure | Fournissent cluster, diskgroups, ressources RAC et accès aux fichiers Oracle. |
| Réseau RoCE / InfiniBand | Transporte les échanges internes rapides et peut influencer latence et disponibilité. |
| Outils Oracle | Enterprise Manager, AHF, Exachk, TFA, RMAN ou Data Guard selon le thème étudié. |

    Les diagrammes associés au chapitre sont :

    - [`patching-process.mmd`](../diagrams/patching-process.mmd)

    ## 5. Fonctionnement détaillé

    Le patching Exadata couvre plusieurs couches. Un bon chapitre enseigne la logique de séquence et de risque sans fournir de commande destructrice hors procédure officielle.

    Le fonctionnement se lit par préparation, préchecks, ordre des composants, rolling ou non rolling, validation post-patch et retour arrière. Chaque étape doit produire une preuve vérifiable.

    Pour ce module, les notions centrales sont **Rolling patch, Pre-check, Rollback**. Elles déterminent la façon dont le composant réagit à une charge réelle. Pour le patching, l’analyse commence par l’inventaire de versions et les prérequis. On ne planifie pas une fenêtre sans vérifier compatibilité, santé cluster et sauvegardes. Une mauvaise lecture consiste à supposer que la plateforme corrige automatiquement un mauvais modèle de données, une requête mal écrite ou une architecture réseau incomplète.

    ## 6. Exemple concret

    Une campagne patch trimestrielle doit être préparée pour réduire le risque sur une base critique.

    Dans ce scénario, l’analyse commence par le symptôme métier, puis remonte vers la couche Oracle concernée. Si le sujet touche les I/O, il faut différencier le temps passé dans Oracle Database, les attentes liées aux cells, la distribution ASM et la santé des storage cells. Si le sujet touche la haute disponibilité, il faut distinguer disponibilité locale RAC, continuité de service, sauvegarde et reprise après sinistre.

    ## 7. Commandes, vues et métriques utiles

    Les commandes ci-dessous sont données comme exemples de lecture. Elles doivent être adaptées aux noms de bases, privilèges, versions et conventions du site.

    ```bash
    imageinfo
imagehistory
opatch lsinventory
crsctl stat res -t
exachk
    ```

    | Élément à lire | Interprétation |
    |---|---|
    | Rolling patch | Cette information indique comment le mécanisme Rolling patch se comporte dans un cas réel. Elle doit être lue avec le contexte de charge, de version et d’architecture. |
| Pre-check | Cette information indique comment le mécanisme Pre-check se comporte dans un cas réel. Elle doit être lue avec le contexte de charge, de version et d’architecture. |
| Rollback | Cette information indique comment le mécanisme Rollback se comporte dans un cas réel. Elle doit être lue avec le contexte de charge, de version et d’architecture. |

    ## 8. Interprétation des résultats

    L’interprétation doit répondre à une question technique précise. Une valeur isolée ne suffit pas : une latence se compare à une période comparable, un volume d’I/O se compare à un plan SQL et un état RAC se compare au placement attendu des services. Les métriques Exadata sont particulièrement utiles lorsqu’elles expliquent pourquoi un volume important de données a été lu, filtré, renvoyé ou retardé.

    Dans les chapitres performance, les valeurs liées aux bytes, événements `cell`, AWR ou ASH indiquent le chemin dominant. Dans les chapitres HA/DR, les états de rôle, lag, services et ressources cluster décrivent la capacité réelle à basculer ou maintenir le service. Dans les chapitres support et maintenance, les rapports AHF, Exachk ou TFA doivent être lus comme des aides structurées, pas comme des remplacements de raisonnement.

    ## 9. Erreurs fréquentes

    | Erreur | Cause probable | Correction pédagogique |
    |---|---|---|
    | Confondre symptôme et cause | Le premier message visible vient parfois d’une couche différente de la cause réelle. | Reconstituer le chemin technique avant de conclure. |
    | Appliquer une recette générique | Exadata dépend fortement du workload, du plan SQL, de la version et du modèle de service. | Relire les composants du chapitre et adapter le diagnostic. |
    | Ignorer les dépendances | Une base RAC dépend de GI, ASM, réseau privé et storage cells. | Vérifier les dépendances avant toute hypothèse. |
    | Oublier les limites du mécanisme | Certaines fonctions Exadata ne s’appliquent pas à tous les accès ou toutes les charges. | Identifier les conditions d’éligibilité et les cas d’exclusion. |

    ## 10. Bonnes pratiques

    | Bonne pratique | Application concrète |
    |---|---|
    | Partir du mécanisme | Dessiner le chemin DB → ASM → cell → réseau → retour résultat selon le sujet. |
    | Séparer lecture et changement | Les commandes de lecture servent à comprendre ; les changements exigent runbook et validation. |
    | Comparer avec un état de référence | Une valeur a du sens lorsqu’elle est rapprochée d’une période saine ou d’une cible prévue. |
    | Documenter la version | Les fonctionnalités et commandes peuvent varier selon génération Exadata et version Oracle. |

    ## 11. Exercice pratique

    Vous êtes responsable du sujet **Patching** sur une plateforme Exadata de formation. À partir du scénario suivant, rédigez une analyse de deux pages :

    > Une campagne patch trimestrielle doit être préparée pour réduire le risque sur une base critique.

    Votre réponse doit inclure un schéma simple des composants impliqués, trois commandes ou vues à exécuter, deux métriques à lire, les erreurs à éviter et une recommandation finale.

    ## 12. Corrigé de l’exercice

    Une bonne réponse commence par identifier les composants du chapitre : **Rolling patch, Pre-check, Rollback**. Elle explique ensuite le chemin technique suivi par l’opération et indique pourquoi les commandes proposées permettent de vérifier ce chemin. Les commandes attendues sont celles de la section 7, adaptées aux noms réels de l’environnement.

    Le corrigé doit aussi distinguer les observations et les décisions. Par exemple, constater un lag, une alerte cell, un volume `eligible bytes` ou une ressource CRS offline ne suffit pas : il faut expliquer la conséquence sur l’application, la disponibilité ou la performance.  : optimisation SQL, ajustement de plan de ressources, revue réseau, ouverture SR, test de restore ou préparation CAB selon le module.

    ## 13. Synthèse à retenir

    ```text
    À retenir
    - Patching  : base, cluster, ASM, storage cells, réseau et outils Oracle.
    - Les notions centrales du chapitre sont : Rolling patch, Pre-check, Rollback.
    - Les commandes de lecture permettent de comprendre le mécanisme avant toute action de changement.
    - Les erreurs les plus coûteuses viennent d’une lecture isolée d’une seule couche.
    - Un bon administrateur Exadata relie toujours architecture, workload, métriques et impact métier.
    ```




## Rectification V5 vérifiable — contenu expert non générique

Cette section constitue la correction V5 visible du module. Elle remplace l’approche répétitive par un raisonnement propre au thème **Patching Exadata**. L’objectif n’est pas d’ajouter une phrase de méthode, mais de montrer comment un administrateur Exadata produit une preuve technique exploitable devant une équipe production, architecture ou support.

| Élément expert V5 | Application concrète au module |
|---|---|
| Objets à nommer explicitement | préchecks, versions, rolling patch, cells, GI, rollback, CAB. |
| Méthode de diagnostic | transformer le patch en procédure contrôlée avec preuves go/no-go. |
| Cas d’école attendu | un patch réussi techniquement peut être rejeté si les validations post-change sont absentes. |
| Preuve minimale | Une commande ou vue read-only, une métrique datée, un composant identifié et une interprétation liée au risque métier. |
| Limite de conclusion | Une mesure isolée ne suffit pas ; elle doit être reliée à la période, au workload, à la version Exadata et à l’objectif de service. |

### Raisonnement attendu en situation réelle

Pour **Patching Exadata**, le diagnostic commence par une hypothèse précise et réfutable. L’administrateur doit formuler ce qu’il cherche à prouver : saturation, mauvais placement, absence d’offload, contention entre workloads, défaut de redondance, fenêtre de maintenance insuffisante ou frontière de responsabilité cloud. Ensuite, il collecte uniquement des preuves read-only. Cette discipline évite deux erreurs fréquentes : modifier une plateforme stable sans preuve et confondre un symptôme visible avec la cause racine.

Le livrable attendu dans un contexte professionnel est une courte note technique. Elle doit contenir le symptôme, l’heure, les objets Exadata concernés, les commandes utilisées, les résultats observés, l’interprétation et la prochaine action. Si une modification est proposée, elle doit être séparée du diagnostic et rattachée à un runbook, une validation CAB ou une procédure de support Oracle.

### Exercice V5 complémentaire

Rédigez une analyse opérationnelle pour le cas suivant : **un patch réussi techniquement peut être rejeté si les validations post-change sont absentes**. Votre réponse doit citer les objets Exadata concernés, indiquer trois preuves read-only, expliquer ce qui invaliderait votre hypothèse et proposer une recommandation limitée au périmètre du module.

### Corrigé V5 complémentaire

Une bonne réponse identifie d’abord le composant dominant du sujet **Patching Exadata**, puis relie les preuves à un impact mesurable. Les trois preuves doivent couvrir au moins deux couches différentes lorsque le sujet l’exige, par exemple base et cell, cluster et réseau, ou cloud et VM cluster. La recommandation est correcte seulement si elle indique ce qui est prouvé, ce qui reste incertain et quelle action peut être engagée sans créer un risque supérieur au problème initial.

## Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle University — Exadata Database Machine Administration Workshop](https://education.oracle.com/exadata-database-machine-administration-workshop/courP_4599) | Cadre pédagogique général du workshop. |
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Administration Exadata, Storage Server, CellCLI, maintenance et monitoring. |
| [Oracle Database Documentation](https://docs.oracle.com/en/database/) | Vues dynamiques, SQL, RMAN, Data Guard, AWR/ASH selon licences. |
| [Oracle Maximum Availability Architecture](https://www.oracle.com/database/technologies/high-availability/maa.html) | Principes HA/DR, Data Guard, sauvegarde et continuité de service. |
| [Oracle Autonomous Health Framework](https://docs.oracle.com/en/engineered-systems/health-diagnostics/autonomous-health-framework/) | AHF, Exachk, ORAchk, TFA et diagnostics automatisés. |
## Complément expert V5 — Patching Exadata sans perte de contrôle

### Explication technique spécifique

Le patching Exadata concerne plusieurs couches : database home, Grid Infrastructure, Exadata System Software des cellules, firmware, OS des database servers, switches et agents. Le risque principal n’est pas seulement l’échec d’un patch ; c’est l’incohérence temporaire entre couches ou l’absence de plan de retour. Un patch rolling peut maintenir le service, mais seulement si RAC, services, redondance ASM, capacité restante et procédures sont vérifiés.[^v5-patching]

```mermaid
flowchart TD
    PRE[Pré-checks] --> GI[Grid Infrastructure]
    PRE --> DB[Database Homes]
    PRE --> CELL[Storage Cells]
    CELL --> ONE[Une cellule à la fois]
    GI --> RAC[RAC rolling]
    ONE --> POST[Post-checks]
    RAC --> POST
    POST --> DOC[Validation et preuves]
```

### Exemple concret réaliste

Avant de patcher une cellule, on vérifie que les diskgroups peuvent tolérer l’indisponibilité temporaire de ses grid disks. Pendant l’intervention, ASM peut resynchroniser après retour. Si une autre cellule est déjà dégradée, continuer le patch peut transformer une maintenance en incident. La fenêtre de patching doit donc intégrer l’état réel, pas seulement le calendrier.

### Comment raisonner

Le raisonnement patching part des prérequis : backups, état RAC, état ASM, absence de panne matérielle, versions actuelles, compatibilité et plan de rollback. Ensuite on ordonne les couches selon la procédure Oracle. Enfin on valide : versions, alertes, services, instances, diskgroups et performance de base.

### Commandes / vues utiles

```bash
opatch lsinventory
crsctl stat res -t
srvctl status database -d <DB_UNIQUE_NAME>
asmcmd lsdg
cellcli -e "list cell attributes name,releaseVersion,status"
cellcli -e "list alerthistory attributes severity,alertMessage,beginTime"
```

### Comment interpréter

Une commande de version réussie n’est pas une validation complète. Il faut vérifier l’état fonctionnel des services, l’absence d’alertes critiques, la capacité ASM et les symptômes post-maintenance. Une différence de version peut être attendue pendant rolling patch, mais elle doit être temporaire et documentée.

### Exercice pratique

Pourquoi faut-il vérifier ASM avant de patcher une storage cell ?

### Corrigé détaillé

Parce que le patch rendra potentiellement indisponibles des grid disks de cette cellule. ASM doit disposer de redondance et de capacité suffisantes pour maintenir les fichiers accessibles. Si un autre failure group est déjà dégradé, le patch augmente le risque. La réponse correcte relie patch cellule, grid disks, failure groups et disponibilité des fichiers.

### Limites et pièges

Ne pas patcher pour “tester” en production. Ne pas ignorer les alertes hardware avant maintenance. Ne pas confondre rolling avec sans impact : les performances peuvent baisser pendant la fenêtre.

### À retenir

Le patching Exadata est une opération de cohérence multi-couches. Les preuves avant et après patch comptent autant que la commande de patch elle-même.

[^v5-patching]: Oracle, *Oracle Exadata Database Machine Maintenance Guide*, https://docs.oracle.com/en/engineered-systems/exadata-database-machine/dbmmn/
