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


  spec.source_files  = "Cheneyee/Cheneyee/Cheneyee/Cheneyee.h"
  
  spec.subspec "Router" do |ss|
    ss.source_files = "Cheneyee/Cheneyee/Cheneyee/Router/*.{h,m}"
  end
  
  spec.subspec "ViewModel" do |ss|
    ss.source_files = "Cheneyee/Cheneyee/Cheneyee/ViewModel/*.{h,m}"
  end
  
  spec.subspec "DataModel" do |ss|
    ss.source_files = "Cheneyee/Cheneyee/Cheneyee/DataModel/*.{h,m}"
  end

  spec.subspec "ViewController" do |ss|
    ss.source_files = "Cheneyee/Cheneyee/Cheneyee/ViewController/*.{h,m}"
  end
  
  spec.subspec "Category" do |ss|
  
    ss.subspec "UINavigationController" do |sss|
      sss.source_files = "Cheneyee/Cheneyee/Cheneyee/Category/UINavigationController/*.{h,m}"
    end

    ss.subspec "UIScrollView" do |sss|
      sss.source_files = "Cheneyee/Cheneyee/Cheneyee/Category/UIScrollView/*.{h,m}"
    end
    
  end

  spec.subspec "Service" do |ss|
    
    ss.subspec "HTTP" do |sss|
      sss.source_files = "Cheneyee/Cheneyee/Cheneyee/Service/HTTP/CYHTTPService.{h,m}"
      sss.subspec "Request" do |ssss|
        ssss.source_files = "Cheneyee/Cheneyee/Cheneyee/Service/HTTP/Request/*.{h,m}"
      end
      sss.subspec "Response" do |ssss|
        ssss.source_files = "Cheneyee/Cheneyee/Cheneyee/Service/HTTP/Response/*.{h,m}"
      end
      sss.subspec "Category" do |ssss|
        ssss.source_files = "Cheneyee/Cheneyee/Cheneyee/Service/HTTP/Category/*.{h,m}"
      end
      sss.subspec "Constant" do |ssss|
        ssss.source_files = "Cheneyee/Cheneyee/Cheneyee/Service/HTTP/Constant/CYHTTPServiceConstant.h"
      end
    end
    
    ss.subspec "IAP" do |sss|
      sss.source_files = "Cheneyee/Cheneyee/Cheneyee/Service/IAP/*.{h,m}"
    end
    
  end
  
  spec.subspec "Utils" do |ss|
  
    ss.subspec "FileManager" do |sss|
      sss.source_files = "Cheneyee/Cheneyee/Cheneyee/Utils/FileManager/*.{h,m}"
    end
    
    ss.subspec "Tool" do |sss|
      sss.source_files = "Cheneyee/Cheneyee/Cheneyee/Utils/Tool/*.{h,m}"
    end
    
  end
  
end
