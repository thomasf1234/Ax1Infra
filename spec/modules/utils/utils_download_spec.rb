require 'spec_helper'

module UtilsDownload
  RSpec.describe 'utils_download' do
    package_name = 'test_package.tgz'

    context "no userpass" do
      context "first download" do
        before :all do
          $inspector.scp("spec/modules/utils/files/samples/#{package_name}", "/tmp/#{package_name}")
          $provisioner.copy_and_execute_site_manifest('spec/modules/utils/manifests/single_download.pp')
        end

        it "downloads the file successfully" do
          expect($inspector.file_exists?("/var/tmp/#{package_name}")).to eq(true)
        end
      end

      context "second download" do
        before :all do
          $inspector.scp("spec/modules/utils/files/samples/#{package_name}", "/tmp/#{package_name}")
          $provisioner.copy_and_execute_site_manifest('spec/modules/utils/manifests/second_download.pp')
        end

        it "skips file download" do
          expect($inspector.file_exists?("/var/tmp/#{package_name}")).to eq(true)
        end
      end
    end
  end
end
