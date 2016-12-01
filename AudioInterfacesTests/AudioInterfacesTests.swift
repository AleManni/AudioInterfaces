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
    
    func testSimpleKnobDefaultInit() {
        let knob = SimpleKnob()
        XCTAssertTrue(knob.startAngle == .threeQuarters, "Default start angle value should be ThreeQuarters")
        XCTAssertTrue(knob.endAngle == .quarter, "Default end angle value should be .Quarter")
        XCTAssertTrue(knob.minValue == 0, "Default minvalue should be 0")
        XCTAssertTrue(knob.maxValue == 10, "Default max value should be 10")
    }
    
    func testKnobCalculator() {
        
        class mockCalculator: KnobCalculator {
    
            func handleRotationforMockKnob<T: KnobProtocol>(_ knob: T, selectedAngleDegr: CGFloat) -> CGFloat {
                managedKnob = knob
                //Update the knob
                self.selectedAngleDegr = selectedAngleDegr
                return delta
            }
        }
        
        let knob = SimpleKnob()
        let calculator = mockCalculator()
        
        knob.touchValueInDegrees = 0  // This is the resutl of delta calculation and we want to test this
        calculator.selectedAngleDegr = 0 // This is the input value fed to delta. delta returns the knob.touchvaluesindegrees 
        //so we will provide a series of selected angel degrees and test the corresponidng result (knob.touchvalueindegree)
        //selected angle at starting position of knob run (lower boundary)
        let delta1 = calculator.handleRotationforMockKnob(knob, selectedAngleDegr: knob.knobStartAngle.radiansToDegrees())
        XCTAssertTrue(delta1 == 0.0)
        //Edge case: selected angle outside knob run boundaries
        let delta2 = calculator.handleRotationforMockKnob(knob, selectedAngleDegr: 200.0)
        XCTAssertTrue(delta2 == 247.145180038223, "Value should have been: \( knob.touchValueInDegrees)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
