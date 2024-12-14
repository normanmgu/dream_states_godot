# Dream State

A top-down action-adventure game where players must escape from a mysterious dream world.
itch.io link:
https://normanmgu.itch.io/dream-states

## Game Overview

In Dream State, players find themselves trapped in a mysterious dream world. To escape, players must progress through different dream levels by defeating enemies and overcoming challenges. Each level represents a deeper layer of the dream, and only by clearing all enemies in each stage can the player progress to the next dream.

## Core Mechanics

### Player Systems
- Health system with hearts display (3 hearts by default)
- Combat system with directional attacks
- Fluid movement in 8 directions
- Death and respawn mechanics

### Enemy System
The game features an abstract base enemy class that can be extended to create different enemy types:

#### Base Enemy Features
- Health management
- Knockback system
- Movement AI
- Death animations
- Damage system

#### Current Enemy Types
- Slimes (with variants like happy and mad versions)
- More enemy types planned

### Level Progression
- Each level (dream) must be cleared of enemies to progress
- Enemy tracking system counts remaining enemies
- Level transitions are blocked until all enemies are defeated
- Uses signal system to detect enemy defeats and manage level progression

## Technical Implementation

### Core Systems

1. **Scene Management**
   - Transitions between different dream levels
   - Persistent player state between scenes
   - Canvas layer for UI elements

2. **Signal System**
   - Health changes
   - Enemy defeat detection
   - Level completion triggers

3. **Enemy Management**
   - Base enemy class for shared functionality
   - Custom enemy types inherit from base class
   - Enemy count tracking for level progression

## Controls
- Arrow keys/WASD for movement
- Directional attack inputs (IJKL)
- Interaction with level elements

## Future Features Planned
- Power-up system in interlude scenes
- Additional enemy types
- More complex dream environments
- Enhanced combat mechanics

## Development

The game is built using the Godot Engine with GDScript. It uses a signal-based architecture for loose coupling between systems.

### Key Scripts
- Player controller
- Base enemy class
- Level management
- UI system
- Global state management