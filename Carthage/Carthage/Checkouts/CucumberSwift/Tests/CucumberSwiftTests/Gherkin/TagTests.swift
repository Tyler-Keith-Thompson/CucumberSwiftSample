//
//  TagTests.swift
//  CucumberSwiftTests
//
//  Created by Tyler Thompson on 7/16/18.
//  Copyright © 2018 Tyler Thompson. All rights reserved.
//

import Foundation
import XCTest
@testable import CucumberSwift

class TagTests: XCTestCase {
    let featureFileWithTags: String =
    """
    @featuretag
    Feature: Some terse yet descriptive text of what is desired

       @scenario1tag
       Scenario: Some determinable business situation
         Given a scenario with tags

       Scenario: Some other determinable business situation
         Given a scenario without tags

    """
    
    func testTagsAreScopedAndInheritedCorrectly() {
        let cucumber = Cucumber(withString: featureFileWithTags)
        XCTAssert(cucumber.features.first?.containsTag("featuretag") ?? false)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("featuretag") ?? false)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("scenario1tag") ?? false)
        XCTAssert(!(cucumber.features.first?.scenarios.last?.containsTag("scenario1tag") ?? true))
    }
    
    func testTagedWorkForScenarioOutlines() {
        let cucumber = Cucumber(withString: """
    @scenario1tag
    Feature: Some terse yet descriptive text of what is desired
        @someOtherTag
       Scenario Outline: Some determinable business situation
         Given a <thing> with tags

        Examples:
        |  thing   |
        | scenario |
    """)
        XCTAssertEqual(cucumber.features.first?.scenarios.first?.steps.first?.match, "a scenario with tags")
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("scenario1tag") ?? false)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("someOtherTag") ?? false)
    }
    
    func testMultipleTagsSpaceSeparated() {
        let cucumber = Cucumber(withString: """
    Feature: Some terse yet descriptive text of what is desired
       @scenario1tag @someOtherTag
       Scenario: Some determinable business situation
         Given a scenario with tags
    """)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("scenario1tag") ?? false)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("someOtherTag") ?? false)
    }
    
    func testMultipleTagsNotSeparated() {
        let cucumber = Cucumber(withString: """
    Feature: Some terse yet descriptive text of what is desired
       @scenario1tag@someOtherTag
       Scenario: Some determinable business situation
         Given a scenario with tags
    """)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("scenario1tag") ?? false)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("someOtherTag") ?? false)
    }

    func testMultipleTagsCommaSeparated() {
        let cucumber = Cucumber(withString: """
    Feature: Some terse yet descriptive text of what is desired
       @scenario1tag, @someOtherTag
       Scenario: Some determinable business situation
         Given a scenario with tags
    """)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("scenario1tag") ?? false)
        XCTAssert(cucumber.features.first?.scenarios.first?.containsTag("someOtherTag") ?? false)
    }

    func testLegacyRunWithSpecificTags() {
        Cucumber.shared.features.removeAll()
        Cucumber.shared.parseIntoFeatures(featureFileWithTags)
        Cucumber.shared.environment["CUCUMBER_TAGS"] = "scenario1tag"
        
        var withTagsCalled = false
        Given("a scenario with tags") { _, _ in
            withTagsCalled = true
        }
        var withoutTagsCalled = false
        Given("a scenario without tags") { _, _ in
            withoutTagsCalled = true
        }
        
        Cucumber.shared.executeFeatures()
        
        XCTAssert(withTagsCalled)
        XCTAssertFalse(withoutTagsCalled)
        Cucumber.shared.environment["CUCUMBER_TAGS"] = nil
    }
    
    func testRunWithSpecificTags() {
        Cucumber.shouldRunWith = { _, tags in
            tags.contains("scenario1tag")
        }
        Cucumber.shared.features.removeAll()
        Cucumber.shared.parseIntoFeatures(featureFileWithTags)
        Cucumber.shared.environment["CUCUMBER_TAGS"] = nil
        
        var withTagsCalled = false
        Given("a scenario with tags") { _, _ in
            withTagsCalled = true
        }
        var withoutTagsCalled = false
        Given("a scenario without tags") { _, _ in
            withoutTagsCalled = true
        }
        
        Cucumber.shared.executeFeatures()
        
        XCTAssert(withTagsCalled)
        XCTAssertFalse(withoutTagsCalled)
        Cucumber.shouldRunWith = { _, _ in true }
    }
    
    func testTagOnExamples() {
        Cucumber.shouldRunWith = { _, tags in
            tags.contains("exampleTag")
        }
        Cucumber.shared.features.removeAll()
        Cucumber.shared.parseIntoFeatures("""
        @scenario1tag
        Feature: Some terse yet descriptive text of what is desired
            @someOtherTag
           Scenario Outline: Some determinable business situation
             Given a <thing> with tags

            @exampleTag
            Examples:
            |  thing   |
            | scenario |
        """)
        Cucumber.shared.environment["CUCUMBER_TAGS"] = nil
        
        var stepCalled = false
        Given("a scenario with tags") { _, _ in
            stepCalled = true
        }
        
        Cucumber.shared.executeFeatures()

        XCTAssert(stepCalled)
        
        Cucumber.shouldRunWith = { _, _ in true }
    }
}
