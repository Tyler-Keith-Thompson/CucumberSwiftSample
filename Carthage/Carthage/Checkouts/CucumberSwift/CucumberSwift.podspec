Pod::Spec.new do |s|
    s.name             = 'CucumberSwift'
    s.version          = '3.1.1'
    s.summary          = 'A lightweight swift only cucumber implementation.'

    s.description      = <<-DESC
  This is a swift only cucumber implementation. This particular implementation contains feature, scenario and step level hooks that Cucumberish does not and has the added benefit of not requiring an objective-c bridging header 
                         DESC
  
    s.homepage         = 'https://github.com/Tyler-Keith-Thompson/CucumberSwift'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Tyler Thompson' => 'Tyler.Thompson@Asynchrony.com' }
    s.source           = { :git => 'https://github.com/Tyler-Keith-Thompson/CucumberSwift.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.9'
    s.tvos.deployment_target = '9.0'
    s.swift_version = '5.0'
  
    s.source_files = 'Sources/**/*.{swift,h,m}'
    s.resources = ["Sources/**/*.{json}"]

    s.subspec 'snippets' do |ss| 
      ss.resources = ["Sources/**/*.{codesnippet,sh}"]
    end
    s.subspec 'syntax' do |ss| 
      ss.resources = ["Sources/CucumberSwift/Gherkin/**/*.{xclangspec,sh,ideplugin}"]
    end
    s.framework = "XCTest"
    s.pod_target_xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks"',
    }
end
  