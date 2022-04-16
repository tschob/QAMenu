Pod::Spec.new do |spec|
  spec.name         = "QAMenuExampleItems"
  spec.version      = File.read('VERSION')

  spec.summary      = "Example QAMenu configurations."
  spec.description  = <<-DESC
    Collection of example QAMenu configurations. Internally used for the example apps and SwiftUI previews. 
                   DESC

  spec.homepage     = "https://github.com/tschob/QAMenu"

  spec.source       = { :git => "https://github.com/tschob/QAMenu.git", :tag => "#{spec.version}" }

  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.authors            = { "Hans Seiffert" => "tschob@posteo.de" }

  spec.ios.deployment_target  = '10.0'
  spec.swift_version          = '5.3'
  spec.requires_arc           = true

  spec.source_files  = "Sources/QAMenuExampleItems/**/*.{h,swift}"

  spec.dependency 'QAMenu'

end
