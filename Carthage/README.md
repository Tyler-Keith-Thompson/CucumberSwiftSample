## Welcome to the CucumberSwift Carthage sample!
This sample project is a detailed description of exactly the steps taken (in which order) to get CucumberSwift set up with a very basic iOS application. 

> NOTE: CucumberSwift is a test runner, while this project chose to use XCUITest as the mechanism for executing those tests it could've been a unit test.

### Steps:
- Create a new Xcode project (in this case I chose iOS -> "App")
- Make sure to tick the "include tests" checkbox, or you'll have to [add the test targets yourself](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/WorkingwithTargets.html) later. 
- Let's get Carthage up and running, in your project directory create a `Cartfile` file. Add the following line: `github "Tyler-Keith-Thompson/CucumberSwift"`
- From a terminal run `carthage update`
- From a terminal run `carthage build --platform iOS`
- In your Xcode project navigate to the "Build Phases" tab of your test target
- Add a new "Copy Files" phase
  - In the dropdown ensure that "Frameworks" is selected
  - Select "Add Other" -> "Add Files"
  - Navigate to Carthage -> Build -> iOS, select CucumberSwift.framework
- Expand the "Link Binary with Libraries" panel, click the plus button
  - In the dropdown select "Add Other" -> "Add Files"
  - Navigate to Carthage -> Build -> iOS, select CucumberSwift.framework
- In your "Build Settings" search for "validate workspace" and ensure it is set to "yes"
- Create the folder that'll hold your .feature files. 
  - NOTE: This folder name is case sensitive by default CucumberSwift looks for "Features". In order to showcase this sample in full I created a folder named "AppFeatures". 
  - NOTE: I chose to add this to the {Project}UITests folder
- In your project right click (or control click) on the {Project}UITests folder and select "Add files to {targetName}"
  - Ensure the correct target is selected, you want your testing target
  - Make certain that "Create Folder Reference" is selected, not "Create Groups"
  - Make sure "Copy items if needed" is UNCHECKED
  - NOTE: I had a weird experience with the Xcode 12.3 on macOS 11.1 one where I had to resize the window in order to select my "AppFeatures" folder
- Run your tests so that everything builds. Shortcut Command + U
- Open the xcode generated .swift file, it should be named something like `{Project}UITests.swift`
- Erase the contents
- Add the following lines:
```swift
import XCTest
import CucumberSwift

extension Cucumber: StepImplementation {
    public var bundle: Bundle {
        class Findme { }
        return Bundle(for: Findme.self) //This is just my shortcut way of identifying the test bundle, you do you. This bundle needs to contain the folder reference we added
    }

    public func setupSteps() {

    }
}
```
- If you run your tests again at this point you should have 1 test executing, the suite is named "CucumberSwift" and the test is named "testGherkin()"
- Let's add a `.feature` file to our folder reference
  - I named mine `FirstFeature.feature` its contents looked like this:
  ```gherkin
  Feature: A feature we would like to describe

    Scenario: A single scenario
        Given CucumberSwift is setup correctly
        When I execute these tests
        Then I can pull generated code from the report explorer and get things set up
  ```
- If you named your folder "Features" (case sensitive!) then you may skip the next step, otherwise continue
  - Because our folder has a different name than CucumberSwift searches for by default we need to tell it where to look. Open the `info.plist` file located in your {Project}UITests target. You can do this in the folder navigator or the project navigator, whatever you want
  - Add a property to the plist named `FeaturesPath`
  - The type should be `string` already, but if it's not, make sure it is
  - Set the value to the relative path to your features folder in my case `AppFeatures`
- Run the tests
  - NOTE: At this point you should see your feature and scenario in your test results.
- To make your life easier CucumberSwift actually generates step stub implementations. Open your [report navigator](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/xcode_guide-continuous_integration/view_integration_results.html) in Xcode
- Find your test run, it'll be named something like {Project}UITests. Then select "tests". Make sure the "all" tab is selected. 
- Expand the step named "GenerateStepStubsIfNecessary". Expand the "Pending Steps" tree section. Open the file named "GENERATED_Unimplemented_Step_Definitions.swift"
- Copy the contents
- Paste them into your `setupSteps()` method from before, mine looks like this:
```swift
public func setupSteps() {
    Given("^CucumberSwift is setup correctly$") { _, _ in

    }
    When("^I execute these tests$") { _, _ in

    }
    Then("^I can pull generated code from the report explorer and get things set up$") { _, _ in

    }
}
```
- This is where your execution code is going to go, what you put in there is entirely up to you and beyond the scope of this tutorial. Because this was an `XCUITest` target it seems probable you're going to stick `XCUITest` code in there.
- To help you get started in your `setupSteps()` method you can do something like the following:
```swift
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
```

Hopefully that helps you get started on your journey using CucumberSwift with Carthage. If you have questions or comments please use [the official CucumberSwift repo](https://github.com/Tyler-Keith-Thompson/CucumberSwift) to submit an issue or start a discussion.