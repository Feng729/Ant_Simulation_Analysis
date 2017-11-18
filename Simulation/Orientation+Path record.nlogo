globals     [name nest-color time food-color meanpaths nestPaths totalPaths nestTicks xrecord foodname nestname yrecord currentSim tickMarks heading-histogram current-heading OrientationTicks FoodPheromeonRecord NestPheromeonRecord] ;; setting global variables (description below)
turtles-own [ carrying-food? pheromone actionsInPath] ;; setting ants variables
patches-own [ food-pheromone nest-pheromone nest? food? obstacle?]
breed [ants ant]
extensions [csv bitmap]



to setup
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)

  clear-all
  file-close-all
  set-current-directory "//Users/wangyaofeng/Desktop/Ant_Research/Data_Files" ; set whatever directory you want to save the files here
  ;carefully [
  ;  file-delete (word "Food path record " population ".csv")
  ;  file-delete (word "Nest path record " population ".csv")
  ;  file-delete (word "Heading record " population ".csv")
  ;  file-delete (word "Food pheromone record " population ".csv")
  ;  file-delete (word "Nest pheromone record " population ".csv")] []; delete all files
  reset-ticks
  set currentSim 1
  reset
end

to reset
  set nest-color yellow  set food-color blue ;; set-up globals first
  setup-patches
  setup-ants
  set totalPaths [] ;;totalPaths is a list to register all the number of moves and paths of all the ants
  set tickMarks []
  set nestTicks []
  set heading-histogram []
  set current-heading []
  set nestPaths[]
  set OrientationTicks []
  set xrecord []
  set yrecord []
  set name []
  set foodname []
  set nestname []
  set FoodPheromeonRecord []
  set meanpaths []
  set NestPheromeonRecord []
  set time (word (substring date-and-time 0 2) "." (substring date-and-time 3 5) "."(substring date-and-time 6 8) " " (substring date-and-time 13 15) " " (substring date-and-time 16 27))
end

to go

  if is-number? sim-length and is-number? simNUM [  ;; check if sim-length has the right input
  ifelse (currentSim <= simNUM)[
   file-open (word "Heading record " time ".csv")
   record-condition
   file-print (word "Name, " "Ticks, " "x-cor, " "y-cor," "Carry food?")
   reset-ticks
  while [ticks < sim-length] ;; time limit to sim
  [
    tick
  if use-obstacle? and mouse-down? ;; If obstacle exists and mouse down, move obstacle.
    [setup-obstacle round mouse-xcor round mouse-ycor 3 10]
  update-ants
  update-patches
  ;record-data

]
  ;(foreach name OrientationTicks heading-histogram xrecord yrecord [file-print csv:to-row  (list ?1 ?2 ?3 ?4)])
  file-close
  export-data
  ct cp cd clear-ticks
  reset
  set currentSim currentSim + 1] [stop]]

end


to record-pheromone
  ;ask patches with [food-pheromone > 0][set FoodPheromeonRecord lput (list ticks pxcor pycor food-pheromone) FoodPheromeonRecord]
  ;ask patches with [nest-pheromone > 0][set NestPheromeonRecord lput (list ticks pxcor pycor nest-pheromone) NestPheromeonRecord]
end

to export-data ;;CSV is better extension then xls, even though it will be opened by excel
  ;file-open (word "Food pheromone record " time ".csv") ; csv would not allow ":" symbol
  ;if (currentsim = 1) [record-condition
  ;file-print (word "Food Pheromone")
  ;file-print (word "Tick Marks," "x," "y," "Food Pheromone")]
  ;(foreach FoodPheromeonRecord [file-print csv:to-row (sentence ?)])
  ;file-close

  ;file-open (word "Nest pheromone record " time ".csv")
  ;if (currentsim = 1) [record-condition
  ;file-print (word "Nest Pheromone")
  ;file-print (word "Tick Marks," "x," "y," "Nest Pheromone")]
  ;(foreach NestPheromeonRecord [file-print csv:to-row (sentence ?)])
  ;file-close

  file-open (word "Mean Path Length " time ".csv") ;The new result append to the old file
  if (currentsim = 1) [record-condition
  file-print (word "Tick Marks," "Mean Path Length")]
  (foreach TickMarks meanPaths [file-print csv:to-row (list ?1 ?2)])
  file-close

  file-open (word "Food path record " time ".csv") ;The new result append to the old file
  if (currentsim = 1) [record-condition
  file-print (word "Tick Marks," "Path Length," "Ants name")]
  ;file-print (word "Current Simulation: " currentsim)
  (foreach TickMarks TotalPaths foodname [file-print csv:to-row (list ?1 ?2 ?3)])
  file-close

  file-open (word "Nest path record " time ".csv") ;The new result append to the old file
  if (currentsim = 1) [record-condition
  file-print (word "Tick Marks," "Path Length," "Ants name")]
  ;file-print (word "Current Simulation: " currentsim)
  (foreach nestTicks nestPaths nestname[file-print csv:to-row (list ?1 ?2 ?3)])
  file-close
