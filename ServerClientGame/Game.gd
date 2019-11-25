extends Node2D

func _ready():
	# First create ourself
	var thisPlayer = preload("res://Player.tscn").instance()
	print("Host player created")
	thisPlayer.set_name(str(get_tree().get_network_unique_id()))
	print("Host name set to " + str(thisPlayer.get_name()))
	thisPlayer.set_network_master(get_tree().get_network_unique_id())
	print(str(thisPlayer.get_name()) + "'s network_master is " + str(thisPlayer.get_network_master()))
	add_child(thisPlayer)
	
	# Now create other players
	var otherPlayer
	for i in globals.otherPlayersIds:
		otherPlayer = preload("res://Player.tscn").instance()
		otherPlayer.set_name(str(i))
		otherPlayer.set_network_master(int(i))
		print(str(otherPlayer.get_network_master()) + " is now network_master")
		add_child(otherPlayer)
	
	print("Network master is " + str(get_network_master()))