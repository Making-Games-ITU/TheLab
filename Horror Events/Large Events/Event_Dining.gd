extends Horror_Event

@export var horror_start_sound_emitter : FmodEventEmitter2D
@export var horror_scream_sound_emitter : FmodEventEmitter3D
@export var horror_eating_sound_emitter : FmodEventEmitter3D
@export var horror_scare_sound_emitter : FmodEventEmitter2D


@export var door : Node3D
@export var collision_shape_left_door : CollisionShape3D
@export var collision_shape_right_door : CollisionShape3D

@export var second_room : Node3D

@export var second_to_start : float = 180

@export var flashlight_spotlight : Light3D
@export var flashlight_pointlight : Light3D

@export var dining_spotlight : Light3D
@export var dining_pointlight : Light3D

@export var flashlight_trigger_box : Trigger_Box
@export var final_trigger_box : Trigger_Box

@export var eating_character : Node3D
@export var player : Player

func _ready() -> void:
	flashlight_trigger_box.on_enter.connect(_turn_off_flashlight_grounded)
	final_trigger_box.on_enter.connect(_character_eating_scare)
	await get_tree().create_timer(second_to_start).timeout
	start_event()
	

func _turn_off_flashlight_grounded():
	flashlight_spotlight.light_energy = 0
	flashlight_pointlight.light_energy = 0
	door.show()
	collision_shape_left_door.set_deferred("disabled", false)
	collision_shape_right_door.set_deferred("disabled", false)

func _process(delta: float) -> void:
	pass

func _character_eating_scare() :
	dining_pointlight.light_energy = 0
	dining_spotlight.light_energy = 0
	eating_character.hide()
	player.force_turn_off_flashlight()
	PlayerStats.flashlight_is_dead = true
	horror_eating_sound_emitter.stop()
	await get_tree().create_timer(3).timeout
	horror_scream_sound_emitter.play()
	await get_tree().create_timer(7).timeout
	%Glitch.show()
	horror_scare_sound_emitter.play()
	await get_tree().create_timer(1).timeout
	%Glitch.hide()
	stop_event()


func start_event():
	horror_eating_sound_emitter.play()
	collision_shape_left_door.set_deferred("disabled", true)
	collision_shape_right_door.set_deferred("disabled", true)
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
	get_tree().quit()
