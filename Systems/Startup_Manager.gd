extends Node

@onready var _world_environment: WorldEnvironment = %WorldEnvironment

func _ready() -> void:
	_world_environment.environment.adjustment_brightness = GameStats.game_brightness
