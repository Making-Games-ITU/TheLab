extends IVialSlot

func _ready() -> void:
	super()

func _insert_vial():
	super()
	%Prop_Microscope_Vial.visible = true
	print("Vial placed in microscope")

func _take_vial():
	super()
	%Prop_Microscope_Vial.visible = false
	print("Picked up vial from microscope")
