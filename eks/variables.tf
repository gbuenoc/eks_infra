# coredns
variable "coredns_enable" {
  type    = bool
  default = false
}
variable "coredns_version" {
  type    = string
  default = null
}

# cilium
variable "cilium_enable" {
  type    = string
  default = null
}

variable "cilium_version" {
  type    = string
  default = null
}