//
//  BeamedRhythm.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import Rhythm

/// - TODO: 
///
/// - Dots
/// - Tuplet bracket
/// - Ties
///
public struct BeamedRhythm <T: Equatable> {
    
    let rhythmTree: RhythmTree<T>
    let beaming: Beaming
    
    public init(_ rhythmTree: RhythmTree<T>, _ beaming: Beaming? = nil) {
        self.rhythmTree = rhythmTree
        self.beaming = beaming ?? Beaming(rhythmTree.metricalDurationTree)
    }
}
    
enum TieContext {
    case start
    case stop
    case none
}
