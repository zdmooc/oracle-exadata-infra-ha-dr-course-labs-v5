    # Module 01 — Overview

    ## 1. Objectif pédagogique

    Présenter la vue d’ensemble Exadata, ses composants et ses usages typiques en production. Le chapitre vise une compréhension opérationnelle et théorique : l’étudiant doit pouvoir expliquer le mécanisme, reconnaître les composants impliqués, lire les principales vues ou commandes et résoudre un cas d’école sans modifier l’environnement.

    ## 2. Pourquoi ce sujet est important

    L’overview explique pourquoi Exadata est adapté aux bases critiques, entrepôts de données, consolidation et environnements hybrides. Sa valeur vient de l’intégration entre calcul, stockage et réseau.

    Le sujet **01 Overview** doit être traité comme un mécanisme Exadata précis : l’objectif est d’identifier les composants concernés, les métriques qui prouvent le comportement et les limites qui empêchent une conclusion hâtive.

    ## 3. Concepts clés expliqués

    | Concept | Définition claire | Exemple concret |
    |---|---|---|
    | **Database Server** | Serveur qui exécute Oracle Database, les instances RAC, les services applicatifs, Grid Infrastructure et les agents. | Un rack peut contenir plusieurs DB servers hébergeant plusieurs bases consolidées. |
| **Storage Cell** | Serveur de stockage intelligent exécutant Exadata System Software, CellCLI, flash cache, offload SQL et métriques I/O. | Une requête Smart Scan peut être traitée partiellement dans les cells. |
| **Scale-out** | Capacité d’augmenter la puissance en ajoutant des nœuds ou cellules selon le modèle Exadata. | Plusieurs storage cells répartissent les I/O et la capacité ASM. |

    Ces concepts doivent être étudiés ensemble. Par exemple, **Database Server** n’a pas la même signification isolément que dans une architecture RAC, ASM et storage cells. La compréhension vient de la relation entre objet Oracle, ressource Exadata et workload applicatif.

    ## 4. Architecture concernée

    | Composant | Rôle dans ce chapitre |
    |---|---|
    | Database servers | Exécutent les instances, services, agents et outils Oracle liés au module. |
| Storage cells | Apportent stockage intelligent, flash, offload, alertes ou métriques lorsque le sujet touche les I/O. |
| ASM / Grid Infrastructure | Fournissent cluster, diskgroups, ressources RAC et accès aux fichiers Oracle. |
| Réseau RoCE / InfiniBand | Transporte les échanges internes rapides et peut influencer latence et disponibilité. |
| Outils Oracle | Enterprise Manager, AHF, Exachk, TFA, RMAN ou Data Guard selon le thème étudié. |

    Les diagrammes associés au chapitre sont :

    - [`architecture-globale-exadata.mmd`](../diagrams/architecture-globale-exadata.mmd)
- [`rack-db-servers-storage-cells.mmd`](../diagrams/rack-db-servers-storage-cells.mmd)

    ## 5. Fonctionnement détaillé

    L’overview explique pourquoi Exadata est adapté aux bases critiques, entrepôts de données, consolidation et environnements hybrides. Sa valeur vient de l’intégration entre calcul, stockage et réseau.

    Le fonctionnement de **01 Overview** se lit en reliant la base Oracle, Grid Infrastructure, ASM, les storage cells, le réseau privé et les outils de support uniquement lorsque ces couches interviennent réellement dans le scénario étudié.

    Pour ce module, les notions centrales sont **Database Server, Storage Cell, Scale-out**. Elles déterminent la façon dont le composant réagit à une charge réelle. Pour **01 Overview**, l’analyse commence par une hypothèse technique testable, puis par des preuves read-only qui confirment ou écartent cette hypothèse. Une mauvaise lecture consiste à supposer que la plateforme corrige automatiquement un mauvais modèle de données, une requête mal écrite ou une architecture réseau incomplète.

    ## 6. Exemple concret

    Une DSI compare un RAC sur SAN et Exadata pour une plateforme décisionnelle avec forte volumétrie et exigences de disponibilité.

    Dans ce scénario, l’analyse commence par le symptôme métier, puis remonte vers la couche Oracle concernée. Si le sujet touche les I/O, il faut différencier le temps passé dans Oracle Database, les attentes liées aux cells, la distribution ASM et la santé des storage cells. Si le sujet touche la haute disponibilité, il faut distinguer disponibilité locale RAC, continuité de service, sauvegarde et reprise après sinistre.

    ## 7. Commandes, vues et métriques utiles

    Les commandes ci-dessous sont données comme exemples de lecture. Elles doivent être adaptées aux noms de bases, privilèges, versions et conventions du site.

    ```bash
    crsctl stat res -t
srvctl status database -d <db_unique_name> -v
select instance_name,status,host_name from gv$instance;
    ```

    | Élément à lire | Interprétation |
    |---|---|
    | Database Server | Cette information indique comment le mécanisme Database Server se comporte dans un cas réel. Elle doit être lue avec le contexte de charge, de version et d’architecture. |
