# Exportação do protótipo

Builds produzidos com Godot 4.6.3 Stable em 27 de outubro de 2026.

## Windows 64-bit

- Arquivo: `build/windows/MarajoEntreAguas.exe`
- Formato validado: PE32+ x86-64.
- SHA-256: `8ab40038c4ef3dd49a6bfe7609989b7bc00c438e7849ebea62a4ba330280de0c`

## Linux 64-bit

- Arquivo: `build/linux/MarajoEntreAguas.x86_64`
- Formato validado: ELF x86-64 para Linux 5.15 ou superior.
- SHA-256: `9f643420c2e03f6cae9eaf62f84528f974587d0427ac300f0c535c52448eb1dc`
- O executável foi iniciado com `--headless --quit-after 5` e encerrou com código zero.

## Reproduzir

Instale os templates oficiais correspondentes à versão do Godot e utilize os presets versionados em `export_presets.cfg`.

Os artefatos em `build/` não são versionados. Eles devem ser anexados a uma GitHub Release ou recompilados localmente.
