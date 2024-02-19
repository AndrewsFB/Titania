extends KinematicBody2D
class_name WorldObject

const UP_DIRECTION := Vector2.UP
const GRAVITY := Vector2(0, 25)

var apply_gravity := true


func move(velocity: Vector2) -> Vector2:
	var motion = velocity + (GRAVITY if apply_gravity else Vector2.ZERO)
	return .move_and_slide(motion, UP_DIRECTION, true)
