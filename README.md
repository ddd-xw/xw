# xw

个人工具集，包含 GitHub 克隆脚本和开发规范文档。

## 工具列表

### 1. GitHub 克隆工具

快速克隆 GitHub 公开/私有仓库的批处理脚本。

**用法：**
```bat
clone.bat owner/repo [owner2/repo2 ...]
```

**示例：**
```bat
:: 克隆单个仓库
clone.bat facebook/react

:: 克隆多个仓库
clone.bat facebook/react microsoft/vscode nodejs/node
```

**私有仓库配置：**
1. 复制 `config.example.txt` 为 `config.txt`
2. 在 [GitHub Settings](https://github.com/settings/tokens) 生成 Personal Access Token
3. 将 Token 填入 `config.txt`

### 2. Android 编译刷写规范

`android-build-flash/SKILL.md` — Android 项目通用编译和刷入流程，包含：
- QSSI / Vendor / BP 编译
- 镜像合并
- fastboot 刷入
- 增量编译指南

### 3. Git 提交规范

`git-commit/SKILL.md` — 代码提交规范和流程，包含：
- 提交信息格式
- Gerrit 推送流程
- 多项目提交规范
- 常用命令速查

## 目录结构

```
.
├── clone.bat               # GitHub 克隆脚本
├── config.txt              # 配置文件 (Token 等)
├── config.example.txt      # 配置模板
├── repos/                  # 克隆的仓库存放目录
├── android-build-flash/    # Android 编译刷写 skill
│   └── SKILL.md
├── git-commit/             # Git 提交规范 skill
│   └── SKILL.md
└── README.md
```
