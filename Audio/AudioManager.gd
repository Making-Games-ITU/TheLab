extends Node
class_name AudioManager

@export var audio_event:FmodEventEmitter3D

@onready var ambient = $Ambient

static func one_shot(event_emitter_3d: FmodEventEmitter3D) -> void:
	event_emitter_3d.play_one_shot()

static func play_loop(event_emitter_3d: FmodEventEmitter3D) -> void:
	event_emitter_3d.play(false)

static func stop(event_emitter_3d: FmodEventEmitter3D) -> void:
	event_emitter_3d.stop()

static func modify_parameter(event_emitter_3d: FmodEventEmitter3D, parameter: String, value: Variant) -> void:
	event_emitter_3d.set_parameter(parameter, value)

#Currently only ambient has another parameter, so made a specific function only for ambient
func update_ambient_param(danger : int) -> void:
	ambient.set_parameter("Progression Level", danger) 
	print("Ambient progression level: ",ambient.get_parameter("Progression Level"))
