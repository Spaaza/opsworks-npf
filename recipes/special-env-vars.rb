node[:deploy].each do |application, deploy|
  node.override['deploy'][application]['environment']['LOG_DIR'] = "#{deploy[:deploy_to]}/shared/log/"
end
