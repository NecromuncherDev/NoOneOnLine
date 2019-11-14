extends Node2D

var speed = 5

slave func setPosition(pos):
	position = pos

slave func setRotation(rot):
	$Sprite.rotation = rot

slave func setNameTag(nameTag):
	$NameTag.text = nameTag
	print("NameTag set to '" + nameTag + "'")

master func shutItDown():
	# Send a shutdown to all connected clients including this one
	rpc("shutDown")

sync func shutDown():
	print("Game shutting down... [Origin:" + get_name() + "]")
	get_tree().quit()

func _ready():
	if(is_network_master()):
		$NameTag.text = str(get_tree().get_network_unique_id())
	rpc_unreliable("setNameTag", str(self.get_name()))
	print("Player " + str(self.get_name()) + " is ready!")

func _process(delta):
	var moveByX = 0
	var moveByY = 0
	var faceTo = 0
	if(is_network_master()):
		if(Input.is_action_pressed("ui_left")):
			moveByX -= speed
			faceTo = -0.5 
		if(Input.is_action_pressed("ui_right")):
			moveByX += speed
			faceTo = 0.5
		if(Input.is_action_pressed("ui_up")):
			moveByY -= speed
			faceTo = 0
		if(Input.is_action_pressed("ui_down")):
			moveByY += speed
			faceTo = 1
		if(Input.is_action_pressed("ui_cancel")):
			if(get_tree().is_network_server()):
				shutItDown()
			else:
				get_parent().leaveGame(self.get_name())
	
		rpc_unreliable("setPosition", Vector2(position.x - moveByX, position.y))
		rpc_unreliable("setRotation", $Sprite.rotation)
	
	if(moveByX != 0 && moveByY != 0):
		moveByX *= 0.75
		moveByY *= 0.75
	
	translate(Vector2(moveByX, moveByY))
	$Sprite.rotation = faceTo * PI
