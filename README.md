![alt tag](https://raw.githubusercontent.com/richardatlateralblast/daeva/master/Daevas.jpg)

daeva
=====

Download and Automatically Enable Various Applications (for OS X)

Ruby script to download and install latest build of an application.
The code has been made generic so other apps can be added.
Currently VLC and WebKit are supported.

Features:

- Checks remote version and local version before downloading
- Installs and fixes Gatekeeper and Quarantine information so application runs without asking for approval

Usage
=====

```
daeva.rb -[cdghilrvVzZ]

-V:     Display version information
-h:     Display usage information
-v:     Verbose output
-d:     Download latest build but don't install
-i:     Download and install latest build
-l:     Get local build date for application
-r:     Get remote build date for application
-p:     Get URL of download for latest package
-c:     Compare local and remote build dates
-a:     Show available packages
-g:     Update Gatekeeper and Quarantine information so application can run
-z:     Clean up temporary directory (delete files older than 7 days
-Z:     Remove existing application
-C:     Remove crash reporter file
```

For example, to show available applications:

```
daeva.rb -a
VLC     [ http://nightlies.videolan.org/build/macosx-intel/ ]
WebKit  [ http://nightly.webkit.org/builds/trunk/mac/1 ]
```


