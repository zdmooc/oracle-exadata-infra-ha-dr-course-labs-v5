# Rapport final de complétude V5

Ce rapport remplace le rapport V4 précédent. Il atteste que le dépôt correspond maintenant à la **V5 — finition expert Exadata** et non à une simple copie de la V4.

| Contrôle visible | Statut V5 |
|---|---|
| README mentionne V5 | Conforme |
| Section « Modules V5 » présente | Conforme |
| Audit `docs/98-audit-finition-expert-v5.md` présent | Conforme |
| Formulations génériques ciblées supprimées des modules | Conforme après correctif incident |
| Module IORM corrigé | Conforme : les phrases signalées ne sont plus présentes |
| Arborescence V4 conservée | Conforme : la structure pédagogique reste stable |

## Synthèse

La V5 conserve les 28 modules et les labs de la V4, mais ajoute une finition de qualité visible. Les modules prioritaires disposent d’un complément expert V5, et les passages d’introduction génériques ont été remplacés par des explications spécifiques au sujet du module. Les éléments les plus visibles pour GitHub — README, rapport final et audit expert — portent désormais explicitement la marque V5.

## Preuves attendues

Les commandes de contrôle suivantes doivent réussir depuis la racine du dépôt :

```bash
grep -RIn "Support de cours français V4\|Modules V4\|Rapport final de complétude V4" README.md docs modules || true
test -f docs/98-audit-finition-expert-v5.md && echo "audit V5 présent"
grep -RIn "Dans Exadata, une décision prise sur une couche se répercute souvent sur les autres\|Le fonctionnement réel peut être résumé en trois niveaux" modules || true
```

Une V5 correcte ne doit retourner aucune occurrence active des libellés V4 visibles ni des formulations génériques interdites dans les modules.
