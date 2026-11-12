extends Node3D

@export var target: Node3D
@export var rotation_speed : float = 20.0

var _offset: Vector3

func _ready() -> void:
	_offset = target.global_transform.affine_inverse() * global_position
	top_level = true

func _process(delta: float) -> void:
	if target == null:
		return
	var current := global_basis.get_rotation_quaternion()
	var goal := target.global_basis.get_rotation_quaternion()
	var weight := 1.0 - exp(-rotation_speed * delta)
	global_basis = Basis(current.slerp(goal, weight))
	global_position = target.global_position + global_basis * _offset
