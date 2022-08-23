Pod::Spec.new do |spec|
  spec.name         = "RealTimePicker"
  spec.version      = "0.0.5"
  spec.summary      = "Time picker written in Swift"
  spec.description  = "RealTimePicker is a time (hour, minute, second) picker based on UIPickerView."
  spec.homepage     = "https://github.com/toure20/RealTimePicker"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "toure20" => "zholayev.t@gmail.com" }
  spec.source       = { :git => "https://github.com/toure20/RealTimePicker.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = '11.0'
  spec.source_files = "RealTimePicker/**/*.{swift,h,m}"
  spec.swift_version = "4.0"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
end
