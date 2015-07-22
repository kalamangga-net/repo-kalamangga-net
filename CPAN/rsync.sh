#!/bin/bash

REPO_DIR="/local/mirror"
REPO_APP="CPAN"
REPO_URL="rsync://kambing.ui.ac.id/CPAN/"
REPO_TMP="$REPO_DIR/tmp"

mkdir -p $REPO_TMP
PIDFILE="$REPO_TMP/$REPO_APP.pid"

if [ -e "${PIDFILE}" ] && (ps -u $(whoami) -opid= |
                           grep -P "^\s*$(cat ${PIDFILE})$" &> /dev/null); then
  echo "Already running."
  exit 99
fi

rsync -rtlzv --delete $REPO_URL $REPO_DIR/$REPO_APP/ > $REPO_TMP/$REPO_APP.log &

echo $! > "${PIDFILE}"
chmod 644 "${PIDFILE}"
