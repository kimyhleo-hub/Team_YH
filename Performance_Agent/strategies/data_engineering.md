# 데이터·피처 엔지니어링 전략

## EDA 필수 확인 항목

1. 클래스 분포 (불균형 비율 확인)
2. 결측치 패턴 (랜덤 결측 vs. 구조적 결측)
3. 이상치 분포 (도메인 지식 기반 판단)
4. 피처 간 상관관계
5. 타겟 변수와 피처 간 관계

## 결측치 처리

| 결측 비율 | 처리 방법 |
|-----------|----------|
| < 5% | 중앙값/최빈값 대체 |
| 5~30% | KNN Imputer, 결측 여부 피처 추가 |
| > 30% | 컬럼 제거 또는 결측 자체를 신호로 활용 |

- 타겟 값 기준 그룹별 결측 패턴이 다르면 → 별도 대체 전략 적용
- 시계열 데이터 → Forward Fill / Backward Fill 우선

## 이상치 처리

- **제거**: IQR 기반 (Q1-1.5*IQR ~ Q3+1.5*IQR), 도메인 범위 외 값
- **클리핑**: 상·하위 1~5% winsorization
- **유지**: 이상치가 타겟과 상관관계 있으면 제거 금지 — 오류 분석 먼저

## 정규화·스케일링

- **StandardScaler**: 정규분포에 가까운 연속형 피처
- **MinMaxScaler**: 범위가 중요한 피처, 신경망 입력
- **RobustScaler**: 이상치 많은 데이터
- **Log Transform**: 심한 왼쪽 꼬리 분포

## 데이터 증강

### 이미지
```
기본   : Flip(H/V), RandomCrop, ColorJitter
중급   : RandomRotate, CutOut, GridDistortion
고급   : Mixup, CutMix, AugMix, RandAugment
```
- Augmentation 강도는 Validation 성능으로 결정, 너무 강하면 오히려 하락

### 텍스트
- Back Translation (EN → KO → EN)
- Synonym Replacement (KoNLPy, WordNet)
- Random Deletion / Swap (간단하지만 효과적)
- LLM 기반 Paraphrasing (데이터 희소 클래스에 집중 적용)

### 테이블
- SMOTE: 소수 클래스 오버샘플링 (연속형 피처에 효과적)
- 가우시안 노이즈 주입 (수치형 피처)
- Undersampling: 다수 클래스 제거 (정보 손실 위험, 신중히)

## 피처 엔지니어링

### 수치형
- 다항식 피처 (degree=2): 비선형 관계 포착
- 비율 피처: A/B, (A-B)/(A+B)
- 집계 피처: 그룹별 mean, std, min, max

### 범주형
- One-Hot Encoding: 카디널리티 낮을 때 (< 10)
- Label/Ordinal Encoding: 트리 계열 모델
- Target Encoding: 카디널리티 높을 때 — 반드시 CV 내부에서 적용 (누수 주의)

### 시계열
- Lag 피처: t-1, t-7, t-30
- Rolling 통계: rolling mean/std (window 크기 도메인 결정)
- 날짜 분해: 요일, 월, 분기, 공휴일 여부

## 피처 선택

1. 상관관계 기반: Pearson, Spearman (타겟과 낮은 상관 → 제거 후보)
2. 중요도 기반: LightGBM feature_importance, SHAP values
3. 제거 후 재학습으로 검증: RFECV
