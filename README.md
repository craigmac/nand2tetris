# nand2tetris.org course files and answers

## How to setup manually

Clone the repo.
Unzip the nan2tetris.zip file.
Make sure you have Java Development Kit installed (OpenJDK on *nix).
Make the shell scripts inside nand2tetris/tools executable.
Run whatever tool you want.

## Copy-paste install for BASH shell on Debian/Ubuntu-based

```
$ sudo apt-get install -y openjdk
$ cd ~/Desktop
$ git clone https://github.com/saltycraig/nand2tetris.git
$ cd nand2tetris && unzip nand2tetris.zip
$ cd nand2tetris/tools && chmod +x *.sh
$ ./HardwareSimulator.sh
```
