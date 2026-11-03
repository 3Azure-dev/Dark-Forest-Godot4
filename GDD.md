# Old Forest — Game Design Document

**3D horror-exploration · Godot 4 · Solo dev**

| | |
|---|---|
| Status | Pre-production |
| Inspiration | Slendrina: The Forest |
| Scope | First 3D game · small-scale |
| Version | 0.1 |

## Design Pillars
- **Small world, dense feeling** — every clearing matters. No big empty spaces.
- **Player curiosity first** — suggest, don't direct. Light, sound, odd shapes.
- **Simple mechanics, deep mood** — few systems. Each one reinforces atmosphere.

## Core Loop
Explore forest → Scavenge huts for resources → Survive enemies → Unlock the house secret

No combat goal. No XP. Survival and discovery only.

## World
| # | Area | Notes |
|---|---|---|
| 01 | Forest entry path | Teaches movement. Dense foliage. Disorienting. |
| 02 | Scattered huts (3–5) | Loot locations. Static for now. Not all have useful items. |
| 03 | Forest corridors | Narrow paths. Enemy encounters. Controls camera. |
| 04 | The large house | End goal. Locked initially. Contains the secret. |
| — | Mountains (border) | World boundary. Unreachable but imposing. No invisible walls. |

One level scene. Looping paths over a grid layout — the player should feel lost on a small map.

## Player
**Movement states**
- Walk — default, quiet
- Run — fast, noisy, attracts enemies
- Crouch — slow, quiet, hides from enemies
- Step-over — automatic on small obstacles
- Jump — removed

**Camera / feel**
- First-person
- Camera height slightly lower than standard FPS
- Subtle head bob on walk
- FOV widens slightly when running
- Flashlight shakes when running

## Enemies
### Ghost (priority 1)
| | |
|---|---|
| Behavior | Floats. Charges immediately on detection. |
| Survive by | Looking away from the ghost to break its charge. |
| Flashlight on | Ghost is more aggressive / spawns more often. |
| Flashlight off | Ghost slows and appears less near the player. |
| Detection rule | Lethal only if within X meters AND inside the player's camera cone. |

### Zombie (priority 2)
| | |
|---|---|
| Behavior | Runs fast toward the player on detection. |
| Survive by | Shining the flashlight to stun it briefly. No permanent stun. |
| Stun window | ~1 second only. Short cooldown before it can be stunned again. |
| Pathfinding | Godot NavigationAgent3D. No complex AI needed. |

## Flashlight System
| State | Effect |
|---|---|
| ON — ghost aggression | HIGH |
| ON — zombie countered | YES (stun only) |
| OFF — ghost aggression | LOW |
| OFF — navigation | BLIND |
| Running — flashlight beam | SHAKES |
| Crouching — flashlight beam | STEADY |

The flashlight is the core tension mechanic. Every player decision runs through it.

## Items & Resources
**Item types**
- Flashlight (default equipment)
- Keys — unlock huts / house
- 1 weapon — melee OR simple ranged (decide later)
- Misc resources — TBD during loot design

**Loot rules**
- Static placement for v1
- Not all huts have useful items
- Empty hut = audio/visual cue, not silence
- Procedural loot — future scope

## Visual & Audio Direction
**Visuals**
- Stylized, not realistic
- Fog everywhere (mood + performance)
- Palette: greens, browns, grey stone + one accent
- Low-poly friendly

**Audio**
- Wind, creaks, distant sounds
- Birds going silent = danger cue
- Footstep surface variation
- Silence used intentionally

## Scope — V1 vs Later
| Feature | When |
|---|---|
| Static hut layout | v1 |
| Static loot placement | v1 |
| Ghost + zombie (2 enemy types) | v1 |
| Flashlight system | v1 |
| One large house goal | v1 |
| Procedural hut generation | later |
| Procedural loot | later |
| Second weapon type | later |
| Lore / story layer | later |

## Open Questions
- Melee or ranged weapon for v1?
- What exactly is the "secret" in the house?
- Run stamina system or noise-only penalty?
- How many keys are needed to unlock the house?
- What is the one accent color?
