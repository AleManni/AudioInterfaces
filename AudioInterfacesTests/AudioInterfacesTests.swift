//
//  AudioInterfacesTests.swift
//  AudioInterfacesTests
//
//  Created by Alessandro Manni on 12/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import AudioInterfaces

class AudioInterfacesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - Knobs and calculators
    
    func testSimpleKnobDefaultInit() {
        let knob = SimpleKnob()
        XCTAssertTrue(knob.startAngle == .threeQuarters, "Default start angle value should be ThreeQuarters")
        XCTAssertTrue(knob.endAngle == .quarter, "Default end angle value should be .Quarter")
        XCTAssertTrue(knob.minValue == 0, "Default minvalue should be 0")
        XCTAssertTrue(knob.maxValue == 10, "Default max value should be 10")
    }
    
    func testSteppedKnobDefaultInit() {
        let knob = SteppedKnob()
        XCTAssertTrue(knob.primaryMarksMultiplier == 1, "Default start value should be 1")
        XCTAssertTrue(knob.secondaryMarksMultiplier == 0, "Default start value should be 0")
        XCTAssertTrue(knob.startAngle == .threeQuarters, "Default start angle value should be ThreeQuarters")
        XCTAssertTrue(knob.endAngle == .quarter, "Default end angle value should be .Quarter")
        XCTAssertTrue(knob.minValue == 0, "Default minvalue should be 0")
        XCTAssertTrue(knob.maxValue == 10, "Default max value should be 10")
    }
    
    func testKnobCalculator() {
        
        let knob = SimpleKnob()
        let calculator = mockCalculator()
        
        //selected angle at starting position of knob run (lower boundary)
        calculator.handleRotationforMockKnob(knob, selectedAngleDegr: knob.knobStartAngle.radiansToDegrees())
        XCTAssertTrue(knob.touchValueInDegrees == 0.0)
        //selected angle within run boundaries
        calculator.handleRotationforMockKnob(knob, selectedAngleDegr: 200.0)
        XCTAssertTrue(knob.touchValueInDegrees == 65, "Value should have been: 65.0 not \( knob.touchValueInDegrees)")
        //Edge case: selected angle outside knob run boundaries
        calculator.handleRotationforMockKnob(knob, selectedAngleDegr: 100.0)
        XCTAssertTrue(knob.touchValueInDegrees == 0.0, "Value should have been: 0.0 not \( knob.touchValueInDegrees)")
    }
    
    func testSteppedKnobCalculator() {
        let knob = SteppedKnob()
        let calculator = mockCalculator()
        
        //selected angle at starting position of knob run (lower boundary)
        calculator.handleRotationforSteppedKnob(knob, selectedAngleDegr: knob.knobStartAngle.radiansToDegrees())
        XCTAssertTrue(knob.touchValueInDegrees == 0.0)
        //selected angle within run boundaries
        calculator.handleRotationforMockKnob(knob, selectedAngleDegr: 200.0)
        XCTAssertTrue(knob.touchValueInDegrees == 65, "Value should have been: 65.0 not \( knob.touchValueInDegrees)")
        //Edge case: selected angle outside knob run boundaries
        calculator.handleRotationforMockKnob(knob, selectedAngleDegr: 100.0)
        XCTAssertTrue(knob.touchValueInDegrees == 0.0, "Value should have been: 0.0 not \( knob.touchValueInDegrees)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
