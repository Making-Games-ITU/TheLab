extends Node

@export var notepad_main_ui: Panel

func _process(_delta) -> void:
	if Input.is_action_just_pressed("notepad"):
		notepad_main_ui.visible = !notepad_main_ui.visible
