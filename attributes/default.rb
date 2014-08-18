default['php']['packages'] = %w{ php5 php5-fpm php5-curl php-pear }

php_fpm_service_name = 'php5-fpm'
version = ''
conf_file = '/etc/' + php_fpm_service_name + (!version.empty? ? '-' + version : '') + '.conf'
pool_conf_dir = '/etc/' + php_fpm_service_name + (!version.empty? ? '-' + version : '') + '.d'

default['php-fpm']['service_name'] = php_fpm_service_name
default['php-fpm']['version'] = version
default['php-fpm']['conf_file'] = conf_file
default['php-fpm']['pool_conf_dir'] = pool_conf_dir
default['php-fpm']['listen_owner'] = 'www-data'
default['php-fpm']['listen_group'] = 'www-data'
default['php-fpm']['listen_mode'] = '0660'
default['php-fpm']['user'] = 'www-data'
default['php-fpm']['group'] = 'www-data'
default['php-fpm']['pid'] = '/var/run/php-fpm' + (version.empty? ? '' : '/' + version) + '/php-fpm.pid'

# Added by jbrook
default['php-fpm']['session_directory'] = '/var/lib/php5/@versionsession'

default['php-fpm']['pools'] = [
  {
    'name' => 'www',
    'process_manager' => 'dynamic',
    'max_children' => 50,
    'start_servers' => 5,
    'min_spare_servers' => 5,
    'max_spare_servers' => 35,
    'max_requests' => 500,
    'catch_workers_output' => 'no',
    'security_limit_extensions' => '.php',
    'slowlog' => '/var/log/php-fpm/slow.log',
    'php_options' => {
      'php_admin_value[memory_limit]' => '128M',
      'php_admin_value[error_log]' => '/var/log/php-fpm/@version@poolerror.log',
      'php_admin_flag[log_errors]' => 'on',
      'php_value[session.save_handler]' => 'files',
      'php_value[session.save_path]' => node['php-fpm']['session_directory']
    }
  }
]

