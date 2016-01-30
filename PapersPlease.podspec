Pod::Spec.new do |s|
  s.name = 'PapersPlease'
  s.version = '0.3.0'
  s.license = { :type => 'MIT' }
  s.summary = 'A flexible, extensible text validation library written in Swift.'
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.homepage = 'https://github.com/poetmountain/PapersPlease'
  s.social_media_url = 'https://twitter.com/petsound'
  s.authors = { 'Brett Walker' => 'brett@brettwalker.net' }
  s.source = { :git => 'https://github.com/poetmountain/PapersPlease.git', :tag => s.version }
  s.source_files = 'Classes/**/*.swift'
  s.requires_arc = true  
end