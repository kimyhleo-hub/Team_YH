# Work Split Plan

Last updated: 2026-05-17

## 목표

Codex와 Claude Code를 분리 운영해 MATLAB 과제 검증 속도를 높인다.

## 역할 분담

### Codex
- 공통 문서 체계 유지
- 워크플로우 설계 및 TODO 관리
- 스킬, 프롬프트, 운영 규칙 정리
- Claude Code 실행 결과를 받아 문서 구조 개선

### Claude Code
- MATLAB MCP 사용
- MATLAB 코드 작성 및 실제 실행
- 그래프 결과 확인
- `solution.md` 완성도 점검
- 실제 과제 end-to-end 검증

## 작업 경계

### Codex가 하지 않는 일
- MATLAB MCP 실제 실행
- MATLAB 그래프 결과의 직접 검증

### Claude Code가 우선 처리하는 일
- `Vibration_Hw/src/solve.m` 생성 및 실행
- `Vibration_Hw/solution.md` 작성
- `Vibration_Hw/figures/` 산출물 생성

## 협업 흐름

1. Codex가 구조와 기준 문서를 정리한다.
2. Claude Code가 MATLAB 실행이 필요한 작업을 수행한다.
3. Claude Code가 결과와 이슈를 보고한다.
4. Codex가 그 결과를 공통 워크플로우와 문서에 반영한다.

## 현재 우선순위

1. Claude Code: MATLAB workflow 테스트
2. Claude Code: `Vibration_Hw` end-to-end 검증
3. Codex: 검증 결과를 바탕으로 `Plan.md`, `AGENT.md`, 스킬 문서 보정

## 완료 판단 기준

- Claude Code가 `Vibration_Hw`를 실제 실행 기반으로 정리 완료
- 저장소에 `solution.md`와 `solve.m`이 남음
- 실행 성공 여부와 한계가 문서에 반영됨
- 이후 다른 MATLAB 과제에도 재사용 가능한 절차가 정리됨
