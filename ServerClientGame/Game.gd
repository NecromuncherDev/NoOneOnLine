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
		print("'i': " + str(i))
		otherPlayer = preload("res://Player.tscn").instance()
		otherPlayer.set_name(str(i))
		print("Player has name " + otherPlayer.get_name())
		otherPlayer.set_network_master(i)
		print("Player network master set to " + str(otherPlayer.get_network_master()))
		add_child(otherPlayer)
	
	get_tree().get_root().print_tree_pretty()

func leaveGame(id):
	rpc("removePlayer", id)
	get_tree().quit()

sync func removePlayer(id):
	print("Removing player " + str(id))
	globals.otherPlayersIds.erase(id)
	remove_child(get_node("./" + id))