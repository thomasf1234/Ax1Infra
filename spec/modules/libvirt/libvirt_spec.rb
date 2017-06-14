require 'spec_helper'

module LibvirtSpec
  RSpec.describe 'libvirt' do
    before :all do
      $provisioner.copy_and_execute_site_manifest('spec/modules/libvirt/manifests/site.pp')
    end

    it "should install qemu-kvm" do
      expect($inspector.package_installed?('qemu-kvm')).to eq(true)
    end

    it "should install libvirt-bin" do
      expect($inspector.package_installed?('libvirt-bin')).to eq(true)
    end

    it "should install bridge-utils" do
      expect($inspector.package_installed?('bridge-utils')).to eq(true)
    end

    it "should install virt-manager" do
      expect($inspector.package_installed?('virt-manager')).to eq(true)
    end
  end
end
