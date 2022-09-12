function Get-RHELLicensePrices
{
    $headers = @{}
    $headers.Add("Accept", "*/*")
    $headers.Add("User-Agent", "powershell/1.0")

    # Obtain RHEL Azure prices 
    $filters="serviceName eq 'Virtual Machines Licenses' and productName eq 'Red Hat Enterprise Linux'"
    $reqUrl = 'https://prices.azure.com/api/retail/prices?currencyCode=EUR&$filter='+$filters
    $response = Invoke-RestMethod -Uri $reqUrl -Method Get -Headers $headers 

    # Azure RHEL Prices processing
    $rhelprices=$response.Items

    foreach ($item in $rhelprices)
    {
        if ($item.meterId -eq '9e9f2263-dfea-5c46-a1be-e185394950d8')
        {
            $rhel5plussupp=$item.unitPrice*(1-$santanderoddisc)
        }
        elseif ($item.meterId -eq '037eddc0-fedd-4d73-b5d8-92fba9edb831')
        {
            $rhel5plusprice=$item.unitPrice*(1-$santanderoddisc)
        }
        elseif ($item.meterId -eq '10462be9-b81b-5356-9fbb-12cc567877fe')
        {
            $rhel14supp=$item.unitPrice*(1-$santanderoddisc)
        }
        elseif ($item.meterId -eq '077a07bb-20f8-4bc6-b596-ab7211a1e247')
        {
            $rhel14price=$item.unitPrice*(1-$santanderoddisc)
        }
    }
    return @($rhel14price,$rhel5plusprice)

}
function Get-SQLServerLicensePrices
{
    # SQL Server Standard 03482a09-76d0-42b1-bd6c-f0b576a173b3 64 cores
    # SQL Server Enterprise 0391f0bf-d055-47ec-bb57-201d27105df7 64 cores

    $headers = @{}
    $headers.Add("Accept", "*/*")
    $headers.Add("User-Agent", "powershell/1.0")

    # Obtain SQL Server Azure prices 
    $filters="serviceName eq 'Virtual Machines Licenses' and skuName eq '64 vCPU VM'"
    $reqUrl = 'https://prices.azure.com/api/retail/prices?currencyCode=EUR&$filter='+$filters
    $response = Invoke-RestMethod -Uri $reqUrl -Method Get -Headers $headers 

    $sqlprices=$response.Items

    foreach ($item in $sqlprices)
    {
        if (($item.meterId -eq '03482a09-76d0-42b1-bd6c-f0b576a173b3') -and ($item.type -eq "Consumption"))
        {
            # Divided by 16 to get the price of 4 cores pack
            $sqlserverstd=$item.unitPrice/16*(1-$santanderoddisc)
        }
        elseif (($item.meterId -eq '0391f0bf-d055-47ec-bb57-201d27105df7') -and ($item.type -eq "Consumption"))
        {
            # Divided by 16 to get the price of 4 cores pack
            $sqlserverent=$item.unitPrice/16*(1-$santanderoddisc)
        }
    }

    return @($sqlserverstd,$sqlserverent)

}
function Get-VmPrices($armskuname,$vcpus,$hoursofuse) 
{
    $headers = @{}
    $headers.Add("Accept", "*/*")
    $headers.Add("User-Agent", "powershell/1.0")
    
    $filters="serviceName eq 'Virtual Machines' and location eq 'EU West' and armSkuName eq '$armskuname'"
    $reqUrl = 'https://prices.azure.com/api/retail/prices?currencyCode=EUR&$filter='+$filters
    $response = Invoke-RestMethod -Uri $reqUrl -Method Get -Headers $headers 
    $vmprices=$response.Items

    foreach ($item in $vmprices)
    {
        if ($item.reservationTerm -eq '1 Year') 
        { 
            $RI1year=[math]::Round($item.unitPrice/12*(1-$santanderridisc),4)
        }
        elseif ($item.reservationTerm -eq '3 Years') 
        { 
            $RI3year=[math]::Round($item.unitPrice/3/12*(1-$santanderridisc),4)
        }
        elseif (($item.type -eq 'Consumption') -and ($item.productName -notcontains 'Spot') -and ($item.productName -notcontains 'Low Priority'))
        {
            if ($item.productName -like '*Windows*')
            {
                $ODWindows=[math]::Round($item.unitPrice*(1-$santanderoddisc),4)
            }
            else
            {
                $ODLinux=[math]::Round($item.unitPrice*(1-$santanderoddisc),4)
            }
        }
    }

    if ($vcpus -gt 8) {$WindowsHBPrice= $ODLinux*$hoursofuse + $hbwinsrvlicenseprice}
    else {$WindowsHBPrice= $ODLinux*$hoursofuse + $hbwinsrvlicenseprice/2}

    if ($vcpus -gt 4) {$RHELPrice=($ODLinux + $rhel5plusprice)*$hoursofuse}
    else {$RHELPrice=($ODLinux + $rhel14price)*$hoursofuse}

    
    $SQLlicenses=[math]::Truncate($vcpus/4)+1
    $armskuname | Out-file abc.csv -Append -force

    $RI1yrPrice = $RI1year
    $RI1yrPrice | Out-file abc.csv -Append -force
    $RI3yrPrice = $RI3year
    $RI3yrPrice | Out-file abc.csv -Append -force
    $LinuxPrice = $ODLinux * $hoursofuse
    $LinuxPrice | Out-file abc.csv -Append -force
    $WindowsPrice = $ODWindows * $hoursofuse
    $WindowsPrice | Out-file abc.csv -Append -force

    $RHELPrice=$RHELPrice;
    $SQLServerStdPrice = ($ODWindows + $SQLlicenses*$sqlserverstd) * $hoursofuse;
    $SQLServerEntPrice = ($ODWindows + $SQLlicenses*$sqlserverent) * $hoursofuse;
    $SQLServerStdHBPrice = $ODWindows* $hoursofuse + $SQLlicenses*2*$sqlserverstdhb;
    $SQLServerEntHBPrice =$ODWindows* $hoursofuse + $SQLlicenses*2*$sqlserverenthb;
    $RHELHBPrice=$ODLinux * $hoursofuse + $hbrhelprice;

    $list = @{
        vmmodel = $armskuname;
        ri1ysavings = if($LinuxPrice -ne 0) {[math]::Round(100-($RI1yrPrice*100/$LinuxPrice),2)} else {ri1ysavings=0}
        ri3ysavings = if($LinuxPrice -ne 0) {[math]::Round(100-($RI3yrPrice*100/$LinuxPrice),2)} else {ri3ysavings=0}
        #hbwinsavings = if($WindowsPrice -ne 0) {[math]::Round(100-($WindowsHBPrice*100/$WindowsPrice),2)} else {hbwinsavings=0}
        #hbsqlstdsavings = if($SQLServerStdPrice -ne 0) {[math]::Round(100-($SQLServerStdHBPrice*100/$SQLServerStdPrice),2)} else {hbsqlstdsavings=0}
        #hbsqlentsavings = if($SQLServerEntPrice -ne 0) {[math]::Round(100-($SQLServerEntHBPrice*100/$SQLServerEntPrice),2)} else {hbsqlentsavings=0}
        #hbrhelsavings = if($RHELPrice -ne 0) {[math]::Round(100-($RHELHBPrice*100/$RHELPrice),2)} else {hbrhelsavings=0}
    }
    return $list
}

