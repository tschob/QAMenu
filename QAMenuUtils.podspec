Pod::Spec.new do |spec|
  spec.name         = "QAMenuUtils"
  spec.version      = File.read('VERSION')

  spec.summary      = "Framework with Helper code for QAMenu."
  spec.description  = <<-DESC
    Framework with Helper code for QAMenu. The collection is inteded for internal use only.
    Classes which are used in a public interface of QAMenu, QAMenuUIKit or QAMenuCatalog should not be part of this framework.
                   DESC

  spec.homepage     = "https://github.com/tschob/QAMenu"

  spec.source       = { :git => "https://github.com/tschob/QAMenu.git", :tag => "#{spec.version}" }

  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.authors            = { "Hans Seiffert" => "tschob@posteo.de" }

  spec.ios.deployment_target  = '13.0'
  spec.swift_version          = '5.10'
  spec.requires_arc           = true
  
  spec.source_files  = "Sources/QAMenuUtils/**/*.{h,swift}"

end
