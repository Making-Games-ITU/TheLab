extends Horror_Event

@export var horror_jumpscare_emitter : FmodEventEmitter3D
@export var horror_breathing_emitter : FmodEventEmitter3D

@export var body_order : Request_Body
@export var on_screen_enabler : VisibleOnScreenEnabler3D
@export var corpse_on_table : Node3D
@export var corpse_in_chamber : Node3D

func _ready() -> void:
	
		body_order.on_body_order.connect(func():
			if(GameStats.body_number > 3 && event_ended != true):
				print("Bodies ordered", GameStats.body_number)
				start_event()
		)
	
	

func _process(_delta: float) -> void:
	if(on_screen_enabler.is_on_screen() && event_started && event_ended != true):
		stop_event()

func start_event():
	horror_breathing_emitter.play()
	event_started = true
	corpse_on_table.show()
	GameStats.power = false
	await get_tree().create_timer(2.4).timeout
	if(event_ended == true) : return
	corpse_in_chamber.hide()

func stop_event():
	event_ended = true
	await get_tree().create_timer(.5).timeout
	%Glitch.show()
	horror_jumpscare_emitter.play()
	horror_breathing_emitter.stop()
	await get_tree().create_timer(.2).timeout
	corpse_on_table.hide()
	corpse_in_chamber.show()
	await get_tree().create_timer(.1).timeout
	GameStats.power = true
	%Glitch.hide()
	
