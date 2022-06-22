$rg = 'finops-assets'
$ws = 'LOG-WS01-TEST'

$savedsearchs = Get-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws

$query = get-content .\fctCostVMDurableByMonth.kql
$alias='fctCostVMDurableByMonth'

if($alias -in $savedsearchs)
{
Set-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctCostVMDurableByMonth.kql" -DisplayName "fctCostVMDurableByMonth" -Category "WorkspaceFunctions" -Query $query -Version 1 -FunctionAlias $alias -FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,entitiesId:string = default4,environments:string = default5'
}
else
{
New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctCostVMDurableByMonth.kql" -DisplayName "fctCostVMDurableByMonth" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force -FunctionAlias $alias -FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,entitiesId:string = default4,environments:string = default5' 
}






$query = get-content .\fctDiskPotentialSavingsCsv.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctDiskPotentialSavingsCsv.kql" 
-DisplayName "fctDiskPotentialSavingsCsv" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctDiskPotentialSavingsCsv" 

$query = get-content .\fctDiskPotentialSavingsStandard.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctDiskPotentialSavingsStandard.kql" 
-DisplayName "fctDiskPotentialSavingsStandard" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctDiskPotentialSavingsStandard" 

$query = get-content .\fctKPIConsumptionsVMByMonth.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIConsumptionsVMByMonth.kql" 
-DisplayName "fctKPIConsumptionsVMByMonth" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIConsumptionsVMByMonth" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5' 

$query = get-content .\fctKPIDowntimeVMsByMonth.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIDowntimeVMsByMonth.kql" 
-DisplayName "fctKPIDowntimeVMsByMonth" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIDowntimeVMsByMonth" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5'

$query = get-content .\fctKPIPriceHourBlobs.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIPriceHourBlobs.kql" 
-DisplayName "fctKPIPriceHourBlobs" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIPriceHourBlobs" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5'

$query = get-content .\fctKPIPriceHourCPU.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIPriceHourCPU.kql" 
-DisplayName "fctKPIPriceHourCPU" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIPriceHourCPU" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5'

$query = get-content .\fctKPIPriceHourDisks.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIPriceHourDisks.kql" 
-DisplayName "fctKPIPriceHourDisks" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIPriceHourDisks" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5'

$query = get-content .\fctKPIPriceHourSnapshots.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIPriceHourSnapshots.kql" 
-DisplayName "fctKPIPriceHourSnapshots" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIPriceHourSnapshots" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5'

$query = get-content .\fctKPIPriceHourTiBBlobs.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIPriceHourTiBBlobs.kql" 
-DisplayName "fctKPIPriceHourTiBBlobs" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIPriceHourTiBBlobs" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5'

$query = get-content .\fctKPIPriceHourTiBDisks.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIPriceHourTiBDisks.kql" 
-DisplayName "fctKPIPriceHourTiBDisks" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIPriceHourTiBDisks" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5'

$query = get-content .\fctKPIPriceHourTiBSnapshots.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctKPIPriceHourTiBSnapshots.kql" 
-DisplayName "fctKPIPriceHourTiBSnapshots" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctKPIPriceHourTiBSnapshots" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3,environments:string = default5'

$query = get-content .\fctVMConsumption_202109.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "fctVMConsumption_202109.kql" 
-DisplayName "fctVMConsumption_202109" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "fctVMConsumption_202109" 

$query = get-content .\reservationCoverageByDate.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "reservationCoverageByDate.kql" 
-DisplayName "reservationCoverageByDate" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "reservationCoverageByDate" 
-FunctionParameter 'maxDate:string = default1,dayBand:int = default2,entitiesName:string = default3'

$query = get-content .\reservationCoverageGrouped.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "reservationCoverageGrouped.kql" 
-DisplayName "reservationCoverageGrouped" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "reservationCoverageGrouped" 
-FunctionParameter 'startYear:string = default1,startMonth:string = default2,entitiesName:string = default3'

$query = get-content .\reservationUtilizationByDate.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "reservationUtilizationByDate.kql" 
-DisplayName "reservationUtilizationByDate" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "reservationUtilizationByDate" 
-FunctionParameter 'maxDate:string = default1,dayBand:int = default2,entitiesName:string = default3'

$query = get-content .\reservationUtilizationGrouped.kql

New-AzOperationalInsightsSavedSearch -ResourceGroupName $rg -WorkspaceName $ws -SavedSearchId "reservationUtilizationGrouped.kql" 
-DisplayName "reservationUtilizationGrouped" -Category "WorkspaceFunctions" -Query $query -Version 1 -Force 
-FunctionAlias "reservationUtilizationGrouped" 
-FunctionParameter 'maxDate:string = default1,dayBand:int = default2,entitiesName:string = default3'

