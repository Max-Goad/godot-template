@tool
class_name ColorButton extends Button
## An extension of button used to make slightly nicer dynamic buttons during development.

## The base color of the button's background.
@export var color := Color.WHITE : set = _set_color
## The base color of the button's border.
@export var border_color := Color.BLACK : set = _set_border_color
## The border width of the button.
@export var border_width := 0 : set = _set_border_width
## The margin for the button's content.
@export var content_margin := 4 : set = _set_content_margin

## The font settings used for the button's text.
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "LabelSettings")
var font_settings: LabelSettings : set = _set_font_settings

@export_group("Shadow")
## The color of the button's shadow.
@export var shadow_color := Color.BLACK : set = _set_shadow_color
## The width of the button's shadow.
@export var shadow_width := 0 : set = _set_shadow_width
## The offset of the button's shadow.
@export var shadow_offset := Vector2.ZERO : set = _set_shadow_offset

@export_group("Advanced")
## Modulates how much the color value is modified when the button is pressed
@export_range(1.0, 2.0, 0.05) var pressed_modifier := 1.25
## Modulates how much the color value is modified when the button is hovered over
@export_range(1.0, 2.0, 0.05) var hover_modifier := 1.10
## Modulates how much the color saturation is modified when the button is pressed or hovered over
@export_range(1.0, 2.0, 0.05) var saturation_modifier := 1.25


var stylebox_normal: StyleBoxFlat	## The stylebox used for the normal button state.
var stylebox_pressed: StyleBoxFlat	## The stylebox used for the pressed button state.
var stylebox_hover: StyleBoxFlat	## The stylebox used for the hover button state.
var stylebox_disabled: StyleBoxFlat	## The stylebox used for the disabled button state.
var stylebox_focus: StyleBoxEmpty	## The stylebox used for the focus button state.

## Internal variable used to gate uninitialized calls to certain functions
var _initialized = false

func _ready() -> void:
	_override_styleboxes()
	_initialized = true
	refresh()

## Refresh the button's style and content to be up to date.
func refresh():
	if not _initialized:
		return
	_refresh_styleboxes()
	if font_settings:
		_refresh_fonts()

## Offset a color for the pressed state.
func pressed_offset(c: Color) -> Color:
	# Pressing should darken the button significantly
	var value = c.v / pressed_modifier
	# Except when the button is already dark
	# Then, it should lighten it significantly
	if c.v < 0.1:
		value = c.v * pressed_modifier
	var saturation = c.s * saturation_modifier
	return Color.from_hsv(c.h, saturation, value, c.a)

## Offset a color for the hover state.
func hover_offset(c: Color) -> Color:
	# Hovering should darken the button slightly
	var value = c.v / hover_modifier
	# Except when the button is already dark
	# Then, it should lighten it slightly
	if c.v < 0.1:
		value = c.v * hover_modifier
	var saturation = c.s * saturation_modifier
	return Color.from_hsv(c.h, saturation, value, c.a)

## Offset a color for the disabled state.
func disabled_offset(c: Color) -> Color:
	return Color.from_hsv(c.h, c.s / 2.5, c.v / 1.5, c.a)

# Default Button Stylebox Values (for reference)
# Normal	 10  10  10  60
# Pressed	  0   0   0  60
# Hover		 22  22  22  60
# Disabled	 10  10  10  30
# Focus		100 100 100  75

#region Styleboxes
func _override_styleboxes():
	stylebox_normal = StyleBoxFlat.new()
	self.add_theme_stylebox_override("normal", stylebox_normal)
	stylebox_pressed = StyleBoxFlat.new()
	self.add_theme_stylebox_override("pressed", stylebox_pressed)
	stylebox_hover = StyleBoxFlat.new()
	self.add_theme_stylebox_override("hover", stylebox_hover)
	stylebox_disabled = StyleBoxFlat.new()
	self.add_theme_stylebox_override("disabled", stylebox_disabled)
	stylebox_focus = StyleBoxEmpty.new()
	self.add_theme_stylebox_override("focus", stylebox_focus)

func _refresh_styleboxes():
	stylebox_normal.bg_color = color
	stylebox_normal.border_color = border_color
	stylebox_normal.set_border_width_all(border_width)
	stylebox_normal.set_content_margin_all(content_margin)
	stylebox_normal.set_shadow_color(shadow_color)
	stylebox_normal.set_shadow_size(shadow_width)
	stylebox_normal.set_shadow_offset(shadow_offset)

	stylebox_pressed.bg_color = pressed_offset(color)
	stylebox_pressed.border_color = border_color
	stylebox_pressed.set_border_width_all(border_width)
	stylebox_pressed.set_content_margin_all(content_margin)
	stylebox_pressed.set_shadow_color(shadow_color)
	stylebox_pressed.set_shadow_size(shadow_width)
	stylebox_pressed.set_shadow_offset(shadow_offset)

	stylebox_hover.bg_color = hover_offset(color)
	stylebox_hover.border_color = border_color
	stylebox_hover.set_border_width_all(border_width)
	stylebox_hover.set_content_margin_all(content_margin)
	stylebox_hover.set_shadow_color(shadow_color)
	stylebox_hover.set_shadow_size(shadow_width)
	stylebox_hover.set_shadow_offset(shadow_offset)

	stylebox_disabled.bg_color = disabled_offset(color)
	stylebox_disabled.border_color = border_color
	stylebox_disabled.set_border_width_all(border_width)
	stylebox_disabled.set_content_margin_all(content_margin)
	stylebox_disabled.set_shadow_color(shadow_color)
	stylebox_disabled.set_shadow_size(shadow_width)
	stylebox_disabled.set_shadow_offset(shadow_offset)
#endregion

#region Font
func _refresh_fonts():
	# Size
	add_theme_font_size_override("font_size", font_settings.font_size)
	# Color
	add_theme_color_override("font_color", font_settings.font_color)
	add_theme_color_override("font_pressed_color", font_settings.font_color)
	add_theme_color_override("font_hover_color", font_settings.font_color)
	add_theme_color_override("font_disabled_color", font_settings.font_color)
	add_theme_color_override("font_focus_color", font_settings.font_color)
	# Outline
	add_theme_constant_override("outline_size", font_settings.outline_size)
	add_theme_color_override("font_outline_color", font_settings.outline_color)
#endregion

#region Setters
func _set_color(value):
	color = value
	refresh()

func _set_border_color(value):
	border_color = value
	refresh()

func _set_border_width(value):
	border_width = value
	refresh()


func _set_content_margin(value):
	content_margin = value
	refresh()

func _set_shadow_color(value):
	shadow_color = value
	refresh()

func _set_shadow_width(value):
	shadow_width = value
	refresh()

func _set_shadow_offset(value):
	shadow_offset = value
	refresh()

func _set_font_settings(value):
	font_settings = value
	refresh()
#endregion
