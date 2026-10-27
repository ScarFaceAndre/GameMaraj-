# Marajó: Entre Águas

Protótipo de jogo de mundo aberto ambientado no corredor Soure–Salvaterra, na Ilha de Marajó. O projeto usa Godot 4 e combina pesquisa territorial e cultural com uma direção visual estilizada.

## Executar

```bash
godot --path . --editor
```

Para uma validação sem interface gráfica:

```bash
mkdir -p /tmp/gamemaraj-godot/{data,cache,config}
XDG_DATA_HOME=/tmp/gamemaraj-godot/data \
XDG_CACHE_HOME=/tmp/gamemaraj-godot/cache \
XDG_CONFIG_HOME=/tmp/gamemaraj-godot/config \
godot --headless --path . --quit-after 3
```

O vertical slice é uma representação condensada e simbólica da travessia do rio Paracauari. Use WASD ou as setas para mover, `E` para interagir, `F5` para salvar e `F9` para carregar.

## Conteúdo jogável

- Duas margens conectadas por travessia fluvial.
- Vila procedural com 36 casas, vegetação, trapiches e moradores.
- Cinco missões: travessia, guia comunitária, pesca, cartografia social e festa.
- Reputação comunitária, relógio, variação atmosférica e objetivos direcionais.
- Salvamento JSON versionado.

Os personagens e lugares ainda são protótipos ficcionais. Nenhum NPC representa diretamente uma pessoa real.

## Exportar

No Godot, abra **Projeto > Exportar**, selecione **Windows 64-bit** ou **Linux 64-bit** e clique em **Exportar projeto**. Instale os templates de exportação quando o editor solicitar.

Pela linha de comando:

```bash
godot --headless --path . --export-release "Windows 64-bit" build/windows/MarajoEntreAguas.exe
godot --headless --path . --export-release "Linux 64-bit" build/linux/MarajoEntreAguas.x86_64
```

Consulte [a pesquisa inicial](docs/PESQUISA_INICIAL.md) e [a procedência cartográfica](docs/DADOS_CARTOGRAFICOS.md).
