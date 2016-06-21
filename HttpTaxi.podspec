
Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name         = "HttpTaxi"
  s.summary      = "HttpTaxi lets http api request more convenient"
  s.requires_arc = true

  s.version      = "0.1.0"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Quincy Chang" => "quincy0710@hotmail.com" }
  s.homepage     = "https://github.com/skchang0710/HttpTaxi"

  s.source       = { :git => "https://github.com/skchang0710/HttpTaxi.git", :tag => "#{s.version}" }

# s.framework    = ""
# s.dependency ''

  s.source_files  = "HttpTaxi/*.{swift}"

# s.resources     = ""
# s.exclude_files = "Classes/Exclude"

end
