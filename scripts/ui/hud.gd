extends CanvasLayer

var mission_title: Label
var mission_description: Label
var prompt: Label
var status: Label
var distance_label: Label
var toast: Label
var fade: ColorRect

func _ready() -> void:
	var panel := ColorRect.new()
	panel.color = Color(0.025, 0.045, 0.055, 0.86)
	panel.position = Vector2(20, 20)
	panel.size = Vector2(610, 118)
	add_child(panel)
	mission_title = _label(Vector2(40, 34), 25, Color("f3c64d"))
	mission_description = _label(Vector2(40, 72), 18, Color.WHITE)
	mission_description.size = Vector2(565, 55)
	mission_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status = _label(Vector2(940, 25), 17, Color.WHITE)
	distance_label = _label(Vector2(40, 145), 15, Color("d5e4e6"))
	prompt = _label(Vector2(520, 640), 26, Color("fff0a8"))
	var controls := _label(Vector2(20, 686), 15, Color.WHITE)
	controls.text = "WASD/setas: mover   E: interagir   F5: salvar   F9: carregar"
	toast = _label(Vector2(490, 570), 20, Color.WHITE)
	fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fade)

func set_mission(title: String, description: String) -> void:
	mission_title.text = title
	mission_description.text = description

func set_prompt(value: String) -> void:
	prompt.text = value

func set_distance(value: float) -> void:
	distance_label.text = "Objetivo: %dm" % int(value)

func set_world_status(minutes: float, weather: String, reputation: int) -> void:
	var hour := int(minutes / 60.0) % 24
	var minute := int(minutes) % 60
	status.text = "%02d:%02d  •  %s\nReputação comunitária: %d" % [hour, minute, weather, reputation]

func show_toast(message: String) -> void:
	toast.text = message
	toast.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_interval(1.4)
	tween.tween_property(toast, "modulate:a", 0.0, 0.7)

func fade_out() -> void:
	create_tween().tween_property(fade, "color:a", 1.0, 0.45)

func fade_in() -> void:
	create_tween().tween_property(fade, "color:a", 0.0, 0.6)

func _label(position_value: Vector2, font_size: int, color: Color) -> Label:
	var result := Label.new()
	result.position = position_value
	result.add_theme_font_size_override("font_size", font_size)
	result.add_theme_color_override("font_color", color)
	add_child(result)
	return result
