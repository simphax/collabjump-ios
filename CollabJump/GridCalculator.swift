//
//  GridCalculator.swift
//  GridTest
//
//  Created by Simon Nilsson on 2016-01-03.
//  Copyright © 2016 Simon Nilsson. All rights reserved.
//

import Foundation
import SpriteKit

class GridCell : CustomStringConvertible {
    var index: Int
    var rect: CGRect
    var angle: CGFloat
    
    init(index: Int, rect: CGRect, angle: CGFloat) {
        self.index = index
        self.rect = rect
        self.angle = angle
    }
    
    var description : String {
        return "{index \(index), rect \(rect), angle \(angle)}"
    }
}

// Creates a grid of rectangles with ID's starting from 0 in the top left corner (when y is up)
// The GridCell's can be used by e.g. SKSpriteNode with the anchor point at (0,0) and zRotation at the angle
// Only fully working with 90 degrees step angles
class GridCalculator {
    
    private var cellSize: CGFloat = 1024
    private var gridCols: CGFloat = 6
    private var gridRows: CGFloat = 5
    var width: CGFloat = 6144
    var height: CGFloat = 5120
    
    init(cellSize: Int, gridCols: Int, gridRows: Int) {
        self.cellSize = CGFloat(cellSize)
        self.gridCols = CGFloat(gridCols)
        self.gridRows = CGFloat(gridRows)
        self.width = CGFloat(cellSize * gridCols)
        self.height = CGFloat(cellSize * gridRows)
    }
    
    func getCells(position: CGPoint, anchorPoint: CGPoint, angleDeg: Int) -> [GridCell] {
        var cells: [GridCell] = []
        for var colIndex = 0; colIndex < Int(gridCols); colIndex++ {
            for var rowIndex = 0; rowIndex < Int(gridRows); rowIndex++ {
                let cellIndex: Int = rowIndex * Int(gridCols) + colIndex;
                let cellPosY = position.y + height - CGFloat(rowIndex + 1) * cellSize - height * anchorPoint.y
                let cellPosX = position.x + CGFloat(colIndex) * cellSize - width * anchorPoint.x
                let cellPos = CGPoint(x: cellPosX, y: cellPosY)
                let cellCGSize = CGSize(width: cellSize, height: cellSize)
                
                let rotationPoint = position
                let rotatedPoint = cellPos.rotateAround(rotationPoint, angle: degreesToRadians(angleDeg))
                
                let gridCell = GridCell(index: cellIndex, rect: CGRect(origin: rotatedPoint, size: cellCGSize), angle: degreesToRadians(angleDeg))
                cells.append(gridCell)
            }
        }
        return cells
    }
    
    func getCells(position: CGPoint, anchorPoint: CGPoint, angleDeg: Int, viewRect: CGRect) -> [GridCell] {
        
        var absAngle = angleDeg % 360
        while(absAngle < 0) {
            absAngle += 360
        }
        
        let allCells = getCells(position, anchorPoint: anchorPoint, angleDeg: angleDeg)
        var intersectingCells: [GridCell] = []
        for cell in allCells {
            var rotatedRect = cell.rect
            if(absAngle > 270) { //0 degrees
            }
            else if(absAngle > 180) { //270 degrees
                rotatedRect.origin.y -= cell.rect.size.height
            }
            else if(absAngle > 90) { //180 degrees
                rotatedRect.origin.x -= cell.rect.size.width
                rotatedRect.origin.y -= cell.rect.size.height
            }
            else if(absAngle > 0) { //90 degrees
                rotatedRect.origin.x -= cell.rect.size.width
            }
            
            if CGRectIntersectsRect(rotatedRect, viewRect) {
                intersectingCells.append(cell)
            }
        }
        return intersectingCells
    }
    
    func degreesToRadians(degrees: Int) -> CGFloat {
        return CGFloat(degrees) * CGFloat(M_PI) / 180.0
    }
    
    func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return radians * 180.0 / CGFloat(M_PI)
    }
    
}

