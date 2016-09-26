

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

  $databases = hiera_hash('databases')

  create_resources("postgresql::server::db", $databases)



  # class { 'docker' :
  #   docker_users => ['jenkins'],
  #   tcp_bind     => 'tcp://127.0.0.1:4243',
  #   socket_bind  => 'unix:///var/run/docker.sock',
  # }
  #
  # nginx::resource::upstream { 'jenkins_upstream':
  #   members => [
  #   'localhost:8080',
  #   ],
  # }
  #
  # nginx::resource::vhost { 'ci.gennovacap.com':
  #   proxy => 'http://jenkins_upstream',
  #   ssl              => true,
  #   rewrite_to_https => true,
  #   ssl_key          => '/etc/letsencrypt/live/ci.gennovacap.com/privkey.pem',
  #   ssl_cert         => '/etc/letsencrypt/live/ci.gennovacap.com/fullchain.pem',
  # }

}
