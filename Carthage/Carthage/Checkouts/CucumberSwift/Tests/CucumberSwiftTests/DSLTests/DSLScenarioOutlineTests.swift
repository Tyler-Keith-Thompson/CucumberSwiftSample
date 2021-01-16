//
//  DSLScenarioOutline.swift
//  CucumberSwiftTests
//
//  Created by thompsty on 7/23/20.
//  Copyright © 2020 Tyler Thompson. All rights reserved.
//

import Foundation
import XCTest
@testable import CucumberSwift

class DSLScenarioOutlineTests: XCTestCase {
    
    override func setUp() {
        Cucumber.shared.features.removeAll()
    }
    
    func testScenarioOutlineCallsThroughForEveryRowInExamples() {
        var called = 0
        var args = [Any]()
        
        let callback:(Any) -> Void = { arg in
            called += 1
            args.append(arg)
        }
        Feature("") {
            ScenarioOutline("SomeTitle", headers: (first:String, last:String, balance:Double).self,
                            steps: { (first, last, balance) in
                Given(I: callback((first: first, last: last, balance: balance)))
            }, examples: {
                [
                    (first: "John", last: "Doe", balance: 0),
                    (first: "Jane", last: "Doe", balance: 10.50),
                ]
            })
        }
        
        Cucumber.shared.executeFeatures()
        
        let firstScenario = Cucumber.shared.features.first?.scenarios.first
        let lastScenario = Cucumber.shared.features.first?.scenarios.last
        XCTAssertEqual(firstScenario?.title, "SomeTitle")
        XCTAssertEqual(lastScenario?.title, "SomeTitle")
        XCTAssertEqual(firstScenario?.location.line, 28)
        XCTAssertEqual(lastScenario?.location.line, 28)
        XCTAssertEqual(firstScenario?.location.column, 28)
        XCTAssertEqual(lastScenario?.location.column, 28)

        XCTAssertEqual(called, 2)
        let firstStep = args.first as? (first:String, last:String, balance:Double)
        XCTAssertEqual(firstStep?.first, "John")
        XCTAssertEqual(firstStep?.last, "Doe")
        XCTAssertEqual(firstStep?.balance, 0)
        
        let lastStep = args.last as? (first:String, last:String, balance:Double)
        XCTAssertEqual(lastStep?.first, "Jane")
        XCTAssertEqual(lastStep?.last, "Doe")
        XCTAssertEqual(lastStep?.balance, 10.50)
    }
    
    func testScenarioOutlineCallsThroughForEveryRowInExamplesWithMultipleSteps() {
        var called = 0
        var args = [Any]()
        
        let callback:(Any) -> Void = { arg in
            called += 1
            args.append(arg)
        }
        Feature("") {
            ScenarioOutline("SomeTitle", headers: (first:String, last:String, balance:Double).self,
                            steps: { (first, last, balance) in
                Given(I: print("Hello World!"))
                Then(I: callback((first: first, last: last, balance: balance)))
            }, examples: {
                [
                    (first: "John", last: "Doe", balance: 0),
                    (first: "Jane", last: "Doe", balance: 10.50),
                ]
            })
        }
        
        Cucumber.shared.executeFeatures()
        
        let firstScenario = Cucumber.shared.features.first?.scenarios.first
        let lastScenario = Cucumber.shared.features.first?.scenarios.last
        XCTAssertEqual(firstScenario?.title, "SomeTitle")
        XCTAssertEqual(lastScenario?.title, "SomeTitle")
        XCTAssertEqual(firstScenario?.location.line, 71)
        XCTAssertEqual(lastScenario?.location.line, 71)
        XCTAssertEqual(firstScenario?.location.column, 28)
        XCTAssertEqual(lastScenario?.location.column, 28)

        XCTAssertEqual(called, 2)
        let firstStep = args.first as? (first:String, last:String, balance:Double)
        XCTAssertEqual(firstStep?.first, "John")
        XCTAssertEqual(firstStep?.last, "Doe")
        XCTAssertEqual(firstStep?.balance, 0)
        
        let lastStep = args.last as? (first:String, last:String, balance:Double)
        XCTAssertEqual(lastStep?.first, "Jane")
        XCTAssertEqual(lastStep?.last, "Doe")
        XCTAssertEqual(lastStep?.balance, 10.50)
    }
    
    func testScenarioOutlineWithTags() {
        var called = 0
        var args = [Any]()
        
        let callback:(Any) -> Void = { arg in
            called += 1
            args.append(arg)
        }
        Feature("") {
            ScenarioOutline("SomeTitle",
                            tags: ["tag1", "tag2"],
                            headers: (first:String, last:String, balance:Double).self,
                            steps: { (first, last, balance) in
                Given(I: callback((first: first, last: last, balance: balance)))
            }, examples: {
                [
                    (first: "John", last: "Doe", balance: 0),
                    (first: "Jane", last: "Doe", balance: 10.50),
                ]
            })
        }
        
        Cucumber.shared.executeFeatures()
        
        let firstScenario = Cucumber.shared.features.first?.scenarios.first
        let lastScenario = Cucumber.shared.features.first?.scenarios.last
        XCTAssertEqual(firstScenario?.title, "SomeTitle")
        XCTAssertEqual(lastScenario?.title, "SomeTitle")
        XCTAssertEqual(firstScenario?.location.line, 115)
        XCTAssertEqual(lastScenario?.location.line, 115)
        XCTAssertEqual(firstScenario?.location.column, 28)
        XCTAssertEqual(lastScenario?.location.column, 28)
        XCTAssertEqual(firstScenario?.tags, ["tag1", "tag2"])
        XCTAssertEqual(lastScenario?.tags, ["tag1", "tag2"])
    }
    
    func testScenarioOutlineWithChangingTitle() {
        var called = 0
        var titles = [String]()
        
        let title:(String) -> String = { arg in
            called += 1
            titles.append(arg)
            return arg
        }
        Feature("") {
            ScenarioOutline({ title($0.first) },
                            tags: ["tag1", "tag2"],
                            headers: (first:String, last:String, balance:Double).self,
                            steps: { (first, last, balance) in
                Given(I: print(""))
            }, examples: {
                [
                    (first: "John", last: "Doe", balance: 0),
                    (first: "Jane", last: "Doe", balance: 10.50),
                ]
            })
        }
        
        Cucumber.shared.executeFeatures()
        
        let firstScenario = Cucumber.shared.features.first?.scenarios.first
        let lastScenario = Cucumber.shared.features.first?.scenarios.last
        XCTAssertEqual(firstScenario?.title, "John")
        XCTAssertEqual(lastScenario?.title, "Jane")
    }
    
    func testScenarioOutlineWithMultipleStepsAndChangingTitle() {
        var called = 0
        var titles = [String]()
        
        let title:(String) -> String = { arg in
            called += 1
            titles.append(arg)
            return arg
        }
        Feature("") {
            ScenarioOutline({ title($0.first) },
                            tags: ["tag1", "tag2"],
                            headers: (first:String, last:String, balance:Double).self,
                            steps: { (first, last, balance) in
                Given(I: print(""))
                Then(I: print(""))
            }, examples: {
                [
                    (first: "John", last: "Doe", balance: 0),
                    (first: "Jane", last: "Doe", balance: 10.50),
                ]
            })
        }
        
        Cucumber.shared.executeFeatures()
        
        let firstScenario = Cucumber.shared.features.first?.scenarios.first
        let lastScenario = Cucumber.shared.features.first?.scenarios.last
        XCTAssertEqual(firstScenario?.title, "John")
        XCTAssertEqual(lastScenario?.title, "Jane")
    }
}
