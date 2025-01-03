variable "image_name" {
  default = "ubuntu"
}
variable "admin_user" {
  default = ""
}
variable "admin_user_group" {
  default = ""
}
variable "additional_groups" {
  type = list(string)
  default = [""]
}
variable "no_cloud_url" {
  default = ""
}
variable "no_cloud_file_path" {
  default = ""
}
variable "ssh_pub_key" {
  default = ""
}
variable "image_url" {
  default = "https://cdimage.ubuntu.com/releases/24.04.1/release/ubuntu-24.04.1-preinstalled-server-arm64+raspi.img.xz"
}
variable "image_url_checksum" {
  default = "https://cdimage.ubuntu.com/releases/24.04.1/release/SHA256SUMS"
}
variable "base_dir_name" {
  default = ""
}

source "arm" "ubuntu_os_arm64" {
  file_urls             = ["${var.image_url}"]
  file_checksum_url     = "${var.image_url_checksum}"
  file_checksum_type    = "sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
  image_build_method    = "reuse"
  image_path            = "images/${var.image_name}.img"
  image_size            = "1.1G"
  image_type            = "dos"
  image_partitions {
    name         = "boot"
    type         = "c"
    start_sector = "2048"
    filesystem   = "fat"
    size         = "512M"
    mountpoint   = "/boot/firmware"
  }
  image_partitions {
    name         = "root"
    type         = "83"
    start_sector = "1050624"
    filesystem   = "ext4"
    size         = "0"
    mountpoint   = "/"
  }
  image_chroot_env             = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
}

build {
  sources = ["source.arm.ubuntu_os_arm64"]
  
  provisioner "shell" {
    script = "scripts/000_pre_configure.sh"
    env = {
      "BASE_DIR_NAME": "${var.base_dir_name}" 
    }
  }
  
  provisioner "file" {
    source = "files/ubuntu.sources"
    destination = "/etc/apt/sources.list.d/ubuntu.sources"
  }
  
  provisioner "shell" {
    script = "scripts/001_install_tools.sh"
    env = {
      "BASE_DIR_NAME": "${var.base_dir_name}" 
    }
  }
  
  provisioner "shell" {
    script = "scripts/002_enable_ssh.sh"
  }
  
  provisioner "shell" {
    script = "scripts/003_enable_swap.sh"
  }

  provisioner "file" {
    content = templatefile("files/createuser.yml.tpl",{
        groupName = var.admin_user_group,
        userName = var.admin_user,
        additionalGroups = var.additional_groups,
        authorizedKey = var.ssh_pub_key
      })
    destination = "/${var.base_dir_name}/setup/createuser.yml"
  }
  
  provisioner "file" {
    source = "files/ansible-playbook-create-user.tgz"
    destination = "/${var.base_dir_name}/setup/"
  }

  provisioner "shell" {
    script = "scripts/004_createuser.sh"
    env = {
      "BASE_DIR_NAME": "${var.base_dir_name}" 
    }
  }
  
  provisioner "shell" {
    script = "scripts/005_disable_userconfig.sh"
  }
  
  provisioner "shell" {
    script = "scripts/098_resize_fs.sh"
  }
 
  provisioner "file" {
    content = templatefile("files/user-data.tpl",{
        config_url = var.no_cloud_url,
      })
    destination = "${var.no_cloud_file_path}/user-data"
  }

  provisioner "file" {
    source      = "files/meta-data.tpl"
    destination = "${var.no_cloud_file_path}/meta-data"
  }
  provisioner "file" {
    content      = templatefile("files/99-nocloud-no-users.cfg",{
        no_cloud_url = var.no_cloud_url
      })
    destination = "/etc/cloud/cloud.cfg.d/99-nocloud.cfg"
  }

  provisioner "shell" {
    env = {
        "ADMIN_USER": "${var.admin_user}",
        "ADMIN_GROUP": "${var.admin_user_group}",
        "BASE_DIR_NAME": "${var.base_dir_name}" 
      }
    script = "scripts/099_post_configure.sh"
  }
}
