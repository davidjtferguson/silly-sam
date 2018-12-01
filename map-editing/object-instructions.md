# map creation instructions

See "test-map-limited.tmx" in Tiled to see examples of everthing described here.

Make sure to call your game objects layer in tiled "objects". This needs to be named as such so the game knows not to draw this layer, since this layer is only used for translating into game objects.

## Tile Custom Properties

- name: collidable
- type: bool
- description: Makes this tile create as a box2d static object if true
- example: see the green tiles in test-tileset as used in test-map-limited

## object instructions

Each object has a specific name and different flags that are read from the map. Here is a description of each name and their related attributes

- name: sam
- tiled object: point
- description: Spawns a Sam (avatar) object at the x and y position of this Tiled point
- custom properties:

   None

- name: skateboard
- tiled object: point
- description: Spawns a Skateboard object at the x and y position of this tiled point
- custom properties:

   texturePathBoard - string: a filepath to the texture to be used for the board.
   
   texturePathWheel - string: a filepath to the texture to be used for the wheels.
   
   cameraDistance - float: If the distance between sam and this object is less than cameraDistance both in the x and the y axis the camera will move and zoom in or out to get both sam and this object in frame. If no objects with the cameraDistance attribute are close enough to Sam the camera will focus on Sam. If multiple objects are within cameraDistance of Sam the camera will centre on the average of all those object's positions and Sam's position and zoom out accordingly.

- name: hangingBag
- tiled object: point
- description: a hanging bag object. A static 'anchor' with a 'rope' and a dynamic block ('bag') at the end of the rope. The static anchor spawns at the x and y position of this tiled point. The 'rope' is not a physics object, it's just a line drawn from the anchor to the bag object.
- custom properties:

   bagHeight - float: the height of the bag object.
   
   bagWidth - float: the width of the bag object.
   
   pivotingJoint - bool: If false, the bag is revolution joined directly onto the anchor. This means the entire bag is always rotated towards the anchor. This is handy for swinging platforms. If true, the anchor is revolution joined to a pivot point at the other end of the rope and the bag is revolution joined to this pivot point. This means while the bag still rotates around the anchor, it can also rotate 'locally' independantly of the rope, which makes it act a little more like an actual punching bag.
   
   ropeLength - float: the distance between the anchor and the bag.
   
   texturePath - string: a filepath to the texture to be used for the bag.
   
   cameraDistance - float: same as for other objects.

- name: ball
- tiled object: eclipse
- description: Creates a ball at the x and y position of the eclipse. Note that the ball is always a circle - if the eclipse on the map does not have equal width and height the game will take the average and use this. Ignores rotation (do not rotate the tiled eclipse as this will cause the game to desync from the map position).
- custom properties:

	static - bool: if true, object will never move. If false will be a 'dynamic' object and move.
	
	texturePath - string: a filepath to the texture to be used for the ball.
   
    cameraDistance - float: same as for other objects.
	
- name: rectangle
- tiled object: rectangle
- description: creates a rectangle at the x and y position of the tiled rectangle, with the same rotation.
- custom properties:

	static - bool: if true, object will never move. If false will be a 'dynamic' object and move.
	
	texturePath - string: a filepath to the texture to be used for the rectangle.
	
    cameraDistance - float: same as for other objects.
