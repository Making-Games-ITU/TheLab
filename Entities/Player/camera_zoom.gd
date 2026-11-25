extends Camera3D

@export var zoom_fov: float = 45.0
@export var zoom_speed: float = 12.0 
var goal: float = 0.0

@export_group("UI")
@export var zoom_on_icon: TextureRect
@export var zoom_off_icon: TextureRect

var _default_fov: float

func _ready() -> void:
	_default_fov = fov

func _process(delta: float) -> void:
	if Input.is_action_pressed("zoom"):
		goal = zoom_fov
		zoom_on_icon.visible = true
		zoom_off_icon.visible = false
	else:
		goal = _default_fov
		zoom_on_icon.visible = false
		zoom_off_icon.visible = true
	
	var weight := 1.0 - exp(-zoom_speed * delta)
	fov = lerpf(fov, goal, weight)
