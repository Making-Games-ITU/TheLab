extends Node3D

func _ready() -> void:
	_prewarm()

func _prewarm() -> void:
	visible = true
	await RenderingServer.frame_post_draw
	visible = false
	
