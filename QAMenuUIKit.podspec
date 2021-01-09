Pod::Spec.new do |spec|
  spec.name         = "QAMenuUIKit"
  spec.version      = File.read('VERSION')

  spec.summary      = "QAMenu renderer based on UIKit."
  spec.description  = <<-DESC
    QAMenu renderer based on UIKit. Contains all UI related UI to present a QA menu.
                   DESC

  spec.homepage     = "https://github.com/tschob/QAMenu"

  spec.source       = { :git => "https://github.com/tschob/QAMenu.git", :tag => "#{spec.version}" }

  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.authors            = { "Hans Seiffert" => "tschob@posteo.de" }

  spec.ios.deployment_target  = '10.0'
  spec.swift_version          = '5.3'
  spec.requires_arc           = true

  spec.frameworks = 'UIKit'
  
  spec.source_files  = "Sources/QAMenuUIKit/**/*.{h,swift,xib}"

  spec.resource_bundles = {
     'QAMenuUIKitResources' => ["Sources/QAMenuUIKit/Resources/**/*"]
  }

  spec.dependency 'QAMenu'

end
