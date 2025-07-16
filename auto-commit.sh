#!/bin/bash

START_DATE="2025-01-01"
END_DATE="2025-06-30"
FILE="README.md"
MIN_COMMITS=15
MAX_COMMITS=20

# 转为时间戳
start_ts=$(date -d "$START_DATE" +%s)
end_ts=$(date -d "$END_DATE" +%s)

# 生成所有可能的日期数组
declare -a all_dates
current_ts=$start_ts
while [ "$current_ts" -le "$end_ts" ]; do
  all_dates+=("$(date -d "@$current_ts" "+%Y-%m-%d")")
  current_ts=$((current_ts + 86400))  # 加一天
done

# 随机选择提交数量（15~20）
total_commits=$((RANDOM % (MAX_COMMITS - MIN_COMMITS + 1) + MIN_COMMITS))

# 从所有日期中随机选出 total_commits 个不重复日期
shuffled_dates=($(shuf -e "${all_dates[@]}" | head -n "$total_commits"))
IFS=$'\n' sorted_dates=($(sort <<<"${shuffled_dates[*]}"))
unset IFS

# 提交操作
for commit_date in "${sorted_dates[@]}"; do
  COMMIT_TIME="T12:00:00"
  COMMIT_DATETIME="${commit_date}${COMMIT_TIME}"
  echo "Commit on $commit_date" >> $FILE
  git add $FILE
  GIT_AUTHOR_DATE="$COMMIT_DATETIME" GIT_COMMITTER_DATE="$COMMIT_DATETIME" git commit -m "Auto commit on $commit_date"
done

echo "✅ Done generating $total_commits fake commits from $START_DATE to $END_DATE."
