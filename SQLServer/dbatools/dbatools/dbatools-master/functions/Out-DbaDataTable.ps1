Function Out-DbaDataTable
{
<#
.SYNOPSIS 
Creates a DataTable for an object 
	
.DESCRIPTION 
Creates a DataTable based on an objects properties. This allows you to easily write to SQL Server tables
	
Thanks to Chad Miller, this script is all him. https://gallery.technet.microsoft.com/scriptcenter/4208a159-a52e-4b99-83d4-8048468d29dd

.PARAMETER InputObject
The object to transform into a DataTable
	
.PARAMETER IgnoreNull 
Use this switch to ignore null rows

.PARAMETER Silent 
Use this switch to disable any kind of verbose messages

.NOTES
dbatools PowerShell module (https://dbatools.io)
Copyright (C) 2016 Chrissy LeMaire
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

.LINK
 https://dbatools.io/Out-DbaDataTable

.EXAMPLE
Get-Service | Out-DbaDataTable

Creates a $datatable based off of the output of Get-Service 
	
.EXAMPLE
Out-DbaDataTable -InputObject $csv.cheesetypes

Creates a DataTable from the CSV object, $csv.cheesetypes
	
.EXAMPLE
$dblist | Out-DbaDataTable

Similar to above but $dbalist gets piped in
	
#>	
	[CmdletBinding()]
	param (
		[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
		[AllowNull()]
		[PSObject[]]$InputObject,
		[switch]$IgnoreNull,
		[switch]$Silent
	)
	
	BEGIN
	{
		function Get-Type
		{
			param ($type)
			
			$types = @(
                'Int32',    
                'UInt32',   
                'Int16',    
                'UInt16',   
                'Int64',    
                'UInt64',   
                'Decimal',  
                'Single',   
                'Double',   
                'Byte',     
                'SByte',    
                'Boolean',
                'Bool',
                'String',   
                'DateTime',
                'Guid',
                'Char',
                'int',  
                'long',
                'System.Int32',    
                'System.UInt32',   
                'System.Int16',    
                'System.UInt16',   
                'System.Int64',    
                'System.UInt64',   
                'System.Decimal',  
                'System.Single',   
                'System.Double',   
                'System.Byte',     
                'System.SByte',    
                'System.Boolean',
                'System.String',   
                'System.DateTime',
                'System.Guid',
                'System.Char'
                )

            # some types require conversion to be stored in a database
            $specialtypes = @{
                'System.TimeSpan' = 'System.String'
                'TimeSpan'        = 'System.String'
            }

            if ($specialtypes.keys -contains $type) 
            {
                # Debug, remove when done
                #Write-Verbose "Found match: $type (special)"
                return $specialtypes[$type]
            }
            elseif ($types -contains $type)
			{
                # Debug, remove when done
                #Write-Verbose "Found match: $type"
				return $type
			}
			else
			{
                # Debug, remove when done
                #Write-Warning "Did not find match: $type"
				return 'System.String'
			}
		}
	
		$datatable = New-Object System.Data.DataTable
	}
	
	PROCESS
	{
		if (!$InputObject)
		{
			if ($IgnoreNull)
			{
				Stop-Function -Message "The InputObject from the pipe is null. Skipping." -Continue
			}
			else
			{
				$datarow = $datatable.NewRow()
				$datatable.Rows.Add($datarow)
				continue
			}
		}
		foreach ($object in $InputObject)
		{
			$datarow = $datatable.NewRow()
			foreach ($property in $object.PsObject.get_properties())
			{
				if ($datatable.Rows.Count -eq 0)
				{
					$column = New-Object System.Data.DataColumn
					$column.ColumnName = $property.Name.ToString()
					
                    # Even if property value is $false or $null we need to check the type
                    # Commenting out this if statement. Can't see the benefit after the other changes, but I could be missing something. /John
					#if ($property.value)
					#{
						if ($property.value -isnot [System.DBNull])
						{
                            # Check if property is a ScriptProperty, then resolve it before checking type
                            If ($property.MemberType -eq 'ScriptProperty') {
                                $type = Get-Type ($object.($property.Name).GetType().ToString())
                            } else {
                                $type = Get-Type $property.TypeNameOfValue
                            }
                            
							$column.DataType = [System.Type]::GetType($type)
						}
					#}
					$datatable.Columns.Add($column)
				}
				
				if ($property.value.length -gt 0)
				{
					if ($property.value.ToString() -eq 'System.Object[]')
					{
						$datarow.Item($property.Name) = $property.value -join ", "
					}
					else
					{
						$datarow.Item($property.Name) = $property.value
					}
				}
			}
			$datatable.Rows.Add($datarow)
		}
	}
	
	End
	{
		return @( ,($datatable))
	}
	
}
