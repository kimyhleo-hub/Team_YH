# 검증 전략 설계 프로토콜

## CV 폴드 선택 기준

| 데이터 특성 | CV 방법 |
|------------|---------|
| 일반 분류·회귀 | Stratified K-Fold (k=5) |
| 클래스 불균형 | Stratified K-Fold (필수) |
| 그룹 있는 데이터 (환자 ID, 사용자 ID) | Group K-Fold |
| 시계열 | TimeSeriesSplit (미래 누수 방지) |
| 적은 데이터 (< 1000) | Stratified K-Fold (k=10) 또는 LOOCV |
| 다중 레이블 | MultilabelStratifiedKFold |

## OOF (Out-of-Fold) 예측 생성

```python
from sklearn.model_selection import StratifiedKFold

skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
oof_pred = np.zeros(len(train))

for fold, (train_idx, val_idx) in enumerate(skf.split(X, y)):
    X_tr, X_val = X[train_idx], X[val_idx]
    y_tr, y_val = y[train_idx], y[val_idx]

    model.fit(X_tr, y_tr)
    oof_pred[val_idx] = model.predict_proba(X_val)[:, 1]

oof_score = metric_fn(y, oof_pred)
print(f"OOF Score: {oof_score:.4f}")
```

- OOF 점수는 단일 홀드아웃보다 신뢰도 높음
- 앙상블 가중치 결정 시 OOF 점수 사용

## 로컬 검증 vs. 리더보드 괴리 분석

| 괴리 방향 | 가능한 원인 | 대응 |
|-----------|-----------|------|
| 로컬 > 리더보드 | 검증셋 오염(누수), 분포 불일치 | CV 전략 재설계, 누수 점검 |
| 로컬 < 리더보드 | 리더보드 과적합(운) | 로컬 기준으로만 판단 |
| 변동 큰 로컬 | fold 수 부족, 시드 민감 | k 늘리기, 다중 시드 평균 |

## 데이터 누수 (Leakage) 체크리스트

- [ ] Target Encoding이 CV 외부에서 적용되었는가?
- [ ] 시계열 데이터에서 미래 정보가 포함되었는가?
- [ ] 정규화·스케일링이 학습+검증 전체로 fit되었는가?
- [ ] 같은 그룹(환자, 사용자)이 train/val에 동시에 있는가?
- [ ] 테스트셋 정보가 피처 생성에 사용되었는가?

## 검증 안정성 향상

- 중요한 결정은 다른 시드 3개로 반복 후 평균
- 5-Fold CV가 기본, 데이터 적으면 10-Fold
- Stratified K-Fold는 회귀에도 적용 가능 (타겟 분위수 기준)

## 홀드아웃 전략

- 제출 횟수 제한이 있는 경우: 전체 데이터의 20%를 로컬 테스트셋으로 고정
- 홀드아웃셋은 최종 모델 선택 시에만 1~2회 사용 (반복 사용 금지)
