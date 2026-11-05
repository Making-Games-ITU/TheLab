extends Node

# Other stuff
@onready var offline_label: Label = $SubViewport/Control/Label
@onready var scan_start_button = $ScanStart

# Lung status images
@onready var lung_status_group: Control = $SubViewport/Control/LungStatusImages
@onready var lung_status_1_image: TextureRect = $SubViewport/Control/LungStatusImages/Lung_Status_1
@onready var lung_status_2_image: TextureRect = $SubViewport/Control/LungStatusImages/Lung_Status_2
@onready var lung_status_3_image: TextureRect = $SubViewport/Control/LungStatusImages/Lung_Status_3
@onready var lung_status_4_image: TextureRect = $SubViewport/Control/LungStatusImages/Lung_Status_4
@onready var lung_status_5_image: TextureRect = $SubViewport/Control/LungStatusImages/Lung_Status_5

func _ready():
	scan_start_button.scan_pressed.connect(_on_scan_pressed)
	offline_label.visible = true

func _on_scan_pressed() -> void:
	lung_status_group.visible = false
	offline_label.visible = true
	offline_label.visible = false
	lung_status_group.visible = true
	_show_lung_status(GameStats.body_state)

func _hide_all_lung_statuses() -> void:
	lung_status_1_image.visible = false
	lung_status_2_image.visible = false
	lung_status_3_image.visible = false
	lung_status_4_image.visible = false
	lung_status_5_image.visible = false

func _show_lung_status(status: int) -> void:
	_hide_all_lung_statuses()
	match status:
		1: lung_status_1_image.visible = true
		2: lung_status_2_image.visible = true
		3: lung_status_3_image.visible = true
		4: lung_status_4_image.visible = true
		5: lung_status_5_image.visible = true
