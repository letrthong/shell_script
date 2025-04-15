
#!/bin/bash

# Enable debugging
set -x


# Your log message
LOG_MESSAGE="This is a log entry by ThongLT"

# Write the log message to the system log
logger "$LOG_MESSAGE"

# View the last 10 entries in the system log
tail -n 10 /var/log/syslog



# Disable debugging
set +x
