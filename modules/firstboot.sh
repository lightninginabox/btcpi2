# Install dependencies and configure firewall
RUN apt-get install -y ufw fail2ban git build-essential python3-pip

# Copy BTCPayServer Installation Script

RUN wget -O /boot/firstboot.sh https://raw.githubusercontent.com/lightninginabox/btcpayserver-doc/master/docs/Deployment/btcpi2.sh

RUN << EOF &> /dev/null
echo [Unit] > /etc/systemd/system/firstboot.service
echo Description=FirstBoot >> /etc/systemd/system/firstboot.service
echo After=network.target apt-daily.service apt-daily-upgrade.service >> /etc/systemd/system/firstboot.service
echo Before=rc-local.service >> /etc/systemd/system/firstboot.service
echo ConditionFileNotEmpty=/boot/firstboot.sh >> /etc/systemd/system/firstboot.service

echo [Service] >> /etc/systemd/system/firstboot.service
echo User=root
echo ExecStart=/boot/firstboot.sh >> /etc/systemd/system/firstboot.service
echo ExecStartPost=/bin/mv /boot/firstboot.sh /boot/firstboot.sh.done >> /etc/systemd/system/firstboot.service
echo Type=oneshot >> /etc/systemd/system/firstboot.service
echo RemainAfterExit=no >> /etc/systemd/system/firstboot.service

echo [Install] >> /etc/systemd/system/firstboot.service
echo WantedBy=multi-user.target >> /etc/systemd/system/firstboot.service

EOF

RUN systemctl enable firstboot
