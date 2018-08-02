Pod::Spec.new do |spec|
  spec.name         = 'SessyStatusIndicator'
  spec.version      = '1.0.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/zshannon/SessyStatusIndicator'
  spec.authors      = { 'Zane Shannon' => 'zane@zaneshannon.com' }
  spec.summary      = 'A nice lil sassy status indicator.'
  spec.source       = { :git => 'https://github.com/zshannon/SessyStatusIndicator.git', :tag => 'v1.0.1' }
  spec.source_files = 'SessyStatusIndicator.swift'
  spec.ios.deployment_target  = '11.0'

  spec.dependency 'Charts'
end
