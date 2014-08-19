node[:deploy].each do |application, deploy|

  directory deploy[application]['environment']['CACHE_DIR'] do
    recursive true
    action :delete
  end

end