#!/bin/sh

# openconnect will call this script with the follow command-line
# arguments, which are needed to populate the contents of the
# HIP report:
#
#   --cookie: a URL-encoded string, as output by openconnect
#             --authenticate --protocol=gp, which includes parameters
#             from the /ssl-vpn/login.esp response
#
#   --client-ip: IPv4 address allocated by the GlobalProtect VPN for
#                this client (included in /ssl-vpn/getconfig.esp
#                response)
#
#   --md5: The md5 digest to encode into this HIP report. I'm not sure
#          exactly what this is the md5 digest *of*, but all that
#          really matters is that the value in the HIP report
#          submission should match the value in the HIP report check.

# Read command line arguments into variables
COOKIE=
IP=
MD5=

while [ "$1" ]; do
    if [ "$1" = "--cookie" ];    then shift; COOKIE="$1"; fi
    if [ "$1" = "--client-ip" ]; then shift; IP="$1"; fi
    if [ "$1" = "--md5" ];       then shift; MD5="$1"; fi
    shift
done

if [ -z "$COOKIE" -o -z "$IP" -o -z "$MD5" ]; then
    echo "Parameters --cookie, --computer, --client-ip, and --md5 are required" >&2
    exit 1;
fi

# Extract username and domain and computer from cookie
USER=$(echo "$COOKIE" | sed -rn 's/(.+&|^)user=([^&]+)(&.+|$)/\2/p')
DOMAIN=$(echo "$COOKIE" | sed -rn 's/(.+&|^)domain=([^&]+)(&.+|$)/\2/p')
COMPUTER=$(echo "$COOKIE" | sed -rn 's/(.+&|^)computer=([^&]+)(&.+|$)/\2/p')

# Timestamp in the format expected by GlobalProtect server
NOW=$(date +'%m/%d/%Y %H:%M:%S')

DAY=$(date +'%d')
MONTH=$(date +'%m')
YEAR=$(date +'%Y')
# This value may need to be extracted from the official HIP report, if a made-up value is not accepted.
HOSTID="ffbcf452-de91-e711-be82-48ba4eac8d35"

cat <<EOF
<hip-report name="hip-report">
	<md5-sum>$MD5</md5-sum>
	<user-name>$USER</user-name>
	<domain>$DOMAIN</domain>
	<host-name>$COMPUTER</host-name>
	<host-id>$HOSTID</host-id>
	<ip-address>$IP</ip-address>
	<ipv6-address></ipv6-address>
	<generate-time>$NOW</generate-time>
	<categories>
		<entry name="host-info">
			<client-version>4.1.5-23</client-version>
			<os>Microsoft Windows 10 Pro N, 64-bit</os>
			<os-vendor>Microsoft</os-vendor>
			<domain>$DOMAIN.internal</domain>
			<host-name>$COMPUTER</host-name>
			<host-id>$HOSTID</host-id>
			<network-interface>
				<entry name="{62DF7C38-079B-44A6-B264-ECB31CBA0181}">
					<description>PANGP Virtual Ethernet Adapter #2</description>
					<mac-address>e4:42:a6:5e:94:fd</mac-address>
					<ip-address>
						<entry name="$IP"/>
					</ip-address>
					<ipv6-address>
						<entry name="fe80::85ec:91cc:c4bf:ac90"/>
					</ipv6-address>
				</entry>
			</network-interface>
		</entry>
		<entry name="anti-malware">
			<list>
				<entry>
					<ProductInfo>
						<Prod name="AVG AntiVirus Free" version="19.4.3089" defver="19050508" prodType="1" engver="18.0.531.0" osType="1" vendor="AVG Technologies CZ, s.r.o." dateday="$DAY" dateyear="$YEAR" datemon="$MONTH">
						</Prod>
						<real-time-protection>no</real-time-protection>
						<last-full-scan-time>N/A</last-full-scan-time>
					</ProductInfo>
				</entry>
				<entry>
					<ProductInfo>
						<Prod name="Windows Defender" version="4.13.17134.1" defver="1.293.958.0" prodType="1" engver="1.1.15900.4" osType="1" vendor="Microsoft Corporation" dateday="$DAY" dateyear="$YEAR" datemon="$MONTH">
						</Prod>
						<real-time-protection>yes</real-time-protection>
						<last-full-scan-time>N/A</last-full-scan-time>
					</ProductInfo>
				</entry>
			</list>
		</entry>
		<entry name="disk-backup">
			<list>
				<entry>
					<ProductInfo>
						<Prod name="Windows Backup and Restore" version="10.0.17134.1" vendor="Microsoft Corporation">
						</Prod>
						<last-backup-time>n/a</last-backup-time>
					</ProductInfo>
				</entry>
				<entry>
					<ProductInfo>
						<Prod name="Windows File History" version="10.0.17134.1" vendor="Microsoft Corporation">
						</Prod>
						<last-backup-time>n/a</last-backup-time>
					</ProductInfo>
				</entry>
			</list>
		</entry>
		<entry name="disk-encryption">
			<list>
				<entry>
					<ProductInfo>
						<Prod name="BitLocker Drive Encryption" version="10.0.17134.1" vendor="Microsoft Corporation">
						</Prod>
						<drives>
							<entry>
								<drive-name>C:</drive-name>
								<enc-state>unencrypted</enc-state>
							</entry>
						</drives>
					</ProductInfo>
				</entry>
			</list>
		</entry>
		<entry name="firewall">
			<list>
				<entry>
					<ProductInfo>
						<Prod name="Windows Firewall" version="10.0.17134.1" vendor="Microsoft Corporation">
						</Prod>
						<is-enabled>yes</is-enabled>
					</ProductInfo>
				</entry>
			</list>
		</entry>
		<entry name="patch-management">
			<list>
				<entry>
					<ProductInfo>
						<Prod name="Windows Update Agent" version="10.0.17134.1" vendor="Microsoft Corporation">
						</Prod>
						<is-enabled>yes</is-enabled>
					</ProductInfo>
				</entry>
			</list>
			<missing-patches/>
		</entry>
		<entry name="data-loss-prevention">
			<list/>
		</entry>
	</categories>
</hip-report>
EOF
