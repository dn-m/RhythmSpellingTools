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
    
    public typealias Level = UInt
    
    // MARK: - Nested Types
    
    /// Model of `State` values for each beam-level
    public struct Junction {
        
        /// Whether to start, stop, or maintain a beam for a given beam-level
        public enum State {
            case start
            case stop
            case maintain
        }
        
        // MARK: - Instance Properties
        
        /// - TODO: Consider just making `Array`, because, we always have to know
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
}

extension Beaming: AnyCollectionWrapping {
    
    // MARK: - AnyCollectionWrapping
    
    public var collection: AnyCollection<Junction> {
        return AnyCollection(junctions)
    }
}
