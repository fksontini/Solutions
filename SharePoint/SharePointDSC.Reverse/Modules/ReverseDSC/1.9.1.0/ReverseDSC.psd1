#
# Module manifest for module 'ReverseDsc'
#
# Generated by: Nik Charlebois
#
# Generated on: 11/07/2017
#
@{
    ModuleVersion = '1.9.1.0'
    GUID = '6c1176a0-4fac-4134-8ca2-3fa8a21a7b90'
    Author = 'Microsoft Corporation'
    CompanyName = 'Microsoft Corporation'
    Copyright = '(c) 2015-2017 Microsoft Corporation. All rights reserved.'
    Description = 'This DSC module is used to extract the DSC Configuration of existing environments.'
    PowerShellVersion = '4.0'
    NestedModules = @("ReverseDSC.Core.psm1")
    CmdletsToExport = @()
    FunctionsToExport = @("Get-DSCParamType", 
                        "Get-DSCBlock",
                        "Get-DSCFakeParameters",
                        "Get-DSCDependsOnBlock",
                        "Export-TargetResource",
                        "Get-ResourceFriendlyName",
                        "Get-Credentials",
                        "Resolve-Credentials",
                        "Save-Credentials",
                        "Test-Credentials",
                        "Convert-DSCStringParamToVariable",
                        "New-ConfigurationDataDocument",
                        "Add-ConfigurationDataEntry",
                        "Get-ConfigurationDataEntry",
                        "Add-ReverseDSCUserName")
    AliasesToExport = @()
    PrivateData = @{
        PSData = @{

            Tags = @('DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource', 'ReverseDSC')

            # A URL to the license for this module.
            LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri = 'https://Github.com/Microsoft/ReverseDSC'

            # A URL to an icon representing this module.
            # IconUri = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}
