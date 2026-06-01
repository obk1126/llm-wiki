#!/usr/bin/env bash
# install.sh — LLM Wiki 스킬 설치 + 새 옵시디언 볼트 생성
# 사용법: bash install.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
DEST="$SKILLS_DIR/llm-wiki"

echo "🧠 LLM Wiki 설치"
echo "------------------------------------"

# 1) 스킬 설치
mkdir -p "$SKILLS_DIR"
if [ -d "$DEST" ]; then
  read -r -p "이미 ~/.claude/skills/llm-wiki 가 있습니다. 덮어쓸까요? [y/N] " ans
  [ "${ans:-N}" = "y" ] || [ "${ans:-N}" = "Y" ] || { echo "스킬 설치 건너뜀."; }
fi
if [ ! -d "$DEST" ] || [ "${ans:-N}" = "y" ] || [ "${ans:-N}" = "Y" ]; then
  rm -rf "$DEST"
  cp -R "$HERE/skills/llm-wiki" "$DEST"
  chmod +x "$DEST/scripts/setup_vault.sh"
  echo "✅ 스킬 설치 완료 → $DEST  (Claude Code에서 /llm-wiki)"
fi

# 2) 새 볼트 생성
echo ""
read -r -p "새 볼트 경로 [기본: $HOME/Documents/my-llm-wiki]: " VPATH
VPATH="${VPATH:-$HOME/Documents/my-llm-wiki}"
read -r -p "볼트 이름 [기본: My LLM Wiki]: " VNAME
VNAME="${VNAME:-My LLM Wiki}"
bash "$DEST/scripts/setup_vault.sh" "$VPATH" "$VNAME"

# 3) (선택) graphify 설치 — 지식 그래프
echo ""
bash "$DEST/scripts/install_graphify.sh"

echo ""
echo "🎉 끝! 다음 단계:"
echo "  1) 옵시디언에서 '$VPATH' 를 볼트로 열기"
echo "  2) Claude Code에서 그 폴더를 열고  /llm-wiki setup  (핵심 맥락 인터뷰)"
echo "  3) 옵시디언 Web Clipper → Settings → Templates → Import → Templates/webclipper/Default.json 먼저,"
echo "     기존 '기본 템플릿' 삭제 후 나머지 4종 Import (자세히는 USAGE.md)"
