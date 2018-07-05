$cyaml = Join-Path -Path "$env:CASSANDRA_HOME" -ChildPath '\conf\cassandra.yaml'
$cyamlDirs = @(Get-Content $cyaml | 
  Where-Object { 
    $_ -match '^\s*-' -and 
    $_ -notmatch '^\s*- class_name: ' -and 
    $_ -notmatch '^\s*- seeds: '
  } | 
  Foreach-Object { $_ -Replace '^\s*- (.*)','$1' } | 
  Foreach-Object { $_ -Replace '/','\' }
)
foreach ($dir in $cyamlDirs) {
  if ($(Test-Path -Path $dir)) {
    echo $dir
  }
}