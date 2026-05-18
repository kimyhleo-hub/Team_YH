# Hw_Agent AGENT.md
Last updated: 2026-05-17

## Absolute Rules
- 읽지 않은 문제 파일을 읽은 것처럼 다루지 않는다.
- 실행하지 않은 코드, 그래프, 수치를 실제 결과처럼 쓰지 않는다.
- 누락된 조건은 임의로 채우지 않고 `가정` 또는 `확인 필요`로 분리한다.
- MATLAB은 MCP 또는 로컬 실행 환경이 없으면 `실행 미검증`으로 표시한다.

## Repo Map
```text
Hw_Agent/
|-- AGENT.md
|-- Plan.md
|-- TODO.md
|-- MATLAB_WORKFLOW.md
|-- .claude/
|   |-- commands/
|-- {subject}_{assignment}/
|   |-- notes.md
|   |-- solution.md
|   |-- src/
|   |-- figures/
```

## Project Invariants
- 공통 운영 규칙은 `AGENT.md`와 `Plan.md`에 둔다.
- MATLAB 과제 절차는 `MATLAB_WORKFLOW.md`에 둔다.
- 과제별 특수 규칙은 각 과제 폴더의 `notes.md`에 둔다.
- 기본 제출물은 `{subject}_{assignment}/solution.md`다.
- 코드가 있으면 `{subject}_{assignment}/src/`, 그래프가 있으면 `{subject}_{assignment}/figures/`를 사용한다.

## Fallback Rules
- Python 실행이 가능하면 로컬에서 직접 실행하거나 최소한 문법 검사를 한다.
- MATLAB 실행이 불가하면 코드만 작성하고, `notes.md`와 `solution.md`에 실행 불가 및 실행 방법을 남긴다.
- 실제 실행 없이 그래프 이미지나 수치 결과를 확정하지 않는다.

## Commands
- 파일 탐색: `rg --files`
- 파일 읽기: `Get-Content -Raw <file>`
- Python 문법 검사: `py -m py_compile <file.py>`
- 프로젝트 전용 빌드/테스트/린트: 아직 없음. 임의 명령어를 추정하지 않는다.

## Writing Rules
- 식은 LaTeX로 쓴다: 인라인 `$...$`, 블록 `$$...$$`
- 기호는 처음 등장할 때 정의한다.
- 그래프 과제는 `그래프 제시`와 `영향 해석`을 분리해서 쓴다.
- 단위가 있는 값은 항상 단위를 함께 적는다.

## When Updating This File
- 코드만 읽어도 알 수 있는 설명은 넣지 않는다.
- 추상 지시보다 측정 가능한 규칙을 우선한다.
- 같은 실수가 반복되면 그 실수를 막는 한 줄 규칙을 추가한다.
