extends Node3D

var boat: Node3D
var marker: MeshInstance3D

func _ready() -> void:
	_build_ground()
	_build_docks()
	_build_settlement("Salvaterra", 35.0, Color("c87955"), 1)
	_build_settlement("Soure", -43.0, Color("6f88a8"), 2)
	_build_boat()
	_build_npcs()
	marker = _mesh_node(CylinderMesh.new(), Color("f3c64d"), Vector3.ZERO)
	var marker_mesh := marker.mesh as CylinderMesh
	marker_mesh.top_radius = 0.25
	marker_mesh.bottom_radius = 0.8
	marker_mesh.height = 2.3
	var marker_material := marker.material_override as StandardMaterial3D
	marker_material.emission_enabled = true
	marker_material.emission = marker_material.albedo_color * 0.5
	add_child(marker)

func _build_ground() -> void:
	_add_static_box("Salvaterra", Vector3(0, -0.5, 35), Vector3(72, 1, 42), Color("789b58"), _terrain_material(Color("789b58"), 0.045))
	_add_water()
	_add_static_box("Soure", Vector3(0, -0.5, -43), Vector3(72, 1, 58), Color("6d9252"), _terrain_material(Color("6d9252"), 0.052))
	_add_static_box("EstradaSalvaterra", Vector3(0, 0.02, 35), Vector3(6, 0.08, 34), Color("a98759"), _terrain_material(Color("a98759"), 0.12))
	_add_static_box("EstradaSoure", Vector3(0, 0.02, -43), Vector3(7, 0.08, 48), Color("a98759"), _terrain_material(Color("a98759"), 0.12))

func _add_water() -> void:
	var body := StaticBody3D.new()
	body.name = "Paracauari"
	body.position = Vector3(0, -0.85, 0)
	var visual := MeshInstance3D.new()
	var mesh := PlaneMesh.new()
	mesh.size = Vector2(80, 28)
	mesh.subdivide_width = 80
	mesh.subdivide_depth = 28
	visual.mesh = mesh
	var material := ShaderMaterial.new()
	var shader := Shader.new()
	shader.code = """
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;
uniform vec3 shallow_color : source_color = vec3(0.08, 0.42, 0.49);
uniform vec3 deep_color : source_color = vec3(0.02, 0.16, 0.24);
void vertex() {
	float wave_a = sin(VERTEX.x * 0.42 + TIME * 1.15) * 0.10;
	float wave_b = cos(VERTEX.z * 0.55 - TIME * 0.82) * 0.07;
	VERTEX.y += wave_a + wave_b;
}
void fragment() {
	float ripple = sin((VERTEX.x + VERTEX.z) * 1.8 + TIME * 1.4) * 0.5 + 0.5;
	float fresnel = pow(1.0 - max(dot(NORMAL, VIEW), 0.0), 3.0);
	ALBEDO = mix(shallow_color, deep_color, 0.38 + ripple * 0.12);
	ROUGHNESS = 0.18;
	METALLIC = 0.05;
	SPECULAR = 0.78;
	EMISSION = vec3(0.015, 0.035, 0.04) + fresnel * vec3(0.16, 0.22, 0.24);
}
"""
	material.shader = shader
	visual.material_override = material
	body.add_child(visual)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(80, 0.6, 28)
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

func _build_docks() -> void:
	for z in [12.0, -15.0]:
		_add_static_box("Trapiche", Vector3(0, 0.3, z), Vector3(5, 0.5, 10), Color("725238"))
		for x in [-2.1, 2.1]:
			for offset in [-3.8, 0.0, 3.8]:
				_add_static_box("Esteio", Vector3(x, -0.5, z + offset), Vector3(0.25, 2.0, 0.25), Color("4d3829"))

