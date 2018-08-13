#
#  Be sure to run `pod spec lint WZUVideoPlayer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "WZUVideoPlayer"
s.summary = "WZUVideoPlayer is a Video Player Controller with zoom capabilities over AVPlayer."
s.requires_arc = false

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Sylvain Bouchard" => "sylvain@waizulabs.com" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/waizuLabs/WZUVideoPlayer"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/waizuLabs/WZUVideoPlayer.git", :tag => "#{s.version}"}

# 7
s.framework = "UIKit", "AVFoundation"
s.dependency 'ASBPlayerScrubbing', '~> 0.1'

# 8
s.source_files = "WZUVideoPlayer/**/*.{swift}"

# 9
s.resources = "WZUVideoPlayer/**/*.{png,jpeg,jpg,storyboard,xib}"
end
