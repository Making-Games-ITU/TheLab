extends Node

@export var notepad_main_ui: VBoxContainer
@export var text_edit: TextEdit
@export var close_button: Button

func _ready() -> void:
	close_button.pressed.connect(close_notepad)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("notepad"):
		if notepad_main_ui.visible:
			close_notepad()
		elif _can_open():
			open_notepad()
		else:
			return
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("escape") and notepad_main_ui.visible:
		close_notepad()
		get_viewport().set_input_as_handled()

func _can_open() -> bool:
	return not PlayerStats.in_cutscene

func open_notepad() -> void:
	notepad_main_ui.visible = true
	PlayerStats.is_typing = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	text_edit.grab_focus()
	var last_line := text_edit.get_line_count() - 1
	text_edit.set_caret_line(last_line)
	text_edit.set_caret_column(text_edit.get_line(last_line).length())

func close_notepad() -> void:
	text_edit.release_focus()
	notepad_main_ui.visible = false
	PlayerStats.is_typing = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
