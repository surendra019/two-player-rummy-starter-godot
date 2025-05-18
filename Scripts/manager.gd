extends Node

#crucial positions for the piles and cards in the main game
const CARD_SIZE = Vector2(72, 52)
const DISCARD_PILE_POSITION = Vector2(776, 396)
const STOCK_PILE_POSITION = Vector2(81, 396)
const WASTE_PILE_POSITION = Vector2(166, 396)

#all the cards which are available in the stock pile
var stock_pile_cards = []



var card_pair:Vector2 = Vector2.ZERO
const SELECT_Z_IDX = 100

#back card image's reference
var card_back = "res://Assets/Pyramid Kings/Cards/back.png"

var all_card_deck = []

#giving values to the images to easily retrieve later
var sphades = {
	1: "res://Assets/Pyramid Kings/Cards/Spades/ace.png",
	2: "res://Assets/Pyramid Kings/Cards/Spades/2.png",
	3: "res://Assets/Pyramid Kings/Cards/Spades/3.png",
	4: "res://Assets/Pyramid Kings/Cards/Spades/4.png",
	5: "res://Assets/Pyramid Kings/Cards/Spades/5.png",
	6: "res://Assets/Pyramid Kings/Cards/Spades/6.png",
	7: "res://Assets/Pyramid Kings/Cards/Spades/7.png",
	8: "res://Assets/Pyramid Kings/Cards/Spades/8.png",
	9: "res://Assets/Pyramid Kings/Cards/Spades/9.png",
	10: "res://Assets/Pyramid Kings/Cards/Spades/10.png",
	11: "res://Assets/Pyramid Kings/Cards/Spades/jack.png",
	12: "res://Assets/Pyramid Kings/Cards/Spades/queen.png",
	13: "res://Assets/Pyramid Kings/Cards/Spades/king.png",

}

var clubs = {
	1: "res://Assets/Pyramid Kings/Cards/Clubs/ace.png",
	2: "res://Assets/Pyramid Kings/Cards/Clubs/2.png",
	3: "res://Assets/Pyramid Kings/Cards/Clubs/3.png",
	4: "res://Assets/Pyramid Kings/Cards/Clubs/4.png",
	5: "res://Assets/Pyramid Kings/Cards/Clubs/5.png",
	6: "res://Assets/Pyramid Kings/Cards/Clubs/6.png",
	7: "res://Assets/Pyramid Kings/Cards/Clubs/7.png",
	8: "res://Assets/Pyramid Kings/Cards/Clubs/8.png",
	9: "res://Assets/Pyramid Kings/Cards/Clubs/9.png",
	10: "res://Assets/Pyramid Kings/Cards/Clubs/10.png",
	11: "res://Assets/Pyramid Kings/Cards/Clubs/jack.png",
	12: "res://Assets/Pyramid Kings/Cards/Clubs/queen.png",
	13: "res://Assets/Pyramid Kings/Cards/Clubs/king.png",

}

var hearts = {
	1: "res://Assets/Pyramid Kings/Cards/Hearts/ace.png",
	2: "res://Assets/Pyramid Kings/Cards/Hearts/2.png",
	3: "res://Assets/Pyramid Kings/Cards/Hearts/3.png",
	4: "res://Assets/Pyramid Kings/Cards/Hearts/4.png",
	5:"res://Assets/Pyramid Kings/Cards/Hearts/5.png",
	6: "res://Assets/Pyramid Kings/Cards/Hearts/6.png",
	7: "res://Assets/Pyramid Kings/Cards/Hearts/7.png",
	8: "res://Assets/Pyramid Kings/Cards/Hearts/8.png",
	9: "res://Assets/Pyramid Kings/Cards/Hearts/9.png",
	10: "res://Assets/Pyramid Kings/Cards/Hearts/10.png",
	11: "res://Assets/Pyramid Kings/Cards/Hearts/jack.png",
	12: "res://Assets/Pyramid Kings/Cards/Hearts/queen.png",
	13: "res://Assets/Pyramid Kings/Cards/Hearts/king.png",

}

var diamonds = {
	1: "res://Assets/Pyramid Kings/Cards/Diamonds/ace.png",
	2: "res://Assets/Pyramid Kings/Cards/Diamonds/2.png",
	3: "res://Assets/Pyramid Kings/Cards/Diamonds/3.png",
	4: "res://Assets/Pyramid Kings/Cards/Diamonds/4.png",
	5: "res://Assets/Pyramid Kings/Cards/Diamonds/5.png",
	6: "res://Assets/Pyramid Kings/Cards/Diamonds/6.png",
	7: "res://Assets/Pyramid Kings/Cards/Diamonds/7.png",
	8: "res://Assets/Pyramid Kings/Cards/Diamonds/8.png",
	9: "res://Assets/Pyramid Kings/Cards/Diamonds/9.png",
	10: "res://Assets/Pyramid Kings/Cards/Diamonds/10.png",
	11: "res://Assets/Pyramid Kings/Cards/Diamonds/jack.png",
	12: "res://Assets/Pyramid Kings/Cards/Diamonds/queen.png",
	13: "res://Assets/Pyramid Kings/Cards/Diamonds/king.png",
	
}


func get_type_from_cards_ref(cards_ref: Dictionary) -> String:
	var result: String = ""
	
	match  cards_ref:
		Manager.sphades:
			result = "s"
		Manager.hearts:
			result = "h"
		Manager.clubs: 
			result = "s"
		Manager.diamonds:
			result = "d"
	return result

func set_texture_according_to_class(card):
	match card.type:
		"s": card.texture = load(sphades[card.value])
		"h": card.texture = load(hearts[card.value])
		"c": card.texture = load(clubs[card.value])
		"d": card.texture = load(diamonds[card.value])
		
