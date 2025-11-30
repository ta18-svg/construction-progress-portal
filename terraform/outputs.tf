# 作成された VM の Public IP を出力する
output "vm_public_ip" {
  # 実際の値として、azurerm_public_ip.public_ip リソースの ip_address を参照
  value       = azurerm_public_ip.public_ip.ip_address
  # terraform apply 実行後に表示される説明文
  # 例）vm_public_ip = "20.xxx.xxx.xxx"
  description = "Public IP of the app VM"
}
# SSH 接続用のサンプルコマンドを出力する
output "ssh_example" {
  # 文字列の中で変数展開して、完成した SSH コマンドを作る
  # 例）ssh azureuser@20.xxx.xxx.xxx
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.public_ip.ip_address}"
  # こちらも terraform apply 後に説明付きで表示される
  description = "Example SSH command"
}
