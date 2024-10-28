#!/bin/bash

NVIDIA_DRIVER_VERSION=${NVIDIA_DRIVER_VERSION:-550}
NVIDIA_USERSPACE_VERSION=${NVIDIA_USERSPACE_VERSION:-1.16.1-1}
NVIDIA_USERSPACE_PKGS=(nvidia-container-toolkit libnvidia-container1 libnvidia-container-tools)

# Create the prestart hook directory
mkdir -p /usr/share/oci/hooks/prestart

# Add hook script
cat <<'END' >  /usr/share/oci/hooks/prestart/nvidia-container-toolkit.sh
#!/bin/bash -x

# Log the o/p of the hook to a file
/usr/bin/nvidia-container-toolkit -debug "$@" > /var/log/nvidia-hook.log 2>&1
END

# Make the script executable
chmod +x /usr/share/oci/hooks/prestart/nvidia-container-toolkit.sh


dnf -y module install nvidia-driver:${NVIDIA_DRIVER_VERSION}-dkms

# install userspace stuff
dnf install -y "${NVIDIA_USERSPACE_PKGS[@]/%/-${NVIDIA_USERSPACE_VERSION}}"

# Configure the settings for nvidia-container-runtime
sed -i "s/#debug/debug/g"                                           /etc/nvidia-container-runtime/config.toml
sed -i "s|/var/log|/var/log/nvidia-kata-container|g"                /etc/nvidia-container-runtime/config.toml
sed -i "s/#no-cgroups = false/no-cgroups = true/g"                  /etc/nvidia-container-runtime/config.toml
sed -i "/\[nvidia-container-cli\]/a no-pivot = true"                /etc/nvidia-container-runtime/config.toml
sed -i "s/disable-require = false/disable-require = true/g"         /etc/nvidia-container-runtime/config.toml
sed -i "s/info/debug/g"



#misc
cat << EOF > /etc/rc.d/rc.local
#!/bin/bash
nvidia-persistenced
nvidia-smi conf-compute -srs 1
EOF
sudo chmod +x /etc/rc.d/rc.local


# Disable dkms service
#
rm -f /etc/systemd/system/multi-user.target.wants/dkms.service
