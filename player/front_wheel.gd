extends RigidBody3D

@export var TURN_EXTENT := 15.0
@export var CAR: RigidBody3D

func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	rotation_degrees.y = CAR.rotation_degrees.y - Input.get_axis("move_right", "move_left") * TURN_EXTENT
