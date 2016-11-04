# nand2tetris.org course files and answers

## Course details

Beginning from primitive boolean functions and given a Nand
chip, you build a simulation of the 15 most common gates such as
And, Not, Or, Xor, Mux, Dmux and their 16-bit variants. You describe
the input and output buses of these gates as well as their functionality
in a language called HDL (Hardware Definition Language). You then test
your implementation of these primitive gates against known working
implementations in a special purpose hardware simulator given to you.

With the basic building blocks working, you begin building the ALU,
CPU, and RAM chips out of these gates.

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
