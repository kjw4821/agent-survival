extends CharacterBody2D

signal defeated

const PlayerBody = preload("res://combat/player.gd")

var target: PlayerBody
var speed := 108.0
var radius := 12.0
var health := 20
var contact_damage := 10
var color := Color("#ff8779")


func configure(is_runner: bool, player: PlayerBody) -> void:
	target = player
	if not is_runner:
		speed = 65.0
		radius = 20.0
		health = 60
		contact_damage = 20
		color = Color("#bd9cf5")
	var shape := CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape


func _physics_process(delta: float) -> void:
	var offset := target.global_position - global_position
	var reach := radius + PlayerBody.BODY_RADIUS
	var distance := offset.length()
	if distance > reach:
		global_position += offset.normalized() * minf(distance - reach, speed * delta)
	if distance <= reach + 0.5:
		target.take_damage(contact_damage)


func take_damage(amount: int) -> void:
	if health <= 0:
		return
	health -= amount
	if health <= 0:
		defeated.emit()
		queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color, true, -1.0, true)
	draw_arc(Vector2.ZERO, radius - 4.0, 0.0, TAU, 24, Color("#524665"), 2.0, true)
