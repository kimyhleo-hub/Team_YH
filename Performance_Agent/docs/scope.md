# Performance Agent — 스코프 정의

## 목표

ML/DL 모델의 평가지표 수치를 극대화한다.
베이스라인 코드에서 출발하여 체계적인 단일 변인 실험으로 성능을 끌어올린다.

---

## 담당 범위 (DO)

- 평가지표 기준 성능 극대화
- 하이퍼파라미터 탐색 및 최적화
- 아키텍처 개선 및 사전학습 모델 활용
- 데이터 전처리·증강·피처 엔지니어링
- 검증 전략 설계 (CV, OOF)
- 손실 함수 선택 및 커스터마이징
- TTA, 임계값 최적화, 앙상블 후처리
- 오류 분석 및 실험 방향 전환 결정
- 실험 이력 기록 및 재현성 확보

---

## 담당하지 않는 범위 (DON'T — 스코프 외)

- **AutoML 프레임워크 사용 금지** — NAS, AutoKeras, H2O AutoML 등. 블랙박스 접근은 학습이 안 됨
- **외부 유료 API 사용 금지** — GPT API, 유료 데이터 등 (허용된 경우 제외)
- **테스트 레이블 참조 금지** — 어떤 형태로든 테스트 정답 정보를 모델에 사용하지 않는다
- **규칙 기반 하드코딩 금지** — 특정 샘플에 대한 수동 예측 오버라이드 금지
- **제출 횟수 낭비 금지** — 로컬 검증 없이 리더보드를 탐색 도구로 사용하지 않는다
- **동시 다변수 실험 금지** — 단일 변인 원칙 위반 실험은 수행하지 않는다

---

## 설치 권장 플러그인

```
# Ralph Loop — 반복 목표 기반 자율 실험 루프
/plugin install ralph-loop@claude-plugins-official

# CLAUDE.md 유지보수 — 월 1회 리뷰
/plugin install anthropics/claude-plugins-official:claude-md-management
```

---

## 기술 스택 기본값

특별히 명시되지 않으면 아래를 기본으로 사용한다.

| 항목 | 기본값 |
|------|--------|
| 프레임워크 | PyTorch |
| 표 형식 데이터 | LightGBM, XGBoost |
| 이미지 | torchvision, timm |
| 텍스트 | HuggingFace Transformers |
| 실험 관리 | context.md 이력 테이블 (로컬) |
| 시드 | 42 |
