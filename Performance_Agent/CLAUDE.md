# Performance Agent — 범용 지침

## 워크플로우

```mermaid
graph TD
    A[새 작업 수신] --> B[context.md + 코드 읽기]
    B --> C{정보 충분?}
    C -- No --> D[사용자에게 질문]
    C -- Yes --> E[개선 방향 우선순위 제시]
    E --> F[단일 변인 실험]
    F --> G[context.md 이력 기록]
    G --> H{3회 연속 정체?}
    H -- Yes --> I[/error-analysis 먼저]
    H -- No --> F
    I --> E
```

## CRITICAL 규칙

> CRITICAL: 아래 세 규칙은 다른 모든 판단보다 우선한다.

- **CRITICAL: 단일 변인 원칙** — 실험 1회당 변경은 정확히 하나. 예외 없음.
- **CRITICAL: 오류 분석 우선** — 3회 연속 성능 정체 시 새 실험 전 `/error-analysis` 먼저.
- **CRITICAL: 중복 제안 금지** — 제안 전 반드시 `context.md` 이력을 읽고 이미 시도한 기법인지 확인한다.

## 행동 규칙

- 파악 전에 제안 금지 — 태스크·평가지표·베이스라인·제약 조건을 먼저 파악한다.
- 실험 후 즉시 기록 — 결과를 `context.md` 이력 테이블에 바로 기록한다.
- 로컬 검증 기준 — 리더보드가 아닌 OOF 점수를 기준으로 방향을 결정한다.
- 아키텍처 큰 변경 시 → Plan Mode(Shift+Tab)로 먼저 계획을 수립한다.

## 작업 시작 시 확인 순서

1. 태스크 유형 / 평가지표 / 제약 조건
2. 현재 베이스라인 성능 수치
3. 이미 시도한 기법 목록 (`context.md` 확인)

## 실행 명령어

프로젝트 `CLAUDE.md`에 아래를 채운다.

```
학습   : python train.py
평가   : python evaluate.py --fold all
예측   : python predict.py --tta
```

## 트리거

| 사용자 발화 | 실행 커맨드 |
|------------|------------|
| `"실험 시작"` / `"다음 실험"` | `/new-experiment` |
| `"막혔어"` / `"왜 안 오르지"` / `"정체"` | `/error-analysis` 먼저 수행 |
| `"제출할게"` / `"submit"` | `/pre-submit` |
| `"새 프로젝트"` / `"공모전 시작"` | `/new-project` |
| `"검토해줘"` / `"이 실험 괜찮아?"` | `/review` |
| `"전략 알려줘"` + [역할명] | 해당 `strategies/` 파일 읽고 답변 |

## 전략 참조 파일

필요할 때만 읽는다. 세션 시작 시 전부 로딩하지 않는다.

| 역할 | 파일 |
|------|------|
| 하이퍼파라미터 | `strategies/hyperparameter.md` |
| 아키텍처 | `strategies/architecture.md` |
| 데이터·피처 | `strategies/data_engineering.md` |
| 실험 관리 | `strategies/experiment_management.md` |
| 손실 함수 | `strategies/loss_function.md` |
| 추론·후처리 | `strategies/inference_postprocess.md` |
| 검증 전략 | `strategies/validation_strategy.md` |
| 오류 분석 | `strategies/error_analysis.md` |

## 커스텀 명령어

- `/new-project` — 새 공모전·연구 프로젝트 폴더 자동 생성
- `/new-experiment` — 단일 변인 실험 시작 + context.md 자동 기록
- `/review` — 실험 제안을 이력과 대조 검토 (실험 전 품질 검증)
- `/error-analysis` — 오류 패턴 분석 + 다음 방향 결정
- `/pre-submit` — 최종 제출 전 체크리스트
