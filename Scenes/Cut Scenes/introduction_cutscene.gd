extends Node3D

@export var flashlight : Light3D

func _end_cutscene():
	PlayerStats.in_cutscene = false
	flashlight.show()
func _start_cutscene():
	PlayerStats.in_cutscene = true
