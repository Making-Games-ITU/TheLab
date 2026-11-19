extends FmodEventEmitter3D
class_name Event_Dining_Follow_Player

var follow : bool = false
@export var speed : float
@export var rotation_speed : float
@export var footsteps_emitter : FmodEventEmitter3D

@export var event_dining : Event_Dining
@export var player : Player

var event_ended : bool

func start_event():
	footsteps_emitter.play()
	follow = true
	show()

func _process(delta: float) -> void:
	if follow == false || event_ended == true : return
	var target_vector = global_position.direction_to(player.global_position)
	var target_basis = Basis.looking_at(target_vector, Vector3.UP)
	basis = basis.slerp(target_basis, clamp(rotation_speed * delta, 0.0, 1.0))
	global_position = global_position.move_toward(player.global_position, speed * delta)
	
	if(global_position.distance_to(player.global_position) < 3 && PlayerStats.flashlight_is_dead == false):
		player.force_turn_off_flashlight()
		PlayerStats.flashlight_is_dead = true
		
	if(global_position.distance_to(player.global_position) < 1):
		_destination_reached()

func _destination_reached():
	event_ended = true
	footsteps_emitter.stop()
	hide()
	event_dining.stop_event()
