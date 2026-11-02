extends Interactable

@export var note_camera : Camera3D 
var player_camera : Camera3D

func _ready() -> void:
	player_camera = get_viewport().get_camera_3d()

func interact(interactor: Node) -> void:
	if(PlayerStats.is_reading):
		_start_reading()
	else:
		_stop_reading()

func _start_reading() -> void:
	note_camera.make_current()

func _stop_reading() -> void:
	player_camera.make_current()
