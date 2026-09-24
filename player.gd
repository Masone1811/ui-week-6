extends CharacterBody2D

signal health_depleted

var max_health = 100.0
var health = max_health

var damage_rate = 5.0

var screen_size = Vector2(1920, 1080)

func increase_enemy_damage():
	damage_rate += 5.0
	print("Enemy damage rate is now: ", damage_rate)

func _physics_process(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 600
	move_and_slide()
	screen_wrap()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= damage_rate * overlapping_mobs.size() * delta
		%HealthBar.value = health
		
		if not %DamageTakenSound.playing:
			%DamageTakenSound.play()
		
		if health <= 0.0:
			health_depleted.emit()
			

func screen_wrap():
	if position.x > screen_size.x:
		position.x = 0
	if position.x < 0:
		position.x = screen_size.x
	if position.y > screen_size.y:
		position.y = 0
	if position.y < 0:
		position.y = screen_size.y

func upgrade_damage():
	$Gun.upgrade_damage()


func upgrade_fire_rate():
	$Gun.upgrade_fire_rate()


func upgrade_health():
	max_health += 10.0
	health += max_health
	
	%HealthBar.max_value = max_health
	%HealthBar.value = health
	
	print("Health upgraded: ", health, " / ", max_health)
