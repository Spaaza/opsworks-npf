include_recipe 'deploy'

node['deploy'].each do |application, deploy|

  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping web application #{application} as it is not a PHP app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    app application
    deploy_data deploy
  end

  # Create the top level log dir if it doesn't exist
  directory "#{deploy[:deploy_to]}/shared/log" do
    owner 'www-data'
    group 'www-data'
    mode "0775" 
  end
  
  # Create the top level cache dir if it doesn't exist
  directory "#{deploy[:deploy_to]}/shared/cache" do
    owner 'www-data'
    group 'www-data'
    mode "0775" 
  end
  
  # Make sure that the app can write and read the log dir and it's sub directories
  execute "change owner of log dir" do
    command "chown -Rf www-data:www-data #{deploy[:deploy_to]}/shared/log"
  end

  # Make sure that the app can write and read the cache dir and it's sub directories
  execute "change owner of cache dir" do
    command "chown -Rf www-data:www-data #{deploy[:deploy_to]}/shared/cache"
  end

end
