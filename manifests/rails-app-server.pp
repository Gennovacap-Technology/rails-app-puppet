

node 'rails-app-server' {

  #Classes

  hiera_include('classes')

  # Hiera lookups
  $packages = hiera_array('packages')

  # Validate all the variables
  validate_array($packages)

  package { $packages:
    ensure => 'installed',
  }

  # Databases
  $databases = hiera_hash('databases')

  # Validate all the variables
  validate_hash($databases)

  create_resources('postgresql::server::db', $databases)

  # PG HBA rules
  $pg_hba = hiera_hash('pg_hba')

  # Validate all the variables
  validate_hash($pg_hba)

  create_resources('postgresql::server::pg_hba_rule', $pg_hba)

  # PG Grants
  $pg_grants = hiera_hash('pg_grants')

  # Validate all the variables
  validate_hash($pg_grants)

  create_resources('postgresql::server::database_grant', $pg_grants)

  # Nginx Vhosts

  $nginx_vhosts = hiera_hash('nginx_vhosts')

  # Validate all the variables
  validate_hash($nginx_vhosts)

  create_resources('nginx::resource::vhost', $nginx_vhosts)

  # Nginx Upstreams

  $nginx_upstreams = hiera_hash('nginx_upstreams')

  # Validate all the variables
  validate_hash($nginx_upstreams)

  create_resources('nginx::resource::upstream', $nginx_upstreams)

  class { 'postgresql::server' :
    listen_addresses => '*'
  }

}
