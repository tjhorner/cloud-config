job "traefik" {
  datacenters = [ "gcp" ]
  type = "system"

  group "traefik" {
    network {
      port "http" {
        static = 80
      }

      port "https" {
        static = 443
      }
    }

    volume "traefik" {
      type      = "host"
      read_only = false
      source    = "traefik"
    }

    service {
      name = "traefik"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "ensure-acme" {
      driver = "docker"

      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      config {
        image = "alpine:3"
        command = "/bin/sh"
        args = [ "-c", "touch /opt/traefik/acme.json && chmod 600 /opt/traefik/acme.json" ]
      }

      volume_mount {
        volume      = "traefik"
        destination = "/opt/traefik"
        read_only   = false
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v2.2"
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      volume_mount {
        volume      = "traefik"
        destination = "/opt/traefik"
        read_only   = false
      }

      template {
        data = <<EOF
[entryPoints]
  [entryPoints.web]
    address = ":80"

  [entryPoints.websecure]
    address = ":443"

[http.routers]
  [http.routers.http_catchall]
    entryPoints = ["web"]
    middlewares = ["https_redirect"]
    rule = "HostRegexp(`{any:.+}`)"
    service = "noop"

[http.services]
  [http.services.noop.loadBalancer]
    [[http.services.noop.loadBalancer.servers]]
      url = "http://192.168.0.1:1337"

[http.middlewares]
  [http.middlewares.https_redirect.redirectScheme]
    scheme = "https"
    permanent = true

[certificatesResolvers.le.acme]
  email = "me@tjhorner.com"
  storage = "/opt/traefik/acme.json"
  [certificatesResolvers.le.acme.httpChallenge]
    entryPoint = "web"

[providers.consulCatalog]
    prefix           = "traefik"
    exposedByDefault = false
    [providers.consulCatalog.endpoint]
      address = "127.0.0.1:8500"
      scheme  = "http"
EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}