# 安装 codespec skills（含 codespec-workflow 模板）

本仓库提供一组 `codespec-*` skills，并内置 `codespec-workflow` 的 OpenSpec 模板与 `codespec-init` 引导流程。

> 约定安装路径：`~/.agents/skills/codespec`  
> `codespec-init` 会从 `~/.agents/skills/codespec/codespec-init/assets/openspec/...` 自动拷贝模板到项目根目录的 `openspec/`；其它 skills 在检测到 OpenSpec 未就绪时会先调用它。

## 1) 安装 skills

在本仓库根目录执行：

```bash
./scripts/install.sh
```

Windows（PowerShell）：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

如果你已经有 `~/.agents/skills/codespec`，并且想覆盖：

```bash
./scripts/install.sh --force
```

Windows（PowerShell）：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Force
```

验证：

```bash
ls -la ~/.agents/skills/codespec
```

Windows（PowerShell）：

```powershell
dir $HOME\.agents\skills\codespec
```

然后重启你的 AI coding assistant（如果它只在启动时扫描 skills）。

### 自定义 skills 目录（可选）

本仓库默认把 skills 安装到 `~/.agents/skills/codespec`，因为 `codespec-init` 会从该路径读取 OpenSpec 模板资产（`codespec-init/assets/openspec/...`）。

如果你的工具需要从其它目录加载 skills，你可以**额外**再创建一个软链接/目录映射，指向 `~/.agents/skills/codespec`（推荐这样做，不需要改动任何 skill 文档）。

macOS/Linux（bash/zsh）示例：

```bash
mkdir -p <your-skill-dir>
ln -s ~/.agents/skills/codespec <your-skill-dir>/codespec
```

Windows（PowerShell）示例（junction）：

```powershell
cmd /c mklink /J "<your-skill-dir>\\codespec" "$HOME\\.agents\\skills\\codespec"
```

## 2) 安装 OpenSpec CLI（必须）

skills 会在流程里检查 `openspec --version`；若未安装，按 OpenSpec 官方建议全局安装：

```bash
npm install -g @fission-ai/openspec@latest
```

前置条件（来自 OpenSpec 文档）：Node.js 20.19.0+（检查：`node --version`）。

## 3) 在项目里使用（自动拷贝模板）

当你在项目里触发 `codespec-brainstorming` / `codespec-writing-plans` 等流程时：

- 若项目缺少 `openspec/`，会先执行 `openspec init --tools none`
- 若项目缺少 `openspec/schemas/codespec-workflow/schema.yaml`，会自动从 skills 拷贝到项目
- 若项目缺少 `openspec/config.yaml`，会自动从 skills 拷贝到项目

建议：把 `openspec/config.yaml` 与 `openspec/schemas/codespec-workflow/` 提交到项目仓库（便于团队协作与 CI）。

## 卸载

```bash
rm ~/.agents/skills/codespec
```
