//
//  BeamedRhythm.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import Rhythm

public struct BeamedRhythm <T: Equatable> {
    
    let rhythmTree: RhythmTree<T>
    let beaming: Beaming
    
    public init(_ rhythmTree: RhythmTree<T>, _ beaming: Beaming) {
        self.rhythmTree = rhythmTree
        self.beaming = beaming
    }
}