func _build_settlement(prefix: String, center_z: float, roof_color: Color, seed_value: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	for index in range(18):
		var side := -1.0 if index % 2 == 0 else 1.0
		var row := int(index / 2)
		var pos := Vector3(side * rng.randf_range(8.0, 24.0), 1.15, center_z + row * 4.7 - 20.0)
		_add_house("%sCasa%02d" % [prefix, index], pos, roof_color, rng.randf_range(-4.0, 4.0))
	for index in range(26):
		var x := rng.randf_range(-32.0, 32.0)
		var z := rng.randf_range(center_z - 25.0, center_z + 20.0)
		if abs(x) > 5.5:
			_add_tree(Vector3(x, 0, z), rng.randf_range(0.75, 1.35))
	for index in range(90):
		var x := rng.randf_range(-34.0, 34.0)
		var z := rng.randf_range(center_z - 25.0, center_z + 20.0)
		if abs(x) > 4.0:
			_add_grass(Vector3(x, 0.08, z), rng.randf_range(0.55, 1.2), rng.randf_range(0.0, 360.0))

func _build_boat() -> void:
	boat = Node3D.new()
	boat.name = "BarcoParacauari"
	boat.position = Vector3(0, 0.25, 8)
	var hull := _mesh_node(BoxMesh.new(), Color("b73e36"), Vector3.ZERO)
	var hull_mesh := hull.mesh as BoxMesh
	hull_mesh.size = Vector3(3.2, 0.7, 6.0)
	boat.add_child(hull)
	var cabin := _mesh_node(BoxMesh.new(), Color("f2e2bd"), Vector3(0, 0.8, -0.5))
	var cabin_mesh := cabin.mesh as BoxMesh
	cabin_mesh.size = Vector3(2.2, 1.4, 2.2)
	boat.add_child(cabin)
	add_child(boat)

func _build_npcs() -> void:
	_add_npc("GuiaComunitaria", Vector3(-8, 1, -35), Color("e5a04f"))
	_add_npc("Pescadora", Vector3(13, 1, -22), Color("4da6a6"))
	_add_npc("Cartografa", Vector3(-15, 1, -52), Color("7654a6"))
	_add_npc("MestreBrincante", Vector3(12, 1, -55), Color("d95175"))
	for index in range(10):
		var z := 28.0 + index * 3.0 if index < 5 else -34.0 - (index - 5) * 4.0
		_add_npc("Morador%02d" % index, Vector3(-4.2 if index % 2 == 0 else 4.2, 1, z), Color("8b6f55"))

func move_marker(target: Vector3, color: Color) -> void:
	marker.visible = true
	marker.position = target + Vector3(0, 1.3, 0)
	var material := marker.material_override as StandardMaterial3D
	material.albedo_color = color
	material.emission = color * 0.55

func hide_marker() -> void:
	marker.visible = false

func _add_house(node_name: String, pos: Vector3, roof_color: Color, yaw: float = 0.0) -> void:
	var house := Node3D.new()
	house.name = node_name
	house.position = pos
	house.rotation_degrees.y = yaw
	var base := _mesh_node(BoxMesh.new(), Color("e6cf9d"), Vector3.ZERO)
	var base_mesh := base.mesh as BoxMesh
	base_mesh.size = Vector3(4.5, 2.3, 4.0)
	house.add_child(base)
	var roof := _mesh_node(PrismMesh.new(), roof_color, Vector3(0, 1.7, 0))
	var roof_mesh := roof.mesh as PrismMesh
	roof_mesh.size = Vector3(5.3, 1.5, 4.8)
	house.add_child(roof)
	var door := _mesh_node(BoxMesh.new(), Color("493426"), Vector3(0, -0.2, 2.03))
	var door_mesh := door.mesh as BoxMesh
	door_mesh.size = Vector3(1.0, 1.6, 0.08)
	house.add_child(door)
	for window_x in [-1.35, 1.35]:
		var window := _mesh_node(BoxMesh.new(), Color("87b9c2"), Vector3(window_x, 0.25, 2.04))
		var window_mesh := window.mesh as BoxMesh
		window_mesh.size = Vector3(0.72, 0.72, 0.06)
		var window_material := window.material_override as StandardMaterial3D
		window_material.metallic = 0.25
		window_material.roughness = 0.18
		house.add_child(window)
	var porch := _mesh_node(BoxMesh.new(), Color("76553a"), Vector3(0, -1.04, 2.65))
	var porch_mesh := porch.mesh as BoxMesh
	porch_mesh.size = Vector3(4.8, 0.16, 1.3)
	house.add_child(porch)
	for stilt_x in [-1.7, 1.7]:
		for stilt_z in [-1.4, 1.4]:
			var stilt := _mesh_node(CylinderMesh.new(), Color("503a29"), Vector3(stilt_x, -1.45, stilt_z))
			var stilt_mesh := stilt.mesh as CylinderMesh
			stilt_mesh.top_radius = 0.12
			stilt_mesh.bottom_radius = 0.16
			stilt_mesh.height = 0.85
			house.add_child(stilt)
	add_child(house)

func _add_tree(pos: Vector3, scale_value: float) -> void:
	var tree := Node3D.new()
	tree.position = pos
	tree.scale = Vector3.ONE * scale_value
	var trunk := _mesh_node(CylinderMesh.new(), Color("69492f"), Vector3(0, 1.1, 0))
	var trunk_mesh := trunk.mesh as CylinderMesh
	trunk_mesh.top_radius = 0.22
	trunk_mesh.bottom_radius = 0.32
	trunk_mesh.height = 2.2
	tree.add_child(trunk)
	var crown := _mesh_node(SphereMesh.new(), Color("397845"), Vector3(0, 2.8, 0))
	var crown_mesh := crown.mesh as SphereMesh
	crown_mesh.radius = 1.25
	crown_mesh.height = 2.2
	tree.add_child(crown)
	var crown_highlight := _mesh_node(SphereMesh.new(), Color("55945a"), Vector3(-0.45, 3.15, 0.15))
	var highlight_mesh := crown_highlight.mesh as SphereMesh
	highlight_mesh.radius = 0.72
	highlight_mesh.height = 1.25
	tree.add_child(crown_highlight)
	add_child(tree)

func _add_grass(pos: Vector3, scale_value: float, yaw: float) -> void:
	var clump := Node3D.new()
	clump.position = pos
	clump.rotation_degrees.y = yaw
	clump.scale = Vector3.ONE * scale_value
	for angle in [-28.0, 0.0, 31.0]:
		var blade := _mesh_node(QuadMesh.new(), Color("4f793e"), Vector3.ZERO)
		var blade_mesh := blade.mesh as QuadMesh
		blade_mesh.size = Vector2(0.34, 0.75)
		blade.position.y = 0.37
		blade.rotation_degrees.y = angle
		var blade_material := blade.material_override as StandardMaterial3D
		blade_material.cull_mode = BaseMaterial3D.CULL_DISABLED
		clump.add_child(blade)
	add_child(clump)

func _add_npc(node_name: String, pos: Vector3, color: Color) -> void:
	var npc := _mesh_node(CapsuleMesh.new(), color, pos)
	npc.name = node_name
	var npc_mesh := npc.mesh as CapsuleMesh
	npc_mesh.radius = 0.48
	npc_mesh.height = 1.7
	add_child(npc)

func _add_static_box(node_name: String, pos: Vector3, size: Vector3, color: Color, custom_material: Material = null) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = pos
	var visual := _mesh_node(BoxMesh.new(), color, Vector3.ZERO)
	var box_mesh := visual.mesh as BoxMesh
	box_mesh.size = size
	if custom_material != null:
		visual.material_override = custom_material
	body.add_child(visual)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

func _terrain_material(base_color: Color, frequency: float) -> StandardMaterial3D:
	var noise := FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = frequency
	noise.fractal_octaves = 5
	noise.fractal_gain = 0.55
	var texture := NoiseTexture2D.new()
	texture.width = 512
	texture.height = 512
	texture.seamless = true
	texture.noise = noise
	var ramp := Gradient.new()
	ramp.set_color(0, base_color.darkened(0.28))
	ramp.set_color(1, base_color.lightened(0.16))
	texture.color_ramp = ramp
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.WHITE
	material.albedo_texture = texture
	material.roughness = 0.92
	material.uv1_scale = Vector3(9, 9, 9)
	return material

func _mesh_node(mesh_value: Mesh, color: Color, pos: Vector3) -> MeshInstance3D:
	var result := MeshInstance3D.new()
	result.mesh = mesh_value
	result.position = pos
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.88
	result.material_override = material
	return result
