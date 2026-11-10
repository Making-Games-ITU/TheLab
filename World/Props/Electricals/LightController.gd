extends Node
class_name LightController

@export var lamp_lights : Array[Light3D]
@export var area_lights : Array[AreaLight3D]

@export var machine_screens : Array[MachineScreen]

signal turn_off_all_lights_signal
signal turn_on_all_lights_signal

func _ready() -> void:
	turn_off_all_lights_signal.connect(turn_off_all_lights)
	turn_on_all_lights_signal.connect(turn_on_all_lights)
	turn_off_all_lights()

func turn_off_all_lights():
	for lamp in lamp_lights:
		lamp.hide()
	for area in area_lights:
		area.hide()
	%WorldEnvironment.environment.set_ambient_light_energy(0.1)

func turn_on_all_lights():
	for lamp in lamp_lights:
		lamp.show()
	for area in area_lights:
		area.show()
	%WorldEnvironment.environment.set_ambient_light_energy(0.2)

func turn_on_all_machines():
	for machine in machine_screens:
		machine.screen_on(true)
