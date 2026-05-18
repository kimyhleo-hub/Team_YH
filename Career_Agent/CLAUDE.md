# Career Agent

취업 준비 전 과정을 지원하는 Claude Code 서브 에이전트 시스템.
API 키 불필요 — Claude Code 환경에서 서브 에이전트로 직접 실행됩니다.

## 디렉토리 구조 원칙

이 디렉토리(`Career_Agent/`)는 **범용 에이전트 베이스**입니다.
회사별 특화 에이전트는 별도 디렉토리로 분리 관리합니다.

```
Team_YH/
├── Career_Agent/        ← 범용 에이전트 (이 디렉토리) — 모든 회사에 공통 적용
├── {회사명}_Agent/      ← 회사별 특화 에이전트 — 해당 회사 JD·컬처 반영
└── ...
```

회사별 에이전트는 이 디렉토리의 프롬프트를 베이스로 하되,
특정 회사의 JD·조직 문화·면접 유형에 맞게 프롬프트를 조정합니다.

## 슬래시 커맨드

| 커맨드 | 역할 |
|--------|------|
| `/career` | 전체 메뉴 (오케스트레이터) |
| `/coverletter` | 자기소개서 작성·첨삭·버전 관리 |
| `/interview` | 모의면접·예상 질문·답변 평가 |
| `/company` | 기업·JD 분석·적합도 평가 |
| `/careerlog` | 경력·프로젝트 STAR 정리 |
| `/spec` | 자격증·어학·스펙 관리 |

## 데이터 저장 위치

| 경로 | 내용 |
|------|------|
| `data/cover_letters/` | 회사·직무별 자소서 JSON (버전 관리) |
| `data/experiences.json` | 경력 DB (STAR 구조) |
| `data/specs.json` | 스펙 DB |
| `data/companies/` | 기업 분석 캐시 |

## 에이전트 시스템 프롬프트

| 파일 | 에이전트 |
|------|---------|
| `prompts/orchestrator.md` | 오케스트레이터 |
| `prompts/cover_letter.md` | 자기소개서 에이전트 |
| `prompts/interview.md` | 면접 준비 에이전트 |
| `prompts/company_analysis.md` | 기업·직무 분석 에이전트 |
| `prompts/career.md` | 경력 관리 에이전트 |
| `prompts/spec_manager.md` | 스펙 관리 에이전트 |

## 서브 에이전트 실행 방법

각 슬래시 커맨드를 실행하면 해당 `prompts/*.md` 파일을 읽어 서브 에이전트를 spawn합니다.
데이터는 `data/` 디렉토리의 JSON 파일로 Read/Write 도구를 통해 영구 저장합니다.
