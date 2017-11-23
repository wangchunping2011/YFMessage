Pod::Spec.new do |s|
  s.name         = "YFMessage"
  s.version      = "1.0.0"
  s.summary      = "对UIAlertController和MBProgressHUD的二次封装，实现一句代码快速调用"
  s.homepage     = "https://github.com/DandreYang/YFMessage"
  s.license      = "MIT"
  s.author             = { "‘Dandre’" => "mkshow@126.com" }
  s.social_media_url   = "https://yangfeng.pw"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DandreYang/YFMessage.git", :tag => "#{s.version}" }
  s.source_files  = "YFMessage/**/*.{h,m}"
  s.public_header_files = "YFMessage/**/*.h"

  s.dependency 'MBProgressHUD', '~> 0.9'
end