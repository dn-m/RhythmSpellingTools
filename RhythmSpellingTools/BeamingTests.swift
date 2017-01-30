//
//  BeamingTests.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import XCTest
import RhythmSpellingTools

class BeamingTests: XCTestCase {
    
    func testBeamingInitEmpty() {
        _ = Beaming([])
    }

    func testBeamingInit() {
        let start = Beaming.Junction([0: .start, 1: .start, 2: .start])
        let stop = Beaming.Junction([0: .stop, 1: .stop, 2: .stop])
        _ = Beaming([start, stop])
    }
}
