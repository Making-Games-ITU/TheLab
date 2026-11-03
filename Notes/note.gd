extends Interactable
class_name Note


@export var note_camera : Camera3D 
@export var note_text : Label

var player_camera : Camera3D


func _ready() -> void:
	player_camera = get_viewport().get_camera_3d()


func focus() -> void:
	_update_prompt()
	
func _update_prompt() -> void:
	_set_outline(true)
	prompt_text = "Read"
	InteractionPrompt.instance.show_prompt(prompt_text)


func interact(interactor: Node) -> void:
	if(!PlayerStats.is_reading):
		_start_reading()
		PlayerStats.is_reading = true
		PlayerStats.current_note = self
		NoteReader.replace_text(note_text.text)
		NoteReader.show_panel()
		print("Start Reading")

func _start_reading() -> void:
	note_camera.make_current()

func _stop_reading() -> void:
	print("Not Reading Anymore")
	player_camera.make_current()
	NoteReader.hide_panel()
	PlayerStats.is_reading = false
	PlayerStats.current_note = null
