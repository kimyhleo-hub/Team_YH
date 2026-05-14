# claude.md에 넣어야 할 내용
- 절대 규칙 (맨 위에 배치) : 프로덕션 DB 직접 쿼지 금지, 시크릿 파일 커밋 금지
- 아키텍처 : 폴더 구조를 트리 형태로 - Claude가 파일을 바로 찾을 수 있게
- 빌드/테스트 명령어 : pnpm dev, pnpm test - Claude가 알아서 빌드 & 테스트 진행
- 도메인 컨텍스트 : 비즈니스 로직 - 'Product -> Variant -> 독립 재고'
- 코딩 컨벤션 : 네이밍 규칙, 커밋 메시지 포맷, 컴포넌트 패턴

- 주의 : 300줄 이하로 유지.

# tip
- 규칙 우선순위: 위에서 아래로 적용됩니다. 가장 중요한 규칙을 맨 위에 두세요.
- 직접 수정하지 마세요: Claude에게 "방금 우리가 정한 패턴, claude.md에 추가해줘"라고 시키면 기존 내용과 자연스럽게 병합됩니다.
- 트리거 키워드: claude.md에 트리거를 등록하면, 짧은 명령으로 정해진 플로우를 자동 실행할 수 있습니다.
- 팀 공유:

 claude.md를 레포에 커밋해서 팀 전체가 같은 규칙으로 Claude를 사용하세요.

 # Lazy Loading 
 - claude.md에 모든 정보를 넣으면 매 세션마다 수천 토큰이 낭비됩니다. 참조만 두고, 상세 내용은 별도 파일로 분리
 - 즉, 한 줄짜리 참조만 남겨 필요할 떄만 해당 파일을 읽도록 할 것.(ex : API 스펙: @docs/api-spec.md, 코딩 컨벤션: @docs/conventions.md 등등..)
 - tip : 폴더별로 CLAUDE.md를 분리하면 Claude가 해당 폴더 작업 시에만 해당 CLAUDE.md를 읽어 컨텍스트 bloat을 방지합니다.

# Mermaid 아키텍처
- CLAUDE.md에 Mermaid 다이어그램으로 아키텍처를 정리하면 Claude가 프로젝트 구조를 한눈에 파악합니다.
- ex : graph LR
        A[클라이언트] --> B[API 게이트웨이]
        B --> C[인증 서비스]
        B --> D[주문 서비스]
        D --> E[결제 서비스]
        D --> F[재고 서비스]
- 팁: 별도 파일(docs/architecture.md)에 정리하고, CLAUDE.md에서 @docs/architecture.md로 참조하세요.

# Non-obvious invariants only
- "코드만 봐도 알 수 있는 건 쓰지 마세요." Claude는 코드를 읽을 수 있습니다. CLAUDE.md에는 코드만 봐서는 알 수 없는 함정과 규칙만 쓰세요.

# 공식 4가지 원칙
1. Specific (구체적으로) — "테스트 잘 짜라" ❌ / "Vitest로 짜고 mock 금지" ⭕
2. Structured (구조화된 마크다운) — 헤딩·리스트로 스캔 가능하게.
3. Reviewed (정기 검토) — 한 달에 한 번 다이어트.
4. Concise (간결하게) — 100줄 이하 권장.

# High-ROI 워크플로우
- "Claude가 실수했을 때, 그 자리에서 바로 — '이 실수 다시는 안 하게 CLAUDE.md에 반영해줘.'"
- 실수 한 번이 → 영구적인 규칙이 되는 사이클. 처음부터 완벽하게 쓰려고 하지 마세요. 실수에 반응만 잘 해도 CLAUDE.md는 알아서 자랍니다.
1. Claude한테 작업 요청 → 잘못된 방식으로 처리함 (예: "이 함수 테스트 짜줘" → mock으로 짜버림)
2. 사용자가 즉시 지적 → "우리는 mock 안 쓰기로 했잖아. 이거 CLAUDE.md에 반영해줘."
3. Claude가 CLAUDE.md에 한 줄 규칙 추가
4. 새 세션에서 같은 요청 → 이번엔 실제 DB로 짬 ✅

# 빌드, 테스트, 린트 명령어를 꼭 넣어라
- ex : ## 명령어
        - 빌드: `npm run build`
        - 테스트: `npm test -- --run` (watch 모드 금지)
        - 린트: `npm run lint:fix`
        - 타입체크: `tsc --noEmit`
- 명령어가 명시되어 있지 않으면 Claude는 추측합니다. package.json을 뒤져보고, 잘못된 명령어를 시도하고, 실패하고, 다시 시도하고… 이 시간이 다 비용이고 토큰입니다. 명시되어 있으면 → 바로 정답으로 갑니다.

# @import로 분할 관리하기
- CLAUDE.md가 80~100줄에 가까워지면 분할하고 싶어집니다. 이때 쓰는 게 @import 문법입니다.
- ex : # CLAUDE.md
        @./docs/coding-style.md
        @./docs/testing-rules.md

# 안티패턴 정리
- 쓰지 마세요
        - 인간용 README 설명
        - 코드로 알 수 있는 폴더 구조
        - 모든 디렉토리 설명
        - "코드를 깨끗하게 짜라" 같은 추상적 가이드
- 이렇게 쓰세요
        - 숨겨진 invariants(불변 규칙)
        - 우선순위가 충돌할 때의 결정 규칙
        - 자주 발생하는 gotcha와 함정
        - "함수 30줄 넘으면 분리, any 금지" 같은 측정 가능한 규칙

# 전역에 Karpathy 스킬 넣기
- 프로젝트 CLAUDE.md가 아니라 전역 ~/.claude/CLAUDE.md 에 등록해, 모든 프로젝트에서 일관되게 적용되도록 하세요.
- 깃허브 forrestchang/andrej-karpathy-skills 에서 레포 클론 -> 스킬 디렉토리를 ~/.claude/skills/ 로 옮기기 -> 전역 ~/.claude/CLAUDE.md 에 한 줄 추가하여 활성화

# claude-md-management - 플러그인
- anthropics/claude-plugins-official → claude-md-management 설치하면 두 개의 슬래시 명령어가 추가됩니다.
- /revise-claude-md : 기존 CLAUDE.md를 분석해서 개선점 제안 ("이 항목은 코드로 알 수 있어요" / "이 규칙은 너무 추상적이에요" / "이건 서브디렉토리로 옮기는 게 좋아요")
- /claude-md-improver: 분석 결과를 바탕으로 더 좋은 형태로 자동 리팩토링
설치 : /plugin install anthropics/claude-plugins-official:claude-md-management
월 1회 /revise-claude-md → /claude-md-improver 사이클을 돌리면 CLAUDE.md가 비대해지는 걸 자동으로 막을 수 있습니다. → always-on 비용 절감으로 직결됩니다.

# 정기 체크리스트
- [ ]  100줄 이하인가?
- [ ]  빌드·테스트·린트 명령어가 명시되어 있는가?
- [ ]  코드만 봐도 알 수 있는 내용은 빠져 있는가?
- [ ]  구체적인 규칙인가? ("잘 짜라" 같은 추상 표현은 없는가)
- [ ]  마지막 업데이트가 최근 한 달 이내인가?
- [ ]  실수가 났을 때 바로바로 반영되고 있는가?