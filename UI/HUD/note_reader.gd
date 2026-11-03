extends Control

@export var text_container : RichTextLabel
@export var panel_container : Panel


func replace_text(txt : String) -> void:
	text_container.text = txt

func hide_panel() -> void:
	panel_container.hide()

func show_panel() -> void:
	panel_container.show()
