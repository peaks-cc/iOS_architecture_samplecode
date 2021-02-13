Pod::Spec.new do |s|
  s.name = 'GitHubAPI'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '3.0'
  s.version = '0.0.1'
  s.source = { :git => 'git@github.com:OpenAPITools/openapi-generator.git', :tag => 'v0.0.1' }
  s.authors = 'susieyy'
  s.license = 'Proprietary'
  s.homepage = 'https://example.com'
  s.summary = 'GitHubAPIClient'
  s.source_files = 'GitHubAPI/Classes/**/*.swift'
  s.dependency 'Alamofire', '~> 4.9.1'
end
