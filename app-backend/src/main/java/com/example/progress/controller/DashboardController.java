package com.example.progress.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

// ★ dto の SiteSummary は import しない
// import com.example.progress.dto.SiteSummary;  // ← コメントアウト or 削除

/**
 * 工事進捗ポータルの画面遷移を担当するコントローラ。
 */
@Controller
public class DashboardController {

    // =========================
    // 画面表示用の record 定義
    // =========================

    /**
     * 現場サマリー（トップページ一覧用）
     */
    public record SiteSummary(
            Long id,             // 現場ID（リンク遷移に使う）
            String name,         // 現場名
            String period,       // 工期
            String location,     // 現場住所
            String owner,        // 発注者
            String manager,      // 現場代理人
            int progressPercent  // 進捗率 (%)
    ) {}

    /**
     * 進捗一覧の1行分（詳細ページ用）
     */
    public record ProgressRow(
            String date,        // 日付
            String phase,       // 工程
            String work,        // 作業内容
            String person,      // 担当者
            String progress,    // 進捗表示（例："80%"）
            String statusType   // ステータス種別: done / warning / info
    ) {}

    // =========================
    // ダミーデータ定義
    // =========================

    // デモ用のダミーデータ（本来はDBやサービス層から取得）
    private final List<SiteSummary> demoSites = List.of(
            new SiteSummary(
                    1L,
                    "広島物流倉庫 新築工事",
                    "2025-10-01 ～ 2026-03-31",
                    "広島県広島市〇〇区〇〇 1-2-3",
                    "山陰パナソニック株式会社",
                    "佐藤 現場代理人",
                    65
            ),
            new SiteSummary(
                    2L,
                    "山陰第2工場 改修工事",
                    "2025-04-01 ～ 2025-09-30",
                    "島根県松江市△△町 10-5",
                    "株式会社ソルコム",
                    "田中 現場代理人",
                    80
            )
    );

    // 現場IDごとの進捗リスト（本来はDBから取得）
    private final Map<Long, List<ProgressRow>> demoProgressMap = Map.of(
            1L, List.of(
                    new ProgressRow("2025-11-18", "基礎工", "捨てコン打設", "佐藤", "100%", "done"),
                    new ProgressRow("2025-11-19", "基礎工", "配筋検査", "佐藤", "80%", "warning"),
                    new ProgressRow("2025-11-20", "躯体工", "1F 柱・梁配筋", "鈴木", "20%", "info")
            ),
            2L, List.of(
                    new ProgressRow("2025-11-18", "解体", "既存設備撤去", "田中", "60%", "warning"),
                    new ProgressRow("2025-11-19", "下地工", "床下地調整", "田中", "30%", "info")
            )
    );

    /**
     * トップページ：現場一覧
     * GET /
     */
    @GetMapping("/")
    public String showSiteList(Model model) {
        model.addAttribute("sites", demoSites);
        return "index";
    }

    /**
     * 詳細ページ：現場ごとの日別進捗
     * GET /sites/{siteId}
     */
    @GetMapping("/sites/{siteId}")
    public String showSiteDetail(@PathVariable Long siteId, Model model) {

        SiteSummary site = demoSites.stream()
                .filter(s -> s.id().equals(siteId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Invalid siteId: " + siteId));

        List<ProgressRow> progressList = demoProgressMap.getOrDefault(siteId, List.of());

        model.addAttribute("site", site);
        model.addAttribute("progressList", progressList);

        return "detail";
    }
}
