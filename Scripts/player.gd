extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var sensetivity = 1
var onCoolDown = false

var gold = 0
var HP = 70
var maxHP = 100
var damage = 20
var target = []

var can_hit := false

@onready var camera = $FirstPersonCam
@onready var animationPlayer = $AnimationPlayer
@onready var coolDown = $AttackCooldown
@onready var hpBAR = $HUD/HP_Bar
@onready var goldScore = $HUD/Gold_counter

func player():
	pass


func _ready():
	hpBAR.max_value = 100
	$FirstPersonCam.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensetivity * 0.001)
		camera.rotate_x(-event.relative.y * sensetivity * 0.001)
		camera.rotation.x = clamp(
			camera.rotation.x,
			deg_to_rad(-60),
			deg_to_rad(70)
		)

func _UpdateHUD():
	hpBAR.value = HP
	goldScore.text = str(gold)


func _attack():
	if Input.is_action_just_pressed("attack") and onCoolDown == false:
		animationPlayer.play("Sword_Swing")
		can_hit = true
		deal_damage()
		can_hit = false
		onCoolDown = true
		coolDown.start()

func deal_damage():
	if not can_hit:
		return
	for enemies in target:
		enemies.HP -= damage


func _switch_view():
	if Input.is_action_just_pressed("switch"):
		if camera == $FirstPersonCam:
			camera = $Top
			$Top/ThirdPersonCam.current = true
		else:
			camera = $FirstPersonCam
			$FirstPersonCam.current = true

func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	_switch_view()
	_attack()
	_UpdateHUD()
	deal_damage()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_attack_cooldown_timeout() -> void:
	onCoolDown = false


func _on_attack_zone_body_entered(body: Node3D) -> void:
	if body.has_method("enemy"):
		target.append(body)


func _on_attack_zone_body_exited(body: Node3D) -> void:
	if body.has_method("enemy"):
		target.erase(body)
