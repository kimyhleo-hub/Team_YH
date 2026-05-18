# Career Agent 개발 계획

## 개요

취업 준비의 전 과정을 지원하는 Claude Code 서브 에이전트 시스템.
자기소개서 작성, 경력 관리, 면접 준비, 기업·직무 분석, 스펙 관리를 슬래시 커맨드로 제공한다.

**API 키 불필요** — Claude Code 환경에서 서브 에이전트로 직접 실행된다.

---

## 시스템 아키텍처

```
사용자
  │
  ├─ /career       → Orchestrator 에이전트
  ├─ /coverletter  → 자기소개서 에이전트
  ├─ /interview    → 면접 준비 에이전트
  ├─ /company      → 기업·직무 분석 에이전트
  ├─ /careerlog    → 경력 관리 에이전트
  └─ /spec         → 스펙 관리 에이전트
          │
          ▼
     data/ (JSON 영구 저장)
```

**실행 방식**
1. 사용자가 슬래시 커맨드 입력
2. `.claude/commands/{command}.md` 로드
3. 해당 `prompts/{agent}.md`를 Read해서 서브 에이전트 spawn
4. 서브 에이전트가 작업 수행 + `data/` 디렉토리에 결과 저장

**모델 배정**

| 에이전트 | 모델 | 이유 |
|---------|------|------|
| 자기소개서 | claude-opus-4-7 | 합격을 가르는 문서 — 최고 품질 필요 |
| 면접 준비 | claude-opus-4-7 | 답변 품질과 피드백 깊이가 결과에 직결 |
| 기업·직무 분석 | claude-opus-4-7 | 갭 분석·인사이트의 깊이가 지원 전략을 좌우 |
| Orchestrator | claude-sonnet-4-6 | 라우팅·컨텍스트 관리 |
| 경력 관리 | claude-sonnet-4-6 | STAR 정제·태그 분류 |
| 스펙 관리 | claude-sonnet-4-6 | 목표 설정·학습 계획 생성 |

---

## 디렉토리 구조

```
Career_Agent/
├── CLAUDE.md                      # 프로젝트 컨텍스트 (Claude Code 자동 로드)
├── Plan.md                        # 이 파일
├── .claude/
│   └── commands/
│       ├── career.md              # /career  — 오케스트레이터 진입점
│       ├── coverletter.md         # /coverletter
│       ├── interview.md           # /interview
│       ├── company.md             # /company
│       ├── careerlog.md           # /careerlog
│       └── spec.md                # /spec
├── prompts/
│   ├── orchestrator.md            # 오케스트레이터 시스템 프롬프트
│   ├── cover_letter.md            # 자기소개서 에이전트 프롬프트
│   ├── interview.md               # 면접 준비 에이전트 프롬프트
│   ├── company_analysis.md        # 기업·직무 분석 에이전트 프롬프트
│   ├── career.md                  # 경력 관리 에이전트 프롬프트
│   └── spec_manager.md            # 스펙 관리 에이전트 프롬프트
└── data/
    ├── cover_letters/             # {회사명}_{직무명}.json (버전 관리)
    ├── experiences.json           # 경력 DB (STAR 구조)
    ├── specs.json                 # 스펙 DB
    └── companies/                 # {회사명}.json (기업 분석 캐시)
```

---

## 에이전트별 상세

### 자기소개서 에이전트 (`/coverletter`)

**필승 공식 — PREP × STAR × 수치화**

| 단계 | 내용 |
|------|------|
| PREP 구조 | Point → Reason → Example(STAR) → Point 재강조 |
| STAR 서술 | Situation · Task · Action · Result |
| 수치화 | 수치 없는 경험 → 에이전트가 질문으로 끌어냄 |
| JD 미러링 | JD 핵심 키워드 → 자소서에 자연스럽게 삽입 |
| 소제목 선택 | 항목별 소제목 3개 제안 → 사용자가 선택 |
| AI 말투 교정 | 과도하게 정제된 패턴 감지 및 자연스러운 표현으로 교체 |

**처리 흐름:**
```
경험 메모(날것) + JD 입력
  → 소제목 3개 제안 → 사용자 선택
  → 수치 없으면 질문
  → JD 키워드 삽입 + PREP/STAR 조립
  → AI 말투 교정
  → 글자수 체크 (80~90% 권장)
  → 완성 초안 + 점수 + 개선 포인트
  → 저장: data/cover_letters/{회사}_{직무}.json
```

---

### 경력 관리 에이전트 (`/careerlog`)

- 날것의 경험 → STAR 구조 정제
- 수치 없는 항목은 질문으로 끌어냄
- 직무 태그 자동 부여
- 지원 직무별 최적 경험 선별
- 저장: `data/experiences.json`

---

### 면접 준비 에이전트 (`/interview`)

- JD + 자소서 기반 예상 질문 생성 (인성·기술·상황)
- 대화형 모의면접 진행
- 답변 5항목 평가 (명확성·구체성·직무 적합성·완결성·자연스러움)
- 면접 유형별 전략 (압박·PT·토론)
- 저장: `data/interviews/{회사}_{직무}.json`

---

### 기업·직무 분석 에이전트 (`/company`)

- JD 분석: 필수/우대 역량, 핵심 키워드
- 갭 분석: 사용자 스펙 vs JD (적합도 0~100점)
- 기업 리서치: 웹 검색 활용
- 저장: `data/companies/{회사명}.json`

---

### 스펙 관리 에이전트 (`/spec`)

- 자격증·어학·학점·활동 등록·조회
- 목표 기업 기반 필요 스펙 도출
- 학습 계획 생성
- 달성률 트래킹
- 저장: `data/specs.json`

---

## 개발 단계 (Milestones)

| 단계 | 내용 | 상태 |
|------|------|------|
| Phase 1 | 슬래시 커맨드 + 프롬프트 파일 전체 구성 | ✅ 완료 |
| Phase 2 | 자기소개서 에이전트 실사용 테스트 및 프롬프트 개선 | 진행 중 |
| Phase 3 | 경력·스펙 관리 에이전트 테스트 및 개선 | 대기 |
| Phase 4 | 면접·기업 분석 에이전트 테스트 및 개선 | 대기 |
| Phase 5 | Orchestrator 라우팅 고도화 | 대기 |
| Phase 6 | MCP 연동 (Google Calendar, Notion, Gmail) | 대기 |

---

## MCP 연동 계획 (Phase 6)

| MCP | 용도 |
|-----|------|
| Google Calendar | 면접 일정, 시험 D-day 알림 |
| Notion | 전체 취업 준비 현황 대시보드 |
| Gmail | 서류 합격/불합격 이메일 파싱, 지원 현황 자동 업데이트 |
