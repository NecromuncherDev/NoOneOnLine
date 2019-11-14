extends Node2D

const PORT = 4242
var maxConn = 0

func _ready():
	get_tree().connect("network_peer_connected",self, "_on_network_peer_connected")

func _on_network_peer_connected(id):
	globals.otherPlayersIds.append(id)
	print(globals.otherPlayersIds)
	var game = preload("res://Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()


func _on_ButtonHost_pressed():
	print("Hosting network")
	var host = NetworkedMultiplayerENet.new()
	
	maxConn = int($ButtonHost/TextboxMaxConn.text)
	var res = host.create_server(PORT, maxConn)
	
	if(res != OK):
		print("Error while creating server")
		return
	
	$ButtonJoin.hide()
	$ButtonHost.disabled = true
	get_tree().set_network_peer(host)
	$ButtonHost.text = "Host: " + IP.get_local_addresses()[1] + " | Port: " + str(PORT)


func _on_ButtonJoin_pressed():
	var joinHost = $ButtonJoin/TextboxHostIP.text
	var joinPort = $ButtonJoin/TextboxHostPort.text
	
	print("Joining game on " + joinHost + ":" + joinPort)
	var host = NetworkedMultiplayerENet.new()
	host.create_client(joinHost, int(joinPort))
	get_tree().set_network_peer(host)
	
	print("Player '" + str(get_tree().get_network_unique_id()) + "' connected to server!")
	
	$ButtonHost.hide()
	$ButtonJoin.disabled = true
	$ButtonJoin.text = "Waiting for players on " + joinHost + ":" + joinPort + "..."