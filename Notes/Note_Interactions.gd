extends Interactable

@export var note_camera: Camera3D 
@export var note_text: Label
@export var stop_reading_sound: FmodEventEmitter3D
var player_camera: Camera3D

func _ready() -> void:
	super()
	player_camera = get_viewport().get_camera_3d()

func focus() -> void:
	_update_prompt()
	
func _update_prompt() -> void:
	if PlayerStats.is_reading:
		_set_outline(false)
		InteractionPrompt.instance.hide_prompt()
	else:
		_set_outline(true)
		InteractionPrompt.instance.show_prompt(prompt_text)
	
func interact(interactor: Node) -> void:
	if not PlayerStats.is_reading:
		_start_reading()
	else:
		_stop_reading()

func _start_reading() -> void:
	note_camera.make_current()
	PlayerStats.is_reading = true
	PlayerStats.current_note = self
	%NoteText.text = note_text.text
	%NoteReader.visible = true
	%ExitFullscreenImage.visible = true
	_update_prompt()
	AudioManager.one_shot(sound_emitter)
	print("Reading")

func _stop_reading() -> void:
	player_camera.make_current()
	%NoteReader.visible = false
	%ExitFullscreenImage.visible = false
	PlayerStats.is_reading = false
	PlayerStats.current_note = null
	AudioManager.one_shot(stop_reading_sound)
	_update_prompt()
