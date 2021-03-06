import nico
import times
import strformat

type BenchmarkMode = enum
  bmPoints
  bmLines
  bmHVLines
  bmRect
  bmRectfill
  bmCirc
  bmCircfill
  bmSprite
  bmSpriteScaled
  bmSpriteRot

var mode = bmPoints
var autoAdjust = false
var lastMs: float32

var toDraw: array[BenchmarkMode, int]
toDraw[bmPoints] = 50000
toDraw[bmLines] = 1000
toDraw[bmHVLines] = 2000
toDraw[bmRect] = 2000
toDraw[bmRectfill] = 2000
toDraw[bmCirc] = 2000
toDraw[bmCircfill] = 2000
toDraw[bmSprite] = 1000
toDraw[bmSpriteScaled] = 1000
toDraw[bmSpriteRot] = 1000

var avgMs = 0f

proc gameInit() =
  loadSpriteSheet(0, "spritesheet.png")

proc gameUpdate(dt: float32) =
  if btn(pcLeft) and toDraw[mode] > 0:
    toDraw[mode] -= 10
  if btn(pcRight):
    toDraw[mode] += 10
  if btnpr(pcDown) and toDraw[mode] > 1000:
    toDraw[mode] -= 1000
  if btnpr(pcUp):
    toDraw[mode] += 1000
  if btnp(pcA):
    mode.incWrap()
  if btnp(pcB):
    autoAdjust = not autoAdjust

  if autoAdjust:
    if lastMs < 15.0'f:
      toDraw[mode] += 100
    elif lastMs > 16.0'f:
      if toDraw[mode] > 100:
        toDraw[mode] -= 100


proc gameDraw() =
  cls()
  let tstart = now()
  var count = 0

  let toDraw = toDraw[mode]

  case mode:
  of bmPoints:
    for i in 0..<toDraw:
      setColor(8+rnd(8))
      pset(rnd(screenWidth),rnd(screenHeight))
      count += 1
  of bmLines:
    for i in 0..<toDraw:
      setColor(8+rnd(8))
      line(rnd(screenWidth),rnd(screenHeight),rnd(screenWidth),rnd(screenHeight))
      count += 1
  of bmHVLines:
    for i in 0..<toDraw:
      setColor(8+rnd(8))
      if rnd(2) == 0:
        hline(rnd(screenWidth),rnd(screenHeight),rnd(screenWidth))
      else:
        vline(rnd(screenWidth),rnd(screenHeight),rnd(screenHeight))
      count += 1
  of bmRect:
    for i in 0..<toDraw:
      setColor(8+rnd(8))
      rect(rnd(screenWidth),rnd(screenHeight),rnd(screenWidth),rnd(screenHeight))
      count += 1
  of bmRectfill:
    for i in 0..<toDraw:
      setColor(8+rnd(8))
      rectfill(rnd(screenWidth),rnd(screenHeight),rnd(screenWidth),rnd(screenHeight))
      count += 1
  of bmCirc:
    for i in 0..<toDraw:
      setColor(8+rnd(8))
      circ(rnd(screenWidth),rnd(screenHeight),rnd(32))
      count += 1
  of bmCircfill:
    for i in 0..<toDraw:
      setColor(8+rnd(8))
      circfill(rnd(screenWidth),rnd(screenHeight),rnd(32))
      count += 1
  of bmSprite:
    for i in 0..<toDraw:
      spr(16+rnd(8), rnd(screenWidth),rnd(screenHeight))
      count += 1
  of bmSpriteScaled:
    for i in 0..<toDraw:
      sprs(16+rnd(8), rnd(screenWidth),rnd(screenHeight), 1, 1, 2, 2)
      count += 1
  of bmSpriteRot:
    for i in 0..<toDraw:
      sprRot(16+rnd(8), rnd(screenWidth),rnd(screenHeight), rnd(TAU))
      count += 1

  let tend = now()
  let dt = tend - tstart
  let ms = dt.inMilliseconds

  setColor(0)
  let str = &"{mode}  x {toDraw} : {avgMs:0.2f}  ms"
  print(str, 4-1, 4)
  print(str, 4+1, 4)
  print(str, 4, 4-1)
  print(str, 4, 4+1)
  setColor(7)
  print(str, 4, 4)

  lastMs = ms.float32

  avgMs = lerp(avgMs, lastMs, 0.25f)

nico.init("nico","benchmark")
nico.createWindow("nico benchmark", 128, 128, 4, false)
nico.run(gameInit, gameUpdate, gameDraw)
