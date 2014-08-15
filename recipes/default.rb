include_recipe 'nginx'

template "/etc/nginx/fastcgi_params" do
  source "fastcgi_params.erb"
  mode "0644"
  owner "root"
  group "root"
end

template "/etc/init/php5-fpm.conf" do
  source "php5-fpm.conf.erb"
  mode "0644"
  owner "root"
  group "root"
end

template "/usr/lib/php5/php5-fpm-checkconf" do
  source "php5-fpm-checkconf.erb"
  mode "0755"
  owner "root"
  group "root"
end

directory "/var/log/php-fpm" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

directory "/var/run/php-fpm" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

include_recipe 'php-fpm::default'

service node['php-fpm']['service_name'] do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [:enable, :restart]
end

node['deploy'].each do |application, deploy|

  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping web application #{application} as it is not a PHP app")
    next
  end

  nginx_web_app application do
    template 'php-fpm-site.erb'
    cookbook 'npf'
    application deploy
    docroot deploy[:absolute_document_root]
    server_name deploy[:domains].first
    php_fpm_service_name node['php-fpm']['service_name']
    php_fpm_pools node['php-fpm']['pools']
    domain_pools deploy[:domain_pools]
    unless deploy[:domains][1, deploy[:domains].size].empty?
      server_aliases deploy[:domains][1, deploy[:domains].size]
    end
    ssl_certificate_ca deploy[:ssl_certificate_ca]
    only_if { node['php-fpm'] && node['php-fpm']['pools'] }
  end
end
