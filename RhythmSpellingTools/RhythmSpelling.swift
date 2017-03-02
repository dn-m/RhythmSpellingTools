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
    
    fileprivate let contexts: [Context]
    
    // groups by depth
    fileprivate let groups: Tree<(CountableClosedRange<Int>, Group)>
    
    // MARK: - Initializers
    
    public init(contexts: [Context], groups: Tree<(CountableClosedRange<Int>, Group)>) {
        self.contexts = contexts
        self.groups = groups
    }
    
    /// Creates a `RhythmSpelling` with the given `rhythmTree`.
    ///
    /// - TODO: Add ability to inject customized beaming algorithm.
    public init(_ rhythmTree: RhythmTree<Int>) {
        
        let leaves = rhythmTree.metricalDurationTree.leaves
        
        let junctions = makeJunctions(leaves)
        let tieStates = makeTieStates(rhythmTree.leafContexts)
        let dots = leaves.map(dotCount)
        let contexts = zip(junctions, tieStates, dots).map(Context.init)
        let groups = makeGroups(rhythmTree.metricalDurationTree)

        self.init(contexts: contexts, groups: groups)
    }
}

extension RhythmSpelling: Equatable {
    
    // MARK: - Equatable
    
    /// - returns: `true` if `RhythmSpelling` values are equivalent. Otherwise, `false`.
    ///
    /// - FIXME: `Groups` not yet equatable
    public static func == (lhs: RhythmSpelling, rhs: RhythmSpelling) -> Bool {
        return lhs.contexts == rhs.contexts /*&& lhs.groups == rhs.groups*/
    }
}

extension RhythmSpelling: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return contexts.description
    }
}

extension RhythmSpelling.Context: Equatable {
    
    // MARK: - Equatable
    
    /// - returns: `true` if `Context` values are equivalent. Otherwise, `false`.
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

internal func makeGroups(_ tree: MetricalDurationTree)
    -> Tree<(CountableClosedRange<Int>, RhythmSpelling.Group)>
{
    
    func traverse(_ tree: MetricalDurationTree, offset: Int)
        -> Tree<(CountableClosedRange<Int>, RhythmSpelling.Group)>
    {
        
        switch tree {
        case .leaf:
            fatalError("Ill-formed MetricalDurationTree")
            
        case .branch(_, let trees):
            
            let group = RhythmSpelling.Group(tree)
            let leavesCount = tree.leaves.count
            let range = offset ... offset + leavesCount

            // Replace with `Tree.branches`
            let trees = trees.filter {
                switch $0 {
                case .leaf:
                    return false
                case .branch:
                    return true
                }
            }

            // Refactor this as a reduce
            var newTrees: [Tree<(CountableClosedRange<Int>, RhythmSpelling.Group)>] = []
            var subOffset = offset
            for subTree in trees {
                newTrees.append(traverse(subTree, offset: subOffset))
                subOffset += subTree.leaves.count
            }
            
            let value = (range, group)
            if newTrees.isEmpty {
                return .leaf(value)
            } else {
                return .branch(value, newTrees)
            }
        }
    }
    
    return traverse(tree, offset: 0)
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
