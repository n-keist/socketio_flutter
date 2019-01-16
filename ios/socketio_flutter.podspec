#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'socketio_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Connect to socket.io Servers with Flutter'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
                       s.homepage         = 'https://n-keist.de'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'n-keist' => 'n.keist@icloud.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Starscream', '~> 3.0.2'
  s.dependency 'Socket.IO-Client-Swift', '~> 13.3.0'

  s.ios.deployment_target = '8.0'
end

