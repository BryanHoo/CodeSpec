# codespec

一组 `codespec-*` skills，把 OpenSpec 的 artifact-driven 规格驱动开发（spec-driven development）融入到现有工作流：**需求确认 → 规格（Requirements/Scenarios）→ 设计 → 详细实施计划（`tasks.md`）→ TDD 实施 → 验证收束 → `archive`**。

本仓库不依赖 `/opsx:*` 斜杠命令；工作流骨架由 OpenSpec CLI 的 `openspec instructions ... --json` 提供。

## 核心能力

- 统一引导：`codespec-init` 负责 OpenSpec 安装/初始化/模板落盘与校验，其它 skills 在 OpenSpec 未就绪时会先调用它
- 项目内闭环：所有需求/设计/计划都落在 `openspec/changes/<change-name>/`，收束时用 `openspec validate` 与 `openspec archive`
- 模板随 skills 分发：`codespec-workflow` schema + templates 存放在 `skills/codespec-init/assets/openspec/`，在项目缺失时自动拷贝到项目根目录 `openspec/`
- 跨平台安装：macOS/Linux（`scripts/install.sh`）与 Windows（`scripts/install.ps1`）

## 目录结构

- `skills/`：所有 `codespec-*` skills
- `skills/codespec-init/assets/openspec/`：OpenSpec `codespec-workflow` schema + templates（项目缺失时的拷贝源）
- `scripts/install.sh`：macOS/Linux 安装脚本（symlink 到 `~/.agents/skills/codespec`）
- `scripts/install.ps1`：Windows 安装脚本（junction 到 `$HOME\.agents\skills\codespec`）
- `tmp/`：只读的公共仓库/文档引用（禁止编辑）

## 安装

详细安装说明见：`INSTALL.md`。

### 1) 安装 skills

在本仓库根目录执行：

```bash
./scripts/install.sh
```

Windows（PowerShell）：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

安装后重启你的 AI coding assistant（如果它只在启动时扫描 skills）。

默认安装路径示例为 `~/.agents/skills/codespec`；如需加载到其它目录，参考 `INSTALL.md` 的“自定义 skills 目录（可选）”。

### 2) 安装 OpenSpec CLI（必须）

skills 会检查 `openspec --version`；若未安装，按 OpenSpec 官方建议全局安装：

```bash
npm install -g @fission-ai/openspec@latest
```

前置条件：Node.js 20.19.0+（检查：`node --version`）。

## 快速开始（项目内闭环）

> 你在“目标项目”里使用，不是在本仓库里使用。

1) 在你的 AI coding assistant 中运行 `codespec-init`
- 目标：确保项目里存在 `openspec/`，并通过 `openspec schema validate codespec-workflow`
- 落盘内容包含：
  - `openspec/config.yaml`
  - `openspec/schemas/codespec-workflow/`

2) 运行 `codespec-brainstorming`
- 与用户确认需求后：
  - `openspec new change <change-name> --schema codespec-workflow`
  - 用 `openspec instructions {proposal|specs|design|tasks} --change <change-name> --json` 获取骨架并写入到：
    - `openspec/changes/<change-name>/proposal.md`
    - `openspec/changes/<change-name>/specs/**/spec.md`
    - `openspec/changes/<change-name>/design.md`
    - `openspec/changes/<change-name>/tasks.md`（仅骨架，详细计划由下一步补齐）

3) 运行 `codespec-writing-plans`
- Gate：先跑 `openspec status --change <change-name> --json`，要求 `specs` + `design` 为 `done`，且 `tasks` 为 `ready/done`
- 输出：把每个 `#### Scenario:` 展开成 `RED → VERIFY_RED → GREEN → VERIFY_GREEN → REFACTOR` 的可执行步骤，写入 `openspec/changes/<change-name>/tasks.md`

4) 实施与验证
- 执行：`codespec-executing-plans`（或 `codespec-subagent-driven-development`）
- 验证收束：`codespec-verification-before-completion`（包含 `openspec validate <change-name> --strict`）

5) 归档收束
- `codespec-finishing-a-development-branch` 会要求：
  - `openspec validate <change-name> --strict`
  - `openspec archive <change-name>`
- 注意：若 `openspec archive` 提示 `Warning: <N> incomplete task(s) found`，应先让 `openspec/changes/<change-name>/tasks.md` 复选框反映真实完成情况，再继续归档（除非用户明确同意继续）。

## 常见问题

### `openspec schema validate codespec-workflow` 失败？

- 先在项目根目录运行 `codespec-init`，再重试：
  - `openspec --version`
  - `openspec schema validate codespec-workflow`

### Windows 下安装 skills 需要管理员权限吗？

`scripts/install.ps1` 使用 `mklink /J` 创建 junction，通常不需要管理员权限或 Developer Mode。

## 贡献

欢迎提交 Issue/PR 来完善 schema、templates 和 skills 文档（尤其是跨平台与不同项目栈的验证命令模板）。

## License

本仓库暂未提供 `LICENSE` 文件；如需开源分发，请先补齐许可证声明。
