Pod::Spec.new do |s|
  s.name             = 'JXView'
  s.version          = 'v0.0.3’
  s.summary          = 'custom view'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/dujinxin/JXView-Swift'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dujinxin' => 'dujinxin8866@163.com' }
  s.source           = { :git => 'https://github.com/dujinxin/JXView.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'

  s.source_files = 'JXView/Classes/**/*'
end
