#!/usr/bin/env swift

import Cocoa

let width = 110
let height = 45

class Coords {
  var x = 1.0
  var y = 1.0
  var zoom = 20.0
  var iters = 1000
}

var coords = Coords()

func mandalalalala() {
  func toComplex(i:Int, j:Int) -> (re:Double, im:Double) {
    let zoom = coords.zoom
    let zoomRe = zoom * 2.0
    let zoomIm = zoom
    let re = ((Double(i) - Double(width)) / zoomRe) + coords.x
    let im = ((Double(j) - Double(height)) / zoomIm) + coords.y
    return (re, im)
  }

  func getIters(c:(re:Double, im:Double)) -> Double {
    let cr = c.re
    let ci = c.im
    var zr = cr
    var zi = ci
    var iters = 0.0

    for _ in 0...coords.iters {
      zr = ((zr * zr) - (zi * zi)) + cr
      zi = 2 * zi * zr + ci
      iters = sqrt(Double((zr * zr) + (zi * zi)))
      if (iters >= 2.0) {
        return iters
      }
    }

    return iters
  }

  func getCol(i:Double) -> Int {
    return 4 + Int(i * 5) % 255
  }

  let chars = "˙.-=+∆*%#0@"
  func getChar(i:Double) -> Character {
    let index = Int(i * 10) % 10
    return chars[chars.startIndex.advancedBy(index)]
  }

  func mandelbrot() {
    print("\u{001B}[2J\u{001B}[;H")
    var ln = ""
    for i in 0...height {
      for j in 0...width {
        let iters = getIters(toComplex(j, j:i))

        if (iters >= 2.0) {
          ln += " "
        } else {
          let col = getCol(iters)
          ln += "\u{001B}[38;5;\(col)m" + String(getChar(iters))
        }
      }
      ln += "\n"
    }
    print(ln)
  }

  mandelbrot()
}

func getInput() -> String {
  return String(UnicodeScalar(Int(getchar())))
}

while true {
  mandalalalala()

  print("> ")

  let input = getInput()

  if input == "z" {
    coords.zoom += 5.0 * (coords.zoom / 50)
  } else if input == "a" {
    coords.zoom -= 5.0 * (coords.zoom / 50)
  } else if input == "h" {
    coords.x -= (0.1 / coords.zoom) * 20
  } else if input == "l" {
    coords.x += (0.1 / coords.zoom) * 20
  } else if input == "j" {
    coords.y += (0.1 / coords.zoom) * 20
  } else if input == "k" {
    coords.y -= (0.1 / coords.zoom) * 20
  } else if input == "?" {
    print("Coords: x: \(coords.x) y: \(coords.y) zoom: \(coords.zoom) iters: \(coords.iters)")
    let _ = getInput()
  } else if input == "+" {
    coords.iters += 1000
  } else if input == "-" {
    if coords.iters > 2000 {
      coords.iters -= 1000
    }
  } else if input == "q" {
    exit(0)
  }
}
