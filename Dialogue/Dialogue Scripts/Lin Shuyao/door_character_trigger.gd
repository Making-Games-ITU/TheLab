extends Node3D

@export var activation_distance : float
@export var knocking_sound: FmodEventEmitter3D
@export var character_ref : Character
var player_camera : Camera3D

var triggered : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_camera = get_viewport().get_camera_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(triggered): return
	var distance_to_player = global_position.distance_to(player_camera.global_position)
	if(distance_to_player < activation_distance):
		_start_event()

func _start_event():
	character_ref.start_dialogue("f3f09eb8-35a1-46e5-b468-a4878494cfe9")
	triggered = true
