Pod::Spec.new do |s|

  s.name         = "XDUICommon"
  s.version      = "2.0.0"
  s.summary      = "Shared UI code for xDesign Swift apps."

  s.description  = <<-DESC
                   Shared UI code for xDesign Swift apps such as base TableViewController.
                   DESC

  s.homepage     = "https://espc.com"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  #s.author         = { "Timothy Brand-Spencer" => "tim@xdesign.com" }
  s.author         = { "MTC" => "apps@mtcmedia.co.uk" }

  # s.platform     = :ios
  s.platform     = :ios, "10.0"
  # s.ios.deployment_target = "9.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.swift_version = "5.0"

  s.source       = { :git => "ssh://git@git.espc.com:33/espcapp-ioscommon", :tag => "#{s.version}" }

  s.source_files  = "XDUICommon/**/*.swift"
  # s.resources     = "XDUICommon/**/*.xib"

end
