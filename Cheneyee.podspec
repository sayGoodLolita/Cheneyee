Pod::Spec.new do |spec|

  spec.name         = "Cheneyee"
  spec.version      = "1.3.0"
  spec.summary      = "Cheneyee, Any proj"
  spec.description  = <<-DESC
			在巨人的肩膀上搭建 MVVM 架构, 以及基于 Signal 的网络请求
                   DESC
  spec.homepage     = "https://github.com/sayGoodLolita/Cheneyee"
  spec.author             = { "Cheney" => "saygoodlolita@gmail.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/sayGoodLolita/Cheneyee.git", :tag => "1.3.0" }

  spec.license      = "MIT"
  
  spec.dependency "YYModel"
  spec.dependency "ReactiveObjC"
  spec.dependency "IQKeyboardManager"
  spec.dependency "MJRefresh"
  spec.dependency "AFNetworking"
  spec.dependency "IGListKit"


  spec.source_files  = "Cheneyee/Cheneyee/Cheneyee/**/*.{h,m}"
  
end
