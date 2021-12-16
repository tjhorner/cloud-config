job "csi-plugin-gfs" {
  datacenters = [ "gcp" ]
  type = "system"

  constraint {
    operator = "distinct_hosts"
    value = true
  }

  group "controllers" {
    task "controller" {
      driver = "docker"

      config {
        image = "tjhorner/gcp-filestore-csi-driver:latest"

        args = [
          "--endpoint=unix:/csi/csi.sock",
          "--nodeid=${node.unique.id}",
          "--controller=true",
          "--v=5",
        ]
      }

      csi_plugin {
        id = "gfs"
        type = "controller"
        mount_dir = "/csi"
      }
    }
  }

  group "nodes" {
    task "node" {
      driver = "docker"

      config {
        image = "tjhorner/gcp-filestore-csi-driver:latest"

        args = [
          "--endpoint=unix:/csi/csi.sock",
          "--nodeid=${node.unique.id}",
          "--node=true",
          "--v=5",
        ]

        privileged = true
      }

      csi_plugin {
        id = "gfs"
        type = "node"
        mount_dir = "/csi"
      }
    }
  }
}