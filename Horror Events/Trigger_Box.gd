extends Area3D
class_name Trigger_Box
var played : bool

signal on_enter

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") && played != true:
		on_enter.emit()
		played = true
