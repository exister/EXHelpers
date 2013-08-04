Pod::Spec.new do |s|
  s.name         = "EXHelpers"
  s.version      = "0.0.3"
  s.summary      = "Some common helpers"
  s.homepage     = "https://github.com/exister/EXHelpers.git"
  s.license      = 'MIT'
  s.author       = { "Mikhail Kuznetsov" => "mkuznetsov.dev@gmail.com" }
  s.source       = { :git => "https://github.com/exister/EXHelpers.git", :tag => "0.0.3" }
  s.platform     = :ios, '5.0'
  s.source_files = 'Source/ExHelpers/Classes/*.{h,m}'
  s.resource     = 'Source/EXHelpers/Resources/*.{xib,png}'
  s.requires_arc = true

  s.frameworks = 'SystemConfiguration', 'MobileCoreServices', 'CoreLocation', 'MapKit'

  s.dependency 'AFNetworking', '~> 1.0'
  s.dependency 'Reachability'
  s.dependency 'SSToolkit'
  s.dependency 'SSKeychain'
  s.dependency 'CocoaLumberjack'
  s.dependency 'AJNotificationView'
  s.dependency 'MBProgressHUD'
  s.dependency 'SVPullToRefresh'
end