FROM python:3-slim

RUN apt-get update \
	&& apt-get install -y --no-install-recommends openssh-server vsftpd \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir flask

# Create service user for SSH and FTP (teaching/demo defaults).
RUN useradd -m -s /bin/bash student \
	&& echo "student:student" | chpasswd

# Configure SSH.
RUN mkdir -p /var/run/sshd \
	&& sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
	&& sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

# Configure FTP.
RUN printf '%s\n' \
	'listen=YES' \
	'background=NO' \
	'anonymous_enable=NO' \
	'local_enable=YES' \
	'write_enable=YES' \
	'chroot_local_user=YES' \
	'allow_writeable_chroot=YES' \
	'pasv_enable=YES' \
	'pasv_min_port=30000' \
	'pasv_max_port=30009' \
	> /etc/vsftpd.conf

COPY app.py /app.py

EXPOSE 5000 21 22 30000-30009

CMD ["/bin/sh", "-c", "/usr/sbin/sshd && /usr/sbin/vsftpd /etc/vsftpd.conf & python /app.py"]
