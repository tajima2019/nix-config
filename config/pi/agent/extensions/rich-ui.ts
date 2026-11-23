import type { AssistantMessage } from "@earendil-works/pi-ai";
import type {
  ExtensionAPI,
  ExtensionContext,
  WorkingIndicatorOptions,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

// ---------- 作業中スピナー ----------
const FRAMES = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];
const COLORS = [
  "\x1b[38;2;255;179;186m",
  "\x1b[38;2;255;223;186m",
  "\x1b[38;2;255;255;186m",
  "\x1b[38;2;186;255;201m",
  "\x1b[38;2;186;225;255m",
  "\x1b[38;2;218;186;255m",
];
const RESET_FG = "\x1b[39m";

const spinner: WorkingIndicatorOptions = {
  frames: FRAMES.map((f, i) => `${COLORS[i % COLORS.length]}${f}${RESET_FG}`),
  intervalMs: 80,
};

// ---------- フッター ----------
const fmt = (n: number) => (n < 1000 ? `${n}` : `${(n / 1000).toFixed(1)}k`);

function installFooter(ctx: ExtensionContext) {
  ctx.ui.setFooter((tui, theme, footerData) => {
    const unsub = footerData.onBranchChange(() => tui.requestRender());

    return {
      dispose: unsub,
      invalidate() {},
      render(width: number): string[] {
        let input = 0;
        let output = 0;
        let cacheRead = 0;
        let cost = 0;
        for (const e of ctx.sessionManager.getBranch()) {
          if (e.type === "message" && e.message.role === "assistant") {
            const m = e.message as AssistantMessage;
            input += m.usage.input;
            output += m.usage.output;
            cacheRead += m.usage.cacheRead;
            cost += m.usage.cost.total;
          }
        }

        // 1行目: 作業場所 + git ブランチ
        const home = process.env.HOME ?? "";
        let cwd = ctx.sessionManager.getCwd();
        if (home && (cwd === home || cwd.startsWith(home + "/"))) {
          cwd = "~" + cwd.slice(home.length);
        }
        const branch = footerData.getGitBranch();
        const line1 = truncateToWidth(
          theme.fg("accent", "📁 ") +
            theme.fg("text", cwd) +
            (branch ? theme.fg("accent", `  ⎇ ${branch}`) : ""),
          width,
          theme.fg("dim", "..."),
        );

        // 2行目: トークン・コスト(左) とモデル名(右)
        const left =
          theme.fg("accent", "◆ ") +
          theme.fg(
            "dim",
            `↑${fmt(input)} ↓${fmt(output)} R${fmt(cacheRead)} `,
          ) +
          theme.fg("warning", `$${cost.toFixed(3)}`);
        const right = theme.fg("success", ctx.model?.id ?? "no-model");
        const pad = " ".repeat(
          Math.max(1, width - visibleWidth(left) - visibleWidth(right)),
        );

        return [line1, truncateToWidth(left + pad + right, width)];
      },
    };
  });
}
// ---------- 通知 ----------
function notify(title: string, body: string): void {
  if (process.env.KITTY_WINDOW_ID) {
    // kitty: OSC 99
    process.stdout.write(`\x1b]99;i=1:d=0;${title}\x1b\\`);
    process.stdout.write(`\x1b]99;i=1:p=body;${body}\x1b\\`);
  } else {
    // Ghostty / iTerm2 / WezTerm: OSC 777
    process.stdout.write(`\x1b]777;notify;${title};${body}\x07`);
  }
}

export default function (pi: ExtensionAPI) {
  let footerOn = true;

  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setWorkingIndicator(spinner);
    if (footerOn) installFooter(ctx);
  });

  // 応答が完全に終わって入力待ちになったときだけ通知する
  pi.on("agent_settled", async () => {
    notify("Pi", "入力待ちです");
  });

  pi.registerCommand("rich-footer", {
    description: "リッチフッターの ON/OFF を切り替える",
    handler: async (_args, ctx) => {
      footerOn = !footerOn;
      if (footerOn) {
        installFooter(ctx);
        ctx.ui.notify("リッチフッター: ON", "info");
      } else {
        ctx.ui.setFooter(undefined);
        ctx.ui.notify("標準フッターに戻しました", "info");
      }
    },
  });
}
