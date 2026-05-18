# 하이퍼파라미터 탐색 전략

## 탐색 전략 선택

| 상황 | 전략 |
|------|------|
| 이전 실험 없음, 탐색 공간 넓음 | Random Search |
| 실험 5회 이상 누적, 결과 패턴 보임 | Bayesian Optimization (Optuna) |
| 탐색 변수 ≤ 3개, 조합 수 ≤ 50 | Grid Search |

## 우선 탐색 순서

1. **학습률** — 가장 영향 큰 단일 변수. 로그 스케일로 탐색 (`1e-4` ~ `1e-1`).
2. **배치 크기** — 메모리 한도 내 최대값부터 시작. 크면 안정적, 작으면 일반화 유리.
3. **옵티마이저** — Adam 기본, 수렴 불안정하면 AdamW 또는 SGD+Momentum.
4. **정규화 강도** — Dropout(`0.1~0.5`), Weight Decay(`1e-5~1e-2`).
5. **학습률 스케줄러** — CosineAnnealingLR, OneCycleLR, ReduceLROnPlateau.

## 학습률 스케줄러 선택 기준

- **CosineAnnealingLR**: epoch 수가 고정된 경우, 일반적으로 안정적
- **OneCycleLR**: 빠른 수렴이 필요할 때, 배치별 스텝
- **ReduceLROnPlateau**: 검증 손실 모니터링 기반, epoch 수 불확실한 경우
- **Warmup + Decay**: Transformer 계열 모델, 초기 불안정성 방지

## 탐색 범위 기준값

```
learning_rate : [1e-4, 3e-4, 1e-3, 3e-3, 1e-2]
weight_decay  : [0, 1e-5, 1e-4, 1e-3, 1e-2]
dropout       : [0.0, 0.1, 0.2, 0.3, 0.5]
batch_size    : [16, 32, 64, 128, 256]
```

## 단계별 탐색 전략

1. 학습률 단독 Random Search (5~10회) → 최적 범위 확인
2. 최적 학습률 고정 후 정규화 파라미터 탐색
3. 스케줄러 조합 탐색 (최종 3개 조합 비교)
4. 배치 크기는 메모리 제약 내에서 마지막에 조정

## 주의사항

- 실험 1회마다 변경 변수는 반드시 1개로 제한
- 학습률 변경 시 스케줄러 파라미터(T_max, max_lr 등)도 함께 조정
- 배치 크기 변경 시 학습률 재조정 필요 (Linear Scaling Rule 참고)
