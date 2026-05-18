# 추론·후처리 최적화 전략

## TTA (Test Time Augmentation)

### 기본 TTA 설계
```python
tta_transforms = [
    original,
    horizontal_flip,
    vertical_flip,
    rotate_90,
    rotate_270,
]

predictions = []
for transform in tta_transforms:
    aug_input = transform(test_input)
    pred = model(aug_input)
    pred = inverse_transform(pred, transform)  # 역변환 필요 시
    predictions.append(pred)

final_pred = torch.stack(predictions).mean(dim=0)
```

- 이미지: Flip, Rotate, Scale TTA 효과적
- 텍스트: 같은 문장을 다른 토크나이저로 처리, 길이 변형
- TTA 수가 많을수록 추론 시간 선형 증가 — 5~10개 권장

## 임계값 최적화 (이진 분류)

```python
from sklearn.metrics import f1_score
import numpy as np

def find_optimal_threshold(y_true, y_prob, metric='f1'):
    thresholds = np.arange(0.1, 0.9, 0.01)
    scores = [f1_score(y_true, y_prob >= t) for t in thresholds]
    return thresholds[np.argmax(scores)]

# OOF 예측값으로 임계값 탐색 (테스트셋 사용 금지)
optimal_threshold = find_optimal_threshold(oof_true, oof_prob)
```

- 반드시 OOF 또는 홀드아웃 검증셋에서 탐색 (테스트셋 사용 = 누수)
- F1 외 다른 지표: accuracy, recall, precision 등 평가지표에 맞게 변경

## 앙상블 후처리

### 방법 비교

| 방법 | 설명 | 추천 상황 |
|------|------|----------|
| Simple Average | 동일 가중치 평균 | 모델 성능 비슷할 때 |
| Weighted Average | OOF 성능 기반 가중치 | 성능 차이 있을 때 |
| Rank Averaging | 확률→순위 변환 후 평균 | 모델 분포 다를 때 |
| Geometric Mean | 확률 기하 평균 | 오버피팅 방지 |

```python
# Rank Averaging
from scipy.stats import rankdata
def rank_avg(preds):
    ranked = np.array([rankdata(p) / len(p) for p in preds])
    return ranked.mean(axis=0)
```

### OOF 기반 앙상블 가중치 결정
```python
from scipy.optimize import minimize

def neg_metric(weights):
    blend = sum(w * p for w, p in zip(weights, oof_preds))
    return -metric_fn(oof_true, blend)

result = minimize(neg_metric, x0=[1/n]*n, method='Nelder-Mead')
optimal_weights = result.x / result.x.sum()
```

## 최종 제출 전 체크리스트

- [ ] 제출 파일 형식이 샘플 제출 파일과 동일한가?
- [ ] ID 컬럼 순서가 맞는가?
- [ ] 예측값 범위가 요구사항 내인가? (확률: 0~1, 정수 레이블 등)
- [ ] 결측값(NaN)이 없는가?
- [ ] 테스트셋 전처리가 학습셋 전처리와 동일한가?
- [ ] 시드 고정 후 재실행해도 동일 결과인가?
- [ ] 마지막으로 제출한 버전과 성능 차이를 확인했는가?
- [ ] 제출 횟수 제한이 남아 있는가?
