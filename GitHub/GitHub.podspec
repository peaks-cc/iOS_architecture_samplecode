Pod::Spec.new do |s|
s.name             = "GitHub"
s.version          = "0.2.0"
s.license          = 'MIT'
s.source           = { :git => "https://github.com/peaks-cc/iOS_architecture_samplecode.git", :tag => s.version.to_s }
s.homepage = "https://github.com/peaks-cc/iOS_architecture_samplecode"
s.authors = { 'marty-suzuki' => 's1180183@gmail.com' }
s.summary = "GitHub Framework for peaks-cc iOS architecture sample code"
s.ios.deployment_target  = "11.0"
s.swift_version = '5.3'
s.source_files = 'GitHub/**/*.{swift}'
end
