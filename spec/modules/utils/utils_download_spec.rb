require 'spec_helper'

module UtilsDownload
  RSpec.describe 'utils_download' do
    package_name = 'test_package.tgz'

    context "no userpass" do
      context "default owner and permissions" do
        before :all do
          $inspector.scp("spec/modules/utils/files/samples/#{package_name}", "/tmp/#{package_name}")
          $provisioner.copy_and_execute_site_manifest('spec/modules/utils/manifests/single_download.pp')
        end

        it "downloads the file successfully" do
          expect($inspector.file_exists?("/var/tmp/#{package_name}")).to eq(true)

          file_info = $inspector.file_info("/var/tmp/#{package_name}")
          expect(file_info[:chmod]).to eq("-rw-rw-r--")
          expect(file_info[:owner]).to eq("root")
          expect(file_info[:group]).to eq("root")
        end
      end

      context "different perssions" do
        before :all do
          $inspector.scp("spec/modules/utils/files/samples/#{package_name}", "/tmp/#{package_name}")
          $provisioner.copy_and_execute_site_manifest('spec/modules/utils/manifests/different_permissions.pp')
        end

        it "downloads the file successfully" do
          expect($inspector.file_exists?("/var/tmp/#{package_name}")).to eq(true)

          file_info = $inspector.file_info("/var/tmp/#{package_name}")
          expect(file_info[:chmod]).to eq("-rwxrwxrwx")
          expect(file_info[:owner]).to eq("nobody")
          expect(file_info[:group]).to eq("nogroup")
        end
      end
    end
  end
end
