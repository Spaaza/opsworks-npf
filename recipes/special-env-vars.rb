node[:deploy].each do |application, deploy|
  node.override['deploy'][application]['environment']['LOG_DIR'] = "#{deploy[:deploy_to]}/shared/log/"
  node.override['deploy'][application]['environment']['CACHE_DIR'] = "#{deploy[:deploy_to]}/shared/cache"
end
