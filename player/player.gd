extends RigidBody3D

@export var FL_WHEEL_COL: CollisionShape3D
@export var FR_WHEEL_COL: CollisionShape3D
@export var BL_WHEEL_COL: CollisionShape3D
@export var BR_WHEEL_COL: CollisionShape3D
@export var FL_WHEEL_MESH: MeshInstance3D
@export var FR_WHEEL_MESH: MeshInstance3D
@export var BL_WHEEL_MESH: MeshInstance3D
@export var BR_WHEEL_MESH: MeshInstance3D

@export var DRIVE_POWER := 3000.0
@export var TURN_POWER := 1000.0

@export var WHEEL_CIRCUMFERENCE := PI

@onready var WHEEL_MESHES = [FL_WHEEL_MESH, FR_WHEEL_MESH, BL_WHEEL_MESH, BR_WHEEL_MESH]

func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	var velocity := linear_velocity

	var v_right = velocity.dot(transform.basis.x)
	var v_forward = velocity.dot(-transform.basis.z)
	var v_up = velocity.dot(transform.basis.y)

	v_right *= 0.25

	linear_velocity = (transform.basis.x * v_right) + (-transform.basis.z * v_forward) + (transform.basis.y * v_up)

func _process(delta: float) -> void:
	var fb = Input.get_axis("move_backward", "move_forward")
	apply_central_force(to_global(Vector3.FORWARD * fb * DRIVE_POWER))
	for wheel in WHEEL_MESHES:
		var dir = -1 if linear_velocity.dot(-transform.basis.z) > 0 else 1
		wheel.rotation.x += linear_velocity.length() / 0.5 * delta * dir
	
	var lr = Input.get_axis("move_right", "move_left")
	FL_WHEEL_MESH.rotation.y = lr * PI / 12
	FR_WHEEL_MESH.rotation.y = lr * PI / 12
	FL_WHEEL_COL.rotation.y = lr * PI / 12
	FR_WHEEL_COL.rotation.y = lr * PI / 12
	var turning_rate = (linear_velocity.length() / 2.5) * tan(lr * PI / 12)
	apply_torque(Vector3.UP * turning_rate * TURN_POWER)
