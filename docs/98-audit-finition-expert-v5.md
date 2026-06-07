# Audit de finition expert V5

Ce document existe pour répondre explicitement à l’exigence `docs/98-audit-finition-expert-v5.md`. Il formalise les corrections apportées après l’incident où le dépôt publié affichait encore des marqueurs V4 et où certains modules conservaient des paragraphes génériques.

## Verdict de l’audit

| Point contrôlé | État avant correctif | État V5 corrigé |
|---|---|---|
| README | Affichait encore « Support de cours français V4 » et « Modules V4 ». | Affiche « Support de cours français V5 » et « Modules V5 ». |
| Rapport final | Intitulé « Rapport final de complétude V4 ». | Intitulé « Rapport final de complétude V5 ». |
| Fichier demandé | `docs/98-audit-finition-expert-v5.md` absent. | Fichier présent avec preuves de contrôle. |
| Module IORM | Conservait des formulations génériques signalées. | Introduction et fonctionnement détaillé réécrits spécifiquement autour de DBRM, IORM plan, cells, métriques `cell%` et workloads concurrents. |
| Module Smart Scan | Conservait une structure générique avec compléments visibles ajoutés en fin de fichier. | Module 10 réécrit comme chapitre autonome : offload SQL, predicate filtering, column projection, Direct Path Read, Storage Index, HCC, vues `v$sql`, statistiques `cell physical IO%`, erreurs fréquentes et exercice corrigé. |
| Formulations ciblées | Certaines phrases restaient présentes dans les modules. | Les phrases ciblées sont supprimées des modules. |

## Formulations explicitement bannies du contenu actif des modules

Les phrases suivantes ne doivent plus apparaître dans les fichiers `modules/*.md` :

| Formulation interdite | Raison |
|---|---|
| « Dans Exadata, une décision prise sur une couche se répercute souvent sur les autres » | Phrase trop générale, répétitive et non spécifique au module. |
| « Le fonctionnement réel peut être résumé en trois niveaux » | Structure générique répliquée d’un module à l’autre. |
| « Une bonne lecture technique consiste à comprendre d’abord le chemin » | Formulation abstraite qui remplace une explication concrète. |
| « Les commandes doivent être adaptées au contexte » | Avertissement utile mais trop vague s’il n’est pas rattaché aux objets Exadata réels. |
| « La recommandation finale doit rester proportionnée » | Conclusion générique insuffisante pour un cours expert. |

## Contrôle spécifique IORM

Le module [`modules/08-iorm.md`](../modules/08-iorm.md) doit maintenant expliquer directement que **IORM agit dans les storage cells** pour arbitrer l’accès aux ressources I/O entre workloads concurrents. Le raisonnement attendu relie **Database Resource Manager**, **consumer groups**, **plan IORM actif**, **métriques CellCLI**, **événements `cell%`**, et impact sur les bases OLTP, reporting ou batch.

## Contrôle spécifique Smart Scan

Le module [`modules/10-smart-scan.md`](../modules/10-smart-scan.md) doit maintenant être un chapitre complet et non une base courte enrichie par appendice. Sa structure active contient seize sections principales : objectif pédagogique, importance Exadata, concepts clés, architecture, fonctionnement détaillé, comparaison scan classique versus Smart Scan, commandes, interprétation des métriques, causes d’absence d’offload, erreurs fréquentes, bonnes pratiques, scénario, exercice, corrigé, synthèse et références officielles.

Le raisonnement attendu relie **Smart Scan**, **offload SQL**, **predicate filtering**, **column projection**, **Direct Path Read**, **Storage Index**, **HCC**, opérations `TABLE ACCESS STORAGE FULL`, vues `v$sql`, colonnes `cell_offload_eligible_bytes` et `cell_offload_returned_bytes`, statistiques `cell physical IO%`, et événements `cell smart table scan`.

## Commandes de preuve reproductibles

Depuis la racine du dépôt, les commandes suivantes permettent de vérifier la V5 :

```bash
grep -RIn "Support de cours français V4\|Modules V4\|Rapport final de complétude V4" README.md docs modules || true
test -f docs/98-audit-finition-expert-v5.md && echo "audit V5 présent"
grep -RIn "Dans Exadata, une décision prise sur une couche se répercute souvent sur les autres\|Le fonctionnement réel peut être résumé en trois niveaux\|Une bonne lecture technique consiste à comprendre d’abord le chemin" modules || true
grep -nE "IORM|DBRM|consumer|cellcli|cell%|workload" modules/08-iorm.md
grep -nE "Smart Scan|offload|predicate|projection|Direct Path Read|Storage Index|cell_offload_eligible_bytes|cell_offload_returned_bytes|cell smart table scan" modules/10-smart-scan.md
```

Une sortie conforme montre le fichier d’audit présent, aucune occurrence des libellés V4 visibles, aucune occurrence des formulations interdites dans les modules, plusieurs lignes IORM spécifiques dans le module 08, et plusieurs lignes Smart Scan spécifiques dans le module 10.
