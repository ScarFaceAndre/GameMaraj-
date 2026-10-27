extends Node

signal mission_changed(mission: Dictionary)
signal mission_completed(id: String, reward: int)

const MISSIONS := [
	{"id":"travessia", "title":"ENTRE DUAS MARGENS", "description":"Vá ao porto de Salvaterra e embarque para Soure.", "action":"Embarcar", "target":Vector3(0, 1, 13), "reward":10, "color":Color("f3c64d")},
	{"id":"guia", "title":"VOZES DA CIDADE", "description":"Encontre a guia comunitária na entrada de Soure.", "action":"Conversar", "target":Vector3(-8, 1, -35), "reward":10, "color":Color("ef7f50")},
	{"id":"pesca", "title":"MARÉ DE TRABALHO", "description":"Converse com a pescadora no trapiche sobre a mudança das marés.", "action":"Ouvir relato", "target":Vector3(13, 1, -22), "reward":15, "color":Color("65d6c4")},
	{"id":"cartografia", "title":"CAMINHOS DA MEMÓRIA", "description":"Ajude a cartógrafa a registrar um caminho comunitário.", "action":"Registrar caminho", "target":Vector3(-15, 1, -52), "reward":20, "color":Color("a78bfa")},
	{"id":"festa", "title":"SOM DE FESTA", "description":"Leve os registros ao mestre brincante na praça.", "action":"Entregar registros", "target":Vector3(12, 1, -55), "reward":25, "color":Color("ff7aa2")}
]

var index := 0

func current_mission() -> Dictionary:
	return MISSIONS[index] if index < MISSIONS.size() else {}

func complete_current() -> void:
	if index >= MISSIONS.size():
		return
	var completed: Dictionary = MISSIONS[index]
	index += 1
	mission_completed.emit(completed["id"], completed["reward"])
	mission_changed.emit(current_mission())

func set_index(value: int) -> void:
	index = clampi(value, 0, MISSIONS.size())
	mission_changed.emit(current_mission())