| Storage Cell | Cette information indique comment le mécanisme Storage Cell se comporte dans un cas réel. Elle doit être lue avec le contexte de charge, de version et d’architecture. |
| Scale-out | Cette information indique comment le mécanisme Scale-out se comporte dans un cas réel. Elle doit être lue avec le contexte de charge, de version et d’architecture. |

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

    Vous êtes responsable du sujet **Overview** sur une plateforme Exadata de formation. À partir du scénario suivant, rédigez une analyse de deux pages :

    > Une DSI compare un RAC sur SAN et Exadata pour une plateforme décisionnelle avec forte volumétrie et exigences de disponibilité.

    Votre réponse doit inclure un schéma simple des composants impliqués, trois commandes ou vues à exécuter, deux métriques à lire, les erreurs à éviter et une recommandation finale.

    ## 12. Corrigé de l’exercice

    Une bonne réponse commence par identifier les composants du chapitre : **Database Server, Storage Cell, Scale-out**. Elle explique ensuite le chemin technique suivi par l’opération et indique pourquoi les commandes proposées permettent de vérifier ce chemin. Les commandes attendues sont celles de la section 7, adaptées aux noms réels de l’environnement.

    Le corrigé doit aussi distinguer les observations et les décisions. Par exemple, constater un lag, une alerte cell, un volume `eligible bytes` ou une ressource CRS offline ne suffit pas : il faut expliquer la conséquence sur l’application, la disponibilité ou la performance. La recommandation finale doit rester proportionnée : optimisation SQL, ajustement de plan de ressources, revue réseau, ouverture SR, test de restore ou préparation CAB selon le module.

    ## 13. Synthèse à retenir

    ```text
    À retenir
    - Overview fait partie d’un ensemble Exadata intégré : base, cluster, ASM, storage cells, réseau et outils Oracle.
    - Les notions centrales du chapitre sont : Database Server, Storage Cell, Scale-out.
    - Les commandes de lecture permettent de comprendre le mécanisme avant toute action de changement.
    - Les erreurs les plus coûteuses viennent d’une lecture isolée d’une seule couche.
    - Un bon administrateur Exadata relie toujours architecture, workload, métriques et impact métier.
    ```


## Références officielles

| Référence | Utilisation dans le module |
|---|---|
| [Oracle University — Exadata Database Machine Administration Workshop](https://education.oracle.com/exadata-database-machine-administration-workshop/courP_4599) | Cadre pédagogique général du workshop. |
| [Oracle Exadata Documentation](https://docs.oracle.com/en/engineered-systems/exadata-database-machine/) | Administration Exadata, Storage Server, CellCLI, maintenance et monitoring. |
| [Oracle Database Documentation](https://docs.oracle.com/en/database/) | Vues dynamiques, SQL, RMAN, Data Guard, AWR/ASH selon licences. |
| [Oracle Maximum Availability Architecture](https://www.oracle.com/database/technologies/high-availability/maa.html) | Principes HA/DR, Data Guard, sauvegarde et continuité de service. |
| [Oracle Autonomous Health Framework](https://docs.oracle.com/en/engineered-systems/health-diagnostics/autonomous-health-framework/) | AHF, Exachk, ORAchk, TFA et diagnostics automatisés. |

