class_name NetworkManager
extends Node

signal game_started

#region Variables
const MAX_CLIENTS: int = 2;

#region UI nodes
@onready var network_ui: CanvasLayer = $NetworkUI
@onready var ip_input: LineEdit = $NetworkUI/NetworkUIPanel/VBoxContainer/IPInput
@onready var port_input: LineEdit = $NetworkUI/NetworkUIPanel/VBoxContainer/PortInput
#endregion

#region Network spawning
@onready var spawned_nodes: Node = $NetworkInstantiatedObjects

var player_scene = preload("res://Content/Player/player.tscn")
var player_map: Dictionary[int, Player]
#endregion

var local_username: String;
#endregion

func _ready() -> void:
	pass

#region Start server/client
func start_host():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(int(port_input.text), MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	_on_player_connected(multiplayer.get_unique_id())
	
	$"../Map".spawn_random_map()
	
	network_ui.visible = false;
	
	game_started.emit()
	
func start_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_input.text, int(port_input.text))
	multiplayer.multiplayer_peer = peer
	
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)
	
	game_started.emit()
	
#endregion

#region Network callbacks
func _on_player_connected(id: int): #server
	print("Player %s joined the game" % id)
	
	var player: Player = player_scene.instantiate()
	player.name = str(id)
	player.username = local_username
	replicate(player)
	player_map[id] = player
	
func _on_player_disconnected(id: int): #server
	print("Player %s left the game" % id)
	player_map[id].queue_free()
	player_map.erase(id)
	
func _connected_to_server(): #Called when the client or host connects
	print("Connected to server")
	network_ui.visible = false

func _connection_failed(): #Called when the client fails to connect
	print("Connection failed")

func _server_disconnected(): #Server shutdown and client is kicked
	print("Server disconnected")
	network_ui.visible = true

#endregion

func _on_username_input_text_changed(new_text: String) -> void:
	local_username = new_text

func replicate(node: Node):
	spawned_nodes.add_child(node, true)
	
