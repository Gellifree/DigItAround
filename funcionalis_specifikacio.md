## Funkcionális specifikáció

### Áttekintés

Egy olyan játékot szeretnék készíteni, ami a sokak által ismert aknakereső játék egy megváltoztatott kinézetű verziója lesz. A játék kifejezettem egyszerű, de a kinézete nem kifejezetten vonzó, a játék működése sokak számára ismeretlen, annak ellenére hogy már számtalanszor próbálták. Természetesen a magas ismeretség annak köszönhető, hogy a Microsoft operációs rendszereivel érkezett a játék.

### Jelenlegi helyzet

A játék kifejezetten egyszerűnek tűnik, azonban a leprogramozását kihívásnak tekintem. Nincs benne számítógépes ellenfél, vagy komoly animációk, vagy zene. Ennek ellenére, úgy gondolom, hogy a hibamentes működést nem lesz egyszerű elérni. A különböző nehézségi szintek beállítását látom problémásnak, és a változó pályaméret adta problémákat. A Godot játékmotor lehetőséget ad arra, hogy használjunk *tilemap* objektumokat, amiket ideálisnak tartok a rács elkészítésére. A grafikai részét, bármilyen művészi tehetség nélkül, *pixelart*okkal kívánom megcsinálni, mivel ezek könnyen elkészíthetőek rövid idő befektetésével.

### Vágyálom rendszer

A cél, hogy minden olyan funkció, hibamentesen működjön, ami az eredeti játékban is szerepel. Ha lesz elegendő idő, akkor szeretnék plusz mechanikákat is beépíteni a játékba, ami szórakoztatóbbá tenné. Talán egy tapasztalati rendszer, szintlépés, és speciális eszközök, váltakozó témájú pályák színesítenék a játékélményt, azonban a korlátolt idő miatt, nem biztos, hogy sor kerül ezekre a módosításokra.

### Követelménylista

| Modul | ID | Név | Kifejtés |
| --- | --- | --- | --- |
| Funkció | K1 | Felfedés | A felhasználó képes legyen, egy még nem felfedett mezőt, kattintással felfedni |
| Funkció | K2 | Jelölés | A felhasználó képes legyen, egy még nem felfedett mezőt, jobb egérgombbal való kattintással veszélyesnek megjelölni |
| Funkció | K3 | Biztonság | Egy veszélyesnek jelölt cellára, véletlenül se lehessen kattintani |
| Funkció | K4 | Mégsem | Egy veszélyesnek jelölt cellára, újbóli jobb egérgomb kattintással távolítsuk el a veszély jelzést |
| Funkció | K5 | Halál | Amennyiben egy olyan cellát akartunk felfedni, ami tartalmaz egy aknát, úgy a játék érjen véget |
| Megjelenés | K6 | Menü | A játékteret válassza el a felhasználótól egy menüvel, ami minimum a kezdést, és a kilépést tartalmazza |
| Megjelenés | K7 | Felület | A játéktér rendelkezzen a felmerülő opciók, értékek megjelenítési lehetőségével (gombok, feliratok stb.) |
