#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint region_settings.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'region_settings'
  s.version          = '0.0.1'
  s.summary          = 'region_settings'
  s.description      = <<-DESC
A Flutter plugin to get device region settings such as measurement system, temperature units, and date formats.
                       DESC
  s.homepage         = 'https://www.nathanatos.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nathan Cosgray' => 'nathanatos@nathanatos.com' }
  s.source           = { :path => '.' }
  s.source_files = 'region_settings/Sources/region_settings/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
