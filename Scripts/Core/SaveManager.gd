extends Node

var savepath = "user://"
var savename = "save1.tres"

var savedata = SaveData.new()

func load_game():
	savedata = ResourceLoader.load(savepath + savename).duplicate(true)
	#PlayerData.inventory_dic = savedata.inventory_dic
	PlayerData.player_dic = savedata.player_dic
	WorldData.world_dic = savedata.world_dic
	#print(PlayerData.player_dic["inventory"])
	#EnemyData.enemy_dic = savedata.enemy_dic
	#print(WorldData.world_dic)
func save_game():
	#print(PlayerData.player_dic["inventory"])
	#savedata.inventory_dic = PlayerData.inventory_dic
	savedata.player_dic = PlayerData.player_dic
	savedata.world_dic = WorldData.world_dic
	#savedata.enemy_dic = EnemyData.enemy_dic
	ResourceSaver.save(savedata, savepath + savename)
	#print(savedata.world_dic)
