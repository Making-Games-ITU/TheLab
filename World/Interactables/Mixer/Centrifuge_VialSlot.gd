extends IVialSlot

@onready var centrifuge_vial_model := %CentrifugeVialModel
@onready var _centrifuge_state_label: Label = %Centrifuge_State_Label

func _insert_vial():
	super()
	print("Vial inserted in Centrifuge")
	if VialStats.empty:
		_centrifuge_state_label.text = "Vial empty"
	else:
		_centrifuge_state_label.text = "Ready"

func _take_vial():
	super()
	print("Vial taken from Centrifuge")
	_centrifuge_state_label.text = "No vial"
