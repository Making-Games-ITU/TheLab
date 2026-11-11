extends Viewport
class_name  MachineScreen

@export var off_screen : ColorRect


func screen_on(on: bool) -> void:
	if(on):
		off_screen.hide()
	else:
		off_screen.show()
