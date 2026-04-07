extends CharacterBody3D


enum States {attack, idle, chase, die}

var state = States.idle
var HP = 50
var damage = 17
var speed = 4.0
var accel = 10
var gravity = 90
var value = 1
var target = null

@onready var navAgent: NavigationAgent3D = $NavigationAgent3D
@export var animationPlayer : AnimationPlayer

func enemy():
	pass


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity

	if state == States.idle:
		velocity = Vector3(0, velocity.y, 0)
		animationPlayer.play("Idle")
	elif state == States.chase:
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP, true)
		navAgent.target_position = target.global_position
		
		var direction = navAgent.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		animationPlayer.play("Walk")
	elif state == States.attack:
		look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP, true)
		animationPlayer.play("Punch")
		velocity = Vector3.ZERO
	elif state == States.die:
		velocity = Vector3.ZERO
		animationPlayer.play("Die")
		
	move_and_slide()

func attack():
	target.HP -= damage


func _process(_delta):
	if HP <= 0:
		state = States.die
	

func give_loot():
	target.gold += value 




func _on_chase_body_entered(body: Node3D) -> void:
	if body.has_method("player") and state != States.die:
		target = body
		state = States.chase


func _on_chase_body_exited(body: Node3D) -> void:
	if body.has_method("player") and state != States.die:
		target = null
		state = States.idle


func _on_attack_body_entered(body: Node3D) -> void:
	if body.has_method("player") and state != States.die:
		state = States.attack


func _on_attack_body_exited(body: Node3D) -> void:
	if body.has_method("player") and state != States.die:
		state = States.chase
