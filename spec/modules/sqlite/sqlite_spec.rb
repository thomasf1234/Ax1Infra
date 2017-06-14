require 'spec_helper'

module SqliteSpec
  RSpec.describe 'sqlite' do
    before :all do
      $provisioner.copy_and_execute_site_manifest('spec/modules/sqlite/manifests/site.pp')
    end

    it "should install sqlite3" do
      expect($inspector.package_installed?('sqlite3')).to eq(true)
    end

    it "should install libsqlite3-dev" do
      expect($inspector.package_installed?('libsqlite3-dev')).to eq(true)
    end
  end
end
