extends Node

var current_interactable: Interactable = null
var current_chair: Interactable = null
var current_note: Interactable = null

var is_sitting: bool = false
var is_analyzing: bool = false
var is_reading: bool = false

enum HoldState { NONE, VIAL, CHEMICAL }
var is_holding: HoldState = HoldState.NONE
