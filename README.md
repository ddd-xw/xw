# xw

快速克隆 GitHub 公开/私有仓库的批处理脚本。

## 用法

```
clone.bat owner/repo [owner2/repo2 ...]
```

### 示例

```bat
:: 克隆单个仓库
clone.bat facebook/react

:: 克隆多个仓库
clone.bat facebook/react microsoft/vscode nodejs/node
```

## 私有仓库配置

1. 复制 `config.example.txt` 为 `config.txt`
2. 在 [GitHub Settings](https://github.com/settings/tokens) 生成 Personal Access Token
3. 将 Token 填入 `config.txt`:
   ```
   GITHUB_TOKEN=ghp_xxxxxxxxxxxx
   ```

## 目录结构

```
E:\git/
├── clone.bat          # 主脚本
├── config.txt         # 配置文件 (Token 等)
├── config.example.txt # 配置模板
├── repos/             # 克隆的仓库存放目录
└── README.md
```
