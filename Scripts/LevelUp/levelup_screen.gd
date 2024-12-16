extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("PauseMenu"):
		GameManager.uimanager.levelup_screen.hide()
		GameManager.pause_play()
	if PlayerData.player_dic["max_health"] == 10:
		$"WarriorHeart/Perk Level".text = "Max Level"
	if PlayerData.player_dic["max_mana"] == 5:
		$"SharpMind/Perk Level".text = "Max Level"
	if PlayerData.player_dic["max_dashes"] == 5:
		$"QuickStep/Perk Level".text = "Max Level"
	if PlayerData.player_dic["waterfall"] == true:
		$"Waterfall/Perk Level".text = "Max Level"
	if PlayerData.player_dic["deep_burn"] == true:
		$"DeepBurn/Perk Level".text = "Max Level"
	
	$"WarriorMight/Perk Level".text = "Melee DMG :" + str(PlayerData.player_dic["melee_dmg"])
	$"FocusedChi/Perk Level".text = "Magic DMG :" + str(PlayerData.player_dic["magic_dmg"])
	$"FlowingWater/Perk Level".text = "Dodge Chance: " + str(PlayerData.player_dic["dodge"])+ "%"
	$"DeepCuts/Perk Level".text = "Crit Chance: " + str(PlayerData.player_dic["crit_chance"]) +"%"
	$Skillpoints.text = "Skillpoints: " + str(PlayerData.player_dic["skillpoints"])
	if PlayerData.player_dic["warrior_heart"] == true:
		$WarriorMight.disabled = false
		$SharpMind.disabled = false
		$QuickStep.disabled = false
		$WHLine1.visible=true
		$WHLine2.visible=true
		$WHLine3.visible=true
	if PlayerData.player_dic["sharp_mind"] == true:
		$FocusedChi.disabled = false
		$SMLine.visible = true
	if PlayerData.player_dic["quick_step"] == true:
		$FlowingWater.disabled = false
		$QSLine.visible = true
	if PlayerData.player_dic["warrior_might"] == true:
		$DeepCuts.disabled = false
		$WMLine.visible = true
	if PlayerData.player_dic["deep_cuts"] == true and PlayerData.player_dic["flowing_water"] == true:
		$Waterfall.disabled = false
		$FWLine.visible = true
		$DCLine2.visible = true
	if PlayerData.player_dic["deep_cuts"] == true and PlayerData.player_dic["focused_chi"] == true:
		$DeepBurn.disabled = false
		$FCLine.visible = true
		$DCLine1.visible = true
		
		

func _on_back_button_pressed():
	GameManager.uimanager.levelup_screen.hide()
	GameManager.pause_play()


func _on_warrior_heart_pressed():
	if PlayerData.player_dic["skillpoints"] > 0 and PlayerData.player_dic["max_health"] < 10:
		PlayerData.player_dic["max_health"] +=1
		PlayerData.player_dic["health"] = PlayerData.player_dic["max_health"]
		PlayerData.player_dic["skillpoints"] -=1
		PlayerData.player_dic["warrior_heart"] = true


func _on_warrior_might_pressed():
	if PlayerData.player_dic["warrior_heart"] == true:
		if PlayerData.player_dic["skillpoints"] > 0:
			PlayerData.player_dic["melee_dmg"] +=1
			PlayerData.player_dic["skillpoints"] -=1
			$"WarriorMight/Perk Level".text = "Melee DMG :" + str(PlayerData.player_dic["melee_dmg"])
			PlayerData.player_dic["warrior_might"] = true
			


func _on_quick_step_pressed():
	if PlayerData.player_dic["warrior_heart"] == true:
		if PlayerData.player_dic["skillpoints"] > 0 and PlayerData.player_dic["max_dashes"]  < 5:
			PlayerData.player_dic["max_dashes"] +=1
			PlayerData.player_dic["dashes"] = PlayerData.player_dic["max_dashes"]
			PlayerData.player_dic["skillpoints"] -=1
			PlayerData.player_dic["quick_step"] = true


func _on_flowing_water_pressed():
	if PlayerData.player_dic["quick_step"] == true:
		if PlayerData.player_dic["skillpoints"] > 0 and PlayerData.player_dic["dodge"]  < 30:
			PlayerData.player_dic["dodge"] += 5
			PlayerData.player_dic["skillpoints"] -= 1
			$"FlowingWater/Perk Level".text = "Dodge Chance: " + str(PlayerData.player_dic["dodge"])+ "%"
			PlayerData.player_dic["flowing_water"] = true


func _on_deep_cuts_pressed():
	if PlayerData.player_dic["warrior_might"] == true:
		if PlayerData.player_dic["skillpoints"] > 0 and PlayerData.player_dic["crit_chance"] < 30:
			PlayerData.player_dic["crit_chance"] += 5
			PlayerData.player_dic["skillpoints"] -= 1
			$"DeepCuts/Perk Level".text = "Crit Chance: " + str(PlayerData.player_dic["crit_chance"]) +"%"
			PlayerData.player_dic["deep_cuts"] = true



func _on_focused_chi_pressed():
	if PlayerData.player_dic["sharp_mind"] == true :
		if PlayerData.player_dic["skillpoints"] > 0:
			PlayerData.player_dic["magic_dmg"] +=1
			PlayerData.player_dic["skillpoints"] -=1
			$"FocusedChi/Perk Level".text = "Magic DMG :" + str(PlayerData.player_dic["magic_dmg"])
			PlayerData.player_dic["focused_chi"] = true


func _on_sharp_mind_pressed():
	if PlayerData.player_dic["warrior_heart"] == true:
		if PlayerData.player_dic["skillpoints"] > 0 and PlayerData.player_dic["max_mana"]  < 5:
			PlayerData.player_dic["max_mana"] +=1
			PlayerData.player_dic["mana"] = PlayerData.player_dic["max_mana"]
			PlayerData.player_dic["skillpoints"] -=1
			PlayerData.player_dic["sharp_mind"] = true


func _on_waterfall_pressed():
	if PlayerData.player_dic["flowing_water"]==true and PlayerData.player_dic["deep_cuts"]==true and PlayerData.player_dic["waterfall"] == false:
		if PlayerData.player_dic["skillpoints"] > 0:
			PlayerData.player_dic["waterfall"] = true
			PlayerData.player_dic["skillpoints"] -= 1


func _on_deep_burn_pressed():
	if PlayerData.player_dic["focused_chi"] == true and PlayerData.player_dic["deep_cuts"] == true and PlayerData.player_dic["deep_burn"] == false:
		if PlayerData.player_dic["skillpoints"] > 0:
			PlayerData.player_dic["deep_burn"] = true
			PlayerData.player_dic["skillpoints"] -=1
