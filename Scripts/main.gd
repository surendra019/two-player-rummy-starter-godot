extends Control


@onready var card_container: Node2D = $Cards
@onready var card_spawn_position: Marker2D = $CardSpawnPosition
@onready var opponent_card_position: Marker2D = $OpponentCardPosition
@onready var self_card_position: Marker2D = $SelfCardPosition
@onready var stock_pile: Panel = $Table/StockPile
@onready var discard_pile: Panel = $Table/DiscardPile
@onready var information_label: Label = $InformationLabel
@onready var turn_indicator: Label = $TurnIndicator
@onready var declare_button: Button = $DeclareButton

var main_deck: Array
var opponent_cards: Array = []
var discard_pile_cards: Array = []
var discard_pile_idx: int = 1
var self_cards: Array = []
const CARD = preload("res://Scenes/card.tscn")

enum TURN {PLAYER_1, PLAYER_2}
var turn: TURN = TURN.PLAYER_1
var current_selected_card

var can_select: bool
var self_played_first_time: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_deck = Array()
	declare_button.disabled = true
	spawn_cards(Manager.sphades)
	spawn_cards(Manager.hearts)
	spawn_cards(Manager.clubs)
	spawn_cards(Manager.diamonds)
	
	main_deck.shuffle()
	for i in main_deck:
		card_container.add_child(i)
		i.global_position = card_spawn_position.global_position - i.size / 2
		i.set_to_back()

	distribute_cards()
	
func set_turn(t: TURN) -> void:
	match t:
		TURN.PLAYER_1:
			turn_indicator.text = "Player 1's turn"
		
		TURN.PLAYER_2:
			turn_indicator.text = "Player 2's turn"
			information_label.text = ""
			await get_tree().create_timer(2).timeout
			add_card_to_opp()
			
	
	
func spawn_cards(cards_ref: Dictionary) -> void:
	for i in cards_ref:
		var c = CARD.instantiate()
		c.initialize(Manager.get_type_from_cards_ref(cards_ref), i, 0)
		main_deck.push_back(c)
	

func distribute_cards() -> void:
	var curr = opponent_card_position
	for i in main_deck:
		i.pickable_mode = i.PICKABLE_MODE.NONE
		var opp: bool = false
		var sel: bool = false
		
		var t = get_tree().create_tween()
		if curr == opponent_card_position:
			if opponent_cards.size() < 10:
				t.tween_property(i, "global_position", (curr.global_position - i.size / 2) + Vector2(45 * opponent_cards.size(), 0), .6)
				opponent_cards.push_back(i)
				curr = self_card_position
				main_deck.erase(i)
				
			else:
				opp = true
		else:
			if self_cards.size() < 10:
				t.tween_property(i, "global_position", (curr.global_position - i.size / 2) + Vector2(45 * self_cards.size(), 0), .6)
				self_cards.push_back(i)
				curr = opponent_card_position
				i.set_to_front()
				main_deck.erase(i)
				
			else:
				sel = true
		t.play()
		t.finished.connect(func():
			i.original_position = i.global_position
			
			)
		
		if sel && opp:
			break
		await get_tree().create_timer(.1).timeout
	for i in main_deck:
		i.pickable_mode = i.PICKABLE_MODE.NONE
		
		var t = get_tree().create_tween()
		t.tween_property(i, "global_position", stock_pile.global_position + (stock_pile.size - i.size) / 2, .5)
		t.play()
		t.finished.connect(func():
			i.original_position = i.global_position
			)
		
	await get_tree().create_timer(.5).timeout
	var last = main_deck[-1]
	var t = get_tree().create_tween()
	t.tween_property(last,"global_position", discard_pile.global_position + (discard_pile.size - last.size) / 2, .5)
	t.play()
	last.set_to_front()
	main_deck.erase(last)
	discard_pile_cards.push_back(last)
	last.pickable_mode = last.PICKABLE_MODE.NONE
	can_select = true
	set_turn(TURN.PLAYER_1)
	
	information_label.text = "pick a card from stock pile"
	
	enable_stock_pile(true)
	enable_discard_pile(true)
	
	

func enable_stock_pile(a: bool) -> void:
	for i in main_deck:
		if a:
			i.pickable_mode = i.PICKABLE_MODE.STOCK
		else:
			i.pickable_mode = i.PICKABLE_MODE.NONE

func enable_self_cards(a: bool) -> void:
	for i in self_cards:
		if a:
			i.pickable_mode = i.PICKABLE_MODE.SELF
		else:
			i.pickable_mode = i.PICKABLE_MODE.NONE

func enable_discard_pile(a: bool) -> void:
	for i in discard_pile_cards:
		if a:
			i.pickable_mode = i.PICKABLE_MODE.DISCARD
		else:
			i.pickable_mode = i.PICKABLE_MODE.NONE
			
