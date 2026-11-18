extends Horror_Event

@export var horrorSoundEmitter : FmodEventEmitter2D
@export var videoPlayer : VideoStreamPlayer
@export var eyeControl : Control



func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func start_event():
	horrorSoundEmitter.play()
	eyeControl.show()
	videoPlayer.play()

func stop_event():
	horrorSoundEmitter.stop()
	eyeControl.hide()
	videoPlayer.stop()