end

to record-condition ;; to record conditions
  file-print date-and-time
  file-print csv:to-row (list "Population: " population)
  file-print csv:to-row (list "Use-obstacle: " use-obstacle?)
  file-print csv:to-row (list "Start at nest?: " start-nest-only?)
  file-print csv:to-row (list "Maximum pheromone: " max-pheromone)
  file-print csv:to-row (list "Diffusion rate: " diffusion-rate)
  file-print csv:to-row (list "Evaporation rate: " evaporation-rate)
  file-print csv:to-row (list "Wiggle angle: " wiggle-angle)
  file-print csv:to-row (list "Number of ticks: " sim-length)
  file-print csv:to-row (list "Spread all at the same time?: "spread-all-at-the-same-time)
end

;; setup procedures
to setup-patches  ;; Initialize patch variables: Create nest and food areas
  ask patches [set nest? false  set food? false] ; food/nest pheromone default to 0
  ask patch-rect (max-pxcor - 1) 0 3 3 [set nest? true]
  ask patch-rect (min-pxcor + 1) 0 3 3 [set food? true]
  ifelse use-obstacle?
  [setup-obstacle 0 0 3 10]
  [setup-obstacle 0 0 0 0]
  paint-patch-features
end

to setup-obstacle [x y w h]
  ask patches [set obstacle? false]
  ask patch-rect x y w h [set obstacle? true]
end

to paint-patch-features ;; Paint features via nest? food? obstacle?
  ask patches with [nest?] [set pcolor nest-color
    ;set nest-pheromone max-pheromone
    ]
  ask patches with [food?] [set pcolor food-color
    ;set food-pheromone max-pheromone
    ]
  if use-obstacle? [ask patches with [obstacle?] [set pcolor gray]]
end

to setup-ants ;; Initialize ants: Position ants on nest with "bug" shape
  create-ants population  [
    set shape "bug" set size 3
    ifelse (start-nest-only? or random 2 = 0)
       [setxy (mean [pxcor] of patches with [nest?]) 0 ;; init ants in middle of nest
         reset-ant false]
       [setxy (mean [pxcor] of patches with [food?]) 0 ;; init ants in middle of nest
         reset-ant true]]
end

to reset-ant [with-food?] ;; Reset ant variables according to whether they have food.
  set carrying-food? with-food?
  set color ifelse-value with-food? [nest-color] [food-color]
  set pheromone max-pheromone
end

;; update procedures
to update-ants
  ask ants [
    if(spread-all-at-the-same-time = false) [if who >= ticks [ stop ]] ;; gradually leave nest
    wiggle-uphill
    drop-pheromone
    ;ifelse (heading > 337.5) [set current-heading lput 1 current-heading][set current-heading lput (ceiling ((heading + 22.5) / 45)) current-heading]
    ;ifelse (heading > 337.5) [set heading-histogram lput 1 heading-histogram][set heading-histogram lput (ceiling ((heading + 22.5) / 45)) heading-histogram]
    ;set OrientationTicks lput ticks OrientationTicks
    ;set xrecord lput xcor xrecord
    ;set yrecord lput ycor yrecord
    ;set name lput who name
    file-print (word who "," ticks "," xcor "," ycor "," carrying-food?)
    ]
end

to wiggle-uphill ;; ant procedure: Follow appropriate pheromone with a bit of wiggle.
  let p max-one-of neighbors with [not obstacle?] in-cone 2 180 [target-pheromone]
  if p = nobody [set p max-one-of neighbors with [not obstacle?][target-pheromone]]
  if p != nobody and [target-pheromone] of p > (.001 / max-pheromone) [face p] ;;basically means to make ants facing the direction with the most amount of pheromone
  ifelse count neighbors4 != 4 or obstacle? [fd -1 rt 91 + random 178
    ]
  [
    if (ants-avoidance = true)
    [
      if any? other ants-on patch-ahead 1
      [fd -1 face p rt (random wiggle-angle) - (wiggle-angle / 2) fd 1 ]]
  rt (wiggle-angle / 2) - random wiggle-angle
  fd 1
  ]
  set actionsInPath actionsInPath + 1
end

to-report target-pheromone ;; patch procedure called by ant: Report appropriate pheromone
  report ifelse-value [carrying-food?] of myself [nest-pheromone] [food-pheromone]
end

to drop-pheromone ;; ant procedure: Drop appropriate pheromone
  if (not carrying-food? and food?) or (carrying-food? and nest?) ;;when arrived at food or nest
    [ if (not carrying-food? and food?)
      [set totalPaths lput actionsInPath totalPaths ;; input the length of the path of each ants that has reached the food source
      set TickMarks lput ticks TickMarks
      set foodname lput who foodname
      set meanPaths lput (mean totalPaths) meanPaths
      ]
      if (carrying-food? and nest?)
      [set nestPaths lput actionsInPath nestPaths
         set nestname lput who nestname
         set nestTicks lput ticks nestTicks]
      set actionsInPath 0   ;; reset the path recorder
      reset-ant not carrying-food?] ;; reset pheromone
  ifelse carrying-food?
    [set food-pheromone food-pheromone + 0.1 * pheromone] ;; restore respective type of pheromone
    [set nest-pheromone nest-pheromone + 0.1 * pheromone]
  set pheromone 0.9 * pheromone
end

to update-patches ;; Diffuse and evaporate pheromones, update patch colors
  diffuse nest-pheromone diffusion-rate
  diffuse food-pheromone diffusion-rate
  ask patches [set food-pheromone food-pheromone * (1 - evaporation-rate)]
  ask patches [set nest-pheromone nest-pheromone * (1 - evaporation-rate)]
  ask patches with [obstacle? or count neighbors4 != 4] [set food-pheromone 0 set nest-pheromone 0]
  ask patches [
    ifelse food-pheromone > nest-pheromone
      [set pcolor scale-color food-color  food-pheromone 0.1 5]
      [set pcolor scale-color nest-color  nest-pheromone 0.1 5]
  ]
  paint-patch-features
end

;; utilities
to-report patch-rect [x y dw dh] ;; report patch set centered at x y and dw dh around x y
  report patches with [pxcor >= x - dw and pxcor <= x + dw and pycor >= y - dh and pycor <= y + dh]
end
@#$#@#$#@
GRAPHICS-WINDOW
237
10
733
527
40
40
6.0
1
4
1
1
1
0
0
0
1
-40
40
-40
40
1
1
1
ticks
30.0

BUTTON
7
10
73
43
NIL
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
7
44
73
77
NIL
go\n
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

SLIDER
3
78
194
111
population
population
25
1000
225
25
1
NIL
HORIZONTAL

SLIDER
10
262
182
295
diffusion-rate
diffusion-rate
0
1
0.25
.01
1
NIL
HORIZONTAL

SLIDER
10
294
182
327
evaporation-rate
evaporation-rate
0
.1
0.025
.005
1
NIL
HORIZONTAL

SLIDER
10
231
182
264
max-pheromone
max-pheromone
1
200
35
1
1
NIL
HORIZONTAL

SLIDER
10
328
182
361
wiggle-angle
wiggle-angle
0
180
72
36
1
NIL
HORIZONTAL

SWITCH
5
152
138
185
start-nest-only?
start-nest-only?
0
1
-1000

INPUTBOX
12
420
77
480
Sim-length
500
1
0
Number

INPUTBOX
84
419
139
479
simNUM
1
1
0
Number

SWITCH
4
113
127
146
use-obstacle?
use-obstacle?
1
1
-1000

MONITOR
91
10
199
55
Current Simulation
currentsim
17
1
11

SWITCH
8
189
147
222
ants-avoidance
ants-avoidance
1
1
-1000

SWITCH
13
370
212
403
spread-all-at-the-same-time
spread-all-at-the-same-time
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

This is a simple ant model, with ants seeking food and returning to their nest guided by pheromones.

## HOW IT WORKS

Ants leave their nest with max pheromone seeking the food supply, dropping pheromone each step.  The pheromone evaporates and diffuses each step.  There are two types of pheromone, depending if the ant is leaving the nest or leaving the food supply.

## HOW TO USE IT

Modify the various settings to see the effect on the effeciency of the ant's searching.  Click on the obstacle to move it around to foil the ants!
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

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="density" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>count turtles with [carrying-food?] &gt; population / 2</exitCondition>
    <metric>ticks</metric>
    <enumeratedValueSet variable="population">
      <value value="250"/>
    </enumeratedValueSet>
    <steppedValueSet variable="evaporation-rate" first="0" step="0.01" last="0.05"/>
    <steppedValueSet variable="diffusion-rate" first="0.1" step="0.1" last="0.9"/>
    <enumeratedValueSet variable="max-pheromone">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wiggle-angle">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="use-obstacle?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Continuous run" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <steppedValueSet variable="population" first="50" step="50" last="500"/>
  </experiment>
</experiments>
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
