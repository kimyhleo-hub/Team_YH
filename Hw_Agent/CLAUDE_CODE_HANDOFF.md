# Claude Code Handoff

Last updated: 2026-05-17

## 목적

Claude Code에서 MATLAB MCP를 사용해 다음 2가지를 수행한다.

1. MATLAB workflow 테스트
2. `Vibration_Hw` 과제 1건 end-to-end 검증

## 현재 상태

- Claude Code 쪽 MATLAB MCP 연결 확인 완료
- Codex 쪽 공통 문서 작성 완료
- 과제별 메모 작성 완료
- 문제풀이 스킬 초안 작성 완료
- 아직 MATLAB 실행 결과가 저장소에 반영되지는 않음

## 먼저 읽을 파일

1. `AGENT.md`
2. `Plan.md`
3. `Vibration_Hw/notes.md`
4. `Vibration_Hw/vibration_hw.md`

## Claude Code가 맡을 일

### 1. MATLAB workflow 테스트
- `Vibration_Hw` 기준으로 MATLAB 과제 처리 흐름이 실제로 동작하는지 점검
- `solve.m` 작성 방식, 그래프 생성 방식, 실행 결과 반영 방식 검증
- MATLAB MCP로 실제 실행 가능한지 확인
- 실행 중 막히는 지점이 있으면 원인 기록

### 2. 실제 과제 1건 end-to-end 검증
- `Vibration_Hw`용 폴더 구조를 제출 가능한 형태로 보강
- 필요하면 아래 파일 생성
  - `Vibration_Hw/solution.md`
  - `Vibration_Hw/src/solve.m`
  - `Vibration_Hw/figures/...`
- 문제 요구사항에 맞는 식, MATLAB 코드, 그래프, 해석 문장까지 완성
- 실행 결과를 바탕으로 문서 반영

## 산출물 기준

### 필수
- `Vibration_Hw/solution.md`
- `Vibration_Hw/src/solve.m`

### 조건부
- `Vibration_Hw/figures/*.png`
- `Vibration_Hw/notes.md` 보강

## 검증 기준

- 문제 1, 문제 2의 요구 산출물이 모두 반영되었는가
- 그래프 축, 범례, 제목이 명확한가
- 파라미터 `m`, `c`, `k` 변화가 분리되어 비교되는가
- `solution.md`에 식, 코드 요약, 그래프 해석, 최종 답이 포함되는가
- MATLAB 실행 여부가 명확히 기록되는가

## Claude Code 작업 순서

1. 문제 요구사항 재정리
2. 폴더 구조 보강
3. `solve.m` 초안 작성
4. MATLAB MCP로 실행
5. 그래프/출력 검토
6. `solution.md` 작성
7. 누락 사항 점검
8. 결과 및 막힌 점 보고

## 보고 형식

작업이 끝나면 아래 형식으로 결과를 남긴다.

```text
완료 항목:
- ...

생성/수정 파일:
- ...

실행 결과:
- ...

남은 이슈:
- ...
```

## 주의

- 실행하지 않은 그래프나 수치를 결과처럼 적지 않는다.
- 문제 2는 문제 1 식을 그대로 복붙하지 말고 전달력 기준으로 다시 정의한다.
- 공통 규칙 수정이 필요하면 `AGENT.md`, 과제 전용 수정이면 `Vibration_Hw/notes.md`에 반영 후보를 기록한다.
