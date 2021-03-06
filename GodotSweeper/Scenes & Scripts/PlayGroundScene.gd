extends Control

var rngen = RandomNumberGenerator.new()
var alive = true

var map = []
var bombCount = []
var marker = []
var flagCount = 0
#Az első kattintásnál sosem lehet akna, ezért figyeljük hogy az első kattintás-e, 
#és ha igen, akkor a kattintás helyéről ha van, elvesszük az aknát, és körülötte is!
var firstClick = 0
var matrixSize = settings.map_size

var Scale = 1

var time = 0

#Győzelmi kondíció
#A markerben bennevan hogy hány darab mezőt fedtünk fel, ha összegezzük a bennelévő eggyeseket
#A map-ben bennevan, hogy hány darab bombánk van
#Hogy ha a markerben felfedtünk annyi blokkot, amihez hozzáadva a bombák számát, megkapjuk az összes elemet, akkor minden blokk felvan fedve, 
#ami nem bomba

func sumMatrix(matrix):
	var result = 0
	for i in range(len(matrix)):
		for j in range(len(matrix)):
			result += matrix[i][j]
	return result
var once = 0
func didWeWin():
	var marked = 0
	var bombs = 0
	marked = sumMatrix(marker)
	bombs = sumMatrix(map)
	if(marked + bombs == matrixSize * matrixSize):
		$BackgroundMusic.stop()
		$Timer.stop()
		$winDialog_T.popup()
		if(once < 1):
			$Win.play()
		once += 1


func generateMap(size):
	#Generáljunk le egy pályát
	#Töltsük fel nullákkal
	for i in range(size):
		map.append([])
		for j in range(size):
			map[i].append(0)
	rngen.randomize()
	#véletlenszerűen hozzuk létre az aknákat
	for i in range(size):
		for j in range(size):
			var rnd = rngen.randf_range(0, 100)
			var treshold = 0
			if(settings.difficulty == 0):
				treshold = 90
			elif(settings.difficulty == 1):
				treshold = 85
			else:
				treshold = 80
			
			if(rnd > treshold):
				map[i][j] = 1


func setTileMap(size):
	Scale =  (1700 / matrixSize) / float(32)
	Scale = Scale
	
	$PlayableTiles.scale.x = Scale
	$PlayableTiles.scale.y = Scale
	
	$ground.scale.x = Scale
	$ground.scale.y = Scale
	
	$grass.scale.x = Scale
	$grass.scale.y = Scale
	
	$MarkerGrid.scale.x = Scale
	$MarkerGrid.scale.y = Scale
	
	$rope.scale.x = Scale
	$rope.scale.y = Scale
	
	for i in range(size):
		for j in range(size):
			$PlayableTiles.set_cell(i,j,9)


func validBorders(point):
	#Nézzük meg egy elemnek mik a valóságos őt körülvevő blokkok egy mátrixban
	#Például egy sarok elemnek csak 3 valódi körülötte lévő blokkja van.
	var result = []
	var Borders = []
	#Manuálisan hozzáadjuk az összes lehetséges "keret" blokkot
	
	#Felül
	Borders.append([point[0]-1,point[1]-1])
	Borders.append([point[0],point[1]-1])
	Borders.append([point[0]+1,point[1]-1])
	
	#Középen
	Borders.append([point[0]-1,point[1]])
	Borders.append([point[0]+1,point[1]])

	#Alul
	Borders.append([point[0]-1,point[1]+1])
	Borders.append([point[0],point[1]+1])
	Borders.append([point[0]+1,point[1]+1])
	
	#Kiválasztjuk azokat a pontokat, amik se nem negatívak, se nem nagyobbak mint a játéktér 
	for i in range(Borders.size()):
		if((Borders[i][0] < 0 or Borders[i][1] < 0) or (Borders[i][0] > map.size()-1 or Borders[i][1] > map.size()-1)):
			pass
		else:
			result.append(Borders[i])
	return result

func sumData(list):
	var sum = 0
	for i in range(len(list)):
		sum += list[i]
	return sum

func generateBombCount():
	bombCount = []
	for i in range(map.size()):
		bombCount.append([])
		for j in range(map.size()):
			bombCount[i].append(0)

	for i in range(map.size()):
		var sumList = []
		for j in range(map.size()):
			sumList = validBorders([i ,j])
			#Ezek azok a koordináták, ahol az otlévő adatokat összekell adni
			var summableList = []
			for s in range(len(sumList)):
				summableList.append(map[sumList[s][0]][sumList[s][1]])
			bombCount[i][j] = sumData(summableList)

func generateMarker():
	for i in range(map.size()):
		marker.append([])
		for j in range(map.size()):
			marker[i].append(0)



func Reveal():
	for i in range(map.size()):
		for j in range(map.size()):
			if(map[i][j] == 1):
				$PlayableTiles.set_cell(i,j,9)
				pass
			else:
				$PlayableTiles.set_cell(i,j,bombCount[i][j])

func revealSingleTile(point):
	$PlayableTiles.set_cell(point[0], point[1], bombCount[point[0]][point[1]])
	if($grass.get_cell(point[0], point[1]) == 1):
		var rnd = rngen.randf_range(0, 100)
		if(rnd > 50):
			$Dig.play()
		else:
			$DigVariation.play()
	$grass.set_cell(point[0], point[1], -1)
	$grass.update_bitmask_area(Vector2(point[0], point[1]))


func revealGrassArea():
	#a->len(map)
	for i in range(0, len(map)):
		for j in range(0, len(map)):
			$grass.set_cell(i,j,-1)
			$grass.update_bitmask_area(Vector2(i,j))

func guessTile(point):
	if(map[point[0]][point[1]] == 1):
		alive = false
		$Bone.play()
		$BackgroundMusic.stop()
		$Lose.play()
		$Timer.stop()
		$loseDialog_T.popup()
		revealGrassArea()
	else:
		didWeWin()
		if(bombCount[point[0]][point[1]] != 0):
			revealSingleTile(point)
			marker[point[0]][point[1]] = 1
		else:
			revealZeroes(point)
	pass

func revealList(list):
	for i in range(len(list)):
		revealSingleTile(list[i])


func revealZeroes(point):
	var validBorder = validBorders(point)
	validBorder.append(point)
	
	revealList(validBorder)
	var zeroes = []
	
	for i in range(len(validBorder)):
		if(bombCount[validBorder[i][0]][validBorder[i][1]] == 0 and marker[validBorder[i][0]][validBorder[i][1]] != 1):
			zeroes.append(validBorder[i])
	if(bombCount[point[0]][point[1]] == 0):
		for i in range(len(validBorder)):
			marker[validBorder[i][0]][validBorder[i][1]] = 1
		for i in range(len(zeroes)):
			revealZeroes(zeroes[i])
	

func _ready():
	#Töltsük ki a játékteret
	setTileMap(matrixSize)
	#Hozzuk létre a pályát, ami tárolja hogy hol vannak a bombák
	
	generateMap(matrixSize)
	generateBombCount()
	generateMarker()
	Reveal()
	drawFence()
	$side_wall/MineValue.text = str(sumMatrix(map))

func drawFence():
	for i in range(-1, len(map) + 1):
		$rope.set_cell(i,-1,0)
		$rope.set_cell(i, len(map), 0)
		$rope.update_bitmask_area(Vector2(i,-1))
		$rope.update_bitmask_area(Vector2(i,len(map)))
	for i in range(len(map)):
		$rope.set_cell(-1, i, 0)
		$rope.set_cell(len(map), i, 0)
		$rope.update_bitmask_area(Vector2(-1,i))
		$rope.update_bitmask_area(Vector2(len(map), i))

func _input(event):
	$MarkerGrid.clear()
	if event is InputEventMouse:
		var eventPos = event.position
		eventPos.x -= 540
		eventPos.y -= 120
		
		var tile_index = $PlayableTiles.world_to_map(eventPos / Scale)
		tile_index[0] = int(tile_index[0]) #Osztani kell a skálázással
		tile_index[1] = int(tile_index[1])
		if(tile_index[0] >= 0 and tile_index[0] < len(map) and tile_index[1] >= 0 and tile_index[1] < len(map)):
			$MarkerGrid.set_cell(tile_index[0], tile_index[1], 0)
	if event is InputEventMouseButton:
		var eventPos = event.position
		eventPos.x -= 540
		eventPos.y -= 120
		
		var tile_index = $PlayableTiles.world_to_map(eventPos / Scale)
		tile_index[0] = int(tile_index[0]) #Osztani kell a skálázással
		tile_index[1] = int(tile_index[1])
		
		var buttonState = event.get_button_index()
		
		if(buttonState == 1 and alive == true):
			if(tile_index[0] >= 0 and tile_index[0] < len(map) and tile_index[1] >= 0 and tile_index[1] < len(map)):
				if(firstClick == 0):
					map[tile_index[0]][tile_index[1]] = 0
					var validBorder = validBorders(tile_index)
					for border in validBorder:
						map[border[0]][border[1]] = 0
					firstClick += 1
					generateBombCount()
					$side_wall/MineValue.text = str(sumMatrix(map))
				if($rope.get_cell(tile_index[0],tile_index[1]) != 1):
					guessTile([tile_index[0],tile_index[1]])
					firstClick += 1
		if(buttonState == 2):
			if(Input.is_action_pressed("Flaging")):
				if(tile_index[0] >= 0 and tile_index[0] < len(map) and tile_index[1] >= 0 and tile_index[1] < len(map)):
					if($grass.get_cell(tile_index[0], tile_index[1]) != -1):
						$Flag.play()
						if($rope.get_cell(tile_index[0],tile_index[1]) == -1):
							$rope.set_cell(tile_index[0],tile_index[1],1)
							flagCount += 1
						elif($rope.get_cell(tile_index[0],tile_index[1]) == 1):
							flagCount -=1 
							$rope.set_cell(tile_index[0],tile_index[1],-1)
					
		

func _process(delta):
	$side_wall/FlagValue.text = str(flagCount)
	$TimeLabel.text = str(time) + " s"
	$winDialog_T/scale/timeLabel.text = str(time) + " s"


func _on_smallOk_pressed():
	$Pressed.play()
	yield($Pressed, "finished")
	get_tree().change_scene("res://Scenes & Scripts/Main.tscn")


func _on_smallOkLose_pressed():
	$Pressed.play()
	yield($Pressed, "finished")
	get_tree().change_scene("res://Scenes & Scripts/Main.tscn")


func _on_BackButton_T_pressed():
	$Pressed.play()
	yield($Pressed, "finished")
	get_tree().change_scene("res://Scenes & Scripts/Main.tscn")


func _on_Timer_timeout():
	time += 0.1


func _on_smallOkLose_mouse_entered():
	$Hover.play()


func _on_smallOkWin_mouse_entered():
	$Hover.play()


func _on_BackButton_T_mouse_entered():
	$Hover.play()
