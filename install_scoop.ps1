# 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 用户输入 Scoop 路径，如果没有输入则使用默认路径
$scoopPath = Read-Host -Prompt "请输入 Scoop 的安装路径(留空使用默认路径 D:\Scoop)"
if ([string]::IsNullOrWhiteSpace($scoopPath)) {
    $scoopPath = 'D:\Scoop'
}

# 配置 Scoop 的路径和环境变量
$env:SCOOP = $scoopPath
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

# 检测当前用户状态并安装 Scoop
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    iwr -useb scoop.201704.xyz | iex
} else {
    iex "& {$(irm scoop.201704.xyz)} -RunAsAdmin"
}

# 输出安装完成信息
$scoopEnvPath = [Environment]::GetEnvironmentVariable('SCOOP', 'User')
Write-Output "Scoop 安装完成，并且 SCOOP 环境变量已设置为 $scoopEnvPath."

# 安装 Git
scoop install git

# 输出添加软件源信息
Write-Output "正在添加软件源"

# 添加软件源
scoop bucket rm *
scoop bucket add main
scoop bucket add extras
scoop bucket add versions

# 输出安装完毕信息
Write-Output "安装完毕！，接下来可以使用了"
