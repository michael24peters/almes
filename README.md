# Almēs Design Document

## Table of Contents
1. [Overview](#overview)
    1. [The Pitch](#thepitch)
    2. [Gantt Chart](#gantchart)
2. [Design Goals](#designgoals)
    1. [Project Goals](#projectgoals)
    2. [Team Goals](#teamgoals)
3. [Concept](#concept)
    1. [Inspirations](#inspirations)
    2. [Gameplay](#gameplay)
    3. [Relation to Theme](#relationtotheme)
    4. [Primary Mechanics](#pmechanics)
    5. [Secondary Mechanics](#smech)
5. [Art](#art)
6. [Music](#music)
7. [Minimal Viable Product](#mvp)

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
**Progression system:** Quality score for how an event or action or activity was performed, which determines progress gained or lost. Progression should roughly model real life.

**Events:** The game is broken up into chunks called "events". In an event, multiple scenes with branching decisions are made that shape who the character is becoming. Events have a limited time window and often conflict with each other, forcing the player to make difficult choices.

**Activity:** Within events, activities are performed which, based on the quality of their completion, funnel into the progression system. Activities are the gameplay components (or "abstractions") that the player interacts with.

**NPC relationships:** Character decisions and dialogue choices influence the relationship they have with NPCs. Talking to an NPC at point A, say X, and they’ll be at point B later in game for another interaction, with the continuous promise of stat increases throughout. At its most basic, this manifests as dialogue trees.

### Secondary Mechanics <a name="smech"></a>
**Resource management:** Hit points, stamina, and time must be managed during certain events in the game. Interacting with the game in a mechanically meaningful way costs time, more than anything else.

## Art <a name="art"></a>
We would like to make our own art wherever possible; however, we must keep very minimal expectations. If art is created in house, it will be simple.

**Perspective:** TODO

## Music <a name="music"></a>
We would like to make our own music wherever possible; however, we must keep very minimal expectations. If music is created in house, it will be simple.

## Minimal Viable Product <a name="mvp"></a>
- [ ]  Age: 5-8
- [ ]  Hours of gameplay: 1-3h
- [ ]  Scenes: 
	- [ ]  Intro
	- [ ]  Family B estate
- [ ]  Story
	- [ ]  Events: old coot death
	- [ ]  Plot: hostage exchange, time skip, daily life, subtle hints that you are different (sit at different spot during meals, unexplained avoidance, odd comments from adults), ends with some inciting event to prompt mentor arrival or acceptance (black sheep uncle, brother of family head).
- [ ]  Skills:
	- 0 - unskilled
	- 1 - novice
	- 2 - proficient
	- 3 - skilled
	- [ ]  Combat
	- [ ]  Social
	- [ ]  Languages, spoken
	- [ ]  Languages, literate
	- [ ]  Religions
	- [ ]  Cultures
	- [ ]  Histories
- [ ]  Mechanics:
	- [ ]  Movement and collision
	- [ ]  Animated map with interactions
	- [ ]  Events (w/ expiry date)
	- [ ]  Stat progression algorithm (tied to events)
	- [ ]  Simple combat
	- [ ]  Dialogue
	- [ ]  Unique NPCs: *family B father*, best friend, caretaker, priest, *general*, traveling merchant
	- [ ]  Generic NPCs: playgroup, old coot, guards, servants, *adult family B members*
- [ ]  UI
	- [ ]  Character sheet
	- [ ]  Inventory
	- [ ]  Dialogue boxes
	- [ ]  HUD
- [ ]  Design
	- [ ]  Define an aesthetic
	- [ ]  Animations
	- [ ]  Character design
	- [ ]  World design
	- [ ]  Map design
- [ ]  Music
	- [ ]  Make one track
	- [ ]  Use other people's music
