extends Horror_Event

@export var horror_start_sound_emitter : FmodEventEmitter2D
@export var door : Node3D
@export var collision_shape : CollisionShape3D

@export var second_room : Node3D

@export var second_to_start : float = 5


func _ready() -> void:
	await get_tree().create_timer(second_to_start).timeout
	start_event()
	

func _process(delta: float) -> void:
	pass

func start_event():
	collision_shape.set_deferred("disabled", true)
	%Glitch.show()
	GameStats.power = false
	%LightController.turn_off_all_lights()
	%LightController.turn_off_all_machines()
	horror_start_sound_emitter.play()
	await get_tree().create_timer(.2).timeout
	door.hide()
	await get_tree().create_timer(.1).timeout
	%Glitch.hide()
	second_room.show()
	event_started = true

func stop_event():
	event_ended = true
