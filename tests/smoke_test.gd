extends SceneTree

func _init() -> void:
	var failures: Array[String] = []
	var mission_script = load("res://scripts/systems/mission_manager.gd")
	if mission_script == null:
		failures.append("MissionManager não carrega")
	else:
		var manager = mission_script.new()
		if manager.MISSIONS.size() != 5:
			failures.append("Esperadas 5 missões")
		var ids: Dictionary = {}
		var total_reward := 0
		for mission in manager.MISSIONS:
			ids[mission["id"]] = true
			total_reward += int(mission["reward"])
			if not mission.has("target") or not mission.has("reward"):
				failures.append("Missão incompleta: %s" % mission.get("id", "sem id"))
		if ids.size() != 5:
			failures.append("IDs de missão duplicados")
		while not manager.current_mission().is_empty():
			manager.complete_current()
		if manager.index != 5 or total_reward != 80:
			failures.append("Progressão ou recompensa total inválida")
		manager.free()
	if failures.is_empty():
		print("SMOKE_OK missions=5 unique_ids=5 total_reward=80 progression=complete")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)
