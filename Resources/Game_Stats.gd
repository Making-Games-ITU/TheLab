extends Node

#change Condition to some other variant of body
enum Condition { HAPPY, SAD, ANGRY, NONE }

var body_state : Condition = Condition.NONE
var body_number : int = 0
var body_ID : String = ""

#Button type enum will be depricated as indicidual functionality will extend interactable script
enum Buttons { BUTTON1, BUTTON2, BUTTON3, NEW_BABY, NONE }
var interacted_button : Buttons = Buttons.NONE

var body_exists: bool = false
var toggle_sample_collector : bool = false

# If there is an active vial
# True when picked up from shelf'
# Until it is disposed in trash can
var is_vial_used: bool = false
