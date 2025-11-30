terraform {
  # ここでは「どのプロバイダを使うか」「どのバージョンか」を宣言する
  required_providers {
    # "azurerm" という名前のプロバイダを使う
    azurerm = {
      # プロバイダの配布元（レジストリ上の名前）
      source  = "hashicorp/azurerm"
      # バージョン指定："3.0 以上 4.0 未満" を許可するという意味
      version = "~> 3.0"
    }
  }
  # Terraform 本体のバージョン制約 # Terraform CLI は v1.6.0 以上を要求する
  required_version = ">= 1.6.0"
}
# ここからが AzureRM（Azure Resource Manager）プロバイダの設定
provider "azurerm" {
  # azurerm が必須とする空の設定ブロック
  # （細かいチューニングが無ければ空でOK）
  features {}
  # ★ Azure CLI 認証を使う場合、ここに
  #   subscription_id / client_id / client_secret / tenant_id
  #   は書かない。
  #
  #   `az login` でログイン済み & `az account set` で
  #   選択したサブスクリプションが自動的に使われる。
  
  # # どの Azure サブスクリプションに接続するかなどの情報
  # # 操作対象となる Azure サブスクリプションの ID
  # subscription_id = var.subscription_id
  # # Service Principal の Client ID（アプリケーションID）
  # client_id       = var.client_id
  # # Service Principal のパスワード（シークレット）
  # client_secret   = var.client_secret
  # # Azure AD テナント ID
  # tenant_id       = var.tenant_id
}
