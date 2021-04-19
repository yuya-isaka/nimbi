import parsecsv
import strformat
import strutils
import sequtils
import math

proc nearPoint(d: var seq[seq[float]], y: int, x: int) =
  if d[y][x] != 0.0:
    return

  # *Pos
  var nearPos = newSeq[seq[int]]()
  var dy = [-1, -1, -1, 0, 0, 1, 1, 1]
  var dx = [-1, 0, 1, -1, 1, -1, 0, 1]
  for i in 0..<len(dy):
    var newY = y + dy[i]
    var newX = x + dx[i]
    if 0 <= newY and newY <= len(d) and 0 <= newX and newX <= len(d[0]) and d[newY][newX] != 0:
      nearPos.add([newY, newX].toSeq)

  # *Dist
  var nearPosDist = newSeq[float]()
  for pos in nearPos:
    var disY = pos[0] - y
    var disX = pos[1] - x
    var s: float = 0.0
    s += float(disY * disY)
    s += float(disX * disX)
    s = sqrt(s)
    nearPosDist.add(1/s)

  # *Score
  var nearPosScore = newSeq[float]()
  var s = sum(nearPosDist)
  for pos in nearPosDist:
    nearPosScore.add(pos/s)

  # *Interpolation
  for i in 0..<len(nearPos):
    var nearY = nearPos[i][0]
    var nearX = nearPos[i][1]
    d[y][x] += nearPosScore[i] * d[nearY][nearX]

proc bilinear(d: var seq[seq[float]]) =
  # *Loop
  for y in 0..<len(d):
    for x in 0..<len(d[0]):
      nearPoint(d, y, x)
      break
    break

proc main() =
  #!データ入力
  stdout.write "\nfile-name> "
  let fileName = readLine(stdin)

  # let fileName = "data.csv"
  var data = newSeq[seq[string]]()
  var p: CsvParser
  p.open(fmt"./{fileName}")
  while p.readRow():
    data.add(p.row)

  #!浮動小数点数に変換
  var d = newSeq[seq[float]]()
  for i in data:
    var tmp = newSeq[float]()
    for j in i:
      tmp.add(parseFloat(j))
    d.add(tmp)

  # var t = d
  
  # echo d
  # echo type(d)
  # echo len(d)
  # echo len(d[0])

  bilinear(d)
  # echo d
  # echo type(d)
  # echo len(d)
  # echo len(d[0])

  # for y in 0..<len(d):
  #   for x in 0..<len(d[0]):
  #     echo t[y][x] - d[y][x]


main()