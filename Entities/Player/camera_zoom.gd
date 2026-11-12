extends Camera3D

@export var zoom_fov: float = 45.0
@export var zoom_speed: float = 12.0 

var _default_fov: float

func _ready() -> void:
	_default_fov = fov

func _process(delta: float) -> void:
	var goal := zoom_fov if Input.is_action_pressed("zoom") else _default_fov
	var weight := 1.0 - exp(-zoom_speed * delta)
	fov = lerpf(fov, goal, weight)
