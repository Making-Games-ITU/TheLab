extends Node
class_name AudioManager

@export var audio_event:FmodEventEmitter3D # The Ambient emitter in Game.tscn

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
	audio_event.set_parameter("ProgressionLevel", danger)
	print("Ambient progression level: ", audio_event.get_parameter("ProgressionLevel"))
