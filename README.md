# silly-sam

A game by Berd

Physics based silly movement joke toy thing.

## Getting Started

On checking out the project there are two main folders. The 'silly-sam' folder contains all the game files as the Love2D project. 'map-editing' contains the Tiled files and the Silly Sam specific object instructions.

Things you'd need to download and learn
- Love2D for the game creation framework
- Tiled for creating the maps

Basics I'm using
- Visual Studio Code
- Git Bash

## Controls

### Joystick controls

If the corrisponding leg is on the ground, the left trigger puts a force up Sam's left leg and the right trigger puts a force up Sam's right leg. These should be alternated to make Sam shuffle around.

The left and right bumpers clench Sam's left and right hands respectively. If Sam's hand is overlapping something he'll grab that object untill the bumper is released.

The left and right sticks make Sam's arms point at the same angle you push the stick in.
So if you push both sticks up Sam will hold their arms in the air.

Press start to pause.

Press back or right on the d-pad to toggle fullscreen. (Note you may have performance issues in fullscreen - if this occurs keeping the game windowed is recommended).

### Keyboard controls

C lifts Sam's left leg if it's on the ground, N lifts Sam's right leg if it's on the ground.

E grabs with left hand, U grabs with right hand.

Use WASD to direct the left arm and IJKL to direct the right arm.

Press P to pause.

Use F to toggle fullscreen.

## Branch labels

Each branch should be named with a prefix to explain what kind of content is in the branch.

- feature/[name]. This is for a new feature, coding wise.
- fix/[name]. This is for a bug fix or fixing a tech debt issue.
- map/[name]. This is a PR focussed on making a new section of map or editing a map.
- art/[name]. This is a branch for adding new art assets to the project. These branches should only be the addition of the art asset and a little code to implement it.

## Projects we're using to make this (thanks so much for making these things!!)

Love2D
Tiled

Simple-Tiled-Implementation:
https://github.com/karai17/Simple-Tiled-Implementation

hump:
https://github.com/vrld/hump