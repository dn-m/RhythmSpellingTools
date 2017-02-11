//
//  BeamedRhythmTests.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import XCTest
import Collections
import Rhythm
import RhythmSpellingTools

class BeamedRhythmTests: XCTestCase {
    
//    var singleDepthRhythm: RhythmTree<Int> {
//        
//        // Prepare leaves
//        let nodesCount = 5
//        let contexts = (0..<nodesCount).map { _ in MetricalContext<Int>.instance(.event(1)) }
//        let leaves = contexts.map { context in
//            MetricalNode<Int>(context, MetricalDuration(1,8))
//        }
//        
//        // Prepare root
//        let rootContext = MetricalContext<Int>.instance(.event(0))
//        let rootNode = MetricalNode(rootContext, MetricalDuration(4,8))
//        
//        // Return constructed tree
//        return RhythmTree(rootNode, leaves)
//    }
//    
//    func testDefaultBeaming() {
//        let rhythm = singleDepthRhythm
//        //print("RHYTHM:\n\(rhythm)")
//        
//        func traverse <T> (_ rhythm: RhythmTree<T>) {
//            switch rhythm {
//            case .leaf(let value):
//                print("\(value)")
//            case .container(let value, let children):
//                children.forEach(traverse)
//            }
//        }
//        
//        traverse(rhythm)
//    }
}
