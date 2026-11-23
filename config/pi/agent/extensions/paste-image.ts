import { readFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { extname } from "node:path";
import {
  CustomEditor,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

// pi が ctrl+v で作る一時ファイル名
const PATH_RE = /\S*pi-clipboard-[0-9a-f-]{36}\.(?:png|jpe?g|webp|gif)/g;
const MARKER_RE = /\[Image #(\d+)\]/g;

const MIME: Record<string, string> = {
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".webp": "image/webp",
  ".gif": "image/gif",
};

export default function (pi: ExtensionAPI) {
  // マーカー番号 -> 一時ファイルのパス
  const images = new Map<number, string>();
  let nextNo = 1;

  // パスをマーカーに変える(同じパスなら同じ番号)
  const toMarker = (path: string): string => {
    if (!path.startsWith(tmpdir())) return path;
    for (const [no, p] of images) if (p === path) return `[Image #${no}]`;
    const no = nextNo++;
    images.set(no, path);
    return `[Image #${no}]`;
  };

  // 入力欄: 本体が画像パスを挿入する瞬間に [Image #N] へ差し替える
  class MarkerEditor extends CustomEditor {
    insertTextAtCursor(text: string): void {
      super.insertTextAtCursor(text.replace(PATH_RE, toMarker));
    }
  }

  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setEditorComponent(
      (tui, theme, kb) => new MarkerEditor(tui, theme, kb),
    );
  });

  // 送信時: 本文に残っているマーカーを画像添付に変換する
  pi.on("input", async (event, ctx) => {
    if (event.source !== "interactive") return { action: "continue" };

    const attached = [...(event.images ?? [])];
    const base = attached.length;

    // 念のため、マーカー化されなかった生のパスも拾う
    const text = event.text.replace(PATH_RE, toMarker);

    const used = new Set<number>();
    for (const m of text.matchAll(MARKER_RE)) used.add(Number(m[1]));

    for (const no of [...used].sort((a, b) => a - b)) {
      const path = images.get(no);
      if (!path) continue;
      try {
        const buf = await readFile(path);
        attached.push({
          type: "image",
          data: buf.toString("base64"),
          mimeType: MIME[extname(path).toLowerCase()] ?? "image/png",
        });
      } catch {
        ctx.ui.notify(`画像を読めませんでした: ${path}`, "warning");
      }
    }

    images.clear();
    nextNo = 1;

    if (attached.length === base) return { action: "continue" };
    return { action: "transform", text, images: attached };
  });
}
