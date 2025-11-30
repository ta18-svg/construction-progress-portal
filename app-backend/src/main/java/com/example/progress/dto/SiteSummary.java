package com.example.progress.dto;

/**
 * 現場一覧画面などで使う「現場サマリー情報」を表すDTOクラスの例。
 * ここでは、
 *  - siteCode       : 現場コード
 *  - siteName       : 現場名
 *  - clientName     : 得意先名（顧客名）
 *  - startDate      : 着工日（文字列で簡易に持つ）
 *  - endDate        : 竣工予定日
 *  - progressRate   : 進捗率（0〜100 の int）
 * を持つ想定で定義しています。
 */
public class SiteSummary {

    private String siteCode;
    private String siteName;
    private String clientName;
    private String startDate;
    private String endDate;
    private int progressRate;

    // ★ エラーに出ているシグネチャと同じコンストラクタを用意する
    //   (String, String, String, String, String, int)
    public SiteSummary(String siteCode,
                       String siteName,
                       String clientName,
                       String startDate,
                       String endDate,
                       int progressRate) {
        this.siteCode = siteCode;
        this.siteName = siteName;
        this.clientName = clientName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.progressRate = progressRate;
    }

    // getter だけ用意しておけば、画面表示やJSON出力に使いやすい
    public String getSiteCode() {
        return siteCode;
    }

    public String getSiteName() {
        return siteName;
    }

    public String getClientName() {
        return clientName;
    }

    public String getStartDate() {
        return startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public int getProgressRate() {
        return progressRate;
    }

    // 必要なら toString() や equals/hashCode も追加
}
