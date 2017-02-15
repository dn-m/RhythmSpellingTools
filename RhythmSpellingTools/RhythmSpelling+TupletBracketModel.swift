//
//  RhythmSpelling+TupletBracketModel.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 2/13/17.
//
//

import Rhythm

extension RhythmSpelling {
    
    /// Information necessary to render a tuplet bracket
    public struct Group {
        public let duration: MetricalDuration
        public let contentsSum: Int
    }
}

extension RhythmSpelling.Group {
    
    /// Creates a `TupletBracketModel` for the given `metricalDurationTree`.
    public init(_ metricalDurationTree: MetricalDurationTree) {
        
        guard case .branch(let duration, let trees) = metricalDurationTree else {
            fatalError("Ill-formed MetricalDurationTree")
        }
        
        self.init(
            duration: duration,
            contentsSum: trees.map { $0.value.numerator }.sum
        )
    }
}

extension RhythmSpelling.Group: CustomStringConvertible {
    
    public var description: String {
        return "\(contentsSum):\(duration)"
    }
}
