
<#
.SYNOPSIS
    A script to retrieve datasets from a remote API.

.DESCRIPTION
    The script retrieves datasets from a remote API based on user selection.
    A hash table is used to map user inputs to API request configuration.

.INPUTS
    User input via Read-Host, mapped to API request config.

.OUTPUTS
    Datasets formatted to table and returned to console.

.EXAMPLE
    .apiTest.ps1

    Runs the script and prompts the user to select desired dataset.
#>


# ****************************************************
# Constants and variables.
# ****************************************************
[int] $script:apiSelection = ""
Set-Variable apiUrlRoot -Scope Script -Option Constant -Value "https://jsonplaceholder.typicode.com/"
Set-Variable apiCallErr -Scope Script -Option Constant -Value "Request to remote API failed. Captured error was: "
Set-Variable welcomeMsg -Scope Script -Option Constant -Value "Welcome. Please select the desired dataset..`n"
Set-Variable selectionWrng -Scope Script -Option Constant -Value " is not a valid selection. Please choose from one of the specified options."
Set-Variable apiOption -Scope Script -Option Constant -Value @{
    1 = @{
        size  = 1
        uriSuffix = 'posts/?_limit='
        optionText = "'1' - Get single post"
    }
    2 = @{
        size  = 1
        uriSuffix = 'comments/?_limit='
        optionText = "'2' - Get single comment"
    }
    3 = @{
        size  = 10
        uriSuffix = 'posts/?_limit='
        optionText = "'3' - Get ten posts"
    }
    4 = @{
        size  = 10
        uriSuffix = 'comments/?_limit='
        optionText = "'4' - Get ten comments"
    }
}


# ****************************************************
# Functions.
# ****************************************************
function Set-APIOption {

    Write-Host $script:welcomeMsg
    $script:apiOption.Values.optionText | Sort-Object
    $script:apiSelection = Read-Host -Prompt "`nEnter selection"

    if(($script:apiOption.Keys) -notcontains $script:apiSelection) {
        Write-Warning ("'$script:apiSelection'" + "$selectionWrng")
        continue
    }
    
}

function Get-APIData {
    
    $fullUri =  [string]($script:apiUrlRoot + `
                ($script:apiOption.$script:apiSelection).uriSuffix + `
                ($script:apiOption.$script:apiSelection).size)

    try {
        $apiData =  Invoke-WebRequest -Uri $fullUri | 
                    ConvertFrom-Json
    }
    catch {
        Write-Host ("$script:apiCallErr" + "$_") -ForegroundColor Red
        return
    }

    #Return results
    return $apiData | Format-Table -AutoSize -Wrap

}

function Get-TestAPIData {

    Set-APIOption
    Get-APIData

}


# ****************************************************
# Run.
# ****************************************************
Get-TestAPIData