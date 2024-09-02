;AGENTES (turtles específicas)
breed [meninos menino] ;slider mín10 inc1 máx50
breed [supervisores supervisor] ;slider mín0 inc1 máx10
breed [predios predio] ;número fixo de tipos

;.........................................................................................................
;.........................................................................................................
;.........................................................................................................
;VARIÁVEIS

;VARIÁVEL GLOBAL
globals []

;VARIÁVEL MENINOS (para onde vai)
meninos-own [status destino idade]

;VARIÁVEL PRÉDIOS (dormitório/oficina)
predios-own [tipo]

;VARIÁVEL PATCHES (artefatos por patch)
patches-own [artefatos]

;.........................................................................................................
;.........................................................................................................
;.........................................................................................................
;FUNÇÕES DOS BOTÕES

;RESETAR O MODELO
to setup
  clear-all
  reset-ticks
  spawnWorld        ;função -> gerar cor do mundo
  spawnMeninos      ;função -> gerar meninos
  spawnSupervisores ;função -> gerar supervisores
  spawnPredios      ;função -> gerar predios
end

;INICIAR O MODELO
to go
  if ticks = 2500 [stop] ;para a simulação, tem de ficar no topo. Funciona.
  moveMeninos            ;função -> meninos andam segundo status
  dropArtefatos          ;função -> artefatos caem quando X meninos se encontram
  superviseMeninos       ;função -> supervisores andam aleatório, fujões->capela
  tick                   ;passar o tempo
end

;.........................................................................................................
;.........................................................................................................
;.........................................................................................................
;FUNÇÕES DO SETUP

to spawnWorld ;COR DO MUNDO
  ask patches [
    set pcolor 59 ;green mais claro
  ]
end

to spawnMeninos ;MENINOS (slider, forma, variáveis status e idade)
  create-meninos (quantosMeninos) / 2 [ ;metade pequena, nasce->dorm
    set color violet
    set size 1.5
    set shape "person"
    setxy random-xcor random-ycor
    set status 0
    set idade 0
  ]
  create-meninos (quantosMeninos) / 2 [ ;metade grande, nasce->dorm
    set color magenta
    set size 2
    set shape "person"
    setxy random-xcor random-ycor
    set status 0
    set idade 1
  ]
end

to spawnSupervisores ;SUPERVISORES (slider, formato)
  create-supervisores quantosSupervisores [
    set color black
    set size 3
    set shape "person"
    setxy random-xcor random-ycor
  ]
end

to spawnPredios ;PRÉDIOS (formato, tipos)
  create-predios 1 [
    set color blue
    set size 4
    set shape "house"
    setxy random-xcor random-ycor
    set tipo "dormitorio"
  ]
  create-predios 3 [
    set color pink
    set size 4
    set shape "factory"
    setxy random-xcor random-ycor
    set tipo "oficinas"
  ]
  create-predios 1 [
    set color yellow
    set size 4
    set shape "x"
    setxy random-xcor random-ycor
    set tipo "capela"
    set heading 45
  ]
  create-predios 1 [
    set color turquoise
    set size 4
    set shape "book"
    setxy random-xcor random-ycor
    set tipo "escola"
  ]
end

;.........................................................................................................
;.........................................................................................................
;.........................................................................................................
;FUNÇÕES DO GO

to moveMeninos ;MOVIMENTO MENINOS (dormitorio, oficinas, capela, escola, andar, vagar)
  ask meninos [
    verifyRota
    if status = 0 [ ;->dorm
      face one-of predios with [tipo = "dormitorio"]
      fd 1
    ]
    if status = 1 [ ;->oficina
      face destino fd 1
    ]
    if status = 4 [ ;->escola
      face destino fd 1
    ]
    if status = 1 [ ;->oficina
      face destino fd 1
    ]
    if status = 3 [ ;->capela
      face destino fd 1
    ]
    if status = 2 [ ;->vagar
      ifelse patch-ahead 1 != nobody [
        lt 45 - random 90
        fd 1
      ] [
        rt 45
        fd 1
      ]
    ]
  ]
end

to verifyRota ;ROTAS MENINOS (de onde para onde, vagar aleatório)
    if any? predios in-radius 1 with [tipo = "dormitorio"] and status = 0 and idade = 1 [
      set status 1 set destino one-of predios with [tipo = "oficinas"]
    ]
    if any? predios in-radius 1 with [tipo = "oficinas"] and status = 1 and idade = 1 [
      set status 4 set destino one-of predios with [tipo = "escola"]
    ]
    if any? predios in-radius 1 with [tipo = "escola"] and status = 4 and idade = 1 [
      set status 0 set destino one-of predios with [tipo = "dormitorio"]
    ]
    if any? predios in-radius 1 with [tipo = "dormitorio"] and status = 0 and idade = 0 [
      set status 4 set destino one-of predios with [tipo = "escola"]
    ]
    if any? predios in-radius 1 with [tipo = "escola"] and status = 4 and idade = 0 [
      set status 1 set destino one-of predios with [tipo = "oficinas"]
    ]
    if any? predios in-radius 1 with [tipo = "oficinas"] and status = 1 and idade = 0 [
      set status 0 set destino one-of predios with [tipo = "dormitorio"]
    ]
    if any? predios in-radius 2 with [tipo = "capela"] and status = 3 [
      set status 0 set destino one-of predios with [tipo = "dormitorio"]
    ]
    if not any? supervisores in-radius 10 [
      if random (autoridade + 5) > autoridade and idade = 1 [
        set status 2
      ]
      if random (autoridade + 10) > autoridade and idade = 0 [
        set status 2
      ]
    ]
end

to dropArtefatos ;ARTEFATOS (caem com X meninos no mesmo patch)
  ask meninos with [status = 2]  [ ;só dropa com meninos vagantes
    let p count meninos-here
    if p >= aglomeracao [
      ask patch-here [
        set artefatos artefatos + 1
        set pcolor 59 - artefatos
        ]
      ]
    ]
end

to superviseMeninos ;MOVIMENTO SUPERVISORES (aleatório, fujões->capela)
  ask supervisores [
    let epa max-one-of patches in-radius (floor (autoridade / 10)) [count meninos-here with [status = 2] ]
    ifelse epa = nobody [
      lt 20 - random 40
      fd 1
    ] [
      face epa
      fd 1
      ask meninos in-radius 5 with [status = 2] [
        set status 3 ;->capela
        set destino one-of predios with [tipo = "capela"]
      ]
    ]
  ]
end

;...........................................######.##..##.#####............................................
;...........................................##.....###.##.##..##...........................................
;...........................................####...##.###.##..##...........................................
;...........................................##.....##..##.##..##...........................................
;...........................................######.##..##.#####............................................
;NMD
@#$#@#$#@
GRAPHICS-WINDOW
343
10
884
552
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-20
20
-20
20
1
1
1
ticks
30.0

BUTTON
199
137
262
170
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
271
137
334
170
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
10
52
333
85
quantosMeninos
quantosMeninos
10
50
30.0
1
1
NIL
HORIZONTAL

SLIDER
176
95
334
128
autoridade
autoridade
0
100
45.0
1
1
%
HORIZONTAL

SLIDER
10
95
168
128
quantosSupervisores
quantosSupervisores
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
10
137
190
170
aglomeracao
aglomeracao
2
6
3.0
1
1
NIL
HORIZONTAL

PLOT
10
179
210
329
fujoes
NIL
NIL
0.0
10.0
0.0
40.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count meninos with [status = 2]"

PLOT
10
337
210
487
artefatos
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot sum [artefatos] of patches"

@#$#@#$#@
# WORKING BOYS SIMULATION / SIMULAÇÃO MENINOS TRABALHADORES

## WHAT IS IT? / O QUE É?

**EN**
This model was made to try and understand the spatial distribution of artifacts at a place that children both lived and worked under the care of catholic orders, something usual in Brazil during the 20th century.

**BR**
Este modelo foi feito buscando entender a distribuição espacial de artefatos em um ambiente que mistura moradia e trabalho de crianças sob os cuidados de ordens religiosas, uma prática comum no Brasil do século XX.

## HOW IT WORKS / COMO FUNCIONA

**EN**
The boys move between their dorm, workshops, and school. However, because they are children, there is chance that they will wander the grounds. If this happens and they are discovered by a supervisor, the boys are sent to the chapel in penance and from there they will go back to the dorm.
The supervisors move randomly while watching the boys.

**BR**
Os meninos se movimentam entre seu dormitório, as oficinas onde trabalham e escola. Entretanto, por serem crianças, há chances de vagarem pelo terreno. Se isso acontecer e forem encontrados por qualquer supervisor, são mandadas para a capela em penitência e, de lá voltam para o dormitório.
Os supervisorem se movimentam aleatoriamente vigiando os meninos.

## HOW TO USE IT / COMO USAR

