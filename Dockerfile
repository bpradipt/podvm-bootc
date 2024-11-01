FROM quay.io/fedora/fedora-bootc:40

#https://gitlab.com/fedora/bootc/examples/

RUN dnf -y install cloud-init && \
    ln -s ../cloud-init.target /usr/lib/systemd/system/default.target.wants && \
    rm -rf /var/{cache,log} /var/lib/{dnf,rhsm}

ADD ./wheel-nopasswd /etc/sudoers.d/

COPY ./payload /

RUN mkdir -p /usr/lib/bootc/install

RUN cat <<EOF >> /usr/lib/bootc/install/00-kargs.toml
[install.filesystem.root]
type = "ext4"
[install]
kargs = [ "console=ttyS0", "selinux=0", "enforcing=0", "audit=0"]
match-architectures = ["x86_64"]
EOF


