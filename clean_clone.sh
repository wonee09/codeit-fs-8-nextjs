#!/bin/bash

# 경로 및 깃허브 주소
OLD_REPO="/Users/jaychoi/Desktop/codeit/fs8"
NEW_REPO="/Users/jaychoi/Desktop/codeit/fs8-clean"
GITHUB_URL="https://github.com/wonee09/codeit-fs-8-nextjs.git"

# 새 폴더 초기화
rm -rf "$NEW_REPO"
mkdir "$NEW_REPO"
cd "$NEW_REPO"
git init
git remote add origin "$GITHUB_URL"

# 기존 레포로 이동
cd "$OLD_REPO"

# 원격 브랜치 리스트 가져오기 (HEAD 제외)
branches=$(git branch -r | grep -v 'HEAD' | sed 's|origin/||')

echo branches

# 브랜치 순회
for branch in $branches; do
  echo "🌀 처리 중: $branch"

  # 브랜치 체크아웃
  git checkout "$branch"

  # 새 디렉토리에 파일 복사
  rsync -av --exclude='.git' ./ "$NEW_REPO" > /dev/null

  # 복사된 폴더에서 해당 브랜치로 커밋 & 푸시
  cd "$NEW_REPO"
  git checkout -b "$branch"
  git add .
  git commit -m "Initial commit for $branch"
  git push -u origin "$branch"

  # 원본으로 다시 돌아가기
  cd "$OLD_REPO"
done

echo "✅ 모든 브랜치 푸시 완료!"
