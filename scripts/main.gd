extends Node3D

const PlayerScript := preload("res://scripts/player.gd")
const WorldBuilder := preload("res://scripts/world/world_builder.gd")
const MissionManager := preload("res://scripts/systems/mission_manager.gd")
const Hud := preload("res://scripts/ui/hud.gd")

var player: CharacterBody3D
var world_builder: Node3D
var mission_manager: Node
var hud: CanvasLayer
var sun: DirectionalLight3D
var environment: Environment
var boat: Node3D
var transition_active := false

func _ready() -> void:
	_build_lighting()
	world_builder = WorldBuilder.new()
	add_child(world_builder)
	boat = world_builder.boat
	_build_player()
	mission_manager = MissionManager.new()
	add_child(mission_manager)
	hud = Hud.new()
	add_child(hud)
	mission_manager.mission_changed.connect(_on_mission_changed)
	mission_manager.mission_completed.connect(_on_mission_completed)
	GameState.state_changed.connect(_refresh_hud)
	GameState.status_message.connect(hud.show_toast)
	_restore_session()
	_on_mission_changed(mission_manager.current_mission())

func _process(delta: float) -> void:
	_update_world_time(delta)
	var mission: Dictionary = mission_manager.current_mission()
	if mission.is_empty():
		hud.set_prompt("")
		return
	var target: Vector3 = mission["target"]
	var distance := player.global_position.distance_to(target)
	hud.set_prompt("[E] %s" % mission["action"] if distance < 3.2 else "")
	hud.set_distance(distance)
	if distance < 3.2 and Input.is_action_just_pressed("interact") and not transition_active:
		_resolve_mission_interaction(mission)
	if Input.is_action_just_pressed("save_game"):
		_save_session()
	if Input.is_action_just_pressed("load_game"):
		_restore_session()

func _build_lighting() -> void:
	sun = DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = Vector3(-52, -28, 0)
	sun.light_color = Color("ffe4bd")
	sun.light_energy = 1.15
	sun.shadow_enabled = true
	add_child(sun)
	var world := WorldEnvironment.new()
	environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("78a7b5")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("dbe8d2")
	environment.ambient_light_energy = 0.72
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = Color("b7d6d8")
	environment.fog_density = 0.0025
	world.environment = environment
	add_child(world)

func _build_player() -> void:
	player = CharacterBody3D.new()
	player.name = "Player"
	player.set_script(PlayerScript)
	player.position = Vector3(0, 1.2, 41)
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.55
	shape.height = 1.8
	collision.shape = shape
	player.add_child(collision)
	var visual := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.radius = 0.55
	mesh.height = 1.8
	visual.mesh = mesh
	visual.material_override = _material(Color("9b3f58"))
	player.add_child(visual)
	add_child(player)
	var camera := Camera3D.new()
	camera.position = Vector3(0, 13, 15)
	camera.rotation_degrees = Vector3(-38, 0, 0)
	player.add_child(camera)

func _resolve_mission_interaction(mission: Dictionary) -> void:
	if mission["id"] == "travessia":
		transition_active = true
		hud.fade_out()
		var tween := create_tween()
		tween.tween_property(boat, "position:z", -17.0, 1.2)
		tween.tween_callback(func(): player.global_position = Vector3(0, 1.2, -31))
		tween.tween_callback(hud.fade_in)
		tween.tween_callback(func(): transition_active = false)
	mission_manager.complete_current()

func _on_mission_changed(mission: Dictionary) -> void:
	if mission.is_empty():
		hud.set_mission("CAPÍTULO CONCLUÍDO", "Explore livremente as duas margens.")
		world_builder.hide_marker()
	else:
		hud.set_mission(mission["title"], mission["description"])
		world_builder.move_marker(mission["target"], mission["color"])

func _on_mission_completed(_id: String, reward: int) -> void:
	GameState.reputation += reward
	GameState.completed_missions = mission_manager.index
	GameState.emit_state_changed()
	GameState.status_message.emit("Missão concluída • +%d reputação" % reward)
	_save_session(false)

func _update_world_time(delta: float) -> void:
	GameState.world_minutes = fmod(GameState.world_minutes + delta * 2.4, 1440.0)
	var hour := GameState.world_minutes / 60.0
	var daylight: float = clampf(sin((hour - 6.0) / 12.0 * PI), 0.12, 1.0)
	sun.rotation_degrees.x = -8.0 - daylight * 62.0
	sun.light_energy = 0.2 + daylight
	environment.ambient_light_energy = 0.22 + daylight * 0.5
	environment.background_color = Color("27364f").lerp(Color("78a7b5"), daylight)
	var closed_weather := int(GameState.world_minutes / 180.0) % 4 == 2
	GameState.weather = "Tempo fechado" if closed_weather else "Céu aberto"
	environment.fog_density = 0.008 if closed_weather else 0.0025
	hud.set_world_status(GameState.world_minutes, GameState.weather, GameState.reputation)

func _save_session(show_message := true) -> void:
	GameState.player_position = player.global_position
	GameState.completed_missions = mission_manager.index
	GameState.save_game()
	if show_message:
		GameState.status_message.emit("Jogo salvo")

func _restore_session() -> void:
	if GameState.load_game():
		player.global_position = GameState.player_position
		mission_manager.set_index(GameState.completed_missions)
		GameState.status_message.emit("Progresso restaurado")
	else:
		mission_manager.set_index(GameState.completed_missions)
	_refresh_hud()

func _refresh_hud() -> void:
	hud.set_world_status(GameState.world_minutes, GameState.weather, GameState.reputation)

func _material(color: Color) -> StandardMaterial3D:
	var result := StandardMaterial3D.new()
	result.albedo_color = color
	result.roughness = 0.82
	return result
