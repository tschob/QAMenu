Pod::Spec.new do |spec|
  spec.name         = "QAMenuSwiftUI"
  spec.version      = File.read('VERSION')

  spec.summary      = "QAMenu renderer based on SwiftUI."
  spec.description  = <<-DESC
    [Alpha] QAMenu renderer based on SwiftUI. Contains all SwiftUI related UI to present a QA menu.
                   DESC

  spec.homepage     = "https://github.com/tschob/QAMenu"

  spec.source       = { :git => "https://github.com/tschob/QAMenu.git", :tag => "#{spec.version}" }

  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.authors            = { "Hans Seiffert" => "tschob@posteo.de" }

  spec.ios.deployment_target  = '14.0'
  spec.swift_version          = '5.3'
  spec.requires_arc           = true

  spec.frameworks = 'SwiftUI'
  
  spec.source_files  = "Sources/QAMenuSwiftUI/**/*.{h,swift,xib}"

  spec.resource_bundles = {
     'QAMenuSwiftUIResources' => ["Sources/QAMenuSwiftUI/Resources/**/*"]
  }

  spec.dependency 'QAMenu'
  # QAMenuCatalog and QAMenuExampleItems are used for SwiftUI previews
  spec.dependency 'QAMenuCatalog'
  spec.dependency 'QAMenuExampleItems'

end
