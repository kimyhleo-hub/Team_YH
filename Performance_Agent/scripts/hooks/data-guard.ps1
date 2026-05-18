# PreToolUse hook: Bash
# 학습 데이터 파일 삭제 명령 차단

$json = [Console]::In.ReadToEnd() | ConvertFrom-Json
$cmd = $json.command

if ($null -ne $cmd) {
    $isDeletion = $cmd -match '(rm\s|del\s|Remove-Item|rmdir)'
    $isDataFile = $cmd -match '\.(csv|parquet|npy|pkl|h5|pt|pth|feather|arrow|tfrecord)'

    if ($isDeletion -and $isDataFile) {
        Write-Host ''
        Write-Host '[DATA GUARD] 데이터/모델 파일 삭제 명령 차단!' -ForegroundColor Red
        Write-Host "명령어: $cmd" -ForegroundColor Red
        Write-Host '실수로 학습 데이터나 저장된 모델이 삭제될 수 있습니다.' -ForegroundColor Yellow
        Write-Host '정말 삭제하려면 터미널에서 직접 실행하세요.' -ForegroundColor Yellow
        Write-Host ''
        exit 2
    }
}

exit 0
