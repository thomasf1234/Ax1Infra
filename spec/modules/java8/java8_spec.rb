require 'spec_helper'

module Java8Spec
  RSpec.describe 'java8' do
    before :all do
      $provisioner.copy_and_execute_site_manifest('spec/modules/java8/manifests/site.pp')
    end

    it "should install openjdk-8-jdk-headless" do
      expect($inspector.package_installed?('openjdk-8-jdk-headless')).to eq(true)
    end

    it "should set JAVA_HOME" do
      expect($inspector.get_environment_variable('JAVA_HOME')).to eq("/usr/lib/jvm/java-8-openjdk-amd64")
    end
  end
end
