Pod::Spec.new do |s|
    s.name = "Desk360"
    s.version = "1.3.4"
    s.summary = "Desk360 iOS SDK"
    s.description = <<-DESC
    Desk360 iOS SDK [WIP]
    DESC
    s.homepage = "https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk"
    s.license = { :type => "Commercial", :file => "LICENSE" }
    s.social_media_url = "http://www.teknasyon.com/"
    s.authors = { "Teknasyon" => "http://www.teknasyon.com/" }
    s.module_name  = "Desk360"
    s.source = { :git => "https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk.git", :tag => s.version }
    s.source_files = "Sources/**/*.swift"
    s.ios.resource_bundle = { "Desk360Assets" => "Assets/Desk360Assets.bundle/Images" }
    s.resource_bundle = { "Desk360" => ["Assets/*.lproj/*.strings"] }
    s.swift_version = "5.0"
    s.requires_arc = true
    s.ios.deployment_target = "10.0"

    s.dependency "SnapKit"
    s.dependency "Moya", '13.0.1'
    s.dependency "PersistenceKit"
    s.dependency "DeviceKit"
    s.dependency "NVActivityIndicatorView", "4.8.0"
end
