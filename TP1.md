# [LP LPW 2026] Compte rendu TP1 UNIX

**Nom :** Vishnukumar
**Prénom :** Tharsan
**N° d'étudiant :** 21530107

## 1. Installation Machine Virtuelle

### 1.1 Récupération de l'image et Configuration

J'ai téléchargé l'image `mini.iso` (NetBoot) depuis le miroir Debian, correspondant à l'architecture `amd64`.
La machine virtuelle "LicencePro2026" a été configurée et lancée avec la commande `Vbox LicencePro2026`.

### 1.2 Partitionnement

Conformément aux consignes, j'ai réalisé un partitionnement manuel avec une table de partition **GPT**. Voici la structure appliquée :

* **Racine (`/`)** : 10 Go, ext4, drapeau bootable activé.
* **Espace temporaire (`/tmp`)** : 4 Go, ext4.
* **Logs (`/var/log`)** : 1 Go, ext4.
* **Swap** : Reste de l'espace disque.

<img width="839" height="626" alt="2026-01-27-203639_hyprshot" src="https://github.com/user-attachments/assets/cbc51679-9604-4cb4-8a4e-e6f5642af9be" />

### 1.3 Choix des paquets

Lors de la sélection des logiciels :

* J'ai décoché l'environnement de bureau et le serveur SSH.
* J'ai conservé uniquement "Utilitaires usuels du système" (Standard system utilities).

<img width="841" height="643" alt="2026-01-27-204426_hyprshot" src="https://github.com/user-attachments/assets/476fe820-78d3-4f99-8d08-a5498d33e2ca" />

---

## 2. Post-Installation

### 2.1 Nombre de paquets

Après le redémarrage, j'ai vérifié le nombre de paquets installés pour confirmer l'installation minimale.

Commande utilisée :

```bash
dpkg -l | wc -l

```

**Résultat attendu :** Environ 302 paquets. J'en ai obtenu 258, sûrement à cause de la version plus récente de l'image ISO.

<img width="384" height="107" alt="2026-01-27-204815_hyprshot" src="https://github.com/user-attachments/assets/4d810090-50d3-4e96-b32d-5ca07b18ca51" />

### 2.2 Configuration SSH

Pour permettre l'administration à distance, j'ai installé et configuré le serveur SSH.

Installation du paquet :

```bash
apt search openssh-server
apt install openssh-server

```

<img width="958" height="267" alt="image" src="https://github.com/user-attachments/assets/679a27d1-83e4-4a8a-8453-719ea1350d2b" />

Modification de la configuration pour autoriser le root :

```bash
vi /etc/ssh/sshd_config

```

*Modification de la ligne `PermitRootLogin` à `yes`.*
<img width="316" height="136" alt="image" src="https://github.com/user-attachments/assets/b5560f52-5148-492a-9598-be2b1c9669b3" />

Redémarrage du service :

```bash
systemctl restart ssh

```

<img width="836" height="336" alt="image" src="https://github.com/user-attachments/assets/ea729e94-e715-4be9-b955-14227a63a514" />

### 2.3 Connexion à distance

J'ai configuré ma VM en accès par pont (Bridge).

<img width="1662" height="312" alt="image" src="https://github.com/user-attachments/assets/73ecb6d4-cb53-471a-9bf3-208976971e7c" />

J'ai exécuté la commande suivante pour récupérer l'IP de ma machine :

```bash
ip a

```

<img width="888" height="515" alt="image" src="https://github.com/user-attachments/assets/06b10437-163a-4456-ad30-4f01f9db5184" />

Je me suis connecté à la VM avec son IP depuis ma machine hôte.

<img width="892" height="350" alt="image" src="https://github.com/user-attachments/assets/c44c037e-18f6-489a-9b59-118c81c3c0bb" />

### 2.4 Espace Disque

Vérification de l'espace utilisé par l'installation minimale.

Commande :

```bash
df -h

```

<img width="778" height="255" alt="image" src="https://github.com/user-attachments/assets/ae54e52f-13e4-485b-abf5-c22eb901ec12" />

### 2.5 Explication des commandes et résultats

Voici les détails des commandes demandées dans la section 2.5 du sujet :

#### Locales

<img width="408" height="46" alt="image" src="https://github.com/user-attachments/assets/e1776c49-2eac-4198-ab7a-258ad91f8e46" />

