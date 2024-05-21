# SSH- Server connection automation

![Version](https://img.shields.io/badge/Version-2.1.0-black?style=for-the-badge)
![Language](https://img.shields.io/badge/Shell_Script_(Bash)-black?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-black?style=for-the-badge)

---

## Explanation

This is a shell- script for linux, which was created to automate the process of connecting to an SSH- Server.

The script was initially created to connect to the ARM- SSH- Server of the TU Darmstadt, but can be modified and used with other SSH- Servers as well.

The script is designed to use a public and a private key, generated with putty, to authenticate yourself. 

---

## How to use

To use this implementation, just run the script. However, you need to provide youre username and the SSH- Servers address with the corresponding flags. 

```shell
./openssh_autoconnect.sh -u yourUsername -l SSH-link
```

If a key is needed as well, you need to use the -k flag.
Note that this script only supports .pem- keys and key- generation with putty!

```shell
./openssh_autoconnect.sh -k -u yourUsername -l SSH-link
```
If not key is specified, the program will look for a key in your directory

You can also specify the .ppk or .pem key you want to be used. Just type the corresponding flag (-ppk/ -pem) followed by the file- name of the key.

```shell
./openssh_autoconnect.sh -k -u yourUsername -l SSH-link -pem Key.pem
```

If you haven't yet made the connection, just use the -new flag

```shell
./openssh_autoconnect.sh -k -new -u yourUsername -l SSH-link -pem TheKey.pem
```

This flag is only for setting up the key. If all keys are already created and you just want to initialize the connection, you can remove the -new flag.

Other options are the --help and --v/ --version flags to show the corresponding man- page from the program.

---

### Can't run script?

If you can run the script, try 
```shell
chmod +x openssh_autoconnect.sh
```

---

## Further Information

If you have any questions or ideas to improve the script, feel free to change them or contact me about it
