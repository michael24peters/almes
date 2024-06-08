extends Node
class_name StatsComponent

@export var entity_name: String
@export var hit_points: HealthComponent
@export var hitbox: HitboxComponent

@export var attr = {"STR": 3, "INT": 3, "WIS": 3, "DEX": 3, "CON": 3, "CHA": 3}
@export var skills = {"social": 0, "athletics": 0, "history": 0, "herbalism": 0, 
	"medicine": 0}
@export var combat : Dictionary
@export var languages_spoken = {"Almerian": 1}
@export var languages_literate = {"Almerian": .0}
@export var religions : Dictionary
@export var histories : Dictionary
@export var cultures : Dictionary
@export var supernatural : Dictionary
@export var elder_races : Dictionary
@export var spells : Dictionary
@export var special_abilities : Dictionary

var attr_progress = {"STR": .0, "INT": 0, "WIS": 0, 
	"DEX": .0, "CON": .0, "CHA": .0}
var skills_progress : Dictionary
var combat_progress : Dictionary
var languages_spoken_progress : Dictionary
var languages_literate_progress : Dictionary
var religions_progress : Dictionary
var histories_progress : Dictionary
var cultures_progress : Dictionary 
var supernatural_progress : Dictionary
var elder_races_progress : Dictionary
var spells_progress : Dictionary
var special_abilities_progress : Dictionary

func progress(stat_name, stats, stat_progress): # Progression algorithm
	stats[stat_name] += stat_progress # TODO: implement progress algorithm
