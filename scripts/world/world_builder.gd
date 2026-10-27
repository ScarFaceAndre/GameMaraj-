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
	_add_static_box("Salvaterra", Vector3(0, -0.5, 35), Vector3(72, 1, 42), Color("8ebf69"))
	_add_static_box("Paracauari", Vector3(0, -0.85, 0), Vector3(80, 0.6, 28), Color("357d99"))
	_add_static_box("Soure", Vector3(0, -0.5, -43), Vector3(72, 1, 58), Color("78ad64"))
	_add_static_box("EstradaSalvaterra", Vector3(0, 0.02, 35), Vector3(6, 0.08, 34), Color("c9a96b"))
	_add_static_box("EstradaSoure", Vector3(0, 0.02, -43), Vector3(7, 0.08, 48), Color("c9a96b"))

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
		_add_house("%sCasa%02d" % [prefix, index], pos, roof_color)
	for index in range(26):
		var x := rng.randf_range(-32.0, 32.0)
		var z := rng.randf_range(center_z - 25.0, center_z + 20.0)
		if abs(x) > 5.5:
			_add_tree(Vector3(x, 0, z), rng.randf_range(0.75, 1.35))

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

func _add_house(node_name: String, pos: Vector3, roof_color: Color) -> void:
	var house := Node3D.new()
	house.name = node_name
	house.position = pos
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
	add_child(tree)

func _add_npc(node_name: String, pos: Vector3, color: Color) -> void:
	var npc := _mesh_node(CapsuleMesh.new(), color, pos)
	npc.name = node_name
	var npc_mesh := npc.mesh as CapsuleMesh
	npc_mesh.radius = 0.48
	npc_mesh.height = 1.7
	add_child(npc)

func _add_static_box(node_name: String, pos: Vector3, size: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = pos
	var visual := _mesh_node(BoxMesh.new(), color, Vector3.ZERO)
	var box_mesh := visual.mesh as BoxMesh
	box_mesh.size = size
	body.add_child(visual)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

func _mesh_node(mesh_value: Mesh, color: Color, pos: Vector3) -> MeshInstance3D:
	var result := MeshInstance3D.new()
	result.mesh = mesh_value
	result.position = pos
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.88
	result.material_override = material
	return result
