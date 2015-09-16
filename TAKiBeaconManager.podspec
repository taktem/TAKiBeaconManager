#
#  Be sure to run `pod spec lint TAKAlertUtil.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "TAKiBeaconManager"
  s.version      = "0.1"
  s.summary      = "iBeacon Handler"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.homepage     = "https://github.com/taktem/TAKiBeaconManager"
  s.author       = { "SOMTD" => "totem.kc[at]me.com" }
  s.source       = { :git => "https://github.com/taktem/TAKiBeaconManager.git", :tag => "#{s.version}" }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.framework  = 'CoreLocation', "CoreBluetooth"
  s.source_files = 'TAKiBeaconManager/**/*.{h,m}'
  s.public_header_files = 'TAKiBeaconManager/**/*.{h}'
end
