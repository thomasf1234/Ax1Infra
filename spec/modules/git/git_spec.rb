require 'spec_helper'

module GitSpec
  RSpec.describe 'git' do
    before :all do
      $provisioner.copy_and_execute_site_manifest('spec/modules/git/manifests/site.pp')
    end

    it "should install git" do
      expect($inspector.package_installed?('git')).to eq(true)
    end
  end
end
