

node 'rails-app-server' {

   $packages = [
	'ufw',
  	'htop',
   ]

   package { $packages:
	ensure => 'installed',
   }

   include '::nginx'
   include '::ntp'
   include 'jenkins'

   class { 'postgresql::server': }

   postgresql::server::db { 'gcap_prod':
      user     => 'gcapdbuser',
      password => postgresql_password('gcapdbuser', '6JPP9py4lrt'),
   }


   class { 'docker' :
	docker_users => ['jenkins'],
	tcp_bind     => 'tcp://127.0.0.1:4243',
        socket_bind  => 'unix:///var/run/docker.sock',
   }

   nginx::resource::upstream { 'jenkins_upstream':
     members => [
       'localhost:8080',
     ],
   }

   nginx::resource::vhost { 'ci.gennovacap.com':
     proxy => 'http://jenkins_upstream',
     ssl              => true,
     rewrite_to_https => true,
     ssl_key          => '/etc/letsencrypt/live/ci.gennovacap.com/privkey.pem',
     ssl_cert         => '/etc/letsencrypt/live/ci.gennovacap.com/fullchain.pem',

   }

}
