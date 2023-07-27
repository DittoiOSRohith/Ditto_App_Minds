# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Ditto' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
     pod 'FastSocket'
     pod 'CryptoSwift'
  # Pods for Ditto

  target 'DittoTests' do
    inherit! :search_paths
    # Pods for testing
  end

target 'DittoDev' do
     pod 'FastSocket'
     pod 'CryptoSwift'
end

target 'DittoDev11' do
     pod 'FastSocket'
     pod 'CryptoSwift'
end

target 'DittoQA' do
     pod 'FastSocket'
     pod 'CryptoSwift'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
end
