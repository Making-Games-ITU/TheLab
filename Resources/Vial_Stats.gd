extends Node

# Vial shader related stats
const MIN_HEIGHT := 0.05      # liquid_height with only blood
const FULL_HEIGHT := 0.5      # liquid_height when full; tune to your mesh
const MAX_QUANTITY := 10.0    # total quantity that counts as full
const BLOOD_AMOUNT := 0.2     # how strongly the blood counts in the color mix
const MAX_CHEMICAL := 10.0    # total chemical amount that fills the vial
const EMPTY_COLOR := Color(0.0, 0.0, 0.0)
const DAMAGED_COLOR := Color(1.0, 1.0, 1.0)
const BLOOD_COLOR := Color(1.0, 0.0, 0.0)
const CHEMICAL_COLORS := {
	Composite.HYDROGEN: Color(0.0, 1.0, 0.0),
	Composite.NITROGEN: Color(0.0, 0.0, 1.0),
}
var empty: bool = true
var liquid_material: ShaderMaterial = preload("res://World/Items/Test Tube/Test_tube_liquid_shader_material.tres")

# Infection related stats
enum InfectionType { NONE, CELL_MUTATION, PARASITES, BOTH}
var infection: InfectionType = InfectionType.NONE

#TODO: Some form of cure variable for each infection
#TODO: What cures Cell mutation?

# Chemical related stats
enum Composite { NONE, HYDROGEN, NITROGEN }
class Chemical:
	var quantity: float = 0.0
	var integrated: bool = false
var chemicals: Dictionary[Composite, Chemical] = {
	Composite.HYDROGEN: Chemical.new(), # A
	Composite.NITROGEN: Chemical.new(), # B
}

# Centrifuge related stats
var murky: bool = false
var centrifuged: bool = false
var damaged: bool = false
const CHEMICAL_A_INTEGRATION_SPEED: int = 2
const CHEMICAL_B_INTEGRATION_SPEED: int = 4
const CENTRIFUGE_DAMAGE_SPEED: int = 5

func _ready() -> void:
	_update_liquid()

# Vial liquid shader update
func _update_liquid() -> void:
	if empty:
		_set_liquid(-1.0, EMPTY_COLOR)
		return
	if damaged:
		_set_liquid(1.0, DAMAGED_COLOR)
		return
	var total_chem := 0.0
	var mix := BLOOD_COLOR * BLOOD_AMOUNT
	for key in chemicals:
		var _quantity: float = chemicals[key].quantity
		total_chem += _quantity
		mix += CHEMICAL_COLORS[key] * _quantity
	var color := mix / (BLOOD_AMOUNT + total_chem)
	var fill := clampf(total_chem / MAX_CHEMICAL, 0.0, 1.0)
	_set_liquid(lerpf(MIN_HEIGHT, FULL_HEIGHT, fill), color)

# Vial liquid shader uptade
func _set_liquid(height: float, color: Color) -> void:
	liquid_material.set_shader_parameter("liquid_height", height)
	liquid_material.set_shader_parameter("liquid_surface_color", color.lightened(0.3))
	var gradient_tex = liquid_material.get_shader_parameter("liquid_rim_gradient")
	gradient_tex.gradient.set_color(0, color)

# Reset vial
func empty_vial() -> void:
	infection = InfectionType.NONE
	empty = true
	damaged = false
	centrifuged = false
	for key in chemicals:
		chemicals[key] = Chemical.new()
	_update_liquid()

# Pipette: adding chemical composition to vial
func add_chemical(composite: Composite, amount: float) -> void:
	empty = false
	var _chemical: Chemical = chemicals[composite]
	_chemical.quantity += amount
	_chemical.integrated = false
	_update_liquid()

# Centrifuge
func centrifuge(speed: int) -> void:
	if speed >= CENTRIFUGE_DAMAGE_SPEED or damaged:
		damaged = true
		print("Centrifuge result: Damage (pre-check)")
		return
	
	var _conflicting_intergration = false
	
	for key: Composite in chemicals:
		var chemical := chemicals[key]
		if chemical.quantity <= 0.0:
			continue
		 
		if chemical.integrated == true:
			continue
		
		if  _conflicting_intergration:
			damaged = true 
			print("Attempting to integrate multiple chemicals: Sample damaged")
			return
		else:
			match key:
				Composite.HYDROGEN:
					if speed >= CHEMICAL_A_INTEGRATION_SPEED:
						chemical.integrated = true
						_conflicting_intergration = true
				Composite.NITROGEN:
					if speed >= CHEMICAL_B_INTEGRATION_SPEED:
						chemical.integrated = true
						_conflicting_intergration = true

	murky = false
	centrifuged = true
	print("Centrifuge result: Success")
