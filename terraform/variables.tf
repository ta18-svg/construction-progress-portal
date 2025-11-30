# Azure 側との接続・リソース作成に必要な情報を
# 「変数」として定義しているファイル

# Azure CLI 認証版：Azure 側の認証情報は
# az login / az account set に任せるので、
# subscription_id / client_id / client_secret / tenant_id は不要。

# # どのサブスクリプションを使うか
# variable "subscription_id" {
#   # 文字列型の変数
#   type        = string
#   # 何の値かの説明（ドキュメント用）
#   description = "Azure Subscription ID"
# }

# # Terraform が使う Service Principal の client_id
# variable "client_id" {
#   type        = string
#   # az ad sp create-for-rbac の appId
#   description = "Service Principal client_id"
# }

# # Service Principal の client_secret（パスワード）
# variable "client_secret" {
#   type        = string
#   description = "Service Principal client_secret"
#   # terraform plan/apply の出力に値を表示しない
#   sensitive   = true
# }

# # Azure AD のテナント ID
# variable "tenant_id" {
#   type        = string
#   # az account show 等で確認できる
#   description = "Azure AD tenant_id"
# }

# リソースを作成するリージョン
variable "location" {
  type    = string
  # 省略時は japaneast（東日本）に作成
  default = "japaneast"
}

# プロジェクト名（リソース名のプレフィックス）
variable "project_name" {
  type    = string
  # cp-portal-rg / cp-portal-vm などに利用
  default = "cp-portal"
}

# VM の管理ユーザー名（SSH ログイン用ユーザー）
variable "admin_username" {
  type    = string
  default = "azureuser"
}

# VM に登録する SSH 公開鍵（パスワードログインは使わない）
variable "admin_ssh_public_key" {
  type        = string
  # ファイルの中身をコピペして入れる想定
  description = "SSH public key (~/.ssh/id_rsa.pub)"
}
