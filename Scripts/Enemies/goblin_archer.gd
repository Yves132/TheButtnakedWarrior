extends CharacterBody2D

const ARROW = preload("res://Scenes/Enemies/arrow.tscn") 
const COINS = preload("res://Scenes/Coins/CoinDrops.tscn")
const MEAT = preload("res://Scenes/Inventory/InventoryItem/inventory_item.tscn")
const BLOOD = preload("res://Scenes/Particles/blood.tscn")
const EXPLOSION = preload("res://Scenes/Particles/explosion_fire.tscn")

@export var speed = 50
@export var direction = 1
@export var detect_cliffs :=true #property for detecting cliffs

@onready var sprite = $AnimatedSprite2D
@onready var collision_size_x = $CollisionShape2D.get_shape().get_size().x#collisionshape of enemy, needed to set floorchecker in right position
@onready var default_speed = speed#store speed property in default speed var
@onready var drop_sprite = $Drop

var spotted :=false#have i spotted someone this instant?
var is_spotting:=false# am i actively spotting?
var Idle := false# am i idle?
var dead := false#am i dead?
var burn := false 
var sliced := false
var myposx:float
var max_health := 2
var current_health = max_health
var Hit := false
var on_fire := false
var shot := false
var shooting :=false
var anim_name :String

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = randf_range(7.0,12.0)#random time for timer
	$Timer.start()#timer for "walk a bit, then stop and look around"
	$floor_checker.position.x = collision_size_x * direction #sets floor checker in front of me at the beginning
	$floor_checker.enabled = detect_cliffs #enables floorchecker only if it is enabled in properties
	$SpotBox/CollisionShape2D.position.x = $SpotBox/CollisionShape2D.position.x * direction#starts spotbox in front of enemy
	if detect_cliffs:
		set_modulate(Color(1,1,1,1))
	elif not detect_cliffs:
		set_modulate(Color(0.5,1,0.5,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	myposx = position.x
	$HealthBar.update_health(max_health, current_health)
	if not dead and not burn and not sliced:
		if not is_on_floor():#handles gravity
			velocity.y += gravity * delta
		
		if is_on_wall() or not $floor_checker.is_colliding() and (detect_cliffs and is_on_floor()):#if touching wall/player or cliff and
			#i have detect cliffs property and am on floor
			direction = direction * -1 #change direction
			$floor_checker.position.x = collision_size_x * direction#sets floor checker (for detecting cliffs) position
			#in front of me
			$SpotBox/CollisionShape2D.position.x = $SpotBox/CollisionShape2D.position.x * -1 #set spotbox in front of me

		#for flipping sprites based on direction
		if direction == 1 and not Hit:
			velocity.x = speed * direction
			if not Idle:#only when not idling
				sprite.flip_h = false
		elif direction == -1 and not Hit:
			velocity.x = speed *  direction
			if not Idle:#only when not idling
				sprite.flip_h = true
		
		if $SpotBox.overlaps_body(GameManager.player):#if player is inside spotbox
			is_spotting = true#i am actively spotting
		else:#if not
			is_spotting = false#i am not actively spotting anyone
		shoot()
	if dead or burn or sliced or shooting:
		velocity.x = 0
	
	
	move_and_slide()
	enemy_animation_handler()
	

func shoot():
	if is_spotting and not shooting and not spotted:
		if not Hit:
			shooting = true
			#$ShootTimer.start()
	elif not is_spotting:
		shooting = false
		
func lose_health(dmg):
	Hit = true
	current_health -= dmg
	
func Hurt(posx):
	$HurtTimer.start()
	if posx > position.x:
		velocity.x = -speed * 2
	if posx < position.x:
		velocity.x = speed * 2
	
func enemy_animation_handler():
	if velocity.x == 0 and not spotted and not dead and not burn and not sliced and not Hit and not on_fire and not shooting:#if stationary and not spotted player this instant
		sprite.play("Idle")#play idle animation
		Idle=true#i am idling
		anim_name = $AnimatedSprite2D.get_animation()
	if velocity.x != 0 and not spotted and not dead and not burn and not sliced and not Hit and not on_fire and not shooting:#if moving and not spotted player this instant
		sprite.play("Walk")#play walk anim
		Idle=false#i am not idling
		anim_name = $AnimatedSprite2D.get_animation()
	if spotted and not dead and not burn and not sliced and not Hit and not shooting:#it stays true only for a second, just needed to play spot anim
		sprite.play("Spot")
		anim_name = $AnimatedSprite2D.get_animation()
	if dead and not burn and not sliced :
		sprite.play("Die")
		anim_name = $AnimatedSprite2D.get_animation()
	if burn and not dead and not sliced:
		sprite.play("Burn")
		anim_name = $AnimatedSprite2D.get_animation()
	if sliced and not dead and not burn:
		sprite.play("Slice")
		anim_name = $AnimatedSprite2D.get_animation()
	if on_fire and not burn and not dead and not sliced:
		sprite.play("on_fire")
		anim_name = $AnimatedSprite2D.get_animation()
	if shooting and not burn and not dead and not sliced and not on_fire and not spotted and not Hit:
		sprite.play("Shoot")
		anim_name = $AnimatedSprite2D.get_animation()
		
func spawn_coin():
	var coin = COINS.instantiate()
	coin.position.x = position.x
	coin.position.y = position.y
	get_parent().add_child(coin)
	
func spawn_meat():
	var meat = MEAT.instantiate()
	meat.position.x = position.x
	meat.position.y = position.y
	meat.item_texture = drop_sprite.texture
	meat.item_name = "Goblin Meat"
	meat.item_effect = "Heal 1 HP"
	meat.item_type = "Consumable"
	meat.cost = 2
	get_parent().add_child(meat)
	
func bleed():
	var blood = BLOOD.instantiate()
	blood.position = position
	get_parent().add_child(blood)
	
func spawn_explosion(pos):
	var explosion = EXPLOSION.instantiate()
	explosion.position = pos
	get_parent().add_child(explosion)

func _on_timer_timeout():#timer to start idle animation
	if not on_fire:
		if not is_spotting:#only if not spotting player
			speed = 0
			$Idle_timer.start()
		else:
			$Timer.wait_time = randf_range(7.0,12.0)
			$Timer.start()

func _on_idle_timer_timeout():#timer to stop idle anim
	if not on_fire:
		
		speed = default_speed
		$Timer.wait_time = randf_range(7.0,12.0)
		$Timer.start()

func _on_bottom_checker_body_entered(body):
	if not dead and not burn and not sliced:
		if body is Player:
			GameManager.lose_health(1)#player loses health
			GameManager.player.Hurt(myposx)#used to play hurt anim

func _on_side_checker_body_entered(body):
	if not burn and not dead and not sliced:
		if body is Fireball:#is player on top of me
			lose_health(PlayerData.player_dic["magic_dmg"])
			Hurt(GameManager.player.Playerposx)
			spawn_explosion(body.position)
			body.queue_free()
			sprite.play("Hit")
			if PlayerData.player_dic["deep_burn"] == true:
				$BurnTimer.start()
				on_fire = true
				Idle=false
				speed = default_speed*2
				$BurnDMGTimer.start()
			if current_health <= 0:
				burn=true#i'm dead
				set_collision_layer_value(5, false)#no more collision
				set_collision_mask_value(1,false)# no more detecting collisions
				#print(get_collision_layer_value(1))
				#print(get_collision_mask_value(1))
				$DeathTimer.start()#run timer for death anim
		elif body is Player and not burn and not dead and not sliced:
			GameManager.lose_health(1)
			GameManager.player.Hurt(myposx)

func _on_spot_box_area_entered(area):#for spotting mechanic and animation
	if not dead and not burn and not sliced and not on_fire:
		if area.get_parent() is Player:#if player entered spot area
			speed = 0#stop
			spotted = true#i have spotted!
			enemy_animation_handler()#for playing spot anim
			$SpotTimer.start()#spot anim lasts only for this timer

func _on_spot_box_area_exited(area):#for spotting mechanic and animation
	if not dead and not burn and not sliced and not on_fire:
		if area.get_parent() is Player:#if the player exited spot area
			speed = default_speed#walk normally
			spotted = false#i have stopped spot anim


func _on_top_checker_body_entered(body):
	if not dead and not burn and not sliced:#if enemy not dead
		if body is Player:
			current_health -= max_health
			dead=true#i'm dead
			set_collision_layer_value(5, false)#no more collision
			set_collision_mask_value(1,false)# no more detecting collisions
			$DeathTimer.start()#run timer for death anim
			GameManager.player.bounce()#player bounces on my head

func _on_spot_timer_timeout():#timer to stop the spot animation
	spotted = false#i have stopped spot anim
	


func _on_death_timer_timeout():#when death animation finished
	var coinspawntrue = randi() % 5 +1
	var meatspwanchance = randi() % 100 +1
	var counter = 0
	#print(coinspawntrue)
	if meatspwanchance <= 30:
		spawn_meat()
	while counter <= coinspawntrue:
		spawn_coin()
		counter+=1
		
	
	GameManager.gain_xp(1)
	queue_free()#delete me 
	for i in WorldData.world_dic["enemies"].size():
		if $"."== WorldData.world_dic["enemies"][i]:
			WorldData.world_dic["dead_enemies"][i] = true

func _on_hit_box_area_entered(area):
	if not dead and not burn and not sliced and not Hit:
		Hurt(GameManager.player.Playerposx)
		if GameManager.crit == true and GameManager.player.can_dash == true:
			lose_health(PlayerData.player_dic["melee_dmg"] * 2)
			GameManager.player.crit.text = "Critical!"
			GameManager.player.crit.show()
			GameManager.player.crittimer.start()
		if GameManager.player.can_dash == false and PlayerData.player_dic["waterfall"] == true:
			lose_health(PlayerData.player_dic["melee_dmg"] * 4)
			GameManager.player.crit.text = "One Sword Style: Waterfall!"
			GameManager.player.crit.show()
			GameManager.player.crittimer.start()
		elif GameManager.crit == false:
			lose_health(PlayerData.player_dic["melee_dmg"])
		sprite.play("Hit")
		if current_health <= 0:
			sliced = true
			bleed()
			$".".set_collision_layer_value(5, false)#no more collision
			$".".set_collision_mask_value(1, false)
			$top_checker.set_collision_layer_value(5, false)#no more collision
			$top_checker.set_collision_mask_value(1, false)
			$side_checker.set_collision_layer_value(5, false)#no more collision
			$side_checker.set_collision_mask_value(1,false)# no more detecting collisions
			$bottom_checker.set_collision_layer_value(5, false)#no more collision
			$bottom_checker.set_collision_mask_value(1,false)# no more detecting collisions
			$DeathTimer.start()#run timer for death anim


func _on_hurt_timer_timeout():
	Hit = false


func _on_burn_timer_timeout():
	$BurnDMGTimer.stop()
	on_fire = false
	speed = default_speed


func _on_burn_dmg_timer_timeout():
	lose_health(PlayerData.player_dic["magic_dmg"])
	Hit = false
	if current_health <= 0:
		burn=true#i'm dead
		set_collision_layer_value(5, false)#no more collision
		set_collision_mask_value(1,false)# no more detecting collisions
		#print(get_collision_layer_value(1))
		#print(get_collision_mask_value(1))
		$DeathTimer.start()#run timer for death anim


func _on_shoot_timer_timeout():
	var arrow = ARROW.instantiate()
	arrow.direction = direction
	get_parent().add_child(arrow)
	arrow.position.x = position.x + 15 * direction
	arrow.position.y = position.y 
	shooting = false
	



func _on_animated_sprite_2d_animation_finished():
	if anim_name == "Shoot":
		$ShootTimer.start()
