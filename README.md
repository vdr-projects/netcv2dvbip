netcv2dvbip
===========

This is a tool for streaming DVB TS packets via udp multicasts on demand from the netceiver.
It listens for IGMP(v1/v2/v3) join/leave multicast group messages on the network and starts/stops
the corresponding streams accordingly. It uses a channels.conf file for channel information.
Each channel is mapped to one multicast group starting with 239.255.0.1 and so on.

Written by:
Christian Cier-Zniewski <c.cier@gmx.de>
Project homepage: http://nanodev.nfshost.com/netcv2dvbip/
SVN source code repository: https://svn.baycom.de/repos/vdr-mcli-plugin/mcast/

The software is based on source code from the following projects:

IGMP component of vdr-streamdev-plugin
Frank Schmirler <vdrdev@schmirler.de>

VDR
Klaus Schmidinger <kls@cadsoft.de>

Netceiver mcli-lib
Baycom GmbH <info@baycom.de>

-----------------------------------------------------------

Quick Compile Howto (Linux):

1) Compile and install libnetceiver  
   https://github.com/vdr-projects/libnetceiver

2) Checkout netcv2dvbip  
   git clone https://github.com/vdr-projects/netcv2dvbip.git

3) cd netcv2dvbip  
   make

5) ./netcv2dvbip

------------------------------------------------------------

Notes:

* Each UDP packet contains 7*188=1316 bytes ( 7 TS packets)
* channels.conf: only frontend paramters are needed. PIDs are
  extracted from the PAT/PMT on demand.
<!--
	* Windows: MS Loopback Adapter Driver has to be installed if you only
	  want to stream local multicasts.
	  Configure a static unused IP for this adapter and add a route for
	  239.255.0.0/16 to this ip
	  eg.: route add 239.255.0.0 mask 255.255.0.0 10.11.12.13
	  where 10.11.12.13 is the static IP address of the loopback
	  adapter.
	  Linux: specify the option "-b lo" and make sure that the
	  multicast flag is set on the lo device.
	  If not, type: ifconfig lo multicast
	* Windows: netcv2dvb for Windows is compiled using Visual C++ 2008 Express Edition
	  Therefore it needs the Microsoft Visual C++ 2008 Runtime Redistributable to be installed.
-->

Known Issues:

* Linux: netcv2dvbip make use of the multicast routing API to be
  able to receive all IGMP (v1,v2) messages on the subnet without joining
  all groups. If you have configured 200 channels, then at least
  those 200 groups would have to be joined to receive the group
  specific queries. IGMPv3 does not suffer this "problem", since
  all reports are sent to the group 224.0.0.22.
  So, if you are already using software that make use of this API,
  netcv2dvbip will fail to start, because only one program can make
  use of this API.
<!--
	* Windows XP does not support MLDv2 messages, so the built-in MLD-Reporter of
	  libmcli is used in the Windows version of netcv2dvbip.
	  Windows Vista and Windows 7 already support MLDv2.
	* IMPORTANT note for VLAN users: Windows does not support VLANs as Linux does.
	  So, if you already using a VLAN-enabled network for the Netceiver and Reel-Netclients
	  then you must use a LAN card which offers VLAN support in the drivers.
	  Eg.: most Intel-adapters support this ( I am using a EXPI9301CT)
-->

------------------------------------------------------------

Possible clients:

* VLC [Linux, Windows]
* vdr-iptv-plugin [Linux]
* DVBLink for IPTV (http://www.dvblogic.com/) [Windows]
* Mediaportal with IPTV source filter (with EPG) [Windows]
* [...]

------------------------------------------------------------

Command line Options:

	-b <interface on which to listen for IGMP mesages and to send streams to>
	   Default: first found running interface

	-p <port to send streams to>
	   Default: 12345

	-i <interface with netceiver network>
	   Default: first found IPv6 interface

	-c <channels.conf file>

	-e include EIT packets in streams (EPG)

	-h help


ChangeLog:
==========

```
2009-??-?? version 1.0.0
           - initial release

2010-06-03 version 1.1.0
           - bugfixes:     * number of channels > 255 is now handled correctly
                           * PMT PIDs > 255 had a wrong entry in the PAT
           - new features: * DVB-C and DVB-T support
                           * support for VDR-1.7.x channels.conf format
                             (older formats and ReelVDR format are still supported)
                           * playlist file generation (M3U)
                           * EPG support: new command line option "-e" activates
                             sending of EIT packets (PID 0x12) in the stream.
2010-06-17 version 1.1.1   * bugfix: port number was not set correctly in M3U file
                           * bugfix: high CPU load (select() timeout was not
                                     set correctly)
                           * changed: streams now also use non-blocking sockets
                           * Windows only: activate built-in MLDv2 reporter only for
                                           Windows XP
```
