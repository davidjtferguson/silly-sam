# object instructions

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

   None

- name: hangingBag
- tiled object: point
- description: a hanging bag object. A static 'anchor' with a 'rope' and a dynamic block ('bag') at the end of the rope. The static anchor spawns at the x and y position of this tiled point.
- custom properties:

   bagHeight - float: the height of the bag object.
   
   bagWidth - float: the width of the bag object.
   
   pivotingJoint - bool: If false, the bag is revolution joined directly onto the anchor. This means the entire bag is always rotated towards the anchor. This is handy for swinging platforms. If true, the anchor is revolution joined to a pivot point at the other end of the rope and the bag is revolution joined to this pivot point. This means while the bag still rotates around the anchor, it can also rotate 'locally' independantly of the rope, which makes it act a little more like an actual punching bag.
   
   ropeLength - float: the distance between the anchor and the bag.

- name: ball
- tiled object: eclipse
- description: Creates a ball at the x and y position of the eclipse. Note that the ball is always a circle - if the eclipse on the map does not have equal width and height the game will take the average and use this. Ignores rotation (do not rotate the tiled eclipse as this will cause the game to desync from the map position).
- custom properties:

	static - bool: if true, object will never move. If false will be a 'dynamic' object and move.
	
- name: rectangle
- tiled object: rectangle
- description: creates a rectangle at the x and y position of the tiled rectangle, with the same rotation.
- custom properties:

	static - bool: if true, object will never move. If false will be a 'dynamic' object and move.
