# 하네스 엔지니어링의 4가지 기둥
1. 기둥 1 : 기계가 읽는 컨텍스트 파일 
- `CLAUDE.md`, `AGENTS.md`, `.cursorrules` 같은 파일들은 단순한 문서가 아니라 AI가 실행하는 런타임 설정 파일입니다.
- 예시: CLAUDE.md에 "새로운 라이브러리를 도입하지 마. DB 쿼리는 반드시 ORM을 통해서만 해."라고 쓰면, AI 에이전트는 이 규칙을 자신의 행동 제약으로 인식합니다. 매번 프롬프트에 반복할 필요가 없어요.

2. 기둥 2 : 결정론적 CI/CD 게이트
- 코드 린터, 구조 테스트, pre-commit hook 등을 통해 규칙을 시스템이 자동으로 강제합니다.
- 린터(Linter) — 코드가 규칙을 어기면 자동으로 에러를 띄움
- 구조 테스트 — 의존성 규칙을 테스트로 강제
- Pre-commit Hook — 코드를 커밋하기 전에 자동으로 검사
- 핵심: CI가 실패하면 에이전트가 스스로 수정합니다. 사람이 개입하지 않아도 돼요.

3. 기둥 3 : 명시적 도구 경계
- AI 에이전트가 어떤 도구를 쓸 수 있고, 어디까지 접근할 수 있는지를 명확하게 제한합니다.
- 파일 시스템: `src/` 읽기·쓰기 가능, `config/` 읽기만 가능
- API: 내부 API 호출 가능, 외부 서비스 호출 불가
- 데이터베이스: `SELECT` 가능, `DROP TABLE` 절대 불가
- 프롬프트는 부탁이고, 도구 경계는 물리적 차단입니다.

4. 기둥 4 : 지속적 피드백 루프
- AI가 만든 코드를 주기적으로 점검하고 품질이 떨어지는 부분을 자동으로 감지·정리하는 시스템입니다.
- 코딩 규칙 위반 자동 감지
- 중복 코드 발견 및 리팩토링 PR 자동 생성
- 사용하지 않는 코드 자동 제거
- 에이전트가 실수할 때마다, 그 실수는 새로운 규칙이 됩니다. 린터 규칙이 추가되고, 테스트가 추가되고, 제약이 추가됩니다. 마구가 점점 더 정교해지는 거예요.

# 하네스 시스템 4단계 작동
1. 분류기 : 고삐의 방향 전환
    - 요청 판별 : 단순 질문 vs 실제 코드 작업
2. 컨텍스트 관리자 : 가림막
    - 딱 필요한 파일과 규칙만 골라서 제공
3. 실행 루프 : 자동 교정 장치
    - 테스트 통과할 떄까지 자동 반복 - 하네스의 심장
4. 워커 격리 : 역할 분리
    - 코드 작성 AI와 코드 검토 AI 확실한 역할 분리

# oh-my-claudecode
- AI를 팀처럼 굴리는 범용 하네스 (오픈소스)
- https://github.com/Yeachan-Heo/oh-my-claudecode.git
- 19개 전문 에이전트 : 설계, 코딩, 테스트, 리서치 등 역할별로 분리된 AI 팀
- 자동 파이프라인 : 단계별 자동 진행, 순서 건너뛰기 불가
- 37개+ 스킬 : 반복 작업을 명령어 하나로 실행
- 모니터링 + 비용 추적 : 실시간 대시보드, 토큰 비용, 스마트 모델 라우팅

# 커스텀 하네스 프레임워크 구조
project/
├── CLAUDE.md                    ← 프로젝트 헌법
├── docs/
│   ├── PRD.md                   ← 뭘 만드는지
│   ├── ARCHITECTURE.md          ← 어떻게 만드는지
│   ├── ADR.md                   ← 왜 이렇게 만드는지
│   └── UI_GUIDE.md              ← 어떻게 보여야 하는지 (선택)
├── .claude/
│   ├── commands/
│   │   ├── harness.md           ← /harness — 원스톱 실행
│   │   └── review.md            ← /review — 규칙 기반 리뷰
│   └── settings.json            ← hooks 설정
├── scripts/
│   ├── execute.py               ← Phase 순차 실행 + 상태 관리
│   └── hooks/
│       ├── tdd-guard.sh         ← 테스트 없으면 구현 차단
│       ├── dangerous-cmd-guard.sh ← 위험 명령어 차단
│       └── circuit-breaker.sh   ← 반복 에러 감지
└── phases/                      ← Phase 파일 + 실행 상태

