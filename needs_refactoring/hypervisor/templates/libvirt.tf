provider "libvirt" {
  uri = "{{ libvirt_uri }}"
}

resource "libvirt_volume" "{{ os_image.name }}" {
  name   = "{{ os_image.name }}"
  pool   = "{{ libvirt_storage }}"
  source = "{{ os_image.url }}"
}

# cloud-init
resource "libvirt_cloudinit_disk" "cloudinit_ubuntu_resized" {
  name = "cloudinit_ubuntu_resized.iso"
  pool = "default"

  user_data = <<EOF
#cloud-config
disable_root: 0
ssh_pwauth: 1
users:
  - name: root
    ssh-authorized-keys:
      - ${file("~/.ssh/id_rsa.pub")}
growpart:
  mode: auto
  devices: ['/']
EOF
}

resource "libvirt_volume" "disk_k8s-master" {
  name           = "disk_k8s-master"
  base_volume_id = "${libvirt_volume.os_image_ubuntu.id}"
  pool           = "vms"
  size           = 107227863040
}
resource "libvirt_domain" "k8s_master" {
  name   = "vm-k8s-master"
  memory = "4096"
  vcpu   = 2

  cloudinit = "${libvirt_cloudinit_disk.cloudinit_ubuntu_resized.id}"

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  # IMPORTANT
  # Ubuntu can hang if an isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = "${libvirt_volume.disk_k8s-master.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "k8s-master" {
  value = "k8s-master: ${libvirt_domain.k8s_master.network_interface.0.addresses.0}"
}
