#!/bin/bash

# Konfigurasi
REPO_DIR="/local/mirror"
REPO_APP="docker"
#REPO_URL=""
REPO_TMP="$REPO_DIR/tmp"

# Pid
mkdir -p $REPO_TMP
PIDFILE="$REPO_TMP/$REPO_APP.pid"

# Cek pid, hentikan proses jika ada
if [ -e "${PIDFILE}" ] && (ps -u $(whoami) -opid= |
                           grep -P "^\s*$(cat ${PIDFILE})$" &> /dev/null); then
  echo "Already running."
  exit 99
fi

# Sinkronisasi, simpan dalam log
debmirror -nosource -m -passive \
	-host=apt.dockerproject.org -root=repo -method=http \
	-progress -dist=debian-jessie,debian-wheezy -section=main \
	-arch=i386,amd64,armhf $REPODIR/$REPO_APP \
	-ignore-release-gpg > $REPO_TMP/$REPO_APP.log &

# Isi pid
echo $! > "${PIDFILE}"
chmod 644 "${PIDFILE}"