# Layer 1 : docs/ - 프로젝트의 뇌
- PRD.md : 뭘 만드는지
    - Product Requirements Document. 핵심 기능과 MVP 제외 사항을 정의
    - 템플릿 : 목표 - 핵심 기능 - MVP 제외 사항
    - MVP 제외 사항이 매우 중요합니다. 이걸 안 써놓으면 AI가 "이 기능도 추가할까요?" 하면서 scope가 끝없이 늘어납니다. "이건 안 만든다"를 명시하는 게 "이건 만든다"보다A 더 중요할 때가 많습니다.
- ARCHITECTURE.md : 어떻게 만드는지
    - 디렉토리 구조, 디자인 패턴, 데이터 흐름을 정의
    - 템플릿 : 디렉토리 구조 - 패턴 - 데이터 흐름
- ADR.md : 왜 이렇게 만드는지
    - Architecture Decision Records. "뭘 선택했고, 왜 선택했고, 뭘 포기했는지" 
    - 템플릿 : ADR 001 - 결정 - 이유 - 트레이드오프 / ADR 002 - ~
    - 트레이드오프가 핵심. 예: "Recharts를 선택했다. D3.js 대비 커스터마이징이 제한되지만 대시보드 수준에서는 충분하다" → AI가 나중에 "D3.js로 바꿀까요?" 같은 제안을 하지 않습니다.
- UI_GUIDE.md : 어떻게 보여야 하는지
    - 색상 팔레트, 컴포넌트 패턴, AI 슬롭 안티패턴(glass morphism 남용, 보라색 그라데이션 텍스트, 네온 글로우 등)을 명시

# Layer 2 : CLAUDE.md - 프로젝트의 헌법
- AI가 코딩할 때 제일 먼저 읽는 파일
- 템플릿 : 기술 스택 - 아키텍처 규칙 - 개발 프로세스 - 명령어
- CRITICAL 키워드 : AI가 우선순위 신호로 인식하여 일반 규칙보다 훨씬 강하게 따릅니다
- TDD 규칙 : "테스트를 먼저 작성하라" 하나만 넣어도 코드 품질이 크게 올라갑니다

# Layer 3 : 실행 엔진 - /harness + execute.py
- /harness 스킬 : .claude/commands/harness.md에 정의된 원스톱 실행 스킬입니다. Claude Code에서 /harness를 입력하면 실행됩니다.
- /harness 실행 흐름 :
    1. docs/문서를 전부 읽는다
    2. 사용자와 논의 - 구체화
    3. 구현 계획을 Phase로 쪼갠다
    4. Phase 파일 생성
    5. execute.py 실행
- 내가 할 일은 docs/ 채우고 /harness 치는 것뿐. 나머지는 프레임워크가 알아서.

- execute.py : scripts/execute.py는 Phase를 순차적으로 실행하는 자동화 스크립트
- 동작 방식 :
    1. `phases/{task-name}/` 폴더에서 다음 pending Phase를 찾는다
    2. Phase 파일 내용을 읽어서 Claude에게 넘긴다 (`claude -p` 헤드리스 모드)
    3. Claude가 작업을 완료하면 상태를 체크한다 (completed, error, blocked)
- 헤드리스 모드(claude -p)
    - Claude Code의 자동화 전용 모드
    - 프롬프트를 텍스트로 넘기면 CLaude가 알아서 실행하고 결과를 돌려준다.

- /review 스킬 : 프로젝트 규칙에 맞춰 자동 리뷰해주는 스킬
    1. ARCHITECTURE.md 폴더 구조 준수 여부
    2. ADR 기술 스택 준수 여부
    3. 테스트 작성 여부
    4. CLAUDE.md CRITICAL 규칙 준수 여부

# Layer 4 : Hooks - 자동 검증 장치
- .claude/settings.json에 설정하는 자동 검증 스크립트
1. TDD Guard : 구현 파일 수정 시 해당 테스트가 없으면 수정을 차단
2. Dangerous Command Guard : rm -rf, force push, git reset --hard 등 위험 명령어 차단
3. Circuit Breaker : 깊은 에러가 60초 안에 5번 반복되면 전략 변경 경고

# 전체 워크플로우
1. 클론 + 셋업
2. docs/ 채우기 (AI와 함께)
3. CLAUDE.md에 CRITICAL 규칙 추가
4. 환경변수 설정
5. /harness 실행
6. execute.py로 자동 실행 (optional)(별도로 Phase만 다시 실행하고 싶을 때)
7. 리뷰 + 개선

# 핵심 교훈 
- 하네스에 뭘 넣느냐 = 결과의 품질
- docs가 얕으면 결과도 얕다