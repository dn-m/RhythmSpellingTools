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
            0: .beamlet,
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
            [0: .start, 1: .start, 2: .start, 3: .start],
            [0: .stop, 1: .stop, 2: .stop, 3: .stop],
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testDoubletFirstHigher() {
        
        let values = [4,1]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [0: .start, 1: .start, 2: .beamlet, 3: .beamlet, 4: .beamlet],
            [0: .stop, 1: .stop]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testDoubletSecondHigher() {
        
        let values = [2,3]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [0: .start, 1: .start, 2: .start],
            [0: .stop, 1: .stop, 2: .stop, 3: .beamlet]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletSameValues() {
        
        let values = [2,2,2]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [0: .start, 1: .start, 2: .start],
            [0: .maintain, 1: .maintain, 2: .maintain],
            [0: .stop, 1: .stop, 2: .stop]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletLowMidHigh() {
        
        let values = [1,2,4]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [0: .start, 1: .start],
            [0: .maintain, 1: .maintain, 2: .start],
            [0: .stop, 1: .stop, 2: .stop, 3: .beamlet, 4: .beamlet]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletLowHighMid() {
        
        let values = [1,3,2]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [0: .start, 1: .start],
            [0: .maintain, 1: .maintain, 2: .start, 3: .beamlet],
            [0: .stop, 1: .stop, 2: .stop]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletMidLowHigh() {
        
        let values = [2,1,4]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [0: .start, 1: .start, 2: .beamlet],
            [0: .maintain, 1: .maintain],
            [0: .stop, 1: .stop, 2: .beamlet, 3: .beamlet, 4: .beamlet]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testTripletMidHighLow() {
        
        let values = [2,3,1]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [0: .start, 1: .start, 2: .start],
            [0: .maintain, 1: .maintain, 2: .stop, 3: .beamlet],
            [0: .stop, 1: .stop]
        ]
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
    
    func testLongSequence() {
        
        let values = [1,3,2,2,4,3,3,1,3]
        let beaming = Beaming(values)
        
        let expectedStates: [[Int: Beaming.Junction.State]] = [
            [0: .start, 1: .start], // 1
            [0: .maintain, 1: .maintain, 2: .start, 3: .beamlet], // 2
            [0: .maintain, 1: .maintain, 2: .maintain], // 2
            [0: .maintain, 1: .maintain, 2: .maintain], // 2
            [0: .maintain, 1: .maintain, 2: .maintain, 3: .start, 4: .beamlet], // 4
            [0: .maintain, 1: .maintain, 2: .maintain, 3: .maintain], // 3
            [0: .maintain, 1: .maintain, 2: .stop, 3: .stop], // 3
            [0: .maintain, 1: .maintain], // 1
            [0: .stop, 1: .stop, 2: .beamlet, 3: .beamlet] // 3
        ]
        
        //print("result:\(beaming.map { $0.states });expected:\(expectedStates))")
        
        print("result:")
        beaming.map { $0.states }.forEach { print($0) }
        
        print("expected:")
        expectedStates.forEach { print($0) }
        
        
        XCTAssertEqual(beaming, Beaming(expectedStates.map(Beaming.Junction.init)))
    }
}








