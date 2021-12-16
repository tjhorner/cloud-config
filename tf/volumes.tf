# resource "nomad_job" "csi_plugin_gfs" {
#   jobspec = file("${path.module}/../nomad/csi-plugin-gfs.hcl")
# }

# data "nomad_plugin" "gfs" {
#   depends_on = [ nomad_job.csi_plugin_gfs ]
#   plugin_id = "gfs"
#   wait_for_healthy = true
# }

# resource "nomad_external_volume" "traefik" {
#   depends_on = [ data.nomad_plugin.gfs ]
#   type = "csi"
#   plugin_id = "gfs"
#   volume_id = "traefik"
#   name = "traefik"
#   capacity_min = "1GiB"
#   capacity_max = "1TiB"

#   capability {
#     access_mode = "multi-node-multi-writer"
#     attachment_mode = "file-system"
#   }
# }