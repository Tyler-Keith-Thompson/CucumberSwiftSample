//
//  CucumberSwiftSampleUITests.swift
//  CucumberSwiftSampleUITests
//
//  Created by Tyler Thompson on 1/16/21.
//

import XCTest
import CucumberSwift

extension Cucumber: StepImplementation {
    public var bundle: Bundle {
        class Findme { }
        return Bundle(for: Findme.self)
    }

    public func setupSteps() {
        let app = XCUIApplication()
        BeforeScenario { (_) in
            app.launch()
        }
        Given("^CucumberSwift is setup correctly$") { _, _ in

        }
        When("^I execute these tests$") { _, _ in

        }
        Then("^I can pull generated code from the report explorer and get things set up$") { _, _ in

        }
    }
}
