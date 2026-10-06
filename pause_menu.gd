extends Control

@onready var main = $"../"
var damage_level := 0
var fire_level := 0
var health_level := 0

func _on_resume_pressed() -> void:
	main.PauseMenu()



func _on_quit_pressed() -> void:
	get_tree().quit()



func _on_damage_button_pressed():
	damage_level += 1
	%Damage.text = "Damage = " + str(damage_level)
	


func _on_fire_rate_button_pressed():
	fire_level += 1
	%Firerate.text = "Firerate = " + str(fire_level)
	


func _on_health_button_pressed():
	health_level += 1
	%Health.text = "Health = " + str(health_level)
	
