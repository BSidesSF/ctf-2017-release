Crack the pin form sqlite DB, then
- Use apktool to decompile the app, change the select query in smali and call version 2 of the decryption function. Recompile and see the flag after logging in
- Or, use apktool + dex2jar to disassemble the application and understand the decryption method. Then fetch the secretDBv2, write custom code to do the PBKDF + AES decryption
