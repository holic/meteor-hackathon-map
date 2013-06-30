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
		"a": "grass"
		"W": "water"
		"A": "tall-grass"
		"T": "tree"
		"H": "house"
		"C": "cave"
		"s": "bench"
		"q": "stone"
		"p": "avatar"
		"É": "path-top-left"
		"»": "path-top-right"
		"¼": "path-bottom-right"
		"È": "path-bottom-left"
		"Ä": "path-bottom"
		"Í": "path-top"
		"º": "path-left"
		"³": "path-right"
		"Ù": "path-inset-top-left"
		"À": "path-inset-top-right"
		"¿": "path-inset-bottom-left"
		"Ú": "path-inset-bottom-right"


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
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
"""

map.addTerrainMap """
TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
TT                                C   q    TT
TT                              q          TT
TT       q            s                    TT
TT                               É»        TT
TT     q                         º³        TT
TT       q     H                 º³        TT
TT                               º³        TT
TT             É»                º³        TT
TT             º³                º³        TT
TT             È¼                º³        TT
TT                           ÉÍÍÍÙ³        TT
TT   ÉÍÍÍÍÍÍÍ»               ºÚÄÄÄ¼        TT
TT ÉÍÙÚÄÄÄÄÄ¿³               º³            TT
TT ÈÄÄ¼     ºÀÍÍ»            º³            TT
TT      WWW ÈÄÄ¿³            º³            TT
TT     WWWWW   ºÀ»           º³            TT
TT     WWWWWWW È¿ÀÍ»         º³            TT
TT q    WWWWWW  ÈÄ¿³         º³            TT
TT      WWWWWWW   º³      ÉÍÍÙ³            TT
TT     WWWWWWWWW  ºÀ»     ºÚÄÄ¼            TT
TT    WWWWWWWWWW  È¿³     º³               TT
TT    WWWWWWWWWWW  ºÀÍÍÍÍÍÙ³      s        TT
TT   WWWWT WWWWWW  ÈÄÄÄÄÄÄÄ¼               TT
TT   WWWW  WWWWWW                     q    TT
TT    WWWWWWWWWWW             s            TT
TT    WWWWWWWWWWW                          TT
TT     WWWWWWWWW                q          TT
TT     WWWW                                TT
TT                                         TT
TT                                         TT
TT                                         TT
TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
"""

map.addPropsMap """
                                             
                                             
                                             
   A                                         
                           A                 
                                             
                                     AAA     
    A                                AAAA    
                       A              AAA    
                                       AA    
    A                                        
                        A           AA       
                       AAA          AAAA     
                      AAAAA         AAAA     
                    AAAAAAA          AA      
                     AAAAAA                  
                     AAAAA                   
                      AAA                    
                       AA                    
                        A            A       
                                             
                                             
                                             
                                    A        
                                   A         
                                             
     A           A                           
     A                  A                    
                                             
                          A          A       
     A                                       
                                             
                                             
                                             
                                             
"""
# collision
map.addPropsMap """
#############################################
#############################################
##                               #O#  #    ##
## ?                            #          ##
##       #                 ?               ##
##                                         ##
##     #     #####                   ???   ##
##  ?    #   ##O##                   ????  ##
##                     ?              ???  ##
##                                     ??  ##
##  ?                                      ##
##                      ?           ??     ##
##                     ???          ????   ##
##                    ?????         ????   ##
##                  ???????          ??    ##
##                   ??????                ##
##                   ?????                 ##
##                    ???                  ##
##                     ??                  ##
## #                    ?            ?     ##
##                                         ##
##                                         ##
##                                         ##
##                                  ?      ##
##       #                         ?       ##
##                                    #    ##
##   ?           ?                         ##
##   ?                  ?                  ##
##                              #          ##
##                        ?          ?     ##
##   ?                                     ##
##                                         ##
##                                         ##
#############################################
#############################################
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
