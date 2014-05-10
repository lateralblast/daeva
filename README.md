![alt tag](https://raw.githubusercontent.com/richardatlateralblast/daeva/master/Daevas.jpg)

daeva
=====

Download and Automatically Enable nightly VLC for Apple

Ruby script to download and install latest nightly build of VLC.

Features:

- Checks remote version and local version before downloading
- Installs and fixes Gatekeeper and Quarantine information so application runs without asking for approval

Usage
=====

```
daeva.rb -[cdghilrvVzZ]

-V: Display version information
-h: Display usage information
-v: Verbose output
-d: Download latest build but don't install
-i: Download and install latest build
-l: Get local build date
-r: Get remote build date
-c: Compare local and remote  build dates
-g: Update Gatekeeper and Quarantine information so application can run
-z: Clean up temporary directory (delete files older than 7 days
-Z: Remove existing VLC application
```
