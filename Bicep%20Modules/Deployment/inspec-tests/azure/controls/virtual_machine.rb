# impact is a string, or numeric that measures the importance of the compliance results. Valid strings for impact are none, low, medium, high, and critical. The values are based off CVSS 3.0. A numeric value must be between 0.0 and 1.0. The value ranges are:
# 0.0 to <0.01 these are controls with no impact, they only provide information
# 0.01 to <0.4 these are controls with low impact
# 0.4 to <0.7 these are controls with medium impact
# 0.7 to <0.9 these are controls with high impact
# 0.9 to 1.0 these are critical controls


resources = yaml(content: inspec.profile.file('virtual_machines.yml')).params
control 'azure_virtual_machine' do
    impact 0.6
    title 'Azure: Confirm standard deployment of virtual machines'
    desc 'Azure: Confirm standard deployment of virtual machines'
    tag 'compute','azure'

    if !resources.blank?
        resources.each do |item|
            describe azure_virtual_machine(resource_group: item['resource_group'], name: item['name']) do
                it { should exist }
                # extensions
                its('installed_extensions_names') { should include('azurePolicy') }
                its('installed_extensions_names') { should include('dependencyAgent') }
                its('installed_extensions_names') { should include('monitoringAgent') }
                #resource
                its('type') { should eq 'Microsoft.Compute/virtualMachines' }
                its('location') { should eq item['location']}
                #properties
                its('properties.hardwareProfile.vmSize') { should eq item['size']}
                its('properties.storageProfile.osDisk.osType') { should eq item['os']}
                its('properties.storageProfile.dataDisks.count') { should eq item['datadisk_count'] }
                its('properties.storageProfile.osDisk.writeAcceleratorEnabled') {should cmp false}
            end
        end
    end
end