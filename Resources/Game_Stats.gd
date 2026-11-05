extends Node

# Where the vial is
var is_vial_used: bool = false
enum VialLocation { NONE, PLAYER, SAMPLER, CENTRIFUGE, MICROSCOPE, PIPETTE }
var vial_location: VialLocation = VialLocation.NONE
var vial_in_collector: bool = false
var vial_in_microscope: bool = false
var vial_in_pipette: bool = false
var vial_in_centrifuge: bool = false

# Sampler
var body_number: int = 0
var body_ID: String = ""
var body_exists: bool = false
var body_state: int = 3 # from 1 to 5, 1 healthy, 5 near death
var toggle_sample_collector: bool = true # what for? not clear

# Pipette
var flask_in_pipette: bool = false
var pipette_current_chemical: VialStats.Composite = VialStats.Composite.NONE
var pipette_current_chemical_name: String = ""
var pipette_chemical_amount: String = ""
var pipette_point_added: bool = false # decimal point
const PIPETTE_CHARACTERS_MAX: int = 5
func pipette_chemical_amount_string_to_float() -> float:
	return pipette_chemical_amount.to_float()

# Centrifuge 
const CENTRIFUGE_MIN_SPEED: int = 1
const CENTRIFUGE_MAX_SPEED: int = 5
var centrifuge_current_speed: int = 3

# Game settings (used this to ensure that it transfers over for now, may be unnecessary)
var game_brightness: float = 1.0
