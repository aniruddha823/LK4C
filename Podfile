# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Equiteez' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Equiteez

  target 'EquiteezTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'EquiteezUITests' do
    # Pods for testing
  end

  pod 'Alamofire', '~> 4.7'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'DropDown'
  pod 'SearchTextField'
  pod 'Charts'
  pod 'ChartsRealm'
  pod 'FaveButton'
  pod 'DLRadioButton', '~> 1.4'
  pod 'FSPagerView'
  pod 'SDWebImage', '~> 5.0'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SPStorkController'
  pod 'SPFakeBar'
  pod 'SwiftDataTables'
  pod 'CollectionViewSlantedLayout', '~> 3.1'
  pod 'BetterSegmentedControl', '~> 1.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
