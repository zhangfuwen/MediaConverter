# about debian packages

```bash
dpkg --info ./build/media-converter-1.1-Linux.deb 
 新格式的 Debian 软件包，格式版本 2.0。
 大小 32838 字节：主控包=473 字节。
     248 字节，   10 行      control              
     298 字节，    4 行      md5sums              
 Architecture: amd64
 Depends: libc6 (>= 2.34), ffmpeg (>= 7:4.4-6ubuntu5), zenity (>= 3.32.0-7build1)
 Description: addnum built using CMake
 Maintainer: Dean
 Package: media-converter
 Priority: optional
 Section: devel
 Version: 1.1
 Installed-Size: 81
 ```


# about desktop files


https://wiki.archlinux.org/title/desktop_entries

# Validation

As some keys have become deprecated over time, you may want to validate your desktop entries using desktop-file-validate(1) which is part of the desktop-file-utils package. To validate, run:

```$ desktop-file-validate <your desktop file> ```

This will give you very verbose and useful warnings and error messages.

# Installation

Use desktop-file-install(1) to install desktop file into target directory. For example:

```$ desktop-file-install --dir=$HOME/.local/share/applications ~/app.desktop```

# Update database of desktop entries

To make desktop entries defined in ~/.local/share/applications work, run the following command:

```$ update-desktop-database ~/.local/share/applications```
