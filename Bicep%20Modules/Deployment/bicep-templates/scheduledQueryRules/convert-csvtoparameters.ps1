$file = "scheduledQueryRules.ae.parameters.json"
$templateFile = "parametersTemplate.json"
$importFile = "logAlerts.csv"

$template = get-content -raw -path $templateFile | ConvertFrom-Json
$scheduledQueryRules= import-csv $importFile

$template.parameters.scheduledQueryRulesObject.value.scheduledQueryRules = $scheduledQueryRules
$output = $template | ConvertTo-Json -Depth 10 | foreach-object { [System.Text.RegularExpressions.Regex]::Unescape($_) }

out-file -force $file -InputObject $output -Encoding utf8

