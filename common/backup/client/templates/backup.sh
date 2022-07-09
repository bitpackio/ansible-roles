#!/bin/sh

failed_backups=0

echo "starting backup at $(date)"
{% for pre_cmd in backup_pre_commands %}
echo "executing backup pre command: {{ pre_cmd }}"

{{ pre_cmd }} 
if [ $? -ne 0 ]; then
    >&2 echo "pre command failed. aborting backup."
    exit 1
fi
{% endfor %}

echo "---"

{% for backup_directory in backup_directories %}
echo "backing up: {{ backup_directory }}"
{{ backup_command }} {{ backup_directory }}

if [[ $? != 0 ]]; then
    ((failed_backups=failed_backups+1))
    echo "error: backup failed"
fi
    
echo "---"
{% endfor %}

{% for post_cmd in backup_post_commands %}
echo "executing backup post command: {{ post_cmd }}"
{{ post_cmd }} 
{% endfor %}

echo "finished backup at $(date)"
echo "failed backups: $failed_backups"
