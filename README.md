- [Backup Database with rclone](#backup-database-with-rclone)
  - [Tested](#tested)
  - [Install Instruction](#install-instruction)
  - [Command Install](#command-install)
  - [How to Use](#how-to-use)
  - [Crontab](#crontab)

# Backup Database with rclone

![](output.png)

## Tested
| Name   | Version      |
|--------|--------------|
| OS     | Ubuntu 20.04 |
| MySQL  | 8.0          |
| rclone | 1.53.3       |

## Install Instruction

- Copy file **backup.sh** to user folder
- Copy file **.backup-rclone.example** to user folder
- Rename **.backup-rclone.example** to **.backup-rclone**
- Edit **.backup-rclone**

## Command Install

```
wget -O backup.sh https://raw.githubusercontent.com/JuniYadi/backup-db-rclone/main/backup.sh
wget -O .backup-rclone https://raw.githubusercontent.com/JuniYadi/backup-db-rclone/main/.backup-rclone.example
```

## How to Use

```
bash backup.sh
```

## Crontab

```
0 0 * * * bash /home/ubuntu/backup.sh
```