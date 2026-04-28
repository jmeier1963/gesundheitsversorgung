$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$csvPath = Join-Path $repoRoot "data/public/approaches.csv"

if (-not (Test-Path $csvPath)) {
  throw "Missing public data file: $csvPath"
}

$requiredColumns = @(
  "id",
  "name",
  "ort_region",
  "bundesland_land",
  "raumtyp",
  "zielgruppe",
  "versorgungsthema",
  "massnahmentyp",
  "traeger_akteure",
  "umsetzungsstand",
  "evidenz_quellenlage",
  "kriterienbewertung",
  "kurzbeschreibung",
  "links",
  "veroeffentlichungsstatus"
)

$forbiddenColumns = @(
  "kontakt",
  "email",
  "telefon",
  "interview",
  "interne_notiz",
  "personenbezogen"
)

$allowedScores = @("niedrig", "mittel", "hoch", "zu pruefen")
$rows = Import-Csv -Path $csvPath

if ($rows.Count -eq 0) {
  throw "Public data file must contain at least one row."
}

$headers = ($rows[0].PSObject.Properties | ForEach-Object Name)
$missingColumns = $requiredColumns | Where-Object { $_ -notin $headers }
if ($missingColumns.Count -gt 0) {
  throw "Missing required columns: $($missingColumns -join ', ')"
}

$blockedColumns = $headers | Where-Object { $_ -in $forbiddenColumns }
if ($blockedColumns.Count -gt 0) {
  throw "Forbidden public columns found: $($blockedColumns -join ', ')"
}

$seenIds = @{}
$rowNumber = 1
foreach ($row in $rows) {
  $rowNumber += 1
  foreach ($column in $requiredColumns) {
    if ([string]::IsNullOrWhiteSpace($row.$column) -and $column -ne "links") {
      throw "Row $rowNumber has empty required field '$column'."
    }
  }

  if ($seenIds.ContainsKey($row.id)) {
    throw "Duplicate id '$($row.id)' found in row $rowNumber."
  }
  $seenIds[$row.id] = $true

  if ($row.kriterienbewertung -notin $allowedScores) {
    throw "Row $rowNumber has invalid kriterienbewertung '$($row.kriterienbewertung)'."
  }

  if ($row.veroeffentlichungsstatus -ne "public") {
    throw "Row $rowNumber has non-public status in public dataset."
  }
}

Write-Host "Validated $($rows.Count) public catalogue rows."
