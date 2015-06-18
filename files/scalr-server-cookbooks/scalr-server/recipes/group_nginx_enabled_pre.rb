# nginx directories

directory etc_dir_for(node, 'nginx') do
  owner     'root'
  group     'root'
  mode      0755
end

directory run_dir_for(node, 'nginx') do
  owner     node[:scalr_server][:app][:user]
  group     node[:scalr_server][:app][:user]
  mode      0755
end

directory data_dir_for(node, 'nginx') do
  owner     node[:scalr_server][:app][:user]
  group     node[:scalr_server][:app][:user]
  mode      0755
end

directory log_dir_for(node, 'nginx') do
  owner     node[:scalr_server][:app][:user]
  group     node[:scalr_server][:app][:user]
  mode      0755
end


# nginx configuration

template "#{etc_dir_for node, 'nginx'}/nginx.conf" do
  source    'nginx/nginx.conf.erb'
  owner     'root'
  group     'root'
  mode      0644
  helpers do
    include Scalr::PathHelper
    include Scalr::ServiceHelper
  end
  notifies  :restart, 'supervisor_service[nginx]' if service_is_up?(node, 'nginx')
end
