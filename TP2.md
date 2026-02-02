# [LP LPW 2026] Compte rendu TP2 UNIX : Services, processus, signaux

**Nom :** Vishnukumar
**Prénom :** Tharsan
**N° d'étudiant :** 21530107

## 1. Secure Shell: SSH

### 1.1 Connexion SSH Root

J'ai installé le serveur OpenSSH et configuré l'accès root.

**Commandes effectuées :**

```bash
apt update
apt search openssh-server
apt install openssh-server

```

Modification du fichier de configuration :

```bash
vim /etc/ssh/sshd_config

```

J'ai modifié la ligne `PermitRootLogin` pour la passer à `yes`.

**Explication `sshd_config` :**
L'option `PermitRootLogin` contrôle si l'utilisateur root peut se connecter via SSH.

* `yes` : Autorise la connexion root (risqué si le mot de passe est faible).
* `prohibit-password` (ou `without-password`) : Autorise root uniquement via clés SSH (plus sécurisé).
* `no` : Interdit toute connexion directe en root.

<img width="566" height="172" alt="image" src="https://github.com/user-attachments/assets/d94bed25-7628-4848-a8ac-e08208004ca8" />

### 1.2 Authentification par clé (Génération)

Sur ma machine hôte, j'ai généré une paire de clés sans passphrase (comme demandé pour le TP, bien que déconseillé en production car si la clé privée est volée, l'attaquant a un accès immédiat).

**Commande (sur la machine hôte) :**

```bash
ssh-keygen -t rsa -b 4096

```

*(Ou `ssh-keygen -t ed25519` pour une clé plus moderne).*

<img width="800" height="467" alt="image" src="https://github.com/user-attachments/assets/d82b2872-84fa-4920-a031-180dc0b4fbd8" />

### 1.3 Authentification par clé (Installation sur le serveur)

J'ai copié ma clé publique manuellement sur le serveur pour comprendre le mécanisme.

1. Création du dossier `.ssh` :
```bash
mkdir /root/.ssh

```


