//
//  SpelledRhythm.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 6/15/17.
//
//

import Collections
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

extension SpelledRhythm: AnyCollectionWrapping {
    
    // MARK: - Collection
    
    /// - Returns: A collection of triples containing the offset, rhythm leaf, and rhythm 
    /// spelling item for each leaf of the spelled rhythm.
    public var collection: AnyCollection<(Double,RhythmLeaf<Int>,RhythmSpelling.Item)> {
        let offsets = rhythm.metricalDurationTree.offsets.map { $0.doubleValue }
        let items = spelling.map { $0 }
        return AnyCollection(Array(zip(offsets, rhythm.leaves, items)))
    }
}
