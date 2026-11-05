extends Node

@onready var _micrograph_clear_image: ColorRect = %CellsImage
@onready var _micrograph_murky_image: ColorRect = %MurkyImage
@onready var _centrifuge_start_button := %CentrifugeButtonStart
@onready var _sampler_extract_button := %SamplerExtractButton
@onready var _sampler_inject_button := %SamplerInjectButton
var micrograph_shader: ShaderMaterial = preload("res://UI/Microscope/micrograph_shader_material.tres")

func _ready():
	_centrifuge_start_button.centrifuge_start_pressed.connect(_on_centrifuged)
	_sampler_extract_button.sampler_extract_pressed.connect(_on_blood_extracted)
	_sampler_inject_button.sampler_inject_pressed.connect(_on_blood_injected)
	_on_reset_micrograph()

func _on_blood_extracted() -> void:
	_micrograph_clear_image.visible = false
	_micrograph_murky_image.visible = true
	_set_cell_color(VialStats.BLOOD_COLOR)

func _on_centrifuged() -> void:
	_micrograph_clear_image.visible = true
	_micrograph_murky_image.visible = false
	if VialStats.damaged:
		_set_cell_color(VialStats.DAMAGED_COLOR)
		return
	var total_chem := 0.0
	var mix: Color = VialStats.BLOOD_COLOR * VialStats.BLOOD_AMOUNT
	for key in VialStats.chemicals:
		var quantity: float = VialStats.chemicals[key].quantity
		total_chem += quantity
		mix += VialStats.CHEMICAL_COLORS[key] * quantity
	_set_cell_color(mix / (VialStats.BLOOD_AMOUNT + total_chem))

func _on_blood_injected() -> void:
	_on_reset_micrograph()

func _on_reset_micrograph() -> void:
	_micrograph_clear_image.visible = false
	_micrograph_murky_image.visible = false
	_set_cell_color(VialStats.EMPTY_COLOR)

func _set_cell_color(color: Color) -> void:
	micrograph_shader.set_shader_parameter("cell_color", color)
