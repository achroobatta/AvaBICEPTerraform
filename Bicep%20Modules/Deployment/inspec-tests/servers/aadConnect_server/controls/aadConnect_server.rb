include_controls 'windows'

############ Services Installed ##########
control 'AAD Connect Services' do
    impact 0.9
    title 'Test AAD connect services'
    desc 'Test status of AAD connect services'
    desc 'rationale', 'This ensures that all required services are running or disabled' # Requires Chef InSpec >=2.3.4
    tag 'windows','aad connect','aad'

    describe service('Azure AD Connect Health AD DS Insights Service') do
        it { should be_running}
        it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
    end
    describe service('Azure AD Connect Health AD DS Monitoring Service') do
        it { should be_running}
        it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
    end
    describe service('Azure AD Connect Health Sync Insights Service') do
        it { should be_running}
        it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
    end
    describe service('Azure AD Connect Health Sync Monitoring Service') do
        it { should be_running}
        it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
    end

end

######### Software installed #############
control 'AAD connect software' do
    impact 0.9
    title 'Test AAD connect software'
    desc 'Test installation status of AAD connect software'
    desc 'rationale', 'This ensures that all required software is installed' # Requires Chef InSpec >=2.3.4
    tag 'windows','aad connect','aad'

    describe package('Azure Advanced Threat Protection Sensor') do
        it { should be_installed }
        its('version') { should match /2.179.*/ }
    end
    describe package('Microsoft Azure AD Connect') do
        it { should be_installed }
        its('version') { should eq '2.1.1.0' }
        end
        
end