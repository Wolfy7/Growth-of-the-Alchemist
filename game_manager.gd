extends Node

const MAX_LEVEL: int = 16 

var level: int = 1
var xp: int = 0
var tutorial_done: bool = false

# Level	XP für Level-Up	Gesamt-XP (zum Erreichen des Levels)
var level_xp: Dictionary = {
	1:[0,100,"Aspiring Apprentice"],
	2:[100,250,"Herb Mixer"],
	3:[250,450,"Tincture Tinkerer"],
	4:[450,800,"Potion Pupil"],
	5:[800,1500,"Bubbling Brewer"],
	6:[1500,2500,"Elemental Experimenter"],
	7:[2500,3900,"Elixir Explorer"],
	8:[3900,5800,"Vial Virtuoso"],
	9:[5800,8300,"Arcane Adept"],
	10:[8300,11600,"Essence Enchanter"],
	11:[11600,15900,"Master of Mixtures"],
	12:[15900,21400,"Transmutation Scholar"],
	13:[21400,28400,"Mystic Infuser"],
	14:[28400,37200,"Grand Philosopher"],
	15:[37200,48200,"Elder of Elixirs"],
	16:[48200,61700,"Legendary Alchemist"],
	17:[61700,999999,"The One Who Grows All"],
}

var permutation_data: Dictionary = {
	2: [2],
	3: [6,6],
	4: [12,24,24],
	5: [20,60,120,12],
	6: [30,120,360,720,720],
	7: [42,210,840,2520,5040,5040],
	8: [56,336,1680,6720,20160,40320,40320],
	9: [72,504,3024,15120,60480,181440,362880,362880],
	10: [90,720,5040,30240,151200,604800,1814400,3628800,3628800],
	11: [110,990,7920,55440,332640,1663200,6652800,19958400,39916800,39916800],
	12: [132,1320,11880,95040,665280,3991680,19958400,79833600,239500800,479001600,479001600],
	13: [156,1716,17160,154440,1235520,8648640,51891840,259459200,1037836800,3113510400,6227020800,6227020800],
	14: [182,2184,24024,240240,2162160,17297280,121080960,726485760,3632428800,14529715200,43589145600,87178291200,87178291200],
	15: [210,2730,32760,360360,3603600,32432400,259459200,1816214400,10897286400,54486432000,217945728000,653837184000,1307674368000,1307674368000],
	16: [240,3360,43680,524160,5765760,57657600,518918400,4151347200,29059430400,174356582400,871782912000,3487131648000,10461394944000,20922789888000,20922789888000]
}

#func factorial(n: int) -> int:
	#if n == 0 or n == 1:
		#return 1
	#return n * factorial(n - 1)
#
#func berechne_permutationen(zutaten_anzahl: int, anzahl_zutaten_im_rezept: int) -> float:
	## Berechnung der Permutationen (P(N, k) = N! / (N - k)!)
	#print("zutaten_anzahl: ", zutaten_anzahl, " anzahl_zutaten_im_rezept: ", anzahl_zutaten_im_rezept)
	#var permutationen = factorial(zutaten_anzahl) / factorial(zutaten_anzahl - anzahl_zutaten_im_rezept)
	#print(permutationen)
	#
	## Ausgabe der berechneten Werte
	#return permutationen
