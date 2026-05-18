# PreToolUse hook: Write / Edit
# 테스트 레이블 파일에 쓰기 시도 시 차단 (데이터 누수 방지)

$json = [Console]::In.ReadToEnd() | ConvertFrom-Json
$path = $json.file_path

if ($null -ne $path -and $path -match 'test_label|answer_key|ground_truth|test_answer|leaderboard_label') {
    Write-Host ''
    Write-Host '[LEAKAGE GUARD] 테스트 레이블 파일 쓰기 차단!' -ForegroundColor Red
    Write-Host "대상 파일: $path" -ForegroundColor Red
    Write-Host '테스트 레이블을 수정하면 데이터 누수(Leakage)가 발생합니다.' -ForegroundColor Yellow
    Write-Host '정말 수정이 필요하면 직접 에디터에서 여세요.' -ForegroundColor Yellow
    Write-Host ''
    exit 2
}

exit 0
