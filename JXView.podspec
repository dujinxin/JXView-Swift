Pod::Spec.new do |s|
  s.name             = 'JXView'
  s.version          = '0.0.13'
  s.summary          = 'custom view'
  
  s.homepage         = 'https://github.com/dujinxin/JXView-Swift'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dujinxin' => 'dujinxin8866@163.com' }
  s.source           = { :git => 'https://github.com/dujinxin/JXView-Swift.git', :tag => s.version.to_s }
 

  s.ios.deployment_target = '8.0'
  s.swift_version    = '3.2'
  s.source_files     = 'JXView/Classes/**/*'
end
