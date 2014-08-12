default['php']['packages'] = %w{ php5 php5-fpm }

default['php-fpm']['service_name'] = 'php5-fpm'
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
      'php_value[session.save_path]' => '/var/lib/php/@versionsession'
    }
  },
  {
    'name' => 'backend'
  }
]

default['deploy']['test']['application'] = 'test'
default['deploy']['test']['application_type'] = 'php'
default['deploy']['test']['deploy_to'] = '/var/www/test'
default['deploy']['test']['user'] = 'www-data'
default['deploy']['test']['group'] = 'www-data'
default['deploy']['test']['domains'] = %w(test.dev.com www.test.dev.com backend.test.dev.com)
default['deploy']['test']['domain_pools'] = { 'www.test.dev.com' => 'www', 'backend.test.dev.com' => 'backend' }




