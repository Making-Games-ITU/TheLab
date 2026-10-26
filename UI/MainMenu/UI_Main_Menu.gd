extends Control

const MAIN_SCENE = preload("res://Scenes/Game.tscn")
@onready var _options_menu := $OptionsMenu
@onready var _hover_sound := $HoverSound
@onready var _click_sound := $ClickSound

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	AudioManager.one_shot(_click_sound)
	_options_menu.visible = not _options_menu.visible

func _on_button_hover() -> void:
	AudioManager.one_shot(_hover_sound)
	
