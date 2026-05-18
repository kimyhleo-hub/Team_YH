# 모델 아키텍처 개선 전략

## 병목 진단 → 처방 테이블

| 증상 | 진단 | 처방 |
|------|------|------|
| 훈련 손실↓, 검증 손실↑ | 과적합 | Dropout 추가, 모델 축소, 데이터 증강 |
| 훈련·검증 손실 모두 높음 | 표현력 부족 | 레이어·채널 수 증가, 사전학습 모델 도입 |
| 손실 진동·불안정 | 수렴 불안정 | 학습률↓, Gradient Clipping, BatchNorm 추가 |
| 검증 손실 조기 수렴 | 용량 낭비 | 학습률 스케줄러 조정, Warmup 추가 |

## 사전학습 모델 Fine-tuning 전략

### 데이터량에 따른 전략
- **데이터 적음 (< 1k)**: 마지막 레이어만 학습 (Head Only)
- **데이터 중간 (1k ~ 10k)**: 마지막 2~3 블록 + Head 학습
- **데이터 많음 (> 10k)**: 전체 Fine-tuning (낮은 학습률, 앞 레이어는 더 낮게)

### Differential Learning Rate
```python
# 앞 레이어: 낮은 학습률, 뒤 레이어: 높은 학습률
optimizer = Adam([
    {'params': backbone.layer1.parameters(), 'lr': 1e-5},
    {'params': backbone.layer4.parameters(), 'lr': 1e-4},
    {'params': head.parameters(), 'lr': 1e-3},
])
```

## 아키텍처 선택 기준

### 이미지
- **분류**: EfficientNet, ConvNeXt, ViT (데이터 충분 시)
- **탐지**: YOLOv8, DINO
- **세그멘테이션**: SegFormer, Mask2Former

### 텍스트
- **분류/회귀**: BERT, RoBERTa, DeBERTa
- **생성**: LLaMA, GPT계열
- **다국어**: XLM-R, mDeBERTa

### 테이블
- **일반**: XGBoost, LightGBM, CatBoost
- **딥러닝 시도**: TabNet, FT-Transformer

## 앙상블 전략 (단일 모델 충분히 최적화 후 적용)

| 방법 | 효과 | 비용 |
|------|------|------|
| Simple Averaging | 안정적 기본 | 낮음 |
| Weighted Averaging | 성능 차이 반영 | 낮음 |
| Stacking | 최고 성능 가능 | 높음 |
| Snapshot Ensemble | 단일 학습 런으로 앙상블 | 중간 |

## 정규화 기법 선택

- **BatchNorm**: CNN, 배치 크기 충분할 때
- **LayerNorm**: Transformer, RNN, 배치 크기 작을 때
- **GroupNorm**: 배치 크기 매우 작을 때 (탐지, 세그멘테이션)
- **Dropout**: 과적합 확인 후 추가. 0.1~0.3 범위에서 탐색.
