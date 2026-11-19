extends CharacterBody2D

signal defeated

const Weapon = preload("res://combat/weapon.gd")
const BODY_RADIUS := 15.0
const MOVE_BOUNDS := Rect2(16, 66, 928, 481)
const HIT_INTERVAL := 0.65

@export var speed := 265.0
@export var max_health := 100

@onready var weapon: Weapon = $Weapon
@onready var health := max_health

var aim := Vector2.RIGHT
var hit_cooldown := 0.0


func _physics_process(delta: float) -> void:
	hit_cooldown = maxf(0.0, hit_cooldown - delta)
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
	move_and_slide()
	position = position.clamp(MOVE_BOUNDS.position, MOVE_BOUNDS.end)

	var cursor_direction := get_global_mouse_position() - global_position
	if not cursor_direction.is_zero_approx():
		aim = cursor_direction.normalized()
	if Input.is_action_pressed("fire"):
		weapon.try_fire(aim)
	queue_redraw()


func take_damage(amount: int) -> void:
	if health <= 0 or hit_cooldown > 0.0:
		return
	health = maxi(0, health - amount)
	hit_cooldown = HIT_INTERVAL
	if health == 0:
		defeated.emit()


func _draw() -> void:
	var color := Color("#7ce5de") if hit_cooldown <= 0.0 else Color("#eefaff")
	draw_line(Vector2.ZERO, aim * 25.0, Color("#d8fff9"), 7.0, true)
	draw_circle(Vector2.ZERO, BODY_RADIUS, color, true, -1.0, true)
	draw_circle(Vector2.ZERO, 6.0, Color("#284a59"), true, -1.0, true)
