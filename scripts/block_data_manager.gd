extends Node

var blocks = {}

func _ready():
	add_block(preload("res://assets/blocks/air.tres"))
	add_block(preload("res://assets/blocks/grass.tres"))
	add_block(preload("res://assets/blocks/dirt.tres"))
	add_block(preload("res://assets/blocks/stone.tres"))
	add_block(preload("res://assets/blocks/sand.tres"))
	add_block(preload("res://assets/blocks/water.tres"))
	add_block(preload("res://assets/blocks/coal_ore.tres"))
	add_block(preload("res://assets/blocks/iron_ore.tres"))
	add_block(preload("res://assets/blocks/diamond_ore.tres"))
	add_block(preload("res://assets/blocks/bedrock.tres"))

func add_block(block: Block):
	blocks[block.name] = block

func get_block(name: String) -> Block:
	return blocks[name]
