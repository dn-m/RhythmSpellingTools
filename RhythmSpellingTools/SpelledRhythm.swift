//
//  SpelledRhythm.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 6/15/17.
//
//

import Rhythm

public struct SpelledRhythm {
    
    // MARK: - Instance Properties
    
    // Constrain to `Int` for now.
    public let rhythm: Rhythm<Int>
    public let spelling: RhythmSpelling
    
    // MARK: - Initializers
    
    public init(rhythm: Rhythm<Int>, spelling: RhythmSpelling) {
        self.rhythm = rhythm
        self.spelling = spelling
    }
}
