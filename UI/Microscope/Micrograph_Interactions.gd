extends Node

@onready var _centrifuge_start_button := %CentrifugeButtonStart
@onready var _sampler_extract_button := %SamplerExtractButton

func _ready():
	_centrifuge_start_button.centrifuge_start_pressed.connect(_on_enable_clear_image)
	_sampler_extract_button.sampler_extract_pressed.connect(_on_enable_murky_image)

@onready var _micrograph_clear_image: ColorRect = %CellsImage
@onready var _micrograph_murky_image: ColorRect = %MurkyImage

func _on_enable_clear_image() -> void:
	_micrograph_clear_image.visible = true
	_micrograph_murky_image.visible = false
	
func _on_enable_murky_image() -> void:
	_micrograph_clear_image.visible = false
	_micrograph_murky_image.visible = true
