# impact is a string, or numeric that measures the importance of the compliance results. Valid strings for impact are none, low, medium, high, and critical. The values are based off CVSS 3.0. A numeric value must be between 0.0 and 1.0. The value ranges are:
# 0.0 to <0.01 these are controls with no impact, they only provide information
# 0.01 to <0.4 these are controls with low impact
# 0.4 to <0.7 these are controls with medium impact
# 0.7 to <0.9 these are controls with high impact
# 0.9 to 1.0 these are critical controls


resources = yaml(content: inspec.profile.file('key_vaults.yml')).params
control 'azure_key_vault' do
    impact 0.6
    title 'Azure: Confirm standard deployment of key vaults'
    desc 'Azure: Confirm standard deployment of key vaults'
    tag 'security','azure'
    if !resources.blank?
        resources.each do |item| 
            describe azure_key_vault(resource_group: item['resource_group'],name: item['name']) do
                it {should exist}
                #its('diagnostic_settings') { should include(true) }
                its('properties.sku.name') {should cmp 'standard'}
                its('properties.enablePurgeProtection') {should be true}
                its('properties.enableRbacAuthorization') {should be true}
                its('properties.enableSoftDelete') {should be true}
            end
        end
    end
end