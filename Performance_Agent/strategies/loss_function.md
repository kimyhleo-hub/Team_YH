# 손실 함수 설계 전략

## 태스크별 기본 손실 함수

| 태스크 | 손실 함수 | 비고 |
|--------|----------|------|
| 이진 분류 | BCEWithLogitsLoss | class_weight으로 불균형 대응 |
| 다중 분류 | CrossEntropyLoss | label_smoothing=0.1 권장 |
| 회귀 | MSELoss / HuberLoss | 이상치 많으면 HuberLoss |
| 다중 레이블 | BCEWithLogitsLoss | 각 레이블 독립 |
| 순위 | RankNet, ListMLE | 검색·추천 |
| 객체 탐지 | Focal Loss + IoU Loss | 클래스 불균형 심함 |

## 평가지표–손실 함수 정렬 확인

```
평가지표 → 권장 손실 함수
F1-score  → Focal Loss 또는 Weighted BCE
AUC-ROC   → BCE (AUC 자체는 미분 불가, 대리 손실 사용)
RMSE      → MSELoss
MAE       → HuberLoss (이상치 존재 시)
mAP       → Focal Loss + Regression Loss (탐지)
```

정렬 불일치 예시: F1이 평가지표인데 CE만 쓰는 경우 → Focal Loss 또는 Class Weight 추가

## 클래스 불균형 대응

### Weighted Cross Entropy
```python
class_counts = [1000, 200, 50]  # 각 클래스 샘플 수
weights = 1.0 / torch.tensor(class_counts, dtype=torch.float)
weights = weights / weights.sum()
criterion = nn.CrossEntropyLoss(weight=weights.to(device))
```

### Focal Loss
```python
# gamma: 어려운 샘플에 집중하는 강도 (기본값 2.0)
# alpha: 클래스 불균형 보정 (0.25 또는 class weight)
focal_loss = FocalLoss(gamma=2.0, alpha=0.25)
```
- 불균형 비율 > 10:1 이상이면 Focal Loss 권장

## 정규화 효과 손실 함수

### Label Smoothing
```python
criterion = nn.CrossEntropyLoss(label_smoothing=0.1)
```
- 과적합 방지 효과. 0.05~0.2 범위에서 탐색.
- Hard target에 과도하게 fitting되는 경우 효과적

### Mixup Loss
```python
# Mixup 데이터: x_mix = λ*x_i + (1-λ)*x_j
loss = λ * criterion(pred, y_i) + (1-λ) * criterion(pred, y_j)
```

## 커스텀 손실 함수 설계 원칙

1. 평가지표와 최대한 정렬
2. 미분 가능한 형태로 설계 (또는 surrogate loss 사용)
3. 스케일 확인: loss 값이 너무 크거나 작으면 학습 불안정
4. 기존 손실 함수와 조합 시 가중치 탐색 필요

## 다중 손실 함수 조합

```python
# 예: 분류 + 보조 회귀 손실
total_loss = cls_loss + lambda_reg * reg_loss
# lambda_reg는 0.1~1.0 범위에서 탐색
```
- 각 손실의 스케일을 먼저 맞춘 뒤 가중치 조정
