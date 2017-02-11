//
//  Beaming.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import Collections

/// Model of beaming, where there is a `Junction` for each `Leaf` of a given `RhythmTree`.
public struct Beaming {
    
    // MARK: - Associated Type
    
    public typealias Level = Int
    
    // MARK: - Nested Types
    
    /// Model of `State` values for each beam-level
    public struct Junction {
        
        /// Whether to start, stop, or maintain a beam for a given beam-level
        public enum State {
            case start
            case stop
            case maintain
            case beamlet
        }
        
        // MARK: - Instance Properties
        
        /// - TODO: Consider just making `Array`, because, we always have to know 0 ..< n
        fileprivate let states: [Level: State]
        
        // MARK: - Initializers
        
        /// Create a `Junction` with a mapping of `State` to beam-level
        public init(_ states: [Level: State] = [:]) {
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
    
    func junctions(_ beamAmounts: [Int]) -> [Junction] {

        // first, check for
        // - single
        // - double
        
        if beamAmounts.count == 1 {
            
            let states: [Level: Junction.State] = [:]
            
            
            
            //let levels = (0...beamAmounts.first!).map { $0 }
            //let states = Junction(Dictionary(levels, ))
            
            //return (0...levels.first!).map { Junction()
        }
        
        // (Int?, Int, Int?)
        
        for (l, level) in beamAmounts.enumerated() {
            
            var prev: Int? = beamAmounts[safe: l - 1]
            let cur: Int = beamAmounts[l]
            let next: Int? = beamAmounts[safe: l + 1]
            

        }
        return []
    }
}


// ([Int]) -> [Junction]




extension Beaming: AnyCollectionWrapping {
    
    // MARK: - AnyCollectionWrapping
    
    public var collection: AnyCollection<Junction> {
        return AnyCollection(junctions)
    }
}
