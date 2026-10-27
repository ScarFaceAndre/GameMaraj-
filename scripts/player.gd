extends CharacterBody3D

const SPEED := 8.0
const ACCELERATION := 28.0

var last_direction := Vector3.FORWARD

func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input_vector.x, 0.0, input_vector.y)
	if direction.length_squared() > 0.01:
		direction = direction.normalized()
		last_direction = direction
		rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), _delta * 10.0)
	velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * _delta)
	velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * _delta)
	if not is_on_floor():
		velocity.y -= 18.0 * _delta
	else:
		velocity.y = 0.0
	move_and_slide()