**EN**
**setup** creates the world, definig its light green color, spawning randomly one dorm, one chapel, three workshops, one school,  and a number of boys and supervisors defined by their sliders.
**quantosMeninos** is the slider that defines the number of boys, the human shaped purple or magenta turtles. Their minimum number is 10 and their maximum is 50.
**quantosSupervisores** is the slider that defines the number of supervisors, the human shaped black turtles. Their minimum number is 0 and their maximum is 10.
**autoridade** is the slider that defines how much the boys respect (or fear) their supervisors. The higher the authority, the smaller the chance of the boys wander. The minimum is 0% and the maximum is 100%.
**aglomeracao** is the slider that defines how many boys are needed on the same patch to make an artifact drop. The minimum is two and the maximum is 6.
**go** starts the model, make boys and supervisors walk, artifacts drop ans patches change color every 10th artifact droped on the same patch.
**fujoes** monitors how many boys wander.
**artefatos** monitors how many artifacts dropped.

**BR**
**setup** gera o mundo, dando-lhe o fundo na cor verde clara, criando um dormitório, uma capela, três oficinas e uma escola, além das quantidades de meninos e supervisores determinadas pelos sliders.
**quantosMeninos** é o slider que define a quantidade de meninos, as turtles de forma humana nas cores roxa e magenta. O mínimo é 10 e o máximo é 50.
**quantosSupervisores** é o slider que define a quantidade de supervisores, as turtles de forma humana na cor preta. O mínimo é 0 e o máximo é 10.
**autoridade** é o slider que define o quanto os meninos respeitam (ou temem) seus supervisores. Quanto maior a autoriadade, menor a chance dos meninos vagarem. O mínimo é 0% e o máximo é 100%.
**aglomeracao** é o slider que define quantos meninos são necessários no mesmo patch para que um artefato caia. O mínimo é 2 e o máximo é 6.
**go** inicia o modelo, fazendo os meninos e supervisores andarem, assim como os artefatos caírem e os patches mudarem de cor a cada acumulo de 10 artefatos.
**fujoes** monitora a quantidade de meninos que vagam.
**artefatos** monitora a quantidade de artefatos que caíram.

## THINGS TO NOTICE / COISAS PARA PERCEBER

**EN**
Observe how the random spatial configuration influences the destribution of artifacts.


**BR**
Note como a configuração espacial aleatória influencia na distribuição de artefatos.

## THINGS TO TRY / COISAS PARA TENTAR

**EN**
Try diffent ratios of *autoridade* and *quantosSupervisores* to see which one is more efficient in controling the boys.
Play around with the *aglomeracao* and *quantosMeninos* sliders to observe if more or less artifacts are dropped.
Observe the relationship between *autoridade* and the places in which the artfacts drop.

**BR**
Experimente ver se *autoridade* ou a maior *quantosSupervisores* é mais eficiente para controlar os meninos.
Brinque com os sliders de *aglomeracao* e de *quantosMeninos* para observar a quantidade de artefatos que caem.
Observe a relação entre autoridade e locais de concentração de artefatos.

## EXTENDING THE MODEL / EXPANDINDO O MODELO

**EN**
This model can be adapted to other exploitative and coercive scenarios.

**BR**
Pode ser modificado para pensar outras situação de exploração e coerção.

## CREDITS AND REFERENCES / CRÉDITOS E REFERÊNCIAS

(c) Nicole Dias

**EN**
SOUZA, MA 2001. *As estratégias da pedagogia do assistencialismo em Belo Horizonte, 1930-1990: educação e caridade* [Doctoral thesis, Federal University of Minas Gerais]. Respositório Institucional da UFMG. https://repositorio.ufmg.br/bitstream/1843/FAEC-86PMYU/1/binder1.pdf

**BR**
SOUZA, Marco Antônio de. **As estratégias da pedagogia do assistencialismo em Belo Horizonte, 1930-1990**: educação e caridade. 2001. 427f. Tese (Doutorado) - Faculdade de Educação, Universidade de Minas Gerais, Belo Horizonte, 2001. Disponível em: https://repositorio.ufmg.br/bitstream/1843/FAEC-86PMYU/1/binder1.pdf. Acessado em: 1 dez 2023.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

book
false
0
Polygon -7500403 true true 30 195 150 255 270 135 150 75
Polygon -7500403 true true 30 135 150 195 270 75 150 15
Polygon -7500403 true true 30 135 30 195 90 150
Polygon -1 true false 39 139 39 184 151 239 156 199
Polygon -1 true false 151 239 254 135 254 90 151 197
Line -7500403 true 150 196 150 247
Line -7500403 true 43 159 138 207
Line -7500403 true 43 174 138 222
Line -7500403 true 153 206 248 113
Line -7500403 true 153 221 248 128
Polygon -1 true false 159 52 144 67 204 97 219 82

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

factory
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Circle -1 true false 129 19 42
Rectangle -7500403 true true 14 228 78 270

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
true
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
