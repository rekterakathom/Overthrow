## Building the addon

**Requirements**
* Mounted P: drive
* [HEMTT](https://github.com/BrettMayson/HEMTT)
* Arma 3 Tools

**Guide**

0. Download the files from GitHub, either as a .zip or by cloning the repository

1. Mount the P: drive from 'Arma 3 Tools/workdrive/mount.bat'

2. Copy the repository to the root of your P: drive

3. Open the command prompt in the Overthrow directory (P:/Overthrow)

4. Run 'hemtt build --release'

5. The built addon can now be found in P:/Overthrow/Releases

## Can I just unpack the PBO instead?

Technically yes, but it is not recommended. HEMTT does a lot of things like rapifying that make things non-human readable.
We recommend sticking to the above instructions, and assistance won't be provided for other methods.

## What is HEMTT, why does Overthrow use it?

HEMTT is an opinionated build system for Arma 3 mods. It is used in large mods like ACE and CBA.

HEMTT is used because it is a complete tool that can build and sign the entire mod as well as rapify, binarize and optimize.

Before HEMTT, Overthrow was built using a completely custom, complicated toolchain that didn't offer all of these benefits.
