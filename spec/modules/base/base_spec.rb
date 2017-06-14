require 'spec_helper'

module BaseSpec
  RSpec.describe 'base' do
    before :all do
      $provisioner.copy_and_execute_site_manifest('spec/modules/base/manifests/site.pp')
    end

    it "should install htop" do
      expect($inspector.package_installed?('htop')).to eq(true)
    end

    it "should install ncdu" do
      expect($inspector.package_installed?('ncdu')).to eq(true)
    end

    it "should install vim" do
      expect($inspector.package_installed?('vim')).to eq(true)
    end

    it "should install curl" do
      expect($inspector.package_installed?('curl')).to eq(true)
    end
  end
end
