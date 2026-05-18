# Hook 만들기
- Claude에게 요청 : "알림 Hook 만들어줘"라고 말하면 settings.json에 자동 추가

# Hook JSON 구조
{
  "hooks": {
    "Notification": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -title 'Claude Code' -message '알림이 있습니다' && afplay /System/Library/Sounds/Ping.aiff &"
          }
        ]
      }
    ]
  }
}
- JSON 구조 분해:
    - 이벤트 타입 (`Notification`) — 언제 실행할지
    - matcher (`*`) — 어떤 상황에 매칭할지 (와일드카드 = 전부)
    - hooks 배열 — 실행할 Hook 목록 (여러 개 가능)
    - command — 실제 실행할 셸 명령어

# 이벤트 타입
- PreToolUse : 도구 호출 직전. 입력값 검증, 승인/차단/수정 가능
- PostToolUse : 도구 실행 직후. 결과 검증, 후처리 (린트, 포맷팅 등)
- Notification : 사용자 응답 대기 시. 알림 전송, 로깅, 외부 서비스 연동
- Stop : 에이전트 턴 종료 시. 최종 정리, 보고서 생성, 상태 저장

- 주의 : Hook 실행 중 Claude는 멈춰서 기다립니다. timeout을 꼭 설정하고, 무거운 작업은 백그라운드(&)로 돌리세요.

# 실용 Hook 4가지
- Link, Test, Build
   - git commit 직전에 자동으로 lint/test/build 실행. 하나라고 실패하면 commit 차단
- Sub-Agent PR Review
   - commit 직전 별도 sub-agent가 diff 리뷰 - 자기 코드 편향 없음. 보안/성능/컨벤션 위반만 잡음
- TDD 강제
   - AI가 src/에 코드 쓰기 전 - 같은 모듈에 .test.ts 있는지 확인. 없으면 차단
- 회사 패턴 Deny List
   - 회사에서 일어난 모든 장애 패턴을 deny list로. AI가 시도하면 즉시 차단 + 시니어 알림