class Map
	constructor: (@name) ->
		@tiles = []
		@terrain = []
		@props = []
		@width = 0
		@height = 0

	rows = (map) ->
		map.split("\n").map (row) ->
			row.replace /\s+$/, ""

	setTiles = (property, tileMap) ->
		tiles = (@[property] or= [])
		tileRows = rows tileMap
		
		width = Math.max.apply null, (row.length for row in tileRows)
		height = tileRows.length

		@width = Math.max @width, width
		@height = Math.max @height, height

		for y in [0...height]
			for x in [0...width]
				tiles[y] or= []
				tiles[y][x] or= []

				tile = tileRows[y][x]
				continue unless tile

				mapTile = new MapTile @, x, y, tile
				mapTile.z = tiles[y][x].push mapTile

	addTileMap: (map) ->
		setTiles.call @, "tiles", map
	addTerrainMap: (map) ->
		setTiles.call @, "terrain", map
	addPropsMap: (map) ->
		setTiles.call @, "props", map
	setCollisionMap: (map) ->
		@collision = []
		setTiles.call @, "collision", map

	# addTileMap: (tileMap) ->
	# 	tileRows = rows tileMap
		
	# 	width = Math.max.apply null, (row.length for row in tileRows)
	# 	height = tileRows.length

	# 	@width = Math.max @width, width
	# 	@height = Math.max @height, height

	# 	for y in [0...height]
	# 		for x in [0...width]
	# 			@tiles or= []
	# 			@tiles[y] or= []
	# 			@tiles[y][x] or= []

	# 			tile = tileRows[y][x]
	# 			continue unless tile

	# 			@tiles[y][x].push new MapTile @, x, y, tile

	# setCollisionMap: -> console.debug "Map.setCollisionMap not yet implemented"


class MapTile
	constructor: (@map, @x, @y, @tile) ->

	tileClasses =
		"w": "wall"
		"g": "grass"
		"G": "tall-grass"
		"d": "door"
		"s": "shrub"
		"t": "tree"
		"T": "tall-tree"

	collisionClasses =
		"#": "solid"
		"O": "warp"
		"r": "random"

	background: -> tileBackgrounds[@tile] or "transparent"
	tileClass: -> tileClasses[@tile] or ""
	collisionClass: -> collisionClasses[@tile or "#"]

	isSolid: -> (@tile or "#") is "#"
	isWarp: -> @tile is "O"
	isRandomEvent: -> @tile is "r"




map = new Map "arena"

map.addTerrainMap """
	 wwwww
	wwgGGww
	dgggGgw
	wgggggd
	wwGggww
	 wwwww
"""
map.addPropsMap """
	
	  ss
	  s
	 T
	   t
"""
# collision
map.addPropsMap """
	#######
	## rr##
	O   r #
	#     O
	##r  ##
	#######
"""

Template.map.map = -> map



Session.setDefault "showTiles", yes
Session.setDefault "showCollision", yes

checkedIfTrue = (truth) ->
	if truth then "checked" else ""

Template.controls.checkedIfShowTiles = ->
	checkedIfTrue Session.get "showTiles"

Template.controls.checkedIfShowCollision = ->
	checkedIfTrue Session.get "showCollision"

Template.controls.events
	'change input[name="showTiles"]': (event) ->
		Session.set "showTiles", not Session.get "showTiles"
	'change input[name="showCollision"]': (event) ->
		Session.set "showCollision", not Session.get "showCollision"


Template.tile.exists = ->
	@tileClass() or @collisionClass()

Template.tile.tileClass = ->
	if Session.get("showTiles") and @tileClass() then "tile-#{@tileClass()}" else ""

Template.tile.collisionClass = ->
	if Session.get("showCollision") and @collisionClass() then "collision-#{@collisionClass()}" else ""
