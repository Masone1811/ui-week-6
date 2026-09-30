extends Area2D

var damage = 1

func upgrade_damage():
	damage += 1
	print("Damage: ", damage)
	
func upgrade_fire_rate():
	$Timer.wait_time *= 0.85
	$Timer.wait_time = max($Timer.wait_time, 0.1)

	print("Fire rate timer is now: ", $Timer.wait_time)
	

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)


func shoot():
	"res://bullet.tscn"
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	
	new_bullet.damage = damage
	
	%ShootingPoint.add_child(new_bullet)
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation

func _on_timer_timeout():
	shoot()
