############ Accounts ##########
describe user('avanoso_admin') do
    it { should exist }
    end
      

############ Windows Services ##########
control 'Windows Services' do
    impact 0.9
    title 'Test Windows Services'
    desc 'Test status of critical windows services'
    desc 'rationale', 'This ensures that all required services are running or disabled' # Requires Chef InSpec >=2.3.4
    tag 'windows'
    describe service('Microsoft Defender Antivirus Service') do
        it { should be_running}
        it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
    end
    describe service('Windows Defender Firewall') do
        it { should be_running}
        it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
    end
    describe service('Windows Time') do
        it { should be_running}
        it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
    end
end

############ Domain Controller Connectivity ##########
control 'Domain Controller Connectivity' do
    impact 0.9
    title 'Test domain controller connectivity'
    desc 'Test access to all Domain Controller Ports'
    desc 'rationale', 'This ensures that all ports are listening and available' # Requires Chef InSpec >=2.3.4
    tag 'windows','domain controller'
    pdc = <<-EOH
    # Test Domain services
    $object = 88,135,139,389,464,445,636,3268,3269 | % {test-netconnection vmprodaedc01.avanoso.com -port $_}
    $object | select RemotePort,TcpTestSucceeded
    EOH
    sdc = <<-EOH
    # Test Domain services
    $object = 88,135,139,389,464,445,636,3268,3269 | % {test-netconnection vmprodaedc02.avanoso.com -port $_}
    $object | select RemotePort,TcpTestSucceeded
    EOH

    describe powershell(pdc) do
        its('stdout') { should_not match /False/ }
    end

    describe powershell(sdc) do
        its('stdout') { should_not match /False/ }
    end
    
end