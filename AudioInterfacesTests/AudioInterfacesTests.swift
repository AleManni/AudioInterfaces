//
//  AudioInterfacesTests.swift
//  AudioInterfacesTests
//
//  Created by Carolina Gigler on 12/06/2016.
//  Copyright © 2016 Alessandro Manni. All rights reserved.
//

import XCTest
@testable import AudioInterfaces

class AudioInterfacesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let testKnob = SimpleKnob()
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
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
