/*: TileMapper
 # TileMapper
 ## TileMapper is a Swift playground that lets you build amazing custom 2d game world!
 ### It uses UIKit, CoreGraphics, and a touch of AVFoundation
 
 */

import PlaygroundSupport
import UIKit

//Window = size
let windowWidth = 600
let heightWidth = 600

//Here you can adjust the amound of squares for the canvas
TMUtils.numberOfSquaresInRow = 40
TMUtils.numberOfSquaresInColumn = 40

//This initializes the data used for drawing
TMUtils.initializeTileFamiliesFromResources()

TMUtils.initializeLayers()

//This is just a default tile
TMUtils.currentImage = UIImage(named: "tile003.png")

//The main window that plays the PlayGround
let mainWindow = MainWindow(frame: CGRect(x: 0, y: 0, width: windowWidth, height: heightWidth))

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundSupport.PlaygroundPage.current.liveView = mainWindow
