# OpenConnect Host Information Profile
Openconnect supports `protocol=gp` from Version 8.0 onwards. To connect to Global Protect VPN you need Host Information Profile, which is an XML file that contains the information about the host machine that is getting connected. [hipreport.sh](https://github.com/saisyam/openconnect-gp-hip/blob/master/hipreport.sh) shell script will generate this file which will be read by OpenConnect client. Use the below command to provide HIP report to OpenConnect:

```shell
$ sudo openconnect --protocol=gp <VPN domain> --user=<username> --key-password=<password> --csd-wrapper=<path to hipreport.sh>
```
