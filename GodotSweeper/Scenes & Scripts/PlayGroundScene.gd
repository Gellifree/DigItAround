extends Control

var rngen = RandomNumberGenerator.new()

func generateMap(map, size):
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
			if(rnd > 70):
				map[i][j] = 1
		print(map[i])


func setTileMap(size):
	for i in range(size):
		for j in range(size):
			$PlayableTiles.set_cell(i,j,11)


func validBorders(map, point):
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

func generateBombCount(map, bombCount):
	print("Bomba megszámlásáért felelős tömb készítése\n")
	for i in range(map.size()):
		bombCount.append([])
		for j in range(map.size()):
			bombCount[i].append(0)

	for i in range(map.size()):
		var sumList = []
		for j in range(map.size()):
			sumList = validBorders(map, [i ,j])
			#print("Szumlist: ",sumList)
			#Ezek azok a koordináták, ahol az otlévő adatokat összekell adni
			var summableList = []
			for s in range(len(sumList)):
				summableList.append(map[sumList[s][0]][sumList[s][1]])
			bombCount[i][j] = sumData(summableList)
		print(bombCount[i])

# Called when the node enters the scene tree for the first time.
func _ready():
	#Töltsük ki a játékteret
	setTileMap(3)
	#Hozzuk létre a pályát, ami tárolja hogy hol vannak a bombák
	var map = []
	var bombCount = []
	generateMap(map, 3)
	generateBombCount(map, bombCount)

	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes & Scripts/Main.tscn")
