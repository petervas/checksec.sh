checksec.sh
========

**checksec.sh** is a lightweight and portable Bash script that helps assess the security properties of executables, processes, and system configurations. It provides insights into applied security mitigations and system hardening measures.

Features:

* Analyze file security properties, checking for **PIE, RELRO, Stack Canaries, ASLR, Fortify Source, and more.**
* Inspect **running processes** to check applied security features.
* Assess **kernel security settings**, including optional Kconfig checks.
* Evaluate **detailed Fortify Source usage** for binaries and running processes.
* Support **batch analysis** using file lists or directories.
* Output results in **multiple formats (CLI, CSV, XML, JSON)** for easy integration into other tools.

This project is a **continuation of the original checksec v2.7.1** by Brian Davis, which is now unmaintained. The original repository can be found [here](https://github.com/slimm609/checksec).

## Why checksec.sh?

✅ **Portable** – Runs on different architectures without modification  
✅ **Lightweight** – No compilation required, just a simple Bash script  
✅ **Minimal dependencies** – Works with tools available in most OS default installations  
✅ **Offline & Embedded compatibility** – Can be used to check cross-compiled systems or embedded targets, such as unpacked firmwares, for tests that do not depend on the running system (e.g., file checks).  
✅ **Supports static and bare-metal binaries** – Works with statically linked ELF files and standalone executables  
✅ **Transparent & modifiable** – Easy to understand and customize  
✅ **Compatible** – Maintains the same command-line interface as the original checksec  

## Supported File Types for Hardening Checks

checksec.sh supports analyzing various ELF binaries, including:

* Executable files – Standard ELF binaries
* Shared libraries – .so files used by dynamically linked applications
* Object files – Compiled but not yet linked objects (e.g., kernel objects)
* Static and bare-metal binaries – Statically linked executables without dynamic dependencies

This makes checksec.sh useful for analyzing both standard applications and embedded system binaries, including unpacked firmware images.

## Installation  

To install **checksec.sh**, simply download the checksec.sh script to your desired location and make it executable:  

```bash
chmod +x checksec.sh
```

## Usage

checksec.sh keeps the familiar execution format of the original checksec, making it easy to use for existing users. Simply run:

```bash
./checksec.sh --file=/path/to/binary
```

For more details, run:

```bash
./checksec.sh --help
```

## Offline Analysis for Cross-compiled Systems or Embedded Targets

If you're working with cross-compiled systems or embedded targets (such as unpacked firmwares), you can specify the path to the appropriate libc file for analysis. This allows you to check files without relying on the running system. For example:

```bash
./checksec.sh --dir=/path/to/firmware --libcfile=/path/to/firmware/lib/
```

or directly specify the libc file:

```bash
./checksec.sh --dir=/path/to/firmware --libcfile=/path/to/firmware/lib/libc.so.6
```