function Get-AzSQLPrices($armskuname)
{
    # transform SKU name so it matches the API format
    $dbtier=$armskuname.Split('_')[0]
    $vcores=$armskuname.Split('_')[2]
    $sku="SQLDB_"+$dbtier+"_Compute_Gen5_"+$vcores

    $headers = @{}
    $headers.Add("Accept", "*/*")
    $headers.Add("User-Agent", "powershell/1.0")
    
    $filters="serviceName eq 'SQL Database' and armRegionName eq 'westeurope' and armSkuName eq '$sku'"
    $reqUrl = 'https://prices.azure.com/api/retail/prices?currencyCode=EUR&$filter='+$filters
    $response = Invoke-RestMethod -Uri $reqUrl -Method Get -Headers $headers 
    $azsqlprices=[math]::Round($response.Items[0].unitPrice*$santanderoddisc,4)

    return $azsqlprices
}

$region='westeurope'
$date=Get-Date -Format "dd-MM-yyyy"

# Santander discounts 

$SCRIPT:santanderoddisc=0.30
$SCRIPT:santanderridisc=0.10

# Santander fixed license prices for Hybrid Benefit

$SCRIPT:hbwinsrvlicenseprice=74.29/36
$SCRIPT:hbrhelprice=156/12
$SCRIPT:sqlserverstdhb=2027.26/36
$SCRIPT:sqlserverenthb=7887.56/36

# --------------- VIRTUAL MACHINES INITIATIVES ---------------------

#List all virtual machines sizes
$vmsizes = Get-AzVMSize -Location $region

$hoursofuse=730

# Get License prices once (to accelerate the execution time), so I define them at script level to be available throughout all the script (inside functions too)

$SCRIPT:rhellicenseprices=Get-RHELLicensePrices

$SCRIPT:rhel14price=$rhellicenseprices[0]
$SCRIPT:rhel5plusprice=$rhellicenseprices[1]

$SCRIPT:sqlserverprices=Get-SQLServerLicensePrices

$SCRIPT:sqlserverent=$sqlserverprices[1]
$SCRIPT:sqlserverstd=$sqlserverprices[0]

#$tablerow=""

#Add headers to csv file
Add-Content -Path C:\VisualStudio\PowerShell\InitiativeSavings_$date.csv  -Value '"ID","Category","Subcategory","Model","Vcpus","Savings","Solution"'
#$tablerow | Select-Object -Property ID,Category,Subcategory,Model,Vcpus,Savings,Solution | Export-Csv C:\VisualStudio\PowerShell\InitiativeSavings_$date.csv

foreach ($vmsize in $vmsizes)
{
    $armskuname=$vmsize.Name
    $list=Get-VmPrices $armskuname $vmsize.NumberOfCores $hoursofuse
    #$vmsize | Select-Object -property Name,NumberOfcores,@{n='ri1ysavings';e={$list.ri1ysavings}},@{n='ri3ysavings';e={$list.ri3ysavings}},@{n='hbwinsavings';e={$list.hbwinsavings}},@{n='hbsqlstdsavings';e={$list.hbsqlstdsavings}},@{n='hbsqlentsavings';e={$list.hbsqlentsavings}},@{n='hbrhelsavings';e={$list.hbrhelsavings}} | Export-Csv -Append .\test1.csv
    
    [hashtable]$hbwin       =  [ordered]@{ID='1';Category='Hybrid_Benefit';Subcategory='Windows';Model=$vmsize.Name;Vcpus=$vmsize.NumberOfCores;Savings=$list.hbwinsavings;Solution="Activate_Hybrid_Benefit_on_$armskuname"}
    [hashtable]$hbrhel      =  [ordered]@{ID='1';Category='Hybrid_Benefit';Subcategory='Red_Hat_Enterprise_Linux';Model=$vmsize.Name;Vcpus=$vmsize.NumberOfCores;Savings=$list.hbrhelsavings;Solution="Activate_Hybrid_Benefit_on_$armskuname"}
    [hashtable]$hbsqlsent   =  [ordered]@{ID='1';Category='Hybrid_Benefit';Subcategory='SQL_Server_IaaS_Enterprise';Model=$vmsize.Name;Vcpus=$vmsize.NumberOfCores;Savings=$list.hbsqlentsavings;Solution="Activate_Hybrid_Benefit_on_$armskuname"}
    [hashtable]$hbsqlsstd   =  [ordered]@{ID='1';Category='Hybrid_Benefit';Subcategory='SQL_Server_IaaS_Standard';Model=$vmsize.Name;Vcpus=$vmsize.NumberOfCores;Savings=$list.hbsqlstdsavings;Solution="Activate_Hybrid_Benefit_on_$armskuname"}
    [hashtable]$ri          =  [ordered]@{ID='2';Category='Reservations';Subcategory='Virtual_Machines';Model=$vmsize.Name;Vcpus=$vmsize.NumberOfCores;Savings=$list.ri3ysavings;Solution="Purchase_Reserved_Instances_for_$armskuname"}


    $hbwin 
    New-Object PsObject -Property $hbwin | Export-Csv C:\VisualStudio\PowerShell\InitiativeSavings_$date.csv -append -force
    $hbrhel 
    New-Object PsObject -Property $hbrhel | Export-Csv C:\VisualStudio\PowerShell\InitiativeSavings_$date.csv -append -force
    $hbsqlsent 
    New-Object PsObject -Property $hbsqlsent | Export-Csv C:\VisualStudio\PowerShell\InitiativeSavings_$date.csv -append -force
    $hbsqlsstd
    New-Object PsObject -Property $hbsqlsstd | Export-Csv C:\VisualStudio\PowerShell\InitiativeSavings_$date.csv -append -force
    $ri 
    New-Object PsObject -Property $ri | Export-Csv C:\VisualStudio\PowerShell\InitiativeSavings_$date.csv -append -force
}

# --------------- AZURE SQL HYBRID BENEFIT ---------------------

# Get all SKUs available for Azure SQL vCore Gen5 (not serverless)

 $azsqlsizes = Get-AzSqlServerServiceObjective -Location $region | where-object {$_.Family -eq 'Gen5' -and $_.SkuName -notlike "*_S_*"} 

foreach ($azsqlsize in $azsqlsizes)
{
    $armskuname=$azsqlsize.ServiceObjectiveName
    $pricehour=Get-AzSqlPrices $armskuname 

    $sqllicenses=[math]::Truncate($azsqlsize.Capacity/4)+1
    
    if ($armskuname -like "BC_*") 
    {
        $odprice=($pricehour+$sqlserverent*$sqllicenses)*$hoursofuse
        $hbprice=($pricehour*$hoursofuse)+$sqlserverenthb*($vcores/2)
        $hbsavings=[math]::Round(100-($hbprice*100/$odprice),2)
        $record
        $model="Business_Critical"
    }
    else 
    {
        $odprice=($pricehour+$sqlserverstd*$sqllicenses)*$hoursofuse
        $hbprice=($pricehour*$hoursofuse)+$sqlserverstdhb*($vcores/2)
        $hbsavings=[math]::Round(100-($hbprice*100/$odprice),2)
        if ($armskuname -like "GP_*") {$model="General_Purpose"}
        else {$model="Hyperscale"}
    }
    [hashtable]$hbazsql      =  [ordered]@{ID='1';Category='Hybrid_Benefit';Subcategory='Azure_SQL_database/elastic_pool';Model=$model;Vcpus=$azsqlsize.Capacity;Savings=$hbsavings;Solution="Activate_Hybrid_Benefit_on_$armskuname"}
    New-Object PsObject -Property $hbazsql | Export-Csv C:\VisualStudio\PowerShell\InitiativeSavings_$date.csv -append -force

}

# --------------- MANAGED DISK REDUNDANCY ---------------------

# HERE THE FOREACH FOR RUN THE OBJECT AND WRITE IN THE FINAL .CSV