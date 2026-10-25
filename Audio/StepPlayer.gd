extends Node

@export var useful_SFX:FmodEventEmitter3D

func very_useful_function() ->void:
	$AudioManager.one_shot(useful_SFX)
	pass
