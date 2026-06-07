# Fiche questions-réponses — Module 07 — ASM et modèle de stockage Exadata

## Objectif de la fiche

Réviser le module **07 — ASM et modèle de stockage Exadata** sous forme de questions-réponses opérationnelles.

Cette fiche sert à vérifier la compréhension, préparer un entretien technique, animer un atelier ou contrôler un runbook Exadata.

## Questions-réponses

### Q01. Quel est l’objectif principal du module 07 ?

comprendre le modèle de stockage Exadata avec ASM, DATA, RECO, grid disks, redundancy et rebalance.

### Q02. Pourquoi ce sujet est-il important sur Exadata ?

ASM assure la répartition, la redondance et l’accès aux fichiers Oracle sur les grid disks fournis par les Storage Cells.

### Q03. Quels sont les concepts clés à connaître ?

Les concepts clés sont : **ASM**, **Diskgroup**, **DATA**, **RECO**, **Failure Group**, **Redundancy**, **Rebalance**, **Usable File MB**.

### Q04. Quels composants Exadata sont concernés ?

Les composants concernés sont : physical disks, cell disks, grid disks, ASM disks, DATA, RECO.

### Q05. Que faut-il retenir sur **ASM** ?

**ASM** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q06. Que faut-il retenir sur **Diskgroup** ?

**Diskgroup** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q07. Que faut-il retenir sur **DATA** ?

**DATA** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q08. Que faut-il retenir sur **RECO** ?

**RECO** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q09. Que faut-il retenir sur **Failure Group** ?

**Failure Group** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q10. Que faut-il retenir sur **Redundancy** ?

**Redundancy** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q11. Que faut-il retenir sur **Rebalance** ?

**Rebalance** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q12. Que faut-il retenir sur **Usable File MB** ?

**Usable File MB** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q13. Quelle est la première question à poser avant de diagnostiquer ?

La première question est : **quel symptôme exact observe-t-on, sur quelle période, pour quel service ou workload, et avec quel impact métier ?** Sans cette précision, les métriques sont difficiles à interpréter.

### Q14. Pourquoi faut-il construire une timeline ?

La timeline permet de relier les symptômes, alertes, changements, batchs, backups, métriques et actions. Elle évite d’attribuer à tort une cause visible mais non corrélée.

### Q15. Quelle différence entre symptôme, métrique et cause racine ?

Le symptôme est ce que l’utilisateur ou l’application observe. La métrique est une mesure technique. La cause racine est l’origine démontrée du problème. Une métrique élevée ou une alerte ne suffit pas à prouver la cause.

### Q16. Quelles commandes ou vues read-only sont utiles ?

```bash
asmcmd lsdg
asmcmd lsdsk -p
select name,total_mb,free_mb,usable_file_mb,type,state from v$asm_diskgroup;
select group_number,operation,state,power,est_minutes from v$asm_operation;
cellcli -e "list griddisk attributes name,status,size"
```

### Q17. Comment interpréter les résultats des commandes ?

Chaque résultat doit être comparé à une baseline, à la période de l’incident, aux autres composants de la plateforme et au comportement attendu du workload. Une valeur isolée n’est pas une preuve suffisante.

### Q18. Quelle erreur fréquente faut-il éviter ?

L’erreur fréquente est de **raisonner en capacité brute au lieu de capacité utilisable ASM.**. La correction consiste à revenir à la méthode : symptôme → période → composants → preuves read-only → interprétation → décision.

### Q19. Quel cas pratique illustre le module ?

DATA a encore de l’espace brut, mais `usable_file_mb` devient faible.

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

ASM, Diskgroup, DATA, RECO, Failure Group, Redundancy, Rebalance, Usable File MB.

### Q26. Quelle phrase de synthèse retenir ?

Le module **07 — ASM et modèle de stockage Exadata** doit être abordé avec une logique de preuve : comprendre les composants, lire les métriques pertinentes, corréler avec le workload et ne conclure qu’après validation technique.

## Mini-test

- Expliquez **ASM** en une phrase et donnez une preuve read-only associée.

- Expliquez **Diskgroup** en une phrase et donnez une preuve read-only associée.

- Expliquez **DATA** en une phrase et donnez une preuve read-only associée.

- Expliquez **RECO** en une phrase et donnez une preuve read-only associée.

- Expliquez **Failure Group** en une phrase et donnez une preuve read-only associée.

- Appliquez la méthode au cas suivant : **DATA a encore de l’espace brut, mais `usable_file_mb` devient faible.**


## À retenir

```text

Module 07 — ASM et modèle de stockage Exadata

- Toujours partir du symptôme et de la période.

- Toujours nommer les composants concernés.

- Toujours préférer les preuves read-only avant toute action.

- Toujours comparer avec une baseline ou un état attendu.

- Toujours distinguer observation, hypothèse, décision et changement.

```
