ThroughTek TPNS Quickstart
=================================
This application is the ThroughTek TPNS service demo for iOS platform.

Introduction
------------

- [Read more about ThroughTek TPNS](http://www.tutk.com/tpns.html)

Getting Started
---------------

- You MUST activate your APPLICATION & UID first before using TPNS. (Please contact your account manager for more help.)
- Register your UIDs to TPNS server.
- Run the sample on your iOS device.
- Send/Push messages from your device via TPNS.

How to Build
------------
You may use the following command to download and build this program.

- Download the full source code from GitHub.

```bash
git clone --recursive git://github.com/cloudhsiao/ios-tpns-quickstart.git

```

- Open `ios-tpns-quickstart/TPNS.xcodeproj` in Xcode
- Remove `Pods' dependcy from RxAlamofire
> See more details [here](http://stackoverflow.com/questions/29865899/ld-framework-not-found-pods)
- Build and have fun.

License
-------
This program is a free software; you can redistribute it and/or modify it under the terms of The BSD 3-Clause License as approved by Open Source Initiative. (See The BSD 3-Clause License for more details) But you may not decompile, disassemble, reverse-engineer, or use this program for commercial purposes.