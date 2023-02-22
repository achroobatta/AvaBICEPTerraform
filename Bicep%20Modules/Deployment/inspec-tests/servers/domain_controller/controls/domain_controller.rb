include_controls 'windows'


############ Processses ##################
##########################################
describe file('C:/Windows/explorer.exe') do
    it { should exist }
    it { should be_file }
  end
  

 
######### Software installed #############
control 'MDI software' do
  impact 0.9
  title 'Test MDI software'
  desc 'Test installation status of MDI software'
  desc 'rationale', 'This ensures that all required software is installed' # Requires Chef InSpec >=2.3.4
  tag 'windows','mdi','aad'
  
  describe package('Azure Advanced Threat Protection Sensor') do
      it { should be_installed }
      its('version') { should match /2.179.*/ }
    end
end


############ Ports Open     ##############
control 'Domain Controller Ports' do
  impact 0.9
  title 'Test domain controller ports'
  desc 'Test status of critical domain controller ports'
  desc 'rationale', 'This ensures that all required ports are open' # Requires Chef InSpec >=2.3.4
  tag 'windows','domain controller'
  
  describe port(53) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
  describe port(53) do
    its('protocols') { should include 'udp' }
    it { should be_listening}
  end
  describe port(88) do
      its('protocols') { should include 'tcp' }
      it { should be_listening}
  end
  describe port(88) do
    its('protocols') { should include 'udp' }
    it { should be_listening}
  end
  describe port(123) do
    its('protocols') { should include 'udp' }
    it { should be_listening}
  end
  describe port(135) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
  describe port(139) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
  describe port(389) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
  describe port(389) do
    its('protocols') { should include 'udp' }
    it { should be_listening}
  end
  describe port(464) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
  describe port(445) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
  describe port(636) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
  describe port(3268) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
  describe port(3269) do
    its('protocols') { should include 'tcp' }
    it { should be_listening}
  end
end

############ Services Installed ##########
control 'Domain Controller Services' do
  impact 0.9
  title 'Test domain controller services'
  desc 'Test status of critical domain controller services'
  desc 'rationale', 'This ensures that all required services are running or disabled' # Requires Chef InSpec >=2.3.4
  tag 'windows','domain controller'

  describe service('Active Directory Domain Services') do
      it { should be_running}
      it { should have_start_mode('Auto') }
  end
  describe service('DNS Server') do
      it { should be_running}
      it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
  end
  describe service('DNS Client') do
    it { should be_running}
    it { should have_start_mode('Auto') } ## Uses Auto instead of automatic for unknown reasons
  end
  describe service('Kerberos Key Distribution Center') do
      it {should be_running}
      it { should have_start_mode('Auto') }
  end
  describe service('Intersite Messaging') do
    it {should be_running}
    it { should have_start_mode('Auto') }
  end
  describe service('Netlogon') do
      it {should be_running}
      it { should have_start_mode('Auto') }
  end

  describe service('Remote Procedure Call (RPC)') do
    it {should be_running}
    it { should have_start_mode('Auto') }
  end

  describe service('RPC Endpoint Mapper') do
    it {should be_running}
    it { should have_start_mode('Auto') }
  end

  describe service('Print Spooler') do
      it {should_not  be_running}
      it { should have_start_mode('Disabled') }
  end
  describe service('DFS Replication') do
    it {should  be_running}
    it { should have_start_mode('Auto') }
  end
end

############ Services Installed ##########
control 'Domain Controller Health' do
  impact 0.5
  title 'Test domain controller health'
  desc 'Test status of critical domain controller health'
  desc 'rationale', 'This ensures that all dodm' # Requires Chef InSpec >=2.3.4
  tag 'windows','domain controller'

  # skip systemlog checks as they can be too noisy
  dcdiag = <<-EOH
  dcdiag /skip:systemlog /q
  EOH

  describe powershell(dcdiag) do
      its('stdout') { should_not match /warning/ }
      its('stdout') { should_not match /error/ }
  end
end
