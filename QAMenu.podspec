Pod::Spec.new do |spec|
  spec.name         = "QAMenu"
  spec.version      = File.read('VERSION')

  spec.summary      = "Reduced data model driven layout renderer tailored to the usage of QA menus and debug menus which are not shipped to end users."
  spec.description  = <<-DESC
    Reduced data model driven layout renderer tailored to the usage of QA menus, debug menus and settings screens which are not shipped to end users, but only used internally.
    Unlike the system settings bundle, it directly lives in your app and is interactive. You can directly retrieve information and execute actions.
                   DESC

  spec.homepage     = "https://github.com/tschob/QAMenu"

  spec.source       = { :git => "https://github.com/tschob/QAMenu.git", :tag => "#{spec.version}" }

  spec.license            = { :type => "MIT", :file => "LICENSE" }
  spec.authors            = { "Hans Seiffert" => "tschob@posteo.de" }

  spec.ios.deployment_target  = '10.0'
  spec.swift_version          = '5.3'
  spec.requires_arc           = true
  
  spec.source_files  = "Sources/QAMenu/**/*.{h,swift}"

  spec.dependency 'QAMenuUtils'

end
