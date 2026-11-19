extends Node2D

const PlayerBody = preload("res://combat/player.gd")
const EnemyBody = preload("res://combat/enemy.gd")
const ENEMY_SCENE := preload("res://combat/enemy.tscn")
const ARENA_SIZE := Vector2(960, 600)

@export var run_duration := 60.0
@export var spawn_interval := 0.85

@onready var player: PlayerBody = $Player
@onready var enemies: Node2D = $Enemies
@onready var status: Label = $HUD/Status
@onready var result: ColorRect = $HUD/Result
@onready var summary: Label = $HUD/Result/Content/Summary
@onready var restart: Button = $HUD/Result/Content/Restart

var elapsed := 0.0
var spawn_cooldown := 0.0
var spawned := 0
var kills := 0
var finished := false


func _ready() -> void:
	player.weapon.projectiles = $Projectiles
	player.defeated.connect(_finish.bind(false))
	restart.pressed.connect(_restart)
	_spawn_enemy()
	_spawn_enemy()
	spawn_cooldown = spawn_interval
	_update_hud()


func _physics_process(delta: float) -> void:
	if finished:
		return
	elapsed = minf(elapsed + delta, run_duration)
	_update_hud()
	if elapsed >= run_duration:
		_finish(true)
		return
	spawn_cooldown -= delta
	if spawn_cooldown <= 0.0:
		_spawn_enemy()
		spawn_cooldown += spawn_interval


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, ARENA_SIZE), Color("#101c28"))
	for x in range(0, int(ARENA_SIZE.x), 40):
		draw_line(Vector2(x, 0), Vector2(x, ARENA_SIZE.y), Color("#1c2b39"))
	for y in range(0, int(ARENA_SIZE.y), 40):
		draw_line(Vector2(0, y), Vector2(ARENA_SIZE.x, y), Color("#1c2b39"))


func _spawn_enemy() -> void:
	var enemy := ENEMY_SCENE.instantiate() as EnemyBody
	enemy.configure(spawned % 3 != 0, player)
	enemy.position = _spawn_position(spawned % 4)
	enemy.defeated.connect(_count_kill)
	enemies.add_child(enemy)
	spawned += 1


func _spawn_position(edge: int) -> Vector2:
	match edge:
		0: return Vector2(randf_range(28.0, ARENA_SIZE.x - 28.0), 70.0)
		1: return Vector2(ARENA_SIZE.x - 24.0, randf_range(70.0, ARENA_SIZE.y - 64.0))
		2: return Vector2(randf_range(28.0, ARENA_SIZE.x - 28.0), ARENA_SIZE.y - 64.0)
		_: return Vector2(24.0, randf_range(70.0, ARENA_SIZE.y - 64.0))


func _count_kill() -> void:
	kills += 1


func _update_hud() -> void:
	status.text = "HP %d / %d     Time %02ds     Kills %d" % [
		player.health, player.max_health, ceili(run_duration - elapsed), kills
	]


func _finish(survived: bool) -> void:
	finished = true
	player.process_mode = Node.PROCESS_MODE_DISABLED
	enemies.process_mode = Node.PROCESS_MODE_DISABLED
	$Projectiles.process_mode = Node.PROCESS_MODE_DISABLED
	_update_hud()
	var outcome := "Run cleared" if survived else "Run ended"
	summary.text = "%s\n%.1fs survived   ·   %d kills" % [outcome, elapsed, kills]
	result.show()
	restart.grab_focus()


func _restart() -> void:
	get_tree().reload_current_scene()
