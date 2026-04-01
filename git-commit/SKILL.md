---
name: git-commit
description: 代码提交规范和流程
metadata:
  author: ddd-xw
  version: 2.0
---

## 代码提交规范

### 提交信息格式
```
[项目][作者][描述 YYYYMMDD][第几笔/总共几笔]
```

### 示例
```
[MyProject][yourname][consumerir hal use lirc 20260330][1/3]
[MyProject][yourname][pwm-ir-tx use new pwm api 20260330][2/3]
[MyProject][yourname][add pwm-ir device tree 20260330][3/3]
```

### 描述规范
- 使用简单英文描述修改内容
- 全部小写字母
- 单词用空格或连字符分隔
- 长度控制在 65 字符以内（Gerrit会警告超过65字符的提交）

### 完整工作流程

#### 1. 拉取最新代码
```bash
git pull --rebase <remote> <branch>
```

如果有未提交的修改，先 stash：
```bash
git stash push -m "temp stash" -- <其他目录>
git pull --rebase <remote> <branch>
```

#### 2. 查看修改状态
```bash
git status
git diff
```

#### 3. 暂存修改
```bash
git add <files>
# 或全部暂存
git add -A
```

#### 4. 提交修改
```bash
git commit -m "[项目][作者][描述 YYYYMMDD][N/M]"
```

#### 5. 推送到 Gerrit 审查
```bash
git push <remote> HEAD:refs/for/<branch>
```

> **注意：** 使用 `refs/for/<branch>` 推送到 Gerrit 进行代码审查，不要直接推送到分支。

### 多项目提交
当修改涉及多个 git 仓库时，需要分别在每个仓库执行提交，序号按仓库数量递增：

- **2 个仓库**：`[1/2]`、`[2/2]`
- **3 个仓库**：`[1/3]`、`[2/3]`、`[3/3]`
- **N 个仓库**：`[1/N]`、`[2/N]` ... `[N/N]`

```bash
# 项目 1
cd /path/to/project1
git pull --rebase <remote> <branch>
git add <files>
git commit -m "[项目][作者][描述 YYYYMMDD][1/3]"
git push <remote> HEAD:refs/for/<branch>

# 项目 2
cd /path/to/project2
git pull --rebase <remote> <branch>
git add <files>
git commit -m "[项目][作者][描述 YYYYMMDD][2/3]"
git push <remote> HEAD:refs/for/<branch>

# 项目 3
cd /path/to/project3
git pull --rebase <remote> <branch>
git add <files>
git commit -m "[项目][作者][描述 YYYYMMDD][3/3]"
git push <remote> HEAD:refs/for/<branch>
```

### 常用命令速查
```bash
# 查看修改状态
git status

# 查看具体修改
git diff

# 查看提交历史
git log --oneline -10

# 修改最近的提交信息
git commit --amend -m "新的提交信息"

# 撤销最近的提交（保留修改）
git reset HEAD~1

# 查看远程仓库
git remote -v

# 暂存未提交的修改
git stash push -m "描述" -- <目录>

# 恢复暂存的修改
git stash pop
```

### 推送问题排查

#### `repo upload` 失败处理
`repo upload` 可能配置了错误的远程服务器，导致 HTTP 404 错误。

**解决方案：直接使用 `git push` 推送到已配置的 Gerrit 服务器**

```bash
# 正确方式：推送到 Gerrit 代码审查
git push <remote> HEAD:refs/for/<branch>

# 示例
git push origin HEAD:refs/for/main
```

> **注意：** 不要直接推送到分支（`git push <remote> <branch>`），Gerrit 会拒绝。必须使用 `refs/for/<branch>` 进行代码审查。

### 注意事项
1. 提交前先 git pull --rebase 拉取最新代码
2. 提交信息第一行不超过 65 字符，否则 Gerrit 会警告
3. 描述要简洁明了，使用简单英文
4. 日期格式为 YYYYMMDD
5. 多笔提交要标明序号关系，如 [1/2] 和 [2/2]
6. 先查看 diff 再提交，确保修改正确
7. 推送到 Gerrit 使用 `HEAD:refs/for/<branch>` 而不是直接推送到分支
8. 如果有未提交的修改，先 stash 再 pull，避免冲突
9. 提交前确认修改的文件是否正确，避免误提交
10. `repo upload` 可能失败（远程服务器配置错误），优先使用 `git push <remote> HEAD:refs/for/<branch>`
