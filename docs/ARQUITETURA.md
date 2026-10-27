# Arquitetura do vertical slice

## Componentes

- `GameState`: estado persistente, reputação, relógio e posição do jogador.
- `MissionManager`: catálogo e progressão das cinco missões demonstrativas.
- `WorldBuilder`: montagem procedural do cenário provisório, povoamento, NPCs, trapiches e barco.
- `Hud`: interface, distância do objetivo, clima, relógio, reputação e transições.
- `Main`: composição dos sistemas e regras específicas da travessia.
- `Player`: movimento e orientação do personagem.

Os dados geográficos oficiais são mantidos separadamente do cenário artístico. O mundo 3D atual é uma condensação ficcional e não uma reconstrução cartográfica.

## Persistência

O salvamento usa JSON versionado em `user://marajo_save.json`. A versão inicial persiste missão, reputação, relógio e posição. F5 salva e F9 carrega.

## Próximas fronteiras

1. Substituir assentamentos procedurais por ruas e volumes derivados de dados licenciados.
2. Migrar diálogos para recursos externos revisáveis.
3. Adicionar navegação e rotinas aos NPCs.
4. Implementar controle direto de embarcação e veículos.
5. Adicionar assets produzidos com consulta cultural.
