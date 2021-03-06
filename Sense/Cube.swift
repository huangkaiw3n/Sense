//
//  Cube.swift
//  HelloMetal
//
//  Created by Kaiwen Huang on 17/9/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
import Metal

class Cube: Node {
    
    init(device: MTLDevice){
        
//        let A = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
//        let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
//        let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
//        let D = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
//        
//        let Q = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
//        let R = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
//        let S = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
//        let T = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        let A = Vertex(x: -0.25, y:   1.0, z:   0.5, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let B = Vertex(x: -0.25, y:  -1.0, z:   0.5, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let C = Vertex(x:  0.25, y:  -1.0, z:   0.5, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let D = Vertex(x:  0.25, y:   1.0, z:   0.5, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        let Q = Vertex(x: -0.25, y:   1.0, z:  -0.5, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
        let R = Vertex(x:  0.25, y:   1.0, z:  -0.5, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
        let S = Vertex(x: -0.25, y:  -1.0, z:  -0.5, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
        let T = Vertex(x:  0.25, y:  -1.0, z:  -0.5, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
        
        let verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D,   //Front
            R,T,S ,Q,R,S,   //Back
            
            Q,S,B ,Q,B,A,   //Left
            D,C,T ,D,T,R,   //Right
            
            Q,A,D ,Q,D,R,   //Top
            B,S,T ,B,T,C    //Bot
        ]
        
        super.init(name: "Cube", vertices: verticesArray, device: device)
    }
    
    override func updateWithDelta(delta: CFTimeInterval) {
        
        super.updateWithDelta(delta)
        
        //_: Float = 6.0
        rotationY = heading
        rotationX = attitude
        rotationZ = bank
    }
}