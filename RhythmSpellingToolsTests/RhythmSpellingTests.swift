//
//  RhythmSpellingTests.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 2/13/17.
//
//

import XCTest
import Rhythm
@testable import RhythmSpellingTools

class RhythmSpellingTests: XCTestCase {
    
    func testBeamsCountDurationCoefficient2() {
        let duration = 8 /> 64 // 1/8
        XCTAssertEqual(beamCount(duration), 1)
    }
    
    func testBeamsCountDurationCoefficient3() {
        let duration = 12 /> 256 // 3/64
        XCTAssertEqual(beamCount(duration), 3)
    }
    
    func testBeamsCountDurationCoefficient7() {
        let duration = 28 /> 32 // 7/8
        XCTAssertEqual(beamCount(duration), -1)
    }
    
    func testSingletSetOfBeamlets() {
        
        let values = [4]
        let junctions = makeJunctions(values)
        
        let expectedStates: [Int: RhythmSpelling.BeamJunction.State] = [
            1: .beamlet,
            2: .beamlet,
            3: .beamlet,
            4: .beamlet
        ]
        
        XCTAssertEqual(junctions, [expectedStates].map(RhythmSpelling.BeamJunction.init))
    }
    
    func testDoubletSameValues() {
        
        let values = [3,3]
        let junctions = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start, 2: .start, 3: .start],
            [1: .stop, 2: .stop, 3: .stop],
            ]
        
        XCTAssertEqual(junctions, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testDoubletFirstHigher() {
        
        let values = [4,1]
        let junctions = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start, 2: .beamlet, 3: .beamlet, 4: .beamlet],
            [1: .stop]
        ]
        
        XCTAssertEqual(junctions, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testDoubletSecondHigher() {
        
        let values = [2,3]
        let beaming = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start, 2: .start],
            [1: .stop, 2: .stop, 3: .beamlet]
        ]
        
        XCTAssertEqual(beaming, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testTripletSameValues() {
        
        let values = [2,2,2]
        let beaming = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start, 2: .start],
            [1: .maintain, 2: .maintain],
            [1: .stop, 2: .stop]
        ]
        
        XCTAssertEqual(beaming, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testTripletLowMidHigh() {
        
        let values = [1,2,4]
        let beaming = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start],
            [1: .maintain, 2: .start],
            [1: .stop, 2: .stop, 3: .beamlet, 4: .beamlet]
        ]
        
        XCTAssertEqual(beaming, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testTripletLowHighMid() {
        
        let values = [1,3,2]
        let beaming = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start],
            [1: .maintain, 2: .start, 3: .beamlet],
            [1: .stop, 2: .stop]
        ]
        
        XCTAssertEqual(beaming, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testTripletMidLowHigh() {
        
        let values = [2,1,4]
        let beaming = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start, 2: .beamlet],
            [1: .maintain],
            [1: .stop, 2: .beamlet, 3: .beamlet, 4: .beamlet]
        ]
        
        XCTAssertEqual(beaming, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testTripletMidHighLow() {
        
        let values = [2,3,1]
        let beaming = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start, 2: .start],
            [1: .maintain, 2: .stop, 3: .beamlet],
            [1: .stop]
        ]
        
        XCTAssertEqual(beaming, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testLongSequence() {
        
        let values = [1,3,2,2,4,3,3,1,3]
        let beaming = makeJunctions(values)
        
        let expectedStates: [[Int: RhythmSpelling.BeamJunction.State]] = [
            [1: .start], // 1
            [1: .maintain, 2: .start, 3: .beamlet], // 2
            [1: .maintain, 2: .maintain], // 3
            [1: .maintain, 2: .maintain], // 2
            [1: .maintain, 2: .maintain, 3: .start, 4: .beamlet], // 4
            [1: .maintain, 2: .maintain, 3: .maintain], // 3
            [1: .maintain, 2: .stop, 3: .stop], // 3
            [1: .maintain], // 1
            [1: .stop, 2: .beamlet, 3: .beamlet] // 3
        ]
        
        XCTAssertEqual(beaming, expectedStates.map(RhythmSpelling.BeamJunction.init))
    }
    
    func testTieStateAllNones() {
        
        let contexts: [MetricalContext<Int>] = [
            .instance(.event(1)),
            .instance(.event(1)),
            .instance(.event(1))
        ]
        
        let expected: [RhythmSpelling.TieState] = [.none, .none, .none]
        
        XCTAssertEqual(makeTieStates(contexts), expected)
    }
    
    func testTieStateCombo() {
        
        let contexts: [MetricalContext<Int>] = [
            .instance(.event(1)),
            .continuation,
            .instance(.absence)
        ]
        
        let expected: [RhythmSpelling.TieState] = [.start, .stop, .none]
        
        XCTAssertEqual(makeTieStates(contexts), expected)
    }
    
    func testTieStatesSequence() {
        
        let contexts: [MetricalContext<Int>] = [
            .instance(.event(1)),
            .instance(.event(1)),
            .continuation,
            .instance(.absence),
            .instance(.event(1)),
            .continuation,
            .continuation,
            .instance(.event(1)),
            .instance(.absence)
        ]
        
        let expected: [RhythmSpelling.TieState] = [
            .none,
            .start,
            .stop,
            .none,
            .start,
            .maintain,
            .stop,
            .none,
            .none
        ]
        
        XCTAssertEqual(makeTieStates(contexts), expected)
    }
    
    func testInitWithRhythmTree() {
        
        let metricalDurationTree = 4/>8 * [1,1,1,1]
        
        let metricalContexts: [MetricalContext<Int>] = [
            .instance(.event(1)),
            .continuation,
            .continuation,
            .instance(.absence)
        ]
        
        let rhythmTree = RhythmTree(metricalDurationTree, metricalContexts)
        let spelling = RhythmSpelling(rhythmTree)

        // TODO: Add assertion!
    }
    
    func testInitWithRhythmTreeDottedValues() {
        
        let metricalDurationTree = 2/>4 * [1,2,3,7]
        
        let metricalContexts: [MetricalContext<Int>] = [
            .instance(.event(1)),
            .continuation,
            .continuation,
            .instance(.absence)
        ]
        
        let rhythmTree = RhythmTree(metricalDurationTree, metricalContexts)
        let spelling = RhythmSpelling(rhythmTree)
        
        // TODO: Add assertion!
    }
}
