extends CharacterBody2D

const COINS = preload("res://Scenes/Coins/CoinDrops.tscn")#preloading the scene of the coin item is necessary  for instantiation
const BLOOD = preload("res://Scenes/Particles/blood.tscn")
const EXPLOSION = preload("res://Scenes/Particles/explosion_fire.tscn")
const LEGS = preload("res://Scenes/Inventory/InventoryItem/inventory_item.tscn")

@export var speed = 50
@export var direction = 1
@export var jump_height = -300
@export var damage = 1
@export var max_health = 1


@onready var current_health = max_health
@onready var dead = false#is the frog dead?
@onready var burnt = false#used to determine which death animation to play
@onready var sliced = false#used to determine which death animation to play
@onready var crushed = false#used to determine which death animation to play
@onready var can_jump = true#jumptimer sets this to true after 1.2 seconds after landing
@onready var air = false#this tells me if the frog is airborne, whenever leaves the floor this is true, landing this
#is flase
@onready var contact = false#hitbox uses this to determine player contact
@onready var myposx = position.x#this is passed to the Hurt func in the player script
@onready var changed = false#it is used to change direction when hitting a wall, but changing it only once per jump
@onready var hit = false#used to prevent sword from hitting frog 2 times

@onready var sprite = $AnimatedSprite2D
@onready var drop_sprite = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
		myposx = position.x#passed to function lose health for player in gamemanager
		#healthbar management start
		$HealthBar.update_health(max_health, current_health)
		if FrogAi.hostile:
			$HealthBar.show()
		else:
			$HealthBar.hide()
		#healthbar management finish
		
		#movement start
		#function to change direction when encountering a wall
		if is_on_wall() and changed == false and not dead:
			direction = direction * -1
			changed = true#has already changed direction, used to prevent multiple changes at once
		
		# Add the gravity.
		if not is_on_floor():
			$JumpTimer.start()#used to determine time between jumps
			can_jump = false#in air we set this to false
			air = true#forg is in air
			velocity.y += gravity * delta

		if is_on_floor():
			if air:#this i need to stop the frog x movement once landed, otherwise it glides
				velocity.x = 0
				air = false#frog has landed
			if can_jump and not dead:
				if direction == 1:#right movement
					velocity.x = direction * speed
					velocity.y = jump_height
					changed = false#can change direction again after this jump
					sprite.flip_h = false
				elif direction == -1:#left movement
					velocity.x = direction * speed
					velocity.y = jump_height
					changed = false#can change direction again after this jump
					sprite.flip_h = true
					
		if FrogAi.hostile and not changed:#chase the player once it's hostile, just sets direction 1 or -1 based on playerpos
			if GameManager.player.Playerposx < myposx: 
				direction = -1
			elif GameManager.player.Playerposx > myposx:
				direction = 1
		move_and_slide()
		#movement end
		hit_management()
		#animations
		animation_handler()
	
		

func hit_management():
	if GameManager.player.can_attack:
			hit = false

func animation_handler():
	if is_on_floor() and not dead:
		sprite.play("Floor")
	if not is_on_floor() and not dead:
		sprite.play("Jump")
	if dead and burnt:
		sprite.play("Burnt")
	if dead and sliced:
		sprite.play("Sliced")
	if dead and crushed:
		sprite.play("Crushed")

func _on_jump_timer_timeout():#timer between jumps
	can_jump = true

func _on_hit_box_body_entered(body):#has the frog touched the player?
	if body is Player:
		contact = true
		#player interaction start
		if FrogAi.hostile and contact:#frogai.hostile is a var in a global script. The script is the hive mind of the frogs.
			GameManager.lose_health(damage)#calling a function in global script gamemanager to make player losehealth and update visual
			GameManager.player.Hurt(myposx)#calling a function in player script through gamemanager to hurt player
		#player interaction finish

func _on_hit_box_body_exited(body):#is it still touchin the player?
	if body is Player:
		contact = false
		#print("contact")

func _on_hit_detector_area_entered(area):#has the sword hit the frog?
	if area.get_parent() is Player and not hit:
		hit = true
		bleed()
		sliced = true#this is used to determine death animation
		FrogAi.hostile = true#this turns ALL frogs hostile by changing a var in a global file
		lose_health(PlayerData.player_dic["melee_dmg"])#this is taken from the player dictionary in PlayerData
		#animation_handler()
		#print("hostile")

func _on_hit_detector_body_entered(body):#has the fireball hit the frog?
	if body is Fireball:
		spawn_explosion(body.position)
		body.queue_free()
		burnt = true#this is used to determine death animation
		FrogAi.hostile = true#this turns ALL frogs hostile by changing a var in a global file
		lose_health(PlayerData.player_dic["magic_dmg"])#this is taken from the player dictionary in PlayerData
		#animation_handler()
		#print("hostile")
		

func _on_top_box_body_entered(body):
	if body is Player and FrogAi.hostile:#has the player crushed the frog?
		crushed = true#this is used to determine death animation
		lose_health(max_health)#calls the function to lose health frog
		GameManager.player.bounce()#player bounces on my head


func lose_health(dmg):#frog loses health equal to player dmg 
	current_health = current_health - dmg
	#GameManager.frame_freeze(0,0.2)
	if (burnt or sliced or crushed) and current_health <= 0:#killed by fireball or sword or crushed
		dead = true
		$HitBox.set_collision_mask_value(1, false)#set this mask layer to false, to prevent damage to player after death of frog
		$TopBox.set_collision_mask_value(1, false)#set this mask layer to false, to prevent infinite jumps on frog head
		$DeathTimer.start()#starts death timer for death animation
		

func spawn_coin():
	var coin = COINS.instantiate()#instantiate the scene of the coin item
	coin.position = position#set it's position to frog's position
	get_parent().add_child(coin)#add it to the tree a.k.a. spawn it
	
func spawn_legs():
	var legs = LEGS.instantiate()
	legs.position = position
	legs.item_texture = drop_sprite.texture
	legs.item_name = "Frog Leg"
	legs.item_effect = "JMP+(20)"
	legs.item_type = "Consumable"
	legs.cost = 3
	get_parent().add_child(legs)

func bleed():
	var blood = BLOOD.instantiate()
	blood.position = position
	get_parent().add_child(blood)

func spawn_explosion(pos):
	var explosion = EXPLOSION.instantiate()
	explosion.position = pos
	get_parent().add_child(explosion)

func _on_death_timer_timeout():
	var coinspawntrue = randi() %2 +1  #random for how many coins will spawn
	var counter = 0#counting how many coins have spawned
	var legspawntrue = randi() % 30 +1
	while counter < coinspawntrue:
		spawn_coin()#runs function to spawn coins
		counter +=1
	
	queue_free()#delete it
	GameManager.gain_xp(1)#calls a function in a global file (gamemanager) that allows the player to gain xp and updates it visually
