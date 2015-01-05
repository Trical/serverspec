require 'spec_helper'

packages = [
  'libselinux-python']

  describe "CentOS Operating System Checks for #{ENV['TARGET_HOST']}" do

    packages.each do|p|
      describe package(p) do
        it { should be_installed }
      end
    end

    describe "Core services should be running" do
      describe service('sshd') do
        it { should be_enabled   }
        it { should be_running   }
      end

      describe port(22) do
        it { should be_listening }
      end

    end

    describe "The network should be configured properly" do

      property[:networks].each do |p|
        describe command("cat /sys/class/net/eth#{p['device_id']}/address") do
          its(:stdout) {should include "#{p['mac_address'].downcase}" }
        end

        describe interface("eth#{p['device_id']}") do
          #its(:speed) { should eq 1000 }
          it { should have_ipv4_address("#{p['ip_address']}/24") }
        end
      end

      describe default_gateway do
        its(:ipaddress) { should eq "#{property[:default_gateway]}" }
      end

    end #Network
end