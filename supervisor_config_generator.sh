#!/bin/bash

create_supervisor_config() {
    read -p "Enter the folder where the site is located: " site_folder
    read -p "Enter the website domain name: " domain_name
    read -p "Enter the username to run the supervisor process (Default: root): " user_name

    # Set default user_name if not provided
    user_name=${user_name:-root}

    config_content=$(cat <<EOF
[program:${domain_name}-queue]
process_name=%(program_name)s_%(process_num)s
command=php ${site_folder}/artisan queue:work --queue=${domain_name}
directory=${site_folder}
user=${user_name}
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/${domain_name}_queue.err.log
stdout_logfile=/var/log/${domain_name}_queue.out.log
stderr_logfile_maxbytes=50MB
stderr_logfile_backups=30
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=30

[program:${domain_name}-websockets]
directory=${site_folder}
command=php artisan websockets:serve
user=${user_name}
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/${domain_name}_websockets.err.log
stdout_logfile=/var/log/${domain_name}_websockets.out.log
stderr_logfile_maxbytes=50MB
stderr_logfile_backups=30
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=30
EOF
)

    config_filename="/etc/supervisord.d/${domain_name}.conf"
    
    echo "$config_content" > "$config_filename"

    echo "Supervisor config file '${config_filename}' created successfully."
}

create_supervisor_config
