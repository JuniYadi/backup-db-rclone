- [Backup Database with rclone](#backup-database-with-rclone)
  - [Tested](#tested)
  - [Install](#install)
  - [How to Use](#how-to-use)
  - [Crontab](#crontab)

# Backup Database with rclone

## Tested
| Name   | Version      |
|--------|--------------|
| OS     | Ubuntu 20.04 |
| MySQL  | 8.0          |
| rclone | 1.53.3       |

## Install

- Copy file **backup.sh** to user folder
- Copy file **.backup-rclone.example** to user folder
- Rename **.backup-rclone.example** to **.backup-rclone**

## How to Use

```
bash backup.sh
```

## Crontab

```
0 0 * * * bash /home/ubuntu/backup.sh
```