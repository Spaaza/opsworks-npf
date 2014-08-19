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

  # Make sure that the group can write and read the logs
  directory "#{deploy[:deploy_to]}/shared/log" do
    owner deploy[:user]
    group deploy[:group]
    mode "0775" 
  end

  # Make sure that the group can write and read the cache
  directory "#{deploy[:deploy_to]}/shared/cache" do
    owner deploy[:user]
    group deploy[:group]
    mode "0775" 
  end

end
