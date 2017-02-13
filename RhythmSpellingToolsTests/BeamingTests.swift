//
//  BeamingTests.swift
//  RhythmSpellingTools
//
//  Created by James Bean on 1/30/17.
//
//

import XCTest
import Rhythm
import RhythmSpellingTools

class BeamingTests: XCTestCase {

    func testBeamsCountDurationCoefficient2() {
        let duration = 8 /> 64 // 1/8
        XCTAssertEqual(beamsCount(duration), 1)
    }
    
    func testBeamsCountDurationCoefficient3() {
        let duration = 12 /> 256 // 3/64
        XCTAssertEqual(beamsCount(duration), 3)
    }
    
    func testBeamsCountDurationCoefficient7() {
        let duration = 28 /> 32 // 7/8
        XCTAssertEqual(beamsCount(duration), -1)
    }
    
    func testBeamingInit() {
        let start = Beaming.Junction([0: .start, 1: .start, 2: .start])
        let stop = Beaming.Junction([0: .stop, 1: .stop, 2: .stop])
        _ = Beaming([start, stop])
    }
    
    func testInitWithValuesEmpty() {
        let values: [Int] = []
        XCTAssertEqual(Beaming(values).count, 0)
    }
    
    func testSingletSetOfBeamlets() {
        
        let values = [4]
        let beaming = Beaming(values)
        
        let expectedStates: [Int: Beaming.Junction.State] = [
            1: .beamlet,
            2: .beamlet,
            3: .beamlet,
            4: .beamlet
        ]
        
        XCTAssertEqual(beaming, Beaming([Beaming.Junction(expectedStates)]))
    }
    
    func testDoubletSameValues() {
        
        let values = [3,3]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [1: .start, 2: .start, 3: .start],
            [1: .stop, 2: .stop, 3: .stop],
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testDoubletFirstHigher() {
        
        let values = [4,1]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [1: .start, 2: .beamlet, 3: .beamlet, 4: .beamlet],
            [1: .stop]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testDoubletSecondHigher() {
        
        let values = [2,3]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [1: .start, 2: .start],
            [1: .stop, 2: .stop, 3: .beamlet]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletSameValues() {
        
        let values = [2,2,2]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [1: .start, 2: .start],
            [1: .maintain, 2: .maintain],
            [1: .stop, 2: .stop]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletLowMidHigh() {
        
        let values = [1,2,4]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [1: .start],
            [1: .maintain, 2: .start],
            [1: .stop, 2: .stop, 3: .beamlet, 4: .beamlet]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletLowHighMid() {
        
        let values = [1,3,2]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [1: .start],
            [1: .maintain, 2: .start, 3: .beamlet],
            [1: .stop, 2: .stop]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletMidLowHigh() {
        
        let values = [2,1,4]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [1: .start, 2: .beamlet],
            [1: .maintain],
            [1: .stop, 2: .beamlet, 3: .beamlet, 4: .beamlet]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletMidHighLow() {
        
        let values = [2,3,1]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [1: .start, 2: .start],
            [1: .maintain, 2: .stop, 3: .beamlet],
            [1: .stop]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testLongSequence() {
        
        let values = [1,3,2,2,4,3,3,1,3]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
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
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testInitWithMetricalDurationTreeSingleDepthCoefficient2() {
        
        let tree = 1 /> 32 * [1,1,1] // 1/64, 1/64, 1/64
        let beaming = Beaming(tree)
        
        let expected = Beaming([
            [1: Beaming.Junction.State.start, 2: .start, 3: .start, 4: .start],
            [1: .maintain, 2: .maintain, 3: .maintain, 4: .maintain],
            [1: .stop, 2: .stop, 3: .stop, 4: .stop],
        ].map(Beaming.Junction.init))

        XCTAssertEqual(beaming, expected)
    }
}
