#!/bin/bash

set -e

echo "Installing crontab..."
echo "Schedule: ${CRON_SCHEDULE}"
echo "Cmd: ${COMMAND}"

REQUIRED_ENV_VARS=(
    CRON_SCHEDULE
    COMMAND
)

# Make sure all required env vars are there
for var in "${REQUIRED_ENV_VARS[@]}" ; do
    if [[ -z "${!var}" ]] ; then
        echo "$var not set"
        exit -1
    fi
done

# Write crontab
echo -e "\
$(env)\n \
$CRON_SCHEDULE $COMMAND >> /var/log/cron.log 2>&1 \
" | crontab -

echo "Starting cron..."
/usr/sbin/crond

# We have to touch this file to make sure it exists when we run tail
touch /var/log/cron.log

echo "Tailing logs..."
# This is to prevent our container from exiting
tail -f /var/log/cron.log