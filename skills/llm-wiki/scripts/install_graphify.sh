#!/usr/bin/env bash
# install_graphify.sh — (선택) 지식 그래프용 graphify 설치 + 검증
# 사용법: bash install_graphify.sh [--yes]
#   --yes : 확인 프롬프트 없이 설치
set -uo pipefail

AUTO=0
[ "${1:-}" = "--yes" ] && AUTO=1

echo "🕸  graphify (지식 그래프) 설치 — 선택 사항"
echo "------------------------------------"

# 1) python3/pip3 확인
if ! command -v python3 >/dev/null 2>&1 || ! command -v pip3 >/dev/null 2>&1; then
  echo "❌ python3/pip3 가 없습니다. graphify는 건너뜁니다."
  echo "   (graphify 없이도 ingest/query/lint 는 완전히 동작합니다.)"
  exit 0
fi

# 2) 이미 설치?
if pip3 show graphify >/dev/null 2>&1; then
  echo "✅ 이미 설치됨: $(pip3 show graphify | awk -F': ' '/^Version/{print $2}')"
  exit 0
fi

# 3) 미검증 고지 + 동의
echo "⚠️  주의: PyPI의 'graphify' 패키지가 카파시 영상 속 도구와 동일한지 미검증입니다."
echo "    Wiki 마크다운을 지식 그래프(graph.json/html/report)로 만드는 용도로 시도합니다."
echo "    graphify 없이도 ingest/query/lint 는 완전히 동작합니다 (그래프는 선택 기능)."
if [ "$AUTO" -ne 1 ]; then
  read -r -p "지금 'pip3 install graphify' 설치할까요? [y/N] " ans
  case "${ans:-N}" in
    y|Y) ;;
    *) echo "건너뜀. 나중에: bash $(basename "$0")  또는  /llm-wiki graphify"; exit 0 ;;
  esac
fi

# 4) 설치
echo "📦 설치 중..."
if pip3 install graphify; then
  echo "--- 설치 검증 ---"
  pip3 show graphify | sed -n '1,4p'
  python3 -c "import graphify" 2>/dev/null && echo "✅ import graphify OK" || echo "ℹ️  모듈 import 형태는 확인 필요(패키지마다 다름)."
  command -v graphify >/dev/null 2>&1 && echo "✅ CLI 'graphify' 사용 가능: $(command -v graphify)" || echo "ℹ️  CLI 진입점 없음 — 사용법은 pip show 의 정보로 확인."
  echo ""
  echo "다음: /llm-wiki graphify  로 Wiki를 그래프로 변환 → graphify_out/ 에 저장"
else
  echo "❌ 설치 실패. graphify 없이도 ingest/query/lint 는 정상 동작합니다."
  exit 0
fi
