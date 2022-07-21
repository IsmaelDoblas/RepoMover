$headers = @{}
$headers.Add("Accept", "*/*")
$headers.Add("User-Agent", "powershell/2.0")
    
    
    # Obtain Instance Flexibility Groups

    $reqUrl = 'https://isfratio.blob.core.windows.net/isfratio/ISFRatio.csv'
    $response = Invoke-RestMethod -Uri $reqUrl -Method Get -Headers $headers 

    # Azure Instances Flex Processing
    $instances=$response.Items

    #Add headers to csv file export
    Add-Content -Path C:\VisualStudio\PowerShell\instancesflexibility.csv  -Value '"InstanceSizeFlexibilityGroup","ArmSkuName","Ratio"'

    foreach ($item in $instances)
    {
        
            [hashtable]$instancetable      =  [ordered]@{InstanceSizeFlexibilityGroup=$item.InstanceSizeFlexibilityGroup;ArmSkuName=$item.ArmSkuName;Ratio=$item.Ratio}
            
            #$instancelist
            New-Object PsObject -Property $instancetable | Export-Csv C:\VisualStudio\PowerShell\instancesflexibility.csv -append -force
        
    }


