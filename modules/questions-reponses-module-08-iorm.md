# Fiche questions-réponses — Module 08 — IORM

## Objectif de la fiche

Réviser le module **08 — IORM** sous forme de questions-réponses opérationnelles.

Cette fiche sert à vérifier la compréhension, préparer un entretien technique, animer un atelier ou contrôler un runbook Exadata.

## Questions-réponses

### Q01. Quel est l’objectif principal du module 08 ?

comprendre I/O Resource Management et son rôle dans l’isolation des workloads Exadata.

### Q02. Pourquoi ce sujet est-il important sur Exadata ?

IORM évite qu’un workload consommateur d’I/O dégrade les workloads critiques qui partagent les mêmes Storage Cells.

### Q03. Quels sont les concepts clés à connaître ?

Les concepts clés sont : **IORM**, **I/O Resource Plan**, **Category Plan**, **Database Plan**, **Noisy Neighbor**, **OLTP**, **Reporting**, **Batch**.

### Q04. Quels composants Exadata sont concernés ?

Les composants concernés sont : Storage Cells, bases, PDB, services, workloads, I/O queues.

### Q05. Que faut-il retenir sur **IORM** ?

**IORM** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q06. Que faut-il retenir sur **I/O Resource Plan** ?

**I/O Resource Plan** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q07. Que faut-il retenir sur **Category Plan** ?

**Category Plan** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q08. Que faut-il retenir sur **Database Plan** ?

**Database Plan** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q09. Que faut-il retenir sur **Noisy Neighbor** ?

**Noisy Neighbor** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q10. Que faut-il retenir sur **OLTP** ?

**OLTP** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q11. Que faut-il retenir sur **Reporting** ?

**Reporting** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q12. Que faut-il retenir sur **Batch** ?

**Batch** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q13. Quelle est la première question à poser avant de diagnostiquer ?

La première question est : **quel symptôme exact observe-t-on, sur quelle période, pour quel service ou workload, et avec quel impact métier ?** Sans cette précision, les métriques sont difficiles à interpréter.

### Q14. Pourquoi faut-il construire une timeline ?

La timeline permet de relier les symptômes, alertes, changements, batchs, backups, métriques et actions. Elle évite d’attribuer à tort une cause visible mais non corrélée.

### Q15. Quelle différence entre symptôme, métrique et cause racine ?

Le symptôme est ce que l’utilisateur ou l’application observe. La métrique est une mesure technique. La cause racine est l’origine démontrée du problème. Une métrique élevée ou une alerte ne suffit pas à prouver la cause.

### Q16. Quelles commandes ou vues read-only sont utiles ?

```bash
cellcli -e "list iormplan"
cellcli -e "list iormplan detail"
cellcli -e "list metriccurrent"
select inst_id,sql_id,event,count(*) from gv$active_session_history group by inst_id,sql_id,event;
select name,value from v$sysstat where name like 'cell%';
```

### Q17. Comment interpréter les résultats des commandes ?

Chaque résultat doit être comparé à une baseline, à la période de l’incident, aux autres composants de la plateforme et au comportement attendu du workload. Une valeur isolée n’est pas une preuve suffisante.

### Q18. Quelle erreur fréquente faut-il éviter ?

L’erreur fréquente est de **penser qu’IORM accélère tout ; il priorise surtout en cas de concurrence I/O.**. La correction consiste à revenir à la méthode : symptôme → période → composants → preuves read-only → interprétation → décision.

### Q19. Quel cas pratique illustre le module ?

Un reporting massif ralentit l’OLTP sur une plateforme consolidée.

### Q20. Quelle démarche appliquer dans ce cas pratique ?

La démarche consiste à qualifier le symptôme, identifier les composants concernés, exécuter uniquement des commandes read-only, comparer les résultats à la baseline, formuler les hypothèses rejetées et conclure avec prudence.

### Q21. Quels éléments doivent apparaître dans une note technique ?

Une note technique doit contenir : contexte, impact métier, période, composants concernés, commandes exécutées, résultats observés, interprétation, hypothèses rejetées, risques, recommandation et prochaine action.

### Q22. Quand faut-il ouvrir une SR Oracle ou escalader ?

Il faut escalader lorsqu’une alerte critique, une dégradation persistante, une incohérence de version, un risque de disponibilité ou une anomalie matérielle dépasse le périmètre d’action local ou nécessite confirmation Oracle.

### Q23. Quelle est la différence entre observation et décision ?

Une observation décrit un fait mesuré. Une décision engage une action. Entre les deux, il faut une interprétation validée, un risque évalué et, si nécessaire, un runbook ou une validation CAB.

### Q24. Comment prouver que le diagnostic est solide ?

Un diagnostic solide associe au moins une période, un composant nommé, une commande ou vue read-only, une métrique interprétée, une comparaison à l’attendu et une conséquence métier.

### Q25. Quels mots-clés faut-il savoir expliquer oralement ?

IORM, I/O Resource Plan, Category Plan, Database Plan, Noisy Neighbor, OLTP, Reporting, Batch.

### Q26. Quelle phrase de synthèse retenir ?

Le module **08 — IORM** doit être abordé avec une logique de preuve : comprendre les composants, lire les métriques pertinentes, corréler avec le workload et ne conclure qu’après validation technique.

## Mini-test

- Expliquez **IORM** en une phrase et donnez une preuve read-only associée.

- Expliquez **I/O Resource Plan** en une phrase et donnez une preuve read-only associée.

- Expliquez **Category Plan** en une phrase et donnez une preuve read-only associée.

- Expliquez **Database Plan** en une phrase et donnez une preuve read-only associée.

- Expliquez **Noisy Neighbor** en une phrase et donnez une preuve read-only associée.

- Appliquez la méthode au cas suivant : **Un reporting massif ralentit l’OLTP sur une plateforme consolidée.**


## À retenir

```text

Module 08 — IORM

- Toujours partir du symptôme et de la période.

- Toujours nommer les composants concernés.

- Toujours préférer les preuves read-only avant toute action.

- Toujours comparer avec une baseline ou un état attendu.

- Toujours distinguer observation, hypothèse, décision et changement.

```
