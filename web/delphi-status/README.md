Public Domain code used from:
* https://github.com/openshift/sinatra-example.git

Vulnerability:
* Padding oracle, leading to shell command execution

This level exposes command-execution functionality, which is done using parameters that are encrypted by a secret key. However, due to a padding oracle vulnerability, those commands can be decrypted and changed.

My secret goal is for somebody to patch my [poracle](https://github.com/iagox86/poracle) tool to support encryption of arbitrary text as well as decryption. :)
