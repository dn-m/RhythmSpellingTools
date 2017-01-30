//
//  Beaming.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import Collections

public struct Beaming {
    
    public struct Junction {
        
        public enum State {
            case start
            case stop
            case maintain
        }
        
        fileprivate let states: [Int: State]
        
        public init(states: [Int: State]) {
            self.states = states
        }
    }
    
    fileprivate let junctions: [Junction]
    
    public init(junctions: [Junction]) {
        self.junctions = junctions
    }
}

extension Beaming: AnyCollectionWrapping {
    
    public var collection: AnyCollection<Junction> {
        return AnyCollection(junctions)
    }
}
