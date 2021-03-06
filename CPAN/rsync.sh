#!/bin/bash

# Konfigurasi
REPO_DIR="/local/mirror"
REPO_APP="CPAN"
REPO_URL="rsync://kambing.ui.ac.id/CPAN/"
REPO_TMP="$REPO_DIR/tmp"
REPO_SCR="$(dirname $0)"

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
rsync -rtlzv --delete $REPO_URL $REPO_DIR/$REPO_APP/ > $REPO_TMP/$REPO_APP.log; bash $REPO_SCR/../chmod.sh $REPO_DIR/$REPO_APP/ &

# Isi pid
echo $! > "${PIDFILE}"
chmod 644 "${PIDFILE}"
