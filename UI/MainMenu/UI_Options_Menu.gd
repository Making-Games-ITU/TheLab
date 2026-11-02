extends Control

@onready var _master_slider: HSlider = %MasterSlider
# @onready var _music_slider: HSlider = %MusicSlider
# @onready var _sfx_slider: HSlider = %SFXSlider
@onready var _resolution_option: OptionButton = %ResolutionOption
@onready var _fullscreen_check: CheckButton = %FullscreenCheck
@onready var _world_environment: WorldEnvironment = %WorldEnvironment

const SETTINGS_PATH := "user://settings.cfg"
const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
]

const MASTER_BUS := "bus:/"
# const MUSIC_BUS := "bus:/Music"
# const SFX_BUS := "bus:/SFX"

var _config := ConfigFile.new()

func _set_bus_volume(value: float) -> void:
	var bus = FmodServer.get_bus(MASTER_BUS)
	bus.volume = value
	%VolumeValue.text = str(value)

func _set_brightness(value: float) -> void:
	GameStats.game_brightness = value
	_world_environment.environment.adjustment_brightness = value
	%BrightnessValue.text = str(value)

func _apply_resolution(index: int) -> void:
	var window := get_window()
	if window.mode != Window.MODE_WINDOWED:
		return
	window.size = RESOLUTIONS[index]
	window.move_to_center()

func _apply_fullscreen(enabled: bool) -> void:
	var window := get_window()
	window.mode = Window.MODE_FULLSCREEN if enabled else Window.MODE_WINDOWED
	_resolution_option.disabled = enabled
	if not enabled:
		# Deferred so the window finishes leaving fullscreen first
		_apply_resolution.call_deferred(_resolution_option.selected)
		
func _set_vsync(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
func _set_fps_limit(value: float) -> void:
	Engine.max_fps = value
	%FPSLimitValue.text = str(int(value))

func _save_settings() -> void:
	_config.set_value("audio", "master", _master_slider.value)
	# _config.set_value("audio", "music", _music_slider.value)
	# _config.set_value("audio", "sfx", _sfx_slider.value)
	_config.set_value("display", "resolution", _resolution_option.selected)
	_config.set_value("display", "fullscreen", _fullscreen_check.button_pressed)
	_config.save(SETTINGS_PATH)

func _load_settings() -> void:
	# If the file is missing, the defaults below are used
	_config.load(SETTINGS_PATH)

	_master_slider.value = _config.get_value("audio", "master", 1.0)
	# _music_slider.value = _config.get_value("audio", "music", 1.0)
	# _sfx_slider.value = _config.get_value("audio", "sfx", 1.0)
	_resolution_option.select(_config.get_value("display", "resolution", 0))
	_fullscreen_check.set_pressed_no_signal(_config.get_value("display", "fullscreen", false))

	_set_bus_volume(_master_slider.value)
	# _set_bus_volume(_music_slider.value, MUSIC_BUS)
	# _set_bus_volume(_sfx_slider.value, SFX_BUS)
	_apply_fullscreen(_fullscreen_check.button_pressed)

func _ready() -> void:
	for res in RESOLUTIONS:
		_resolution_option.add_item("%d x %d" % [res.x, res.y])

	$Button.pressed.connect(hide)

	# Save whenever the menu closes, instead of on every slider tick
	visibility_changed.connect(func(): if not visible: _save_settings())

	_load_settings()
