Pod::Spec.new do |s|
s.name         = "CleanRequest"
s.version      = "1.0.0"
s.summary      = "Network based on Moya"
s.homepage     = "https://github.com/wangcy90/CleanRequest"
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'WangChongyang' => 'chongyangfly@163.com' }
s.ios.deployment_target = '9.0'
s.source       = { :git => "https://github.com/wangcy90/CleanRequest.git", :tag => s.version }
s.default_subspec = "Core"
s.swift_version = '4.2'
s.cocoapods_version = '>= 1.4.0'

s.subspec "Core" do |ss|
ss.source_files  = "CleanRequest/Core/"
ss.dependency "Moya"
ss.dependency "HandyJSON"
ss.dependency "SwiftyJSON"
end

s.subspec "RxSwift" do |ss|
    ss.source_files = "CleanRequest/RxCleanRequest/"
    ss.dependency "CleanRequest/Core"
    ss.dependency "Moya/RxSwift"
end

end

