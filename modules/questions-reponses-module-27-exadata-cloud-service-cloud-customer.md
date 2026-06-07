# Fiche questions-réponses — Module 27 — Exadata Cloud Service et Cloud@Customer

## Objectif de la fiche

Réviser le module **27 — Exadata Cloud Service et Cloud@Customer** sous forme de questions-réponses opérationnelles.

Cette fiche sert à vérifier la compréhension, préparer un entretien technique, animer un atelier ou contrôler un runbook Exadata.

## Questions-réponses

### Q01. Quel est l’objectif principal du module 27 ?

comparer Exadata on-prem, Exadata Database Service et Exadata Cloud@Customer : responsabilités, IAM, réseau et opérations.

### Q02. Pourquoi ce sujet est-il important sur Exadata ?

Le modèle cloud change les droits, outils, responsabilités, patching, supervision et escalade support.

### Q03. Quels sont les concepts clés à connaître ?

Les concepts clés sont : **Exadata on-prem**, **Exadata Database Service**, **Cloud@Customer**, **Responsabilité partagée**, **VM Cluster**, **IAM OCI**, **Compartiment**, **OCI CLI**.

### Q04. Quels composants Exadata sont concernés ?

Les composants concernés sont : OCI, VM Cluster, Exadata Infrastructure, IAM, VCN, DB homes, databases, Oracle Support.

### Q05. Que faut-il retenir sur **Exadata on-prem** ?

**Exadata on-prem** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q06. Que faut-il retenir sur **Exadata Database Service** ?

**Exadata Database Service** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q07. Que faut-il retenir sur **Cloud@Customer** ?

**Cloud@Customer** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q08. Que faut-il retenir sur **Responsabilité partagée** ?

**Responsabilité partagée** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q09. Que faut-il retenir sur **VM Cluster** ?

**VM Cluster** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q10. Que faut-il retenir sur **IAM OCI** ?

**IAM OCI** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q11. Que faut-il retenir sur **Compartiment** ?

**Compartiment** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q12. Que faut-il retenir sur **OCI CLI** ?

**OCI CLI** doit être compris dans le contexte Exadata : il faut le relier aux composants concernés, au workload, aux métriques observables et à l’impact métier. La bonne pratique consiste à ne jamais l’analyser isolément.

### Q13. Quelle est la première question à poser avant de diagnostiquer ?

La première question est : **quel symptôme exact observe-t-on, sur quelle période, pour quel service ou workload, et avec quel impact métier ?** Sans cette précision, les métriques sont difficiles à interpréter.

### Q14. Pourquoi faut-il construire une timeline ?

La timeline permet de relier les symptômes, alertes, changements, batchs, backups, métriques et actions. Elle évite d’attribuer à tort une cause visible mais non corrélée.

### Q15. Quelle différence entre symptôme, métrique et cause racine ?

Le symptôme est ce que l’utilisateur ou l’application observe. La métrique est une mesure technique. La cause racine est l’origine démontrée du problème. Une métrique élevée ou une alerte ne suffit pas à prouver la cause.

### Q16. Quelles commandes ou vues read-only sont utiles ?

```bash
oci db cloud-vm-cluster get --cloud-vm-cluster-id <ocid>
oci db vm-cluster list --compartment-id <ocid>
crsctl stat res -t
srvctl status database -d <db_unique_name> -v
select name,open_mode,database_role from v$database;
```

### Q17. Comment interpréter les résultats des commandes ?

Chaque résultat doit être comparé à une baseline, à la période de l’incident, aux autres composants de la plateforme et au comportement attendu du workload. Une valeur isolée n’est pas une preuve suffisante.

### Q18. Quelle erreur fréquente faut-il éviter ?

L’erreur fréquente est de **raisonner Cloud@Customer comme un simple Exadata on-prem sans frontière de responsabilité.**. La correction consiste à revenir à la méthode : symptôme → période → composants → preuves read-only → interprétation → décision.

### Q19. Quel cas pratique illustre le module ?

Une entreprise hésite entre on-prem et Cloud@Customer pour garder les données sur site tout en déléguant certaines opérations.

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

Exadata on-prem, Exadata Database Service, Cloud@Customer, Responsabilité partagée, VM Cluster, IAM OCI, Compartiment, OCI CLI.

### Q26. Quelle phrase de synthèse retenir ?

Le module **27 — Exadata Cloud Service et Cloud@Customer** doit être abordé avec une logique de preuve : comprendre les composants, lire les métriques pertinentes, corréler avec le workload et ne conclure qu’après validation technique.

## Mini-test

- Expliquez **Exadata on-prem** en une phrase et donnez une preuve read-only associée.

- Expliquez **Exadata Database Service** en une phrase et donnez une preuve read-only associée.

- Expliquez **Cloud@Customer** en une phrase et donnez une preuve read-only associée.

- Expliquez **Responsabilité partagée** en une phrase et donnez une preuve read-only associée.

- Expliquez **VM Cluster** en une phrase et donnez une preuve read-only associée.

- Appliquez la méthode au cas suivant : **Une entreprise hésite entre on-prem et Cloud@Customer pour garder les données sur site tout en déléguant certaines opérations.**


## À retenir

```text

Module 27 — Exadata Cloud Service et Cloud@Customer

- Toujours partir du symptôme et de la période.

- Toujours nommer les composants concernés.

- Toujours préférer les preuves read-only avant toute action.

- Toujours comparer avec une baseline ou un état attendu.

- Toujours distinguer observation, hypothèse, décision et changement.

```
