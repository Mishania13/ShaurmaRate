# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ShaurmaRate' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

 pod 'RealmSwift'
 pod 'Cosmos', '~> 21.0'
 post_install do |installer|
 installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
         config.build_settings['LD_NO_PIE'] = 'NO'
     end
  end
end
