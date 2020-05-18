Pod::Spec.new do |s|
  s.name = 'GlideEngine'
  s.version = '1.0.8'
  s.license = 'MIT'
  s.summary = 'Game engine for making 2d games on iOS, macOS and tvOS'
  s.homepage = 'https://github.com/cocoatoucher/Glide'
  s.authors = { 'cocoatoucher' => 'cocoatoucher@posteo.se' }
  s.swift_version = '5.0'
  
  s.ios.deployment_target = '11.4'
  s.osx.deployment_target = '10.14'
  s.tvos.deployment_target = '12.4'
  
  s.source = { :git => 'https://github.com/cocoatoucher/Glide.git', :tag => s.version }
  s.source_files = "Sources/**/*.swift"
  
  s.frameworks  = "Foundation", "CoreGraphics", "SpriteKit"
end
