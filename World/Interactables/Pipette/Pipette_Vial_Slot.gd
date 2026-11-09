extends IVialSlot

@onready var pipette_vial_model := $Pipette_Vial
@onready var pipette_vial_tube_on := $Pipette_Vial_Tube_ON
@onready var pipette_vial_tube_off := $Pipette_Vial_Tube_OFF

func _insert_vial():
	super()
	print("Vial inserted into pipette vial slot")


func _take_vial():
	super()
	print("Picked up vial from pipette vial slot")