func add_card_to_self(card) -> void:
	card_container.move_child(card, -1)
	self_cards.push_back(card)
	main_deck.erase(card)
	var t = get_tree().create_tween()
	t.tween_property(card, "global_position", (self_card_position.global_position - card.size / 2) + Vector2(45 * 11, 0), .3)
	t.play()
	t.finished.connect(func():
		card.original_position = card.global_position
		)
	card.set_to_front()
	for i in self_cards:
		var tw = get_tree().create_tween()
		tw.tween_property(i, "global_position", (self_card_position.global_position - i.size / 2) + Vector2(450/11 * self_cards.find(i), 0), .6)
		tw.play()
		tw.finished.connect(func():
			i.original_position = i.global_position
			
			)
		await get_tree().create_timer(.05).timeout
	enable_stock_pile(false)
	enable_discard_pile(false)
	enable_self_cards(true)
	information_label.text = "pick a card for discard pile"
	if turn == TURN.PLAYER_1:
		if self_played_first_time:
			declare_button.disabled = false
	else:
		declare_button.disabled = true
		
func add_card_to_opp() -> void:
	var top = main_deck[-1]
	card_container.move_child(top, -1)
	
	main_deck.erase(top)
	opponent_cards.push_back(top)
	var t = get_tree().create_tween()
	t.tween_property(top, "global_position", (opponent_card_position.global_position - top.size / 2) + Vector2(45 * 11, 0), .3)
	t.play()
	t.finished.connect(func():
		top.original_position = top.global_position
		)
	for i in opponent_cards:
		var tw = get_tree().create_tween()
		tw.tween_property(i, "global_position", (opponent_card_position.global_position - i.size / 2) + Vector2(450/11 * opponent_cards.find(i), 0), .6)
		tw.play()
		tw.finished.connect(func():
			i.original_position = i.global_position
			
			)
		await get_tree().create_timer(.05).timeout
	var rnd = opponent_cards.pick_random()
	move_opp_card_to_discard_pile(rnd)

func move_opp_card_to_discard_pile(card) -> void:
	card_container.move_child(card, -1)
	print("cal")
	opponent_cards.erase(card)
	discard_pile_cards.push_back(card)
	card.set_to_front()
	card.z_index = discard_pile_idx
	discard_pile_idx += 1
	
	var t = get_tree().create_tween()
	t.tween_property(card, "global_position", discard_pile.global_position + (discard_pile.size - card.size) / 2, .4)
	t.play()
	t.finished.connect(func():
		card.global_position = discard_pile.global_position + (discard_pile.size - card.size) / 2
		card.original_position = card.global_position
		set_turn(TURN.PLAYER_1)
		enable_stock_pile(true)
		enable_discard_pile(true)
		)
	
func move_card_to_discard_pile(card) -> void:
	
	current_selected_card = null
	self_cards.erase(card)
	discard_pile_cards.push_back(card)
	card.z_index = discard_pile_idx
	discard_pile_idx += 1
	if not self_played_first_time:
		self_played_first_time = true
	var t = get_tree().create_tween()
	t.tween_property(card, "global_position", discard_pile.global_position + (discard_pile.size - card.size) / 2, .4)
	t.play()
	set_turn(TURN.PLAYER_2)
	declare_button.disabled = true
	card_container.move_child(card, -1)
	t.finished.connect(func():
		card.original_position = card.global_position
		enable_self_cards(false)
		)
		
		
func add_card_to_self_from_discard_pile(card) -> void:
	card_container.move_child(card, -1)
	self_cards.push_back(card)
	discard_pile_cards.erase(card)
	var t = get_tree().create_tween()
	t.tween_property(card, "global_position", (self_card_position.global_position - card.size / 2) + Vector2(45 * 11, 0), .3)
	t.play()
	t.finished.connect(func():
		card.original_position = card.global_position
		)
	card.set_to_front()
	for i in self_cards:
		var tw = get_tree().create_tween()
		tw.tween_property(i, "global_position", (self_card_position.global_position - i.size / 2) + Vector2(450/11 * self_cards.find(i), 0), .6)
		tw.play()
		tw.finished.connect(func():
			i.original_position = i.global_position
			
			)
		await get_tree().create_timer(.05).timeout
	enable_stock_pile(false)
	enable_discard_pile(false)
	enable_self_cards(true)
	information_label.text = "pick a card for discard pile"

	if turn == TURN.PLAYER_1:
		if self_played_first_time:
			declare_button.disabled = false
	else:
		declare_button.disabled = true


func add_card_to_opp_from_discard_pile(card) -> void:
	print("p")
	card_container.move_child(card, -1)
	opponent_cards.push_back(card)
	discard_pile_cards.erase(card)
	var t = get_tree().create_tween()
	t.tween_property(card, "global_position", (opponent_card_position.global_position - card.size / 2) + Vector2(45 * 11, 0), .3)
	t.play()
	t.finished.connect(func():
		card.original_position = card.global_position
		)
	card.set_to_front()
	for i in self_cards:
		var tw = get_tree().create_tween()
		tw.tween_property(i, "global_position", (opponent_card_position.global_position - i.size / 2) + Vector2(450/11 * opponent_cards.find(i), 0), .6)
		tw.play()
		tw.finished.connect(func():
			i.original_position = i.global_position
			
			)
		await get_tree().create_timer(.05).timeout
	var rnd = opponent_cards.pick_random()
	move_opp_card_to_discard_pile(rnd)
