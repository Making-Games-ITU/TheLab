class_name GameManager
extends Node

@export var next_timer: float =  1.0

# Which baby emotion each physical button answers
var pressed : GameStats.Buttons = GameStats.interacted_button

var _clear_timer : Timer

func _ready() -> void:
	_clear_timer = Timer.new()
	_clear_timer.one_shot = true
	add_child(_clear_timer)
	_clear_timer.start(next_timer)

func _process(_delta: float) -> void:
	pass



func _game_over() -> void:
	print("You lose!")
	GameStats.game_over = true
	# Scary stuff can be set here
