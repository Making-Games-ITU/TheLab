extends Node

@onready var _micrograph_clear_image: ColorRect = %CellsImage
@onready var _micrograph_murky_image: ColorRect = %MurkyImage
@onready var _centrifuge_start_button := %CentrifugeButtonStart
@onready var _sampler_extract_button := %SamplerExtractButton
@onready var _sampler_inject_button := %SamplerInjectButton
@onready var _pipette_fill_button :=  %Pipette_Button_Start
var micrograph_shader: ShaderMaterial = preload("res://UI/Microscope/micrograph_shader_material.tres")

func _ready():
	_centrifuge_start_button.centrifuge_start_pressed.connect(_on_centrifuged)
	_sampler_extract_button.sampler_extract_pressed.connect(_on_blood_extracted)
	_sampler_inject_button.sampler_inject_pressed.connect(_on_blood_injected)
	_pipette_fill_button.pipette_start_pressed.connect(_on_chemical_added)
	_on_reset_micrograph()

func _on_blood_extracted() -> void:
	_micrograph_clear_image.visible = false
	_micrograph_murky_image.visible = true
	_set_cell_color(VialStats.BLOOD_COLOR)
	_set_mutation_parameters(0)
	_set_parasite_parameters(0)

func _on_centrifuged() -> void:
	_micrograph_clear_image.visible = true
	_micrograph_murky_image.visible = false
	if VialStats.damaged:
		_set_cell_color(VialStats.DAMAGED_COLOR)
		micrograph_shader.set_shader_parameter("chemical_amount_0", 0)
		micrograph_shader.set_shader_parameter("chemical_amount_1", 0)
		return
	var total_chem := 0.0
	var mix: Color = VialStats.BLOOD_COLOR * VialStats.BLOOD_AMOUNT
	for key in VialStats.chemicals:
		var quantity: float = VialStats.chemicals[key].quantity
		total_chem += quantity
		mix += VialStats.CHEMICAL_COLORS[key] * quantity
	_set_cell_color(mix / (VialStats.BLOOD_AMOUNT + total_chem))
	micrograph_shader.set_shader_parameter("chemical_amount_0", 0)
	micrograph_shader.set_shader_parameter("chemical_amount_1", 0)
	if VialStats.infection == VialStats.InfectionType.NONE:
		_set_mutation_parameters(0)
		_set_parasite_parameters(0)
	elif VialStats.infection == VialStats.InfectionType.CELL_MUTATION:
		if GameStats.body_state == 1:
			_set_mutation_parameters(0)
		else:
			_set_mutation_parameters(20)
	elif VialStats.infection == VialStats.InfectionType.PARASITES:
		if GameStats.body_state == 1:
			_set_parasite_parameters(0)
		else:
			_set_parasite_parameters(20)
	elif VialStats.infection == VialStats.InfectionType.BOTH:
		if GameStats.body_state == 1:
			_set_mutation_parameters(0)
			_set_parasite_parameters(0)
		else:
			_set_mutation_parameters(20)
			_set_parasite_parameters(20)

func _on_blood_injected() -> void:
	_on_reset_micrograph()
	
func _on_chemical_added(chemicalColor : VialStats.Composite) -> void:
	match chemicalColor:
		VialStats.Composite.HYDROGEN:
			micrograph_shader.set_shader_parameter("chemical_color_1", VialStats.CHEMICAL_COLORS.get(chemicalColor))
			micrograph_shader.set_shader_parameter("chemical_amount_1", 20)
		VialStats.Composite.NITROGEN:
			micrograph_shader.set_shader_parameter("chemical_color_0", VialStats.CHEMICAL_COLORS.get(chemicalColor))
			micrograph_shader.set_shader_parameter("chemical_amount_0", 20)
		
	

func _on_reset_micrograph() -> void:
	_micrograph_clear_image.visible = false
	_micrograph_murky_image.visible = false
	_set_cell_color(VialStats.EMPTY_COLOR)

func _set_cell_color(color: Color) -> void:
	micrograph_shader.set_shader_parameter("cell_color", color)


func _set_mutation_parameters(percent: int) -> void:
	if VialStats.chemicals[VialStats.Composite.NITROGEN].integrated:
		micrograph_shader.set_shader_parameter("mutation_percentage", 0)
	else:
		micrograph_shader.set_shader_parameter("mutation_percentage", percent)

func _set_parasite_parameters(amount: int) -> void:
	if VialStats.chemicals[VialStats.Composite.HYDROGEN].integrated:
		micrograph_shader.set_shader_parameter("parasite_amount", 0)
	else:
		micrograph_shader.set_shader_parameter("parasite_amount", amount)
