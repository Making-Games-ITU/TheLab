extends Node

# Add enum for vial, where it is in the world
# Replace vial_in_BLANK with the new enum types later
enum VialLocation {
	NONE,
	PLAYER,
	SAMPLECOLLECTOR,
	MIXER,
	FILLINGMACHINE,
	MICROSCOPE
}

# Other, to be figured out
var body_number: int = 0
var body_ID: String = ""
var body_exists: bool = false
var body_state: int = 3 # from 1 to 5, below 1 or above 5 = dead
var toggle_sample_collector: bool = true
var vial_in_collector: bool = false
var vial_in_microscope: bool = false

# Game world state
# chemical enum should be independant from VialStats
var current_chemical : VialStats.Composite

# Pipette stats
var vial_in_pipette: bool = false
var flask_in_pipette: bool = false
var pipette_chemical_amount: String = ""
const PIPETTE_CHARACTERS_MAX: int = 5

func pipette_chemical_amount_string_to_float() -> float:
	return pipette_chemical_amount.to_float()

# Mixer 
var vial_in_mixer: bool = false
const MIXER_MIN_SPEED: int = 0
const MIXER_MAX_SPEED: int = 5
var mixer_current_speed: int = 0

# If there is an active vial
# True when picked up from shelf'
# Until it is disposed in trash can
var is_vial_used: bool = false

# Other game settings
var game_brightness: float = 1.0
