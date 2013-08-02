Pod::Spec.new do |s|
  s.name         = "EXHelpers"
  s.version      = "0.0.1"
  s.summary      = "Some common helpers"
  s.homepage     = "https://github.com/exister/EXHelpers.git"
  s.license      = 'MIT'
  s.author       = { "Mikhail Kuznetsov" => "mkuznetsov.dev@gmail.com" }
  s.source       = { :git => "https://github.com/exister/EXHelpers.git", :tag => "0.0.1" }
  s.platform     = :ios, '5.0'
  s.source_files = 'Source/*.{h,m}'
  s.resource     = 'Source/*.xib'
  s.requires_arc = true
  s.dependency 'AFNetworking'
  s.dependency 'AJNotificationView'
end