Pod::Spec.new do |spec|
  spec.name         = "QAMenuCatalog"
  spec.version      = File.read('VERSION')

  spec.summary      = "Collection of simple QAMenu items."
  spec.description  = <<-DESC
    Collection of simple QAMenu items for very common debug information like app version, info plist entries etc. 
                   DESC

  spec.homepage     = "https://github.com/tschob/QAMenu"

  spec.source       = { :git => "https://github.com/tschob/QAMenu.git", :tag => "#{spec.version}" }

  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.authors            = { "Hans Seiffert" => "tschob@posteo.de" }

  spec.ios.deployment_target  = '13.0'
  spec.swift_version          = '5.10'
  spec.requires_arc           = true

  spec.source_files  = "Sources/QAMenuCatalog/**/*.{h,swift}"

  spec.dependency 'QAMenu'

end
