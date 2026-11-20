extends Node2D

const ProjectileBody = preload("res://combat/projectile.gd")
const PROJECTILE_SCENE := preload("res://combat/projectile.tscn")

@export var shot_interval := 0.08
@export var damage := 3

var projectiles: Node2D
var cooldown := 0.0


func _physics_process(delta: float) -> void:
	cooldown = maxf(0.0, cooldown - delta)


func try_fire(direction: Vector2) -> void:
	if projectiles == null or cooldown > 0.0 or direction.is_zero_approx():
		return
	var projectile := PROJECTILE_SCENE.instantiate() as ProjectileBody
	projectile.direction = direction.normalized()
	projectile.damage = damage
	projectile.position = projectiles.to_local(global_position)
	projectiles.add_child(projectile)
	cooldown = shot_interval
