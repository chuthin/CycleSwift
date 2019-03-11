Pod::Spec.new do |spec|
  spec.name         = "CycleSwift"
  spec.version      = "1.0.0"
  spec.summary      = "An implement Cycle.js"
  spec.description  = "An implement Cycle.js with Swift, RxSwif, Stylist"

  spec.homepage     = "https://github.com/chuthin/CycleSwift"
  spec.license      = "MIT"
  spec.author             = { "Chu Thin" => "thincv@live.com" }
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/chuthin/CycleSwift.git", :tag => "#{spec.version}" }

  spec.source_files  = "CycleSwift/**/*.{swift}"
  spec.framework  = "UIKit"
  # spec.framework  = "SomeFramework"
  # spec.dependency "JSONKit", "~> 1.4"
  spec.dependency "RxSwift"
  spec.dependency "RxCocoa"
  spec.dependency "Alamofire"
  spec.dependency "Stylist"
end
