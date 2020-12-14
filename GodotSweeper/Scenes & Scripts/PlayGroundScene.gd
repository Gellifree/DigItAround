extends Control

var rngen = RandomNumberGenerator.new()
var alive = true

var map = []
var bombCount = []
var marker = []
#Az első kattintásnál sosem lehet akna, ezért figyeljük hogy az első kattintás-e, 
#és ha igen, akkor a kattintás helyéről ha van, elvesszük az aknát, és körülötte is!
var firstClick = 0

func generateMap(size):
	#Generáljunk le egy pályát
	
	#Töltsük fel nullákkal
	print("Térkép elkészítése\n")
	for i in range(size):
		map.append([])
		for j in range(size):
			map[i].append(0)
	rngen.randomize()
	#véletlenszerűen hozzuk létre az aknákat
	for i in range(size):
		for j in range(size):
			var rnd = rngen.randf_range(0, 100)
			if(rnd > 75):
				map[i][j] = 1
		print(map[i])


func setTileMap(size):
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
	print("Bomba megszámlásáért felelős tömb készítése\n")
	bombCount = []
	for i in range(map.size()):
		bombCount.append([])
		for j in range(map.size()):
			bombCount[i].append(0)

	for i in range(map.size()):
		var sumList = []
		for j in range(map.size()):
			sumList = validBorders([i ,j])
			#print("Szumlist: ",sumList)
			#Ezek azok a koordináták, ahol az otlévő adatokat összekell adni
			var summableList = []
			for s in range(len(sumList)):
				summableList.append(map[sumList[s][0]][sumList[s][1]])
			bombCount[i][j] = sumData(summableList)
		print(bombCount[i])

func generateMarker():
	for i in range(map.size()):
		marker.append([])
		for j in range(map.size()):
			marker[i].append(0)



func Reveal():
	for i in range(map.size()):
		for j in range(map.size()):
			if(map[i][j] == 1):
				$PlayableTiles.set_cell(i,j,11)
				pass
			else:
				$PlayableTiles.set_cell(i,j,bombCount[i][j])
				#if(bombCount[i][j] == 0):
				#	$PlayableTiles.set_cell(j, i, 9)
				pass

func revealSingleTile(point):
	$PlayableTiles.set_cell(point[0], point[1], bombCount[point[0]][point[1]])
	pass

func guessTile(point):
	if(map[point[0]][point[1]] == 1):
		alive = false
		print("You lose - Game over")
		$LoseDialog.popup()
		Reveal()
	else:
		if(bombCount[point[0]][point[1]] != 0):
			revealSingleTile(point)
			marker[point[0]][point[1]] == 1
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
	

# Called when the node enters the scene tree for the first time.
func _ready():
	#Töltsük ki a játékteret
	setTileMap(7)
	#Hozzuk létre a pályát, ami tárolja hogy hol vannak a bombák
	
	generateMap(7)
	generateBombCount()
	generateMarker()
	#Reveal()
	#guessTile([1,1])
	pass



func _input(event):
	if event is InputEventMouseButton:
		var eventPos = event.position
		#eventPos.x -= 30
		#eventPos.y -= 30
		
		var tile_index = $PlayableTiles.world_to_map(eventPos)
		tile_index[0] = int(tile_index[0] / 2)  #Osztani kell a skálázással
		tile_index[1] = int(tile_index[1] / 2)
		
		var buttonState = event.get_button_index()
		#print("buttonstate:",buttonState)
		
		if(buttonState == 1 and alive == true):
			#print("Mouse click at: ", tile_index) 
			if(tile_index[0] >= 0 and tile_index[0] < len(map) and tile_index[1] >= 0 and tile_index[1] < len(map)):
				#print("Firstclick értéke: ",firstClick)
				if(firstClick == 0):
					map[tile_index[0]][tile_index[1]] = 0
					#print("map:",map[tile_index[0]][tile_index[1]])
					var validBorder = validBorders(tile_index)
					#print("list of validborders:",validBorder)
					for border in validBorder:
						map[border[0]][border[1]] = 0
					firstClick += 1
					generateBombCount()
				if($PlayableTiles.get_cell(tile_index[0],tile_index[1]) != 10):
					guessTile([tile_index[0],tile_index[1]])
					firstClick += 1
		if(buttonState == 2):
			if(Input.is_action_pressed("Flaging")):
				if(tile_index[0] >= 0 and tile_index[0] < len(map) and tile_index[1] >= 0 and tile_index[1] < len(map)):
					if($PlayableTiles.get_cell(tile_index[0],tile_index[1]) == 9):
						$PlayableTiles.set_cell(tile_index[0],tile_index[1],10)
					elif($PlayableTiles.get_cell(tile_index[0],tile_index[1]) == 10):
						$PlayableTiles.set_cell(tile_index[0],tile_index[1],9)
					
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes & Scripts/Main.tscn")


func _on_LoseDialog_confirmed():
	get_tree().change_scene("res://Scenes & Scripts/Main.tscn")
