extends Node

var current_interactable: Interactable = null
var current_chair: Interactable = null
var current_note: Interactable = null
var current_chemical: VialStats.Composite = VialStats.Composite.NONE
var current_chemical_name: String = ""

var is_sitting: bool = false
var is_analyzing: bool = false
var is_reading: bool = false
var in_cutscene: bool = false

enum HoldState { NONE, VIAL, CHEMICAL, FLASH_DRIVE }
var is_holding: HoldState = HoldState.NONE
