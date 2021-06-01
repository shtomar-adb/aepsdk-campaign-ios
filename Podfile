platform :ios, '10.0'
use_frameworks!

project 'AEPCampaign.xcodeproj'

# POD groups

def campaign_core_dependencies
   pod 'AEPCore', :git => 'git@github.com:adobe/aepsdk-core-ios.git', :branch => 'dev-v3.1.4'
   pod 'AEPServices', :git => 'git@github.com:adobe/aepsdk-core-ios.git', :branch => 'dev-v3.1.4'
   pod 'AEPIdentity', :git => 'git@github.com:adobe/aepsdk-core-ios.git', :branch => 'dev-v3.1.4'
end

def rulesengine
   pod 'AEPRulesEngine', :git => 'git@github.com:adobe/aepsdk-rulesengine-ios.git', :branch => 'dev-v1.0.2'
end

def assurance
   pod 'ACPCore', :git => 'git@github.com:adobe/aepsdk-compatibility-ios.git', :branch => 'main'
   pod 'AEPAssurance'
end

def user_profile
   pod 'AEPUserProfile', :git => 'git@github.com:adobe/aepsdk-userprofile-ios.git', :branch => 'dev-v3.0.0'
end

def core_additional_dependecies
   pod 'AEPLifecycle', :git => 'git@github.com:adobe/aepsdk-core-ios.git', :branch => 'dev-v3.1.4'
   pod 'AEPSignal', :git => 'git@github.com:adobe/aepsdk-core-ios.git', :branch => 'dev-v3.1.4'
end

target 'AEPCampaign' do
   campaign_core_dependencies
   rulesengine   
end

target 'AEPCampaignUnitTests' do
   campaign_core_dependencies
   rulesengine
end

target 'AEPCampaignFunctionalTests' do
  campaign_core_dependencies
  rulesengine
  user_profile
  core_additional_dependecies 
end

target 'CampaignTester' do
   campaign_core_dependencies
   rulesengine
   user_profile
   core_additional_dependecies   
   assurance
end
