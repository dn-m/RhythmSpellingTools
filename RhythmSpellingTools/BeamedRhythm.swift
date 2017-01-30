//
//  BeamedRhythm.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import Rhythm

public struct BeamedRhythm {
    
    let rhythmTree: RhythmTree<Any>
    let beaming: Beaming
    
    public init(_ rhythmTree: RhythmTree<Any>, _ beaming: Beaming) {
        self.rhythmTree = rhythmTree
        self.beaming = beaming
    }
}
