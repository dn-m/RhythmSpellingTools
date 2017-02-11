//
//  Beaming.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import Collections
import ArithmeticTools

/// Model of beaming, where there is a `Junction` for each `Leaf` of a given `RhythmTree`.
public struct Beaming {
    
    // MARK: - Associated Type
    
    // MARK: - Nested Types
    
    /// Model of `State` values for each beam-level
    public struct Junction {
        
        /// Whether to start, stop, or maintain a beam for a given beam-level
        public enum State: String {
            
            /// Start a beam on a given level.
            case start
            
            /// Stop a beam on a given level.
            case stop
            
            /// Maintain a beam on a given level.
            case maintain
            
            /// Add a beamlet on a given level.
            case beamlet
        }
        
        // MARK: - Instance Properties
        
        /// - TODO: Consider just making `Array`, because, we always have to know 0 ..< n
        public let states: [Int: State]
        
        // MARK: - Initializers
        
        /// Create a `Junction` with a mapping of `State` to beam-level
        public init(_ states: [Int: State] = [:]) {
            self.states = states
        }
    }

    // MARK: - Instance Properties
    
    fileprivate let junctions: [Junction]
    
    // MARK: - Initializers
    
    /// Create a `Beaming` with an array of `Junction` values.
    public init(_ junctions: [Junction] = []) {
        self.junctions = junctions
    }
}

extension Beaming {
    
    /// Create a `Beaming` with
    public init(_ values: [Int]) {
        
        let junctions: [Junction] = values.indices.map { index in
            
            let prev: Int? = values[safe: index - 1]
            let cur: Int = values[index]
            let next: Int? = values[safe: index + 1]
            
            return Junction(prev, cur, next)
        }
        
        self.init(junctions)
    }
}


extension Beaming.Junction {
    
    /// Create a `Junction` with the given context:
    ///
    /// - prev: Previous beaming value (if it exists)
    /// - cur: Current beaming value
    /// - next: Next beaming value (if it exists)
    public init(_ prev: Int?, _ cur: Int, _ next: Int?) {
        
        typealias Ranges = [State: CountableClosedRange<Int>]
        
        /// - returns: `Ranges` for a singleton value.
        func singleton(_ cur: Int) -> Ranges {
            return [.beamlet: 0...cur]
        }
        
        /// - returns: `Ranges` for a first value.
        func first(_ cur: Int, _ next: Int) -> Ranges {
            
            var ranges: Ranges = [.start: 0...min(cur,next)]
            
            // add beamlets if necessary
            if cur > next {
                ranges[.beamlet] = next + 1 ... cur
            }
            
            return ranges
        }
        
        /// - returns: `Ranges` for a middle value.
        func middle(_ prev: Int, _ cur: Int, _ next: Int) -> Ranges {
            
            var ranges: Ranges = [.maintain: 0...min(prev,cur,next)]
            
            // start new beams if necessary
            if cur > prev {
                ranges[.start] = prev + 1 ... cur
            }
            
            // neighboring junctions
            let (lower, higher) = ordered(prev,next)
            
            // stop beams if necessary
            if cur == higher && lower != higher {
                ranges[.stop] = lower + 1 ... higher
            }
            
            if cur > higher {
                
                // add beamlets
                ranges[.beamlet] = higher + 1 ... cur
                
                // stop beams
                if prev > next {
                    ranges[.stop] = lower + 1 ... higher
                }
            }
            
            return ranges
        }
        
        /// - returns: `Ranges` for a last value.
        func last(_ prev: Int, _ cur: Int) -> Ranges {
            
            // stop beams
            var ranges: Ranges = [.stop: 0...min(cur,prev)]
            
            // add beamlets if necessary
            if cur > prev {
                ranges[.beamlet] = prev + 1 ... cur
            }
            
            return ranges
        }
        
        /// - returns: `Ranges` for the given context.
        func ranges(_ prev: Int?, _ cur: Int, _ next: Int?) -> Ranges {
            
            switch (prev, cur, next) {
            case (nil, cur, nil):
                return singleton(cur)
            case (nil, let cur, let next?):
                return first(cur, next)
            case (let prev?, let cur, let next?):
                return middle(prev, cur, next)
            case (let prev?, let cur, nil):
                return last(prev, cur)
            default:
                fatalError("Ill-formed context")
            }
        }
        
        /// Apply the states to the levels in each range
        let states: [Int: State] = ranges(prev,cur,next).reduce([:]) { accum, cur in
            
            let (state, range) = cur
            
            var dict = accum
            range.forEach { dict[$0] = state }
            
            return dict
        }
        
        self.init(states)
    }
}

extension Beaming: Equatable {
    
    public static func == (lhs: Beaming, rhs: Beaming) -> Bool {
        return lhs.junctions == rhs.junctions
    }
}

extension Beaming.Junction: Equatable {
    
    public static func == (lhs: Beaming.Junction, rhs: Beaming.Junction) -> Bool {
        return lhs.states == rhs.states
    }
}

extension Beaming.Junction.State: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
}

extension Beaming: AnyCollectionWrapping {
    
    // MARK: - AnyCollectionWrapping
    
    public var collection: AnyCollection<Junction> {
        return AnyCollection(junctions)
    }
}
