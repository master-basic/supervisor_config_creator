import os

def create_supervisor_config():
    site_folder = input("Enter the folder where the site is located: ")
    domain_name = input("Enter the website domain name: ")
    user_name = input("Enter the username to run the supervisor process (Default: root): ")

    config_content = f"""
[program:{domain_name}-queue]
process_name=%(program_name)s_%(process_num)s
command=php {site_folder}/artisan queue:work --queue={domain_name}
directory={site_folder}
user={user_name}
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/{domain_name}_queue.err.log
stdout_logfile=/var/log/{domain_name}_queue.out.log
stderr_logfile_maxbytes=50MB
stderr_logfile_backups=30
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=30

[program:{domain_name}-websockets]
directory={site_folder}
command=php artisan websockets:serve
user={user_name}
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/var/log/{domain_name}_websockets.err.log
stdout_logfile=/var/log/{domain_name}_websockets.out.log
stderr_logfile_maxbytes=50MB
stderr_logfile_backups=30
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=30
    """

    config_filename = f"/etc/supervisord.d/{domain_name}.conf"
    
    with open(config_filename, 'w') as config_file:
        config_file.write(config_content)

    print(f"Supervisor config file '{config_filename}' created successfully in /etc/supervisord.d/.")

if __name__ == "__main__":
    create_supervisor_config()