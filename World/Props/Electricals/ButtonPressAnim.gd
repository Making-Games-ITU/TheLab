extends Node3D
class_name ButtonPressAnimation

@export var press_offset := Vector3(0,0,-0.02)
@export var press_duration := 0.06
@export var release_duration := 0.10

var start_position: Vector3
var press_tween: Tween



func _ready() -> void:
	start_position = position
	

func press() -> void:
	if press_tween:
		press_tween.kill()
		
	var pushed_position := start_position + basis * press_offset

	press_tween = create_tween()
	press_tween.set_trans(Tween.TRANS_QUAD)
	press_tween.set_ease(Tween.EASE_OUT)
	
	press_tween.tween_property(
		self, "position", pushed_position, press_duration
	)
	press_tween.tween_property(
		self, "position", start_position, release_duration
	)
	
