# Command Line Static Route

To view the existing routes,
```sh
C:\> ROUTE PRINT
```

To add a static route,

SYNTAX:
```sh
C:\> ROUTE ADD <TARGET> MASK <NETMASK> <GATEWAY IP> METRIC <METRIC COST> IF <INTERFACE>
```
EXAMPLE:
C:\> ROUTE ADD 10.10.10.0 MASK 255.255.255.0 192.168.1.1 METRIC 1

Note: If there is more than one Network Interface and if the interface is not mentioned, the interface is selected based on the gateway IP.
This Static route gets erased when the system reboots. 


To avoid this, use the -p (Persistent) switch to the above command:
```sh
C:\> ROUTE -P ADD 10.10.10.0 MASK 255.255.255.0 192.168.1.1 METRIC 1
```
This writes the persistent route to the following Windows Registry key as a string value (REG_SZ):

HKEY_LOCAL_MACHINE\SYSTEM\CURRENTCONTROLSET\SERVICES\TCPIP\PARAMETERS\PERSISTENTROUTES

Also, you can write a small batch file with the route commands and add it to the startup folder to add the routes at startup (similar to the startup scripts in Solaris)

For more options like flushing the IP Routing table or to delete, modify IP Routing table entry use the route command with no arguments. This displays the various options for the route command.
```sh
C:\> ROUTE
```