extends SceneTree

func _init() -> void:
	var state_script = load("res://scripts/core/game_state.gd")
	var state = state_script.new()
	state.reputation = 80
	state.completed_missions = 5
	state.world_minutes = 1110.0
	state.player_position = Vector3(3, 1.2, -55)
	if not state.save_game():
		push_error("Falha ao salvar estado")
		state.free()
		quit(1)
		return
	state.reputation = 0
	state.completed_missions = 0
	state.player_position = Vector3.ZERO
	if not state.load_game():
		push_error("Falha ao carregar estado")
		state.free()
		quit(1)
		return
	if state.reputation != 80 or state.completed_missions != 5 or not state.player_position.is_equal_approx(Vector3(3, 1.2, -55)):
		push_error("Estado restaurado não corresponde ao salvo")
		state.free()
		quit(1)
		return
	print("STATE_OK version=1 reputation=80 missions=5 position=restored")
	state.free()
	quit(0)
