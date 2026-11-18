extends Horror_Event

@export var horror_sound_emitter : FmodEventEmitter2D
@export var video_player_layer : VideoStreamPlayer
@export var eye_control : Control
@export var microscope : Microscope
@export var body_dispose : Body_Dispose


func _ready() -> void:
	print("Horror event is set and ready")
	microscope.microscope_zoomed.connect(func():
		print("zoomed signal received")
		print("Interactions: ", microscope.times_interacted)
		print("Bodies disposed: ", body_dispose.body_disposed)
		
		if(microscope.times_interacted > 3 && body_dispose.body_disposed > 1 && event_ended != true):
			start_event()
	)
	
	microscope.microscope_exit.connect(func():
		if(event_started):
			stop_event()
	)

func _process(delta: float) -> void:
	pass

func start_event():
	horror_sound_emitter.play()
	eye_control.show()
	video_player_layer.play()
	event_started = true

func stop_event():
	horror_sound_emitter.stop()
	eye_control.hide()
	video_player_layer.stop()
	event_ended = true
