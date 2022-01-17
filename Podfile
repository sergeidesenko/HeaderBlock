platform :ios, '14.1'
use_frameworks!

target 'HeaderBlock' do
  pod 'SnapKit', '~> 5.0.1'
  pod 'RxSwift', '~> 5.1.3'
  pod 'RxCocoa', '~> 5.1.3'
  pod 'RxSwiftExt', '~> 5.2.0'
  pod 'RxKeyboard', '~> 1.0'
  pod 'RxAlamofire', '~> 5.3.2'
  pod 'Nuke', '~> 10.3'
  pod 'NukeUI', '~> 0.6.7'
  pod 'Action', '~> 4.0'
  pod 'Apollo', '~> 0.49.1'
  pod 'DeepDiff', '~> 2.3'
  pod 'DifferenceKit', '~> 1.1'
  pod 'ReachabilitySwift', '~> 5.0.0'
  pod 'Foil', '~> 1.0.0'
  pod 'Introspect', '~> 0.1.3'
  pod 'RxCombine', '~> 1'
  
# UI helper libs
  pod 'lottie-ios', '~> 3.2.1'
  pod 'SKPhotoBrowser', '~> 6.1.0'
  pod 'TagListView', '~> 1.0'
  pod 'SwiftRichString', '3.7.1'
  pod 'UICircularProgressRing', '~> 6.5.0'
  pod 'ImageSlideshow', '~> 1.9.0'
  pod 'ImageSlideshow/Alamofire', '~> 1.9.0'
  pod 'SkeletonView', '~> 1.8.7'
  pod 'ScrollingPageControl', '~> 0.1.1'
  pod 'NVActivityIndicatorView', '~> 5.0.1'
  pod 'NYTPhotoViewer', '~> 5.0.5'
  
  pod 'Umbrella', '~> 0.11.0', :subspecs => ['Firebase', 'Amplitude']
  
  pod 'Amplitude', '~> 8.5.0'
  
  pod 'Firebase/Crashlytics', '~> 7.0.0'
  pod 'Firebase/Analytics', '~> 7.0.0'
  pod 'Firebase/Messaging', '~> 7.0.0'
  pod 'Firebase/RemoteConfig', '~> 7.0.0'
  pod 'Firebase/Auth', '~> 7.0.0'

  pod 'FBSDKCoreKit', '~> 9.1.0'
  pod 'FBSDKLoginKit', '~> 9.1.0'
  pod 'FBSDKShareKit', '~> 9.1.0'

  pod 'GoogleSignIn', '~> 5.0.2'
  
  pod 'DeviceKit', '~> 4.1.0'

  pod 'R.swift', '~> 5.3.1'
  pod 'FileKit', '~> 5.2.0'
  pod 'Kingfisher', '~> 7.1'

  pod 'ImageCoordinateSpace', '~> 1.1'

  pod 'TensorFlowLiteSwift', '~> 2.7', :subspecs => ['CoreML', 'Metal']

  pod 'Purchases', '~> 3.13'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

