#!/bin/sh

# Download and install Xray
mkdir /tmp/Xray
curl -L -H "Cache-Control: no-cache" -o /tmp/Xray/Xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/Xray/Xray.zip -d /tmp/Xray
install -m 755 /tmp/Xray/xray /usr/local/bin/xray

# Remove temporary directory
rm -rf /tmp/Xray

# Xray new configuration
install -d /usr/local/etc/Xray
cat << EOF > /usr/local/etc/Xray/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$ID",
						"flow": "xtls-rprx-direct",
                        "level": 0
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
				}
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Run Xray
/usr/local/bin/xray -config /usr/local/etc/Xray/config.json
