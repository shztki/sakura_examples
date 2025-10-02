#output "server01_ip" {
#  value = sakuracloud_server.server01.*.ip_address
#}
output "vpn_router01_ip" {
  value = sakuracloud_vpc_router.vpn_router01.*.public_ip
}
#output "wireguard_peer1_public_key" {
#  value = sakuracloud_vpc_router.vpn_router01[0].wire_guard[0].public_key
#}
output "vpn_router01_wireguard_server_public_keys" {
  value = [for r in sakuracloud_vpc_router.vpn_router01 : r.wire_guard[0].public_key]
}
