# Fiche questions-réponses — Module 15 — Monitoring Exadata System Software

## Objectif de la fiche

Réviser le module **15 — Monitoring Exadata System Software** sous forme de questions-réponses opérationnelles.

Cette fiche sert à vérifier la compréhension, préparer un entretien technique, animer un atelier ou contrôler un runbook Exadata.

## Questions-réponses

### Q01. Quel est l’objectif principal du module 15 ?

surveiller les versions, images, historiques, alertes et cohérence d’Exadata System Software.

### Q02. Pourquoi ce sujet est-il important sur Exadata ?

Une incohérence de version ou un historique de patch mal compris complique support, diagnostic et patching.

### Q03. Quels sont les concepts clés à connaître ?

Les concepts clés sont : **Exadata System Software**, **imageinfo**, **imagehistory**, **CellCLI**, **releaseVersion**, **Alerthistory**, **Exachk**.

### Q04. Quels composants Exadata sont concernés ?

Les composants concernés sont : DB nodes, Storage Cells, Oracle Homes, Grid Infrastructure, firmware, AHF/Exachk.

### Q05. Que faut-il retenir sur **Exadata System Software** ?

**Exadata System Software** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q06. Que faut-il retenir sur **imageinfo** ?

**imageinfo** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q07. Que faut-il retenir sur **imagehistory** ?

**imagehistory** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q08. Que faut-il retenir sur **CellCLI** ?

**CellCLI** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q09. Que faut-il retenir sur **releaseVersion** ?

**releaseVersion** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q10. Que faut-il retenir sur **Alerthistory** ?

**Alerthistory** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q11. Que faut-il retenir sur **Exachk** ?

**Exachk** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q12. Quelle est la première question à poser avant de diagnostiquer ?

La première question est : **quel symptôme exact observe-t-on, sur quelle période, pour quel service ou workload, et avec quel impact métier ?** Sans cette précision, les métriques sont difficiles à interpréter.

### Q13. Pourquoi faut-il construire une timeline ?

La timeline permet de relier les symptômes, alertes, changements, batchs, backups, métriques et actions. Elle évite d’attribuer à tort une cause visible mais non corrélée.

### Q14. Quelle différence entre symptôme, métrique et cause racine ?

Le symptôme est ce que l’utilisateur ou l’application observe. La métrique est une mesure technique. La cause racine est l’origine démontrée du problème. Une métrique élevée ou une alerte ne suffit pas à prouver la cause.

### Q15. Quelles commandes ou vues read-only sont utiles ?

```bash
imageinfo
imagehistory
opatch lsinventory
cellcli -e "list cell attributes name,releaseVersion"
cellcli -e "list alert history detail"
```

### Q16. Comment interpréter les résultats des commandes ?

Chaque résultat doit être comparé à une baseline, à la période de l’incident, aux autres composants de la plateforme et au comportement attendu du workload. Une valeur isolée n’est pas une preuve suffisante.

### Q17. Quelle erreur fréquente faut-il éviter ?

L’erreur fréquente est de **confondre version Oracle Database et version Exadata System Software.**. La correction consiste à revenir à la méthode : symptôme → période → composants → preuves read-only → interprétation → décision.

### Q18. Quel cas pratique illustre le module ?

Avant patching, l’équipe doit inventorier les images DB nodes et Storage Cells.

### Q19. Quelle démarche appliquer dans ce cas pratique ?

La démarche consiste à qualifier le symptôme, identifier les composants concernés, exécuter uniquement des commandes read-only, comparer les résultats à la baseline, formuler les hypothèses rejetées et conclure avec prudence.

### Q20. Quels éléments doivent apparaître dans une note technique ?

Une note technique doit contenir : contexte, impact métier, période, composants concernés, commandes exécutées, résultats observés, interprétation, hypothèses rejetées, risques, recommandation et prochaine action.

### Q21. Quand faut-il ouvrir une SR Oracle ou escalader ?

Il faut escalader lorsqu’une alerte critique, une dégradation persistante, une incohérence de version, un risque de disponibilité ou une anomalie matérielle dépasse le périmètre d’action local ou nécessite confirmation Oracle.

### Q22. Quelle est la différence entre observation et décision ?

Une observation décrit un fait mesuré. Une décision engage une action. Entre les deux, il faut une interprétation validée, un risque évalué et, si nécessaire, un runbook ou une validation CAB.

### Q23. Comment prouver que le diagnostic est solide ?

Un diagnostic solide associe au moins une période, un composant nommé, une commande ou vue read-only, une métrique interprétée, une comparaison à l’attendu et une conséquence métier.

### Q24. Quels mots-clés faut-il savoir expliquer oralement ?

Exadata System Software, imageinfo, imagehistory, CellCLI, releaseVersion, Alerthistory, Exachk.

### Q25. Quelle phrase de synthèse retenir ?

Le module **15 — Monitoring Exadata System Software** doit être abordé avec une logique de preuve : comprendre les composants, lire les métriques pertinentes, corréler avec le workload et ne conclure qu’après validation technique.

## Mini-test

- Expliquez **Exadata System Software** en une phrase et donnez une preuve read-only associée.

- Expliquez **imageinfo** en une phrase et donnez une preuve read-only associée.

- Expliquez **imagehistory** en une phrase et donnez une preuve read-only associée.

- Expliquez **CellCLI** en une phrase et donnez une preuve read-only associée.

- Expliquez **releaseVersion** en une phrase et donnez une preuve read-only associée.

- Appliquez la méthode au cas suivant : **Avant patching, l’équipe doit inventorier les images DB nodes et Storage Cells.**


## À retenir

```text

Module 15 — Monitoring Exadata System Software

- Toujours partir du symptôme et de la période.

- Toujours nommer les composants concernés.

- Toujours préférer les preuves read-only avant toute action.

- Toujours comparer avec une baseline ou un état attendu.

- Toujours distinguer observation, hypothèse, décision et changement.

```