Cette commande affiche la variable d'environnement qui définit la langue et le jeu de caractères (encodage) utilisés par le système.

#### Nom de la machine et domaine

<img width="388" height="92" alt="image" src="https://github.com/user-attachments/assets/9a0f6c67-e20f-4527-a794-eefc5ebcbd07" />

* `hostname` : Affiche le nom d'hôte du système (défini comme `serveur1` lors de l'installation).
* `hostname -d` : Affiche le nom de domaine DNS de la machine (défini comme `ufr-info-p6.jussieu.fr`).

#### Vérification des dépôts

<img width="673" height="92" alt="image" src="https://github.com/user-attachments/assets/358c42b0-4655-4b0f-accd-dd0ec2606585" />

Cette commande affiche le contenu du fichier de configuration des dépôts (`sources.list`), en excluant (`grep -v`) les lignes commentées (commençant par `#`) et les lignes vides (`^$`). Cela permet de voir uniquement les dépôts actifs.

#### Passwd et Shadow

**Fichier Shadow :**

```bash
cat /etc/shadow | grep -vE ':*::!*:'

```

Affiche les lignes du fichier `/etc/shadow` (qui contient les mots de passe chiffrés) en filtrant les comptes systèmes qui n'ont pas de mot de passe utilisable. Cela permet d'identifier les comptes utilisateurs réels (comme root) qui ont un hash de mot de passe défini.

**Comptes utilisateurs :**

```bash
cat /etc/passwd | grep -vE 'nologin|sync'

```

Filtre le fichier `/etc/passwd` pour exclure les utilisateurs ayant un shell `/usr/sbin/nologin` ou `/bin/sync`. Cela liste les utilisateurs "humains" ou administrateurs pouvant potentiellement ouvrir une session shell.

#### Partitionnement détaillé

```bash
fdisk -l

```

Affiche la liste des tables de partitions pour les périphériques spécifiés.

```bash
fdisk -x

```

Affiche des détails supplémentaires (étendus) sur la table de partitions, comme les descripteurs spécifiques GPT.

---

## 3. Aller plus loin

### 3.1 Installation automatique (Preseed)

Le **Preseed** est une méthode permettant d'automatiser l'installation de Debian. Il consiste à fournir un fichier de configuration contenant les réponses aux questions posées par l'installateur (langue, clavier, partitionnement, paquets, etc.). Cela permet de déployer des serveurs sans interaction humaine.

### 3.2 Mode Rescue (Mot de passe root perdu)

Pour changer le mot de passe root en cas d'oubli :

1. Démarrer sur l'ISO d'installation.
2. Aller dans "Advanced options" > "Rescue mode".
3. Sélectionner la partition racine à monter.
4. Choisir "Exécuter un shell dans /dev/..."
5. Utiliser la commande `passwd root` pour définir un nouveau mot de passe.

### 3.3 Redimensionnement de partition

Pour redimensionner la partition racine (`/`) sans réinstaller :

* **Si LVM est utilisé :** On peut étendre le volume logique à chaud (`lvextend`) puis redimensionner le système de fichiers (`resize2fs`).
* **Sans LVM (notre cas) :** Il n'est généralement pas possible de réduire ou déplacer une partition racine montée en cours d'utilisation. Il faut démarrer sur un LiveCD (comme GParted ou SystemRescueCd), réduire la partition adjacente (ex: swap ou supprimer/recréer swap) et étendre la partition racine, puis étendre le système de fichiers.

### 3.4 Configuration Proxy

Pour configurer le proxy `proxy.ufr-info-p6.jussieu.fr:3128`, j'ai ajouté les variables d'environnement suivantes :

**Dans `/etc/profile` (pour l'environnement global) :**

```bash
vi /etc/profile

```

Ajout des lignes :

```bash
export http_proxy="http://proxy.ufr-info-p6.jussieu.fr:3128"
export https_proxy="http://proxy.ufr-info-p6.jussieu.fr:3128"
export ftp_proxy="proxy.ufr-info-p6.jussieu.fr:3128"

```

**Dans `/etc/apt/apt.conf` (pour APT) :**

```bash
vi /etc/apt/apt.conf

```

Ajout de la ligne :

```text
Acquire::http::Proxy "http://proxy.ufr-info-p6.jussieu.fr:3128/";

```

[TP2-2](TP2-2.md)

