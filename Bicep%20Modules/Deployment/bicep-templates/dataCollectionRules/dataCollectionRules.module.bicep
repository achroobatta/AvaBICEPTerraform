targetScope = 'resourceGroup'
param dataCollectionRulesObject object
param tags object
param name string

param location string

// Params from the global.yml VGS
param workspaceGroup string
param workspaceName string
param hubSubscription string


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}

resource dataCollectionRules 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: name
  location: location
  tags: tags
  kind: dataCollectionRulesObject.osType
  properties: {
    description: dataCollectionRulesObject.description
    destinations: {
      azureMonitorMetrics: {
        name: 'azureMonitorMetrics-default'
      }
      logAnalytics: [
        {
          name: 'logAnalytics-default'
          workspaceResourceId: logAnalytics.id
        }
      ]
    }
    dataFlows: [
      {
        destinations: [
          'azureMonitorMetrics-default'
        ]
         streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
      {
        destinations: [
          'logAnalytics-default'
        ]
         streams:  [
          contains(dataCollectionRulesObject.osType,'Windows')? 'Microsoft-Event': 'Microsoft-Syslog'
        ]
      }
    ]
    dataSources: {
      performanceCounters: [
        {
          name: 'perfCounterDataSource'
          samplingFrequencyInSeconds: 10
          streams: [
            'Microsoft-InsightsMetrics'
          ]
          counterSpecifiers: [
            'Processor Information(_Total)\\% Processor Time'
            'Processor Information(_Total)\\% Privileged Time'
            'Processor Information(_Total)\\% User Time'
            'Processor Information(_Total)\\Processor Frequency'
            'System\\Processes'
            'Process(_Total)\\Thread Count'
            'Process(_Total)\\Handle Count'
            'System\\System Up Time'
            'System\\Context Switches/sec'
            'System\\Processor Queue Length'
            'Memory\\% Committed Bytes In Use'
            'Memory\\Available Bytes'
            'Memory\\Committed Bytes'
            'Memory\\Cache Bytes'
            'Memory\\Pool Paged Bytes'
            'Memory\\Pool Nonpaged Bytes'
            'Memory\\Pages/sec'
            'Memory\\Page Faults/sec'
            'Process(_Total)\\Working Set'
            'Process(_Total)\\Working Set - Private'
            'LogicalDisk(_Total)\\% Disk Time'
            'LogicalDisk(_Total)\\% Disk Read Time'
            'LogicalDisk(_Total)\\% Disk Write Time'
            'LogicalDisk(_Total)\\% Idle Time'
            'LogicalDisk(_Total)\\Disk Bytes/sec'
            'LogicalDisk(_Total)\\Disk Read Bytes/sec'
            'LogicalDisk(_Total)\\Disk Write Bytes/sec'
            'LogicalDisk(_Total)\\Disk Transfers/sec'
            'LogicalDisk(_Total)\\Disk Reads/sec'
            'LogicalDisk(_Total)\\Disk Writes/sec'
            'LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
            'LogicalDisk(_Total)\\Avg. Disk sec/Read'
            'LogicalDisk(_Total)\\Avg. Disk sec/Write'
            'LogicalDisk(_Total)\\Avg. Disk Queue Length'
            'LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
            'LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
            'LogicalDisk(_Total)\\% Free Space'
            'LogicalDisk(_Total)\\Free Megabytes'
            'Network Interface(*)\\Bytes Total/sec'
            'Network Interface(*)\\Bytes Sent/sec'
            'Network Interface(*)\\Bytes Received/sec'
            'Network Interface(*)\\Packets/sec'
            'Network Interface(*)\\Packets Sent/sec'
            'Network Interface(*)\\Packets Received/sec'
            'Network Interface(*)\\Packets Outbound Errors'
            'Network Interface(*)\\Packets Received Errors'
          ]
        }
      ]
      windowsEventLogs: contains(dataCollectionRulesObject.osType,'Windows')? [
        {
          name: 'eventLogsDataSource'
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=5)]]'
            'Security!*[System[(band(Keywords,13510798882111488))]]'
            'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=5)]]'
          ]
        }
      ]: null
      syslog: contains(dataCollectionRulesObject.osType,'Linux') ? [
        {
          name: 'syslogDataSource'
          streams: [
            'Microsoft-Syslog'
          ]
          facilityNames: [
            'auth'
            'authpriv'
            'cron'
            'daemon'
            'kern'
            'local0'
            'local1'
            'local2'
            'local3'
            'local4'
            'local5'
            'local6'
            'local7'
            'lpr'
            'mail'
            'mark'
            'news'
            'syslog'
            'user'
            'uucp'
          ]
          logLevels: [
              'Alert'
              'Critical'
              'Debug'
              'Emergency'
              'Error'
              'Info'
              'Notice'
              'Warning'
          ]
        }
      ]: null
    }
  }
}
