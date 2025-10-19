class_name ScreenAdjuster
## Helper class used to keep values for things like containers on screen.
##
## Example usage:
## [codeblock]
## var adjuster := ScreenAdjuster.new()
## adjuster.screen_size = get_viewport().get_size()
## adjuster.size = my_container.get_size()
## var clamped_pos := adjuster.clamp(target_pos)
## [/codeblock]

## The size of the screen to use as a bound.
var screen_size := Vector2.ZERO
## The size of the object to bound.
var size := Vector2.ZERO
## The size of the object's parent (used for flipping).
var parent_size := Vector2.ZERO
## An offset value used to shift the position slightly (usually for aesthetic reasons).
var manual_offset := Vector2.ZERO

## Rest the state of the ScreenAdjuster so it can be reused.
func reset():
	screen_size = Vector2.ZERO
	size = Vector2.ZERO
	parent_size = Vector2.ZERO
	manual_offset = Vector2.ZERO

## Returns a Vector2 that will ensure container will fit on screen.
## If the container doesn't fit naturally, the x/y values will be clamped
## to the minimum value necessary to fit container on screen.
func clamp(target: Vector2) -> Vector2:
	return Vector2(clamp_x(target.x), clamp_y(target.y))

## Returns an x value that will ensure container will fit on screen.
## If the container doesn't fit naturally, the x value will be clamped
## to the minimum value necessary to fit container on screen.
func clamp_x(target_x: float) -> float:
	# First, make requested adjustment
	var adjusted_x := target_x + manual_offset.x
	var on_screen := adjusted_x + size.x <= screen_size.x
	if on_screen:
		return adjusted_x
	else:
		return clamp(adjusted_x, 0.0, screen_size.x - size.x)

## Returns a y value that will ensure container will fit on screen.
## If the container doesn't fit naturally, the y value will be clamped
## to the minimum value necessary to fit container on screen.
func clamp_y(target_y: float) -> float:
	# First, make requested adjustment
	var adjusted_y := target_y + manual_offset.y
	var on_screen := adjusted_y + size.y <= screen_size.y
	if on_screen:
		return adjusted_y
	else:
		# Trust me about the 3x adjustment
		return clamp(adjusted_y, 0.0, screen_size.y - size.y)

## Returns a Vector2 that will ensure container will fit on screen.
## If the container doesn't fit naturally, the x/y values will be moved
## such that the container will "flip" to the other side.
##	- For example, a menu that opens to the right will now open to the left.
## The "parent size" param is used to flip "around" an object.
##	- For example, a submenu flipping around a parent menu
func flip(target: Vector2) -> Vector2:
	return Vector2(flip_x(target.x), flip_y(target.y))

## Returns a Vector2 that will ensure container will fit on screen.
## If the container doesn't fit naturally, the x value will be moved
## such that the container will "flip" to the other side.
##	- For example, a menu that opens to the right will now open to the left.
## The "parent size" param is used to flip "around" an object.
##	- For example, a submenu flipping around a parent menu
func flip_x(target_x: float) -> float:
	# First, make requested adjustments
	var adjusted_x := target_x + parent_size.x + manual_offset.x
	var on_screen := adjusted_x + size.x <= screen_size.x
	if on_screen:
		return adjusted_x
	else:
		# 2x because we need to offset the adjustment already made
		return adjusted_x - size.x - parent_size.x - (manual_offset.x*2.0)

## Returns a Vector2 that will ensure container will fit on screen.
## If the container doesn't fit naturally, the y value will be moved
## such that the container will "flip" to the other side.
##	- For example, a menu that opens down will now open up.
## The "parent size" param is used to flip "around" an object.
##	- For example, a submenu flipping around a parent menu
func flip_y(target_y: float) -> float:
	# First, make requested adjustments
	var adjusted_y := target_y + parent_size.y + manual_offset.y
	var on_screen := adjusted_y + size.y <= screen_size.y
	if on_screen:
		return adjusted_y
	else:
		# 2x because we need to offset the adjustment already made
		return adjusted_y - size.y - parent_size.y - (manual_offset.y*2.0)