2. Création du fichier `authorized_keys` et ajout de la clé publique (copiée depuis l'hôte) :
```bash
vim /root/.ssh/authorized_keys

```
<img width="1885" height="132" alt="image" src="https://github.com/user-attachments/assets/7200f1b8-d96d-4fba-a403-32b8326ca10e" />


3. Attribution des permissions strictes (nécessaires pour qu'OpenSSH accepte la clé) :
```bash
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

```


<img width="608" height="199" alt="image" src="https://github.com/user-attachments/assets/daf4cfcf-5b25-4ad6-8903-4e39ddfbd1b0" />

### 1.4 Connexion depuis la machine hôte

Je me suis connecté en utilisant la clé privée correspondante.

**Commande :**

```bash
ssh -i maclef root@ip_du_serveur

```

<img width="886" height="237" alt="image" src="https://github.com/user-attachments/assets/bb298a61-5625-41cf-a1b1-93592d3fc9e0" />

### 1.5 Sécurisation

Pour sécuriser l'accès, j'ai désactivé l'authentification par mot de passe pour ne laisser que l'authentification par clé.

**Modification dans `/etc/ssh/sshd_config` :**

* `PermitRootLogin prohibit-password` (ou `without-password`)
* `PasswordAuthentication no`

<img width="476" height="137" alt="image" src="https://github.com/user-attachments/assets/e762aea9-b496-430f-96ca-9644a06bc782" />


**Attaque Brute Force SSH :**
Une attaque brute force consiste à tester automatiquement des milliers de combinaisons d'identifiants et de mots de passe pour deviner les accès.

**Autres protections possibles :**

* **Fail2Ban :** Bannit les IP après plusieurs échecs de connexion.
* **Changement de port :** Changer le port 22 par défaut pour éviter les scans automatiques.
* **AllowUsers :** Restreindre l'accès à une liste précise d'utilisateurs dans la configuration.

---

## 2. Processus

### 2.1 Étude des processus UNIX

Affichage de la liste des processus avec les colonnes demandées.

**Commande :**

```bash
ps -eo user,pid,%cpu,%mem,stat,start,time,command

```

**Réponses aux questions :**

* **TIME :** Correspond au temps processeur cumulé (temps CPU) utilisé par le processus depuis son lancement.
* **Processus le plus gourmand (CPU) :** *Dans l'instantané, c'est la commande ps elle-même (PID 1361) qui affiche 100% de CPU car elle était en train de s'exécuter pour générer l'affichage.*
* **Premier processus :** C'est `systemd` (ou `init`) avec le PID 1.
* **Heure de démarrage :** Visible via la commande `uptime` ou `who -b`.
* **Nombre de processus :** Visible via la commande `ls /proc | grep -c '^[0-9]'` ou simplement la dernière ligne lors d'un `top`.

<img width="1419" height="925" alt="image" src="https://github.com/user-attachments/assets/b296c60f-4dd3-4a77-a0cd-fbb5baa9ce2d" />
<img width="1618" height="922" alt="image" src="https://github.com/user-attachments/assets/1f399bde-db3e-42f4-94e8-0cd0146f12ce" />
<img width="1190" height="153" alt="image" src="https://github.com/user-attachments/assets/94e450c8-f1ce-4eb1-bafb-4af07d9db9fe" />

### 2.2 Arborescence (Parents/Enfants)

Pour afficher le PPID (Parent PID), on utilise l'option `ppid` ou `f` (forest).

**Commande pour les ancêtres :**

```bash
ps -ef | grep ps

```

On remonte ensuite les PPID successivement jusqu'à PID 1.

**Avec pstree :**
J'ai installé `pstree` (paquet `psmisc`) pour visualiser l'arbre.

```bash
apt install psmisc
pstree -p

```

<img width="854" height="364" alt="image" src="https://github.com/user-attachments/assets/d40e8329-0dc1-44aa-a858-2360959c95a4" />

### 2.3 Top et Htop

**Top :**
Dans `top`, j'ai trié par mémoire.

* Processus le plus gourmand en mémoire : *unattended-upgr (PID 661)*.

**Commandes interactives de top :**

* `z` : Active la couleur.
* `x` : Met en surbrillance la colonne de tri.
* `M` : Trie par mémoire.
* `P` : Trie par CPU.

**Htop :**
J'ai testé `htop`.

* **Avantages :** Interface plus conviviale, support de la souris, barres de progression graphiques, défilement vertical et horizontal facilité.

<img width="1882" height="840" alt="image" src="https://github.com/user-attachments/assets/80422e21-4f73-48d6-9740-a754fd6caf07" />

---

## 3. Arrêt d'un processus

J'ai créé les deux scripts demandés.

**Fichier `date.sh` :**

```bash
#!/bin/sh
while true; do sleep 1; echo -n 'date '; date +%T; done

```

**Fichier `date-toto.sh` :**

```bash
#!/bin/sh
while true; do sleep 1; echo -n 'toto '; date --date '5 hour ago' +%T; done

```

**Manipulations :**

1. Lancement de `./date.sh` puis mise en arrière-plan avec `CTRL-Z`.
2. Lancement de `./date-toto.sh` puis mise en arrière-plan avec `CTRL-Z`.
3. Affichage des tâches avec `jobs`.
4. Rappel au premier plan avec `fg %1` puis arrêt avec `CTRL-C`.
5. Pour tuer le second processus sans le rappeler :
```bash
ps -ef | grep date-toto
kill -9 [PID]

```



<img width="714" height="514" alt="image" src="https://github.com/user-attachments/assets/9720c28a-43ea-4026-916f-fe3a33822baf" />

---

## 4. Les tubes (Pipes)

**Différence `tee` vs `cat` :**

* `cat` lit un fichier et l'affiche sur la sortie standard.
* `tee` lit l'entrée standard et l'écrit **à la fois** sur la sortie standard (écran) et dans un fichier.

**Analyse des commandes :**

* `ls | cat` : Liste les fichiers et les passe à cat (affichage simple).
* `ls -l | cat > liste` : Écrit la liste détaillée dans le fichier `liste` (rien à l'écran).
* `ls -l | tee liste` : Écrit la liste détaillée dans le fichier `liste` **ET** l'affiche à l'écran.
* `ls -l | tee liste | wc -l` : Écrit dans `liste`, mais l'affichage écran est envoyé à `wc -l` qui compte les lignes.

<img width="507" height="246" alt="image" src="https://github.com/user-attachments/assets/338eb448-06da-4926-8dba-8b0605a708e6" />

---

## 5. Journal système rsyslog

**Service rsyslog :**

* Vérification : `systemctl status rsyslog`.
* PID du démon : Visible sur la ligne "Main PID".

**Fichiers de logs :**
Sur Debian, la configuration `/etc/rsyslog.conf` indique que la plupart des logs vont dans :

* `/var/log/syslog` (Logs généraux).
* `/var/log/auth.log` (Authentification/Cron).

**Service Cron :**
`cron` est un planificateur de tâches qui permet d'exécuter des scripts à des moments précis (répétitifs ou programmés).

**Surveillance temps réel :**
Commande pour voir les logs défiler :

```bash
tail -f /var/log/syslog

```

En redémarrant cron (`systemctl restart cron`), on voit apparaître les lignes de log indiquant l'arrêt et le démarrage du service.

**Logrotate :**
Le fichier `/etc/logrotate.conf` configure la rotation des logs. Cela permet d'archiver les vieux logs, de les compresser et de supprimer les plus anciens pour éviter de saturer le disque dur.

**Dmesg :**

* **Modèle processeur :** `dmesg | grep CPU` (détecte le type Intel).
* **Carte réseau :** `dmesg | grep eth` ou `grep net` (détecte souvent Intel e1000 dans VirtualBox).

<img width="1224" height="533" alt="image" src="https://github.com/user-attachments/assets/8b4d4a47-0158-4a0f-9a63-2cdf42ee2d31" />
