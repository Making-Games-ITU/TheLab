extends Sprite3D

@export var normal_indicator : Texture
@export var filled_indicator : Texture

@export var small_size : Vector3
@export var normal_size : Vector3

@export var hidden_color : Color
@export var base_color : Color

@export var lerp_speed: float = 8.0

@export var show_distance : float = 5

var player_camera: Camera3D
var indicator_shown : bool = false
var highlighted : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_camera = get_viewport().get_camera_3d()
	modulate = hidden_color
	scale = normal_size
func _process(delta: float) -> void:
	var distance_to_player = global_position.distance_to(player_camera.global_position)
	
	if(distance_to_player < show_distance && !PlayerStats.is_reading):
		indicator_shown = true
	else :
		indicator_shown = false
	
	var target_color: Color = hidden_color
	var target_scale: Vector3 = small_size
		
	if indicator_shown:
		target_color = base_color
		target_scale = normal_size
		
	modulate = modulate.lerp(target_color, 1.0 - exp(-lerp_speed * delta))
	scale = scale.lerp(target_scale, 1.0 - exp(-lerp_speed * delta))
