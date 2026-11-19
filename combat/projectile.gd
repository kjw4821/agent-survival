extends CharacterBody2D

@export var speed := 740.0
@export var lifetime := 0.65

var direction := Vector2.RIGHT
var damage := 0


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(direction * speed * minf(delta, lifetime))
	if collision:
		collision.get_collider().take_damage(damage)
		queue_free()
		return
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _draw() -> void:
	draw_line(-direction * 9.0, Vector2.ZERO, Color("#f6b660"), 3.0, true)
	draw_circle(Vector2.ZERO, 4.0, Color("#ffe4a3"), true, -1.0, true)
