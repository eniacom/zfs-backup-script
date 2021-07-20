#!/bin/bash
#     Author: Eniacom Srl 2021-07-20
#     Website: eniacom.com
#     Repo: https://github.com/eniacom/zfs-backup-script

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.


if [ $# -lt 1 ]
then
    echo "Usage: $0 {daily|weekly|monthly}"
    exit 1
fi

TYPE=$1
SRCHOST=`hostname`
DESTHOST=
DESTDIR=/backup/${SRCHOST}/${TYPE}
REDUNDANCY=2
MAIL=

#List of ZFS not to backup, syntax: ZFSPOOL-ZFSNAME
IGNORE=("examplepool-examplefs" "examplepool-examplefs2")

#List of ZFS POOL not to backup, syntax: ZFS POOL
IGNOREPOOL=("examplepool" "examplepool2")

#create destination dir
mkdir -p ${DESTDIR}

# count exiting bakcup
NUMBACKUP=`ls -d ${DESTDIR}/backup-* | wc -l`

if [ "$NUMBACKUP" -ge "$REDUNDANCY" ] ; then
    OLDESTBACKUP=`cd ${DESTDIR} && ls 2>/dev/null -drt backup-* | head -1`
    # truncate oldest existings backup
    rm -rf ${DESTDIR}/${OLDESTBACKUP}
fi

#get current date and time
INDEXBACKUP=`date +%Y%m%d-%H%M%S`

#set real destination dir
DESTBACKUP="${DESTDIR}/backup-${INDEXBACKUP}"

#create real dest dir
mkdir -p ${DESTBACKUP}

# Local backup

ZFS=`/usr/sbin/zfs list | grep - | awk {'print $1'}`
while IFS=':' read -r ZFS 
do  
    ZFSFS=`cut -d'/' -f2 <<<"$ZFS"`
    ZFSPOOL=`cut -d'/' -f1 <<<"$ZFS"`
    if [[ ! " ${IGNOREPOOL[@]} " =~ " ${ZFSPOOL} " ]]; then
        if [[ ! " ${IGNORE[@]} " =~ " ${ZFSPOOL}-${ZFSFS} " ]]; then
        BACKUP=backup-${ZFSPOOL}-${ZFSFS}
    echo $BACKUP
    echo ${ZFS}@${BACKUP}
        /usr/sbin/zfs snapshot ${ZFS}@${BACKUP}
        /usr/sbin/zfs send ${ZFS}@${BACKUP} | pigz -c > ${DESTBACKUP}/${BACKUP}.img.gz
        /usr/sbin/zfs destroy ${ZFS}@${BACKUP}
        fi
    fi
done <<< "$ZFS"

#backup VM config files OPTIONAL FOR PROXMOX
cp /etc/pve/nodes/*/qemu-server/* ${DESTBACKUP}/

#create backup folder on remote host
ssh ${DESTHOST} "mkdir -p ${DESTBACKUP}"

#transfer local backup to remote host
/usr/bin/scp ${DESTBACKUP}/* ${DESTHOST}:${DESTBACKUP}

#send a report
/bin/echo "VMs Backup from ${SRCHOST} to ${DESTHOST} completed" | /usr/bin/mail -s "${SRCHOST}: VMs Backup to ${DESTHOST} completed" ${MAIL}
