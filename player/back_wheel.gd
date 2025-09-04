extends RigidBody3D

@export var WHEEL_TORQUE := 300.0
@export var STOP_TORQUE := 30.0

func _physics_process(_delta: float) -> void:
	var fb = Input.get_axis("move_forward", "move_backward")
	if is_zero_approx(fb):
		apply_torque(to_global(-angular_velocity * STOP_TORQUE))
	else:
		apply_torque(to_global(Vector3(fb * WHEEL_TORQUE, 0.0, 0.0)))
