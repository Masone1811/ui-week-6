extends CharacterBody2D

signal killed

var health = 4
var damage = 5.0

@onready var player = get_node("/root/Game/Player")

func _ready():
	%Slime.play_walk()

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300.0
	move_and_slide()

func get_damage():
	return damage

func take_damage(damage):
	health -= damage
	%Slime.play_hurt()
	
	if health <= 0:
		killed.emit()
		queue_free()
		
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
