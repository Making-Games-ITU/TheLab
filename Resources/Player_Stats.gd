extends Node

@export var player_name: String = "John Science"

var current_interactable: Interactable = null
var current_chair: Interactable = null
var is_sitting: bool = false
var is_analyzing: bool = false

var has_new_vial : bool = false
var has_sample : bool = false
