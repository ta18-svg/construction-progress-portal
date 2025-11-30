# Resource Group（リソースグループ）
resource "azurerm_resource_group" "rg" {
  # RG名: cp-portal-rg
  name     = "${var.project_name}-rg"
  # リージョン: japaneast
  location = var.location
}
# Virtual Network（仮想ネットワーク / VNet）
resource "azurerm_virtual_network" "vnet" {
  # VNet名: cp-portal-vnet
  name                = "${var.project_name}-vnet"
  # ネットワークアドレス
  address_space       = ["10.0.0.0/16"]
  #　リージョン
  location            = var.location
  # 所属する RG
  resource_group_name = azurerm_resource_group.rg.name
}
# Subnet（サブネット）
resource "azurerm_subnet" "subnet" {
  #サブネット名
  name                 = "${var.project_name}-subnet"
  # 所属する RG
  resource_group_name  = azurerm_resource_group.rg.name
  # どの VNet 配下か
  virtual_network_name = azurerm_virtual_network.vnet.name
  #　サブネットのネットワークアドレス
  address_prefixes     = ["10.0.1.0/24"]
}
# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.project_name}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  # 静的 IP（再起動しても変わらない）
  allocation_method   = "Static"
  # サービスの等級 / 性能プラン
  sku                 = "Standard"
}
# Network Security Group（NSG）
# VM に対するファイアウォールルール
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.project_name}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  # ルール1: SSH (22/TCP) を許可 
  security_rule {
    name                       = "SSH"
    priority                   = 100    # 優先度（小さいほど優先される）
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  # ルール2: HTTP (80/TCP) を許可 
  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# Network Interface（NIC）
# VM にぶら下がるネットワークインターフェース
# VNet / Subnet / Public IP をここでひも付ける
resource "azurerm_network_interface" "nic" {
  name                = "${var.project_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    # IP設定名
    name                          = "ipconfig"
    # どのサブネットに属するか
    subnet_id                     = azurerm_subnet.subnet.id
    # VM のプライベートIPは自動割り当て
    private_ip_address_allocation = "Dynamic"
    # この NIC に紐付ける PublicIP
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
# NIC と NSG の関連付け
# 「この NIC に対して、この NSG のルールを適用する」
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
# Azure VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.project_name}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B1s"
  # SSH ログインユーザー名
  admin_username      = var.admin_username
  # この VM に接続する NIC のID配列（単一 NIC でも配列で渡す）
  network_interface_ids = [azurerm_network_interface.nic.id]
  # パスワードログインを無効化し、SSH鍵のみでログインする設定
  disable_password_authentication = true
  # SSH 公開鍵認証の設定
  admin_ssh_key {
    # ログインユーザー名（上と一致させる）
    username   = var.admin_username
    # ~/.ssh/id_rsa.pub の中身
    public_key = var.admin_ssh_public_key
  }
  # OSディスクの設定
  os_disk {
    name                 = "${var.project_name}-osdisk"
    # キャッシュポリシー
    caching              = "ReadWrite"
    # ストレージの種類（標準HDD相当）
    storage_account_type = "Standard_LRS"
  }
  # どの OS イメージを使うか（Ubuntu 22.04 LTS）
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
