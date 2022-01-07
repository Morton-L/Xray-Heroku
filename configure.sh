#!/bin/sh

apk update && apk add --no-cache ca-certificates unzip wget


# Download and install Xray
mkdir /tmp/Xray
wget -O /tmp/Xray/Xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/Xray/Xray.zip -d /tmp/Xray
install -m 755 /tmp/Xray/xray /usr/local/bin/Xray

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
                        "id": "$ID"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/"
                }
			}
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ],
	"log": {
		"loglevel": "none"
	}
}
EOF

# Run Xray
/usr/local/bin/Xray -config /usr/local/etc/Xray/config.json
