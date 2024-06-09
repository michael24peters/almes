# Almēs Design Document

## Table of Contents
1. [Overview](#overview)
    1. [The Pitch](#thepitch)
2. [Design Goals](#designgoals)
    1. [Project Goals](#projectgoals)
    2. [Team Goals](#teamgoals)
3. [Concept](#concept)
    1. [Inspiration](#inspiration)
    2. [Gameplay](#gameplay)
    3. [Primary Mechanics](#pmechanics)
    4. [Secondary Mechanics](#smech)
5. [Art](#art)
6. [Music](#music)
7. [Minimal Viable Product](#mvp)
    1. [Systems & Mechanics](#sys)
    2. [Content](#content)

## Overview <a name="overview"></a>

### The Pitch <a name="thepitch"></a>
This game is about playing out the character creation process narratively. This is the story of a child becoming an adult, pulled in two directions by desire for individual fulfillment and obligation to their family in crisis.

## Design Goals <a name="designgoals"></a>

### Project Goals <a name="projectgoals"></a>
1. **Difficult.** Progression is hard. There are endless incentives to not work towards your goals, and most of these distractions are significantly more *fun* but usually not as *satisfying*.
2. **Narrative.** The primary purpose of this game is to take the player through a meaningful story.
3. **Meaningful, consequential decisions.** Limited time for events, overlapping and conflicting events.

### Team Goals <a name="teamgoals"></a>
1. Tell a story that poses interesting dilemmas, leaves you thinking.
2. Resume-building. Whether it be for artistic purposes, programming purposes, or game development purposes, everyone involved can add this to their resume.
3. Challenge the player to consider how they spend and value their time in real life.

## Concept <a name="concept"></a>

### Inspiration <a name="inspiration"></a>
**Fallout 1:** Even in 1997, *Fallout* dialogue is legendary for its witty, sometimes dark, sometimes hilarious, dialogue. It knows when to strike deep, when to play it loose, and how to inform you about the world without it feeling like a chore. You were free to pursue the story on your own terms.

**Fable 1 & 2:** *Fable* provides a useful model for how to create significant childhood sections of the game with decisions that inform future play style.

**Baldur's Gate I & II:** *Baldur's Gate* captures the classic gameplay and style of the old-school, 2D, isometric RPGs from the Infinity Engine era.

**Diablo I & II:** Aesthetically, *Diablo* mood and atmosphere is perfect to the kind of game we'd want to create: home base feels like safety, outside world feels dangerous and scary. The music and art direction are peak.

**Dark Souls:** *Dark Souls* doesn't hold your hand with anything. The story and setting are told through environmental storytelling; you never feel like exposition is getting shoved down your throat, and any written lore is entirely optional and flavorful, available to those interested in it. The difficulty of the series is also a point to model off of; we want to make a difficult game that feels satisfying and rewarding, not necessarily "fun".

**Robert E. Howard:** Specifically, the *Conan* and *Kull* short stories create an atmosphere we more or less want to mimic.

### Gameplay <a name="gameplay"></a>

### Primary Mechanics <a name="pmechanics"></a>
**Progression system:** Quality score for how an event or action or activity was performed, which determines progress gained or lost in a stat. The progression algorithm should roughly model real life learning, difficulty, and motivation.

**Events:** The game is broken up into chunks called "events". In an event, multiple scenes with branching decisions are made that shape who the character is becoming. Events have a limited time window and often conflict with each other, forcing the player to make difficult choices.

**Activity:** Within events, activities are performed which, based on the quality of their completion, funnel into the progression system. Activities are the gameplay components (or "abstractions") that the player interacts with.

**Skills:** Scores range from 0-3 (0 - unskilled, 1 - novice, 2 - proficient, 3 - skilled). Skills are used to resolve tasks, unlock events, supplement the story, and more.

### Secondary Mechanics <a name="smech"></a>
**Resource management:** Hit points, stamina, and time must be managed during certain events in the game. Interacting with the game in a mechanically meaningful way costs time, more than anything else.

**NPC relationships:** Character decisions and dialogue choices influence the relationship they have with NPCs. Talking to an NPC at point A, say X, and they’ll be at point B later in game for another interaction, with the continuous promise of stat progression throughout. At its most basic, this manifests as dialogue trees.

## Art <a name="art"></a>
We would like to make our own art wherever possible; however, we must keep very minimal expectations. If art is created in house, it will be simple.

## Music <a name="music"></a>
We would like to make our own music wherever possible; however, we must keep very minimal expectations. If music is created in house, it will be simple.

## Minimal Viable Product <a name="mvp"></a>
The minimal viable product should cover the first act of the game, ranging from ages 5 to 8 for the character and taking place entirely in family B's estate (plus the small hostage exchange scene). It should give a basic introduction to the gameplay loop and should take 1 to 3 hours to complete.

### Systems & Mechanics <a name="sys"></a>
Exploratory. Less planning, more doing. Playful mentality. Make a lot of different things.

- [ ] Animation
	- [ ] Character idle
	- [ ] Character walk
	- [ ] Character run
	- [ ] Character attack
	- [ ] Fire
	- [ ] Snow particles
- [ ] Collision
	- [ ] Y/Z layers
	- [ ] Collision boxes
	- [ ] Weapon collisions
	- [ ] World collisions
	- [ ] Character collisions
- [ ] Progression algorithm
- [ ] Skill system
	- [ ] Every skill should have one or more mini-games associated with progressing it, as well as associated dialogue trees to add a more subjective factor.
- [ ] Simple combat
	- [ ] A* pathfinding
	- [ ] Damage
- [ ] Advanced combat (optional)
	- [ ] Contextual movement and weight-based steering
	- [ ] Weapon types
	- [ ] Attack types
	- [ ] Damage types
- [ ] UI
	- [ ] Character sheet
	- [ ] Inventory
	- [ ] Dialogue boxes
	- [ ] Dialogue choices
	- [ ] HUD
- [ ] Cutscenes

### Content <a name="content"></a>
Make plans to limit scope. Good deadline. Work mentality.

- [ ] Maps
	- [ ] Introduction
	- [ ] Family B estate (partial)
- [ ] Dialogue
- [ ] Unique NPCs: 
	- [ ] *family B father*
	- [ ] best friend
	- [ ] caretaker
	- [ ] priest
	- [ ] *general*
	- [ ] traveling merchant
- [ ] Generic NPCs: 
	- [ ] playgroup
	- [ ] old coot
	- [ ] guards
	- [ ] servants
	- [ ] *adult family B members*
- [ ] Events (w/ expiry dates)
	- [ ] **Cultures** - old coot's death and funeral
	- [ ] **Languages, literate** - caretaker (difficult; maybe leave out)
	- [ ] **Cultures** - caretaker
	- [ ] **Histories** - old coot
	- [ ] **Languages, spoken** - traveling merchant
	- [ ] **Combat** - playgroup
	- [ ] **Combat** - best friend
	- [ ] **Social** - playgroup
	- [ ] **Social** - traveling merchant
	- [ ] **Religions** - priest
	- [ ] **Histories** - general
	- [ ] **Combat** - guards, general
- [ ] Art. Create everything in MSPaint or Photoshop, just prototypes with no particular style in mind. These initial drawings should be crude to promote rapid development.
	- [ ] Character sprite sheets
	- [ ] Nature
	- [ ] Exterior buildings
	- [ ] Interior buildings
	- [ ] Furniture
- [ ] Music & Sound
	- [ ] Make one track
	- [ ] Use other people's music
	- [ ] Howling wind sounds
	- [ ] Footsteps
- [ ] Story beats
	- [ ] Hostage exchange. Do not mention any names on family A side. 
	- [ ] Time skip.
	- [ ] Show daily life (status quo) .
	- [ ] Introduction to playgroup.
	- [ ] Intro to dialogue trees. Player decides how to navigate the social dynamic of being part of the group but subtle hints of being different, e.g. no parent, battle broken up by house but you are part of none, etc.
	- [ ] Introduction to best friend. Steps in in defense of player. Player defines the dynamic of the friendship going forward.
	- [ ] Intro to conflict resolution. Player and friend decide how to deal with the hostile kids. Violence, words, trickery, running, etc.
		- [ ] Intro to combat. Basic swings, very random, unreliable hit-boxes, etc.
	- [ ] Caretaker steps in to break up conflict. 
		- [ ] If player resolves it alone through violence, they will be scolded by misunderstanding.
		- [ ] If resolved through words, they will be ushered off without a word.
		- [ ] If the player avoids combat and is injured, the caretaker will sympathize with player and can boost the relationship.
	- [ ] Introduction to the old coot before dinner.
	- [ ] Subtle hints that you are different (sit at different spot during meals, unexplained avoidance, odd comments from adults).
	- [ ] Game opens up to freely pursue interests in estate
		- [ ] Priest returns from diplomatic mission.
		- [ ] Traveling merchant that serves the family returns from expedition.
		- [ ] General holds training session in the grounds.
		- [ ] Caretaker gives chores.
		- [ ] Explore estate and grounds with best friend.
		- [ ] Interact with guards.
	- [ ] Old coot's death. Funeral and burial rites.
	- [ ] Inciting event to prompt mentor arrival or acceptance. The mentor is the black sheep of the family, a brother of the family patriarch.
