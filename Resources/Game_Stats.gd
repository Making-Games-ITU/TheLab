extends Node

# Add enum for vial, where it is in the world

var body_number : int = 0
var body_ID : String = ""

var body_exists: bool = false
var toggle_sample_collector : bool = false

var vial_in_collector : bool = false

#Game world state
#chemical enum should be independant from VialStats
var current_chemical : VialStats.Composite

#Chemical Machine stats. Should be moved to a seperate manager script when more complicated
var vial_in_pip : bool = false
var chem_in_pip : bool = false
var amount = ""

func parseAmount () -> float:
	return amount.to_float()

#Vial in Mixer 
var vial_in_mixer : bool = false
var mixer_speed = VialStats.Speed.Min

# If there is an active vial
# True when picked up from shelf'
# Until it is disposed in trash can
var is_vial_used: bool = false
