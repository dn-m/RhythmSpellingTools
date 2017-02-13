//
//  RhythmSpelling.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 2/13/17.
//
//

import Collections
import ArithmeticTools
import Rhythm

public struct RhythmSpelling {
    
    // MARK: - Nested Types
    
    /// Context for a single event in a `RhythmSpelling`.
    public struct Context {
        
        /// The actions necessary to render beams.
        let beamJunction: BeamJunction
        
        /// The actions necessary to render ties.
        let tieState: TieState
        
        /// The amount of dots necessary to represent duration.
        let dots: Int
    }
    
    // MARK: - Instance Properties
    
    private let contexts: [Context]
    
    // MARK: - Initializers
    
    /// Creates a `RhythmSpelling` with the given `rhythmTree`.
    ///
    /// - TODO: Add ability to inject customized beaming algorithm.
    public init(_ rhythmTree: RhythmTree<Int>) {
        
        let leaves = rhythmTree.metricalDurationTree.leaves
        
        let junctions = makeJunctions(leaves)
        let tieStates = makeTieStates(rhythmTree.leafContexts)
        let dots = leaves.map(dotCount)
        
        self.contexts = zip(junctions, tieStates, dots).map(Context.init)
    }
}

extension RhythmSpelling.Context: Equatable {
    
    public static func == (lhs: RhythmSpelling.Context, rhs: RhythmSpelling.Context) -> Bool {
        return (
            lhs.beamJunction == rhs.beamJunction &&
            lhs.tieState == rhs.tieState &&
            lhs.dots == rhs.dots
        )
    }
}

/// - returns: The amount of dots required to render the given `duration`.
internal func dotCount(_ duration: MetricalDuration) -> Int {

    let beats = duration.reduced.numerator
    
    guard [1,3,7].contains(beats) else {
        fatalError("Unsanitary duration for beamed representation: \(beats)")
    }
    
    return beats == 3 ? 1 : beats == 7 ? 2 : 0
}

/// - returns: An array of `BeamJunction` values for the given `counts` (amounts of beams).
internal func makeJunctions(_ counts: [Int]) -> [RhythmSpelling.BeamJunction] {
    
    return counts.indices.map { index in
        
        let prev = counts[safe: index - 1]
        let cur = counts[index]
        let next = counts[safe: index + 1]
        
        return RhythmSpelling.BeamJunction(prev, cur, next)
    }
}

/// - returns: An array of `BeamJunction` values for the given `leaves`.
internal func makeJunctions(_ leaves: [MetricalDuration]) -> [RhythmSpelling.BeamJunction] {
    return makeJunctions(leaves.map(beamCount))
}

/// - returns: Amount of beams needed to represent the given `duration`.
internal func beamCount(_ duration: MetricalDuration) -> Int {
    
    let reduced = duration.reduced
    
    guard [1,3,7].contains(reduced.numerator) else {
        fatalError("Unsanitary duration for beamed representation: \(reduced)")
    }
    
    let subdivisionCount = countTrailingZeros(reduced.denominator) - 2
    
    if reduced.numerator.isDivisible(by: 3) {
        return subdivisionCount - 1
    } else if reduced.numerator.isDivisible(by: 7) {
        return subdivisionCount - 2
    }
    
    return subdivisionCount
}

/// - returns: The `TieState` values necessary to render the given `MetricalContext` values.
internal func makeTieStates <T> (_ metricalContexts: [MetricalContext<T>])
    -> [RhythmSpelling.TieState]
{
    
    return metricalContexts.indices.map { index in

        let cur = metricalContexts[index]

        guard let next = metricalContexts[safe: index + 1] else {
            return cur == .continuation ? .stop : .none
        }
        
        switch (cur, next) {
        case (.continuation, .continuation):
            return .maintain
        case (.continuation, _):
            return .stop
        case (_, .continuation):
            return .start
        default:
            return .none
        }
    }
}
