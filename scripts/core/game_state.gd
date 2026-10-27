extends Node

signal state_changed
signal status_message(message: String)

const SAVE_PATH := "user://marajo_save.json"

var reputation := 0
var completed_missions := 0
var world_minutes := 8.0 * 60.0
var weather := "Céu aberto"
var player_position := Vector3(0, 1.2, 41)

func emit_state_changed() -> void:
	state_changed.emit()

func save_game() -> bool:
	var payload := {
		"version": 1,
		"reputation": reputation,
		"completed_missions": completed_missions,
		"world_minutes": world_minutes,
		"player_position": [player_position.x, player_position.y, player_position.z]
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(payload))
	return true

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY or int(data.get("version", 0)) != 1:
		return false
	reputation = int(data.get("reputation", 0))
	completed_missions = int(data.get("completed_missions", 0))
	world_minutes = float(data.get("world_minutes", 480.0))
	var position_data: Array = data.get("player_position", [0.0, 1.2, 41.0])
	if position_data.size() == 3:
		player_position = Vector3(float(position_data[0]), float(position_data[1]), float(position_data[2]))
	state_changed.emit()
	return true
