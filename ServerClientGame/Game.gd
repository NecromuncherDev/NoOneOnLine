extends Node2D

func _ready():
	# First create ourself
	var thisPlayer = preload("res://Player.tscn").instance()
	print("Host player created")
	thisPlayer.set_name(str(get_tree().get_network_unique_id()))
	print("Host name set to " + str(thisPlayer.get_name()))
	thisPlayer.set_network_master(get_tree().get_network_unique_id())
	print("Host set to network master as " + str(thisPlayer.get_network_master()))
	add_child(thisPlayer)
	
	# Now create other players
	var otherPlayer
	for i in globals.otherPlayersIds:
		otherPlayer = preload("res://Player.tscn").instance()
		otherPlayer.set_name(str(i))
		otherPlayer.set_network_master(int(i))
		print(str(i) + " is now network_master")
		add_child(otherPlayer)
	
	get_tree().get_root().print_tree_pretty()

func leaveGame(id):
	if(is_network_master()):
		rpc("removePlayer", id)
	else:
		print( str(id) + " tried to remove player despite not being network_master")

sync func removePlayer(id):
	print("Removing player " + str(id))
	globals.otherPlayersIds.erase(int(id))
	remove_child(get_node("./" + id))
	if(get_tree().get_network_unique_id() == int(id)):
		get_tree().quit()