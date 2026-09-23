
# ================================================================
#   LAUNCHER DO MODPACK DOS BROTHERS  -  interface grafica
#   Mora em  .minecraft\_LAUNCHER\  e acha a instalacao subindo
#   um nivel. Se atualiza sozinho a partir do GitHub.
# ================================================================
$ErrorActionPreference = 'Stop'
$AQUI = Split-Path -Parent $MyInvocation.MyCommand.Path
$MC   = Split-Path -Parent $AQUI
$MODS = Join-Path $MC 'mods'
$CFG  = Join-Path $AQUI 'launcher.cfg'
$LIXO = Join-Path $MC '_mods-removidos'
$LOG  = Join-Path $AQUI 'ultimo-run.log'
try { Start-Transcript -LiteralPath $LOG -Force | Out-Null } catch { }
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }
$ProgressPreference = 'SilentlyContinue'
Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
Add-Type -AssemblyName PresentationCore, WindowsBase -ErrorAction SilentlyContinue
Add-Type -AssemblyName Microsoft.VisualBasic -ErrorAction SilentlyContinue

$VERSAO = 3   # sobe a cada mudanca minha; o auto-update compara com o do GitHub
# >>>>>>  O MATHEUS PREENCHE ESTA LINHA DEPOIS DE CRIAR O REPO  <<<<<<
$BASE_URL = 'https://raw.githubusercontent.com/SEUUSER/mc-modpack/main'
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

# Lista embutida: vale se o GitHub nao responder (ou se ainda nao existir)
$ENTRAM = @(
  @{ n = 'kubejs-fabric-2001.6.5-build.26.jar'; sha = '08d70c86bb9501eeaf936722784c09de18f0e32f'; url = 'https://cdn.modrinth.com/data/umyGl7zF/versions/Pu0Ygbq6/kubejs-fabric-2001.6.5-build.26.jar' }
  @{ n = 'rhino-fabric-2001.2.3-build.10.jar'; sha = 'a1fd74cf31c0bf959803870c1ac3d918ae66fc1e'; url = 'https://cdn.modrinth.com/data/sk9knFPE/versions/MLIu0Tct/rhino-fabric-2001.2.3-build.10.jar' }
  @{ n = 'fpsdisplay-3.1.0+1.20.x.jar'; sha = 'aec4dc9e2105578dd463bd733725199e93857d9f'; url = 'https://cdn.modrinth.com/data/DIlqwRFH/versions/WaO5IB1q/fpsdisplay-3.1.0%2B1.20.x.jar' }
  @{ n = 'DistantHorizons-3.3.0-1.20.1-fabric-forge.jar'; sha = 'd144553e1b20f11343b1d1e4d5a5a3673563e949'; url = 'https://cdn.modrinth.com/data/uCdwusMi/versions/10i2Xjtv/DistantHorizons-3.3.0-1.20.1-fabric-forge.jar' }
  @{ n = 'iris-1.7.5+mc1.20.1.jar'; sha = '613d3e28f4c0744a049f2583a25c2f36bd8537d9'; url = 'https://cdn.modrinth.com/data/YL57xq9U/versions/Bi9nvICq/iris-1.7.5%2Bmc1.20.1.jar' }
  @{ n = 'mapsyncer-1.0.3-fabric-1.20.1.jar'; sha = 'c725b5e7079d7fe0c42fbc3a7a628c269a1c9784'; url = 'https://cdn.modrinth.com/data/AW5A8Q2T/versions/pEx7Onlg/mapsyncer-1.0.3-fabric-1.20.1.jar' }
  @{ n = 'portablespawner-fabric-1.20.1-1.0.1.jar'; sha = 'df1a9b5ac9252c914a1a905723413379663069d9'; url = 'https://cdn.modrinth.com/data/TASFM9Js/versions/okNsHv0u/portablespawner-fabric-1.20.1-1.0.1.jar' }
  @{ n = 'Too Many Entities 1.20.1 Fabric v1.1.1.jar'; sha = '9c8a31a3d83c135865cae12a01d428fae3dc237c'; url = 'https://cdn.modrinth.com/data/BvnRxzIF/versions/TVYzh7G6/Too%20Many%20Entities%201.20.1%20Fabric%20v1.1.1.jar' }
  @{ n = 'xmmp-0.3.2+1.20.1-fabric.jar'; sha = '5a70fa2c7411a4af03016aea8bf93f4c05b080f0'; url = 'https://cdn.modrinth.com/data/stTaMuWa/versions/Ofe69fhn/xmmp-0.3.2%2B1.20.1-fabric.jar' }
)
$SAEM = @(
  'emi-1.1.24+1.20.1+fabric.jar'
  'nearbycrafting-1.0.3.jar'
  'recipebookaccess-1.1.0.jar'
  'DistantHorizons-2.1.2-a-1.20.1-forge-fabric.jar'
  'iris-1.7.2+mc1.20.1.jar'
)
$DHPERFIL = @{
  marcelo = @{ radius = 192; res = 'BLOCK'; threads = 6; ratio = '0.8' }
  gabu = @{ radius = 128; res = 'TWO_BLOCKS'; threads = 3; ratio = '0.6' }
  fabio = @{ radius = 128; res = 'TWO_BLOCKS'; threads = 3; ratio = '0.6' }
  say = @{ radius = 96; res = 'FOUR_BLOCKS'; threads = 2; ratio = '0.4' }
}
$MURAL = @(
  @{ quem = 'todos'; txt = 'Rodar este atualizador ANTES de abrir o jogo, sempre.' }
  @{ quem = 'todos'; txt = 'Se o terreno de longe nao aparecer, rode este atualizador com o jogo FECHADO - ele conserta sozinho.' }
  @{ quem = 'marcelo'; txt = 'A farm de galinha da base tem 279 galinhas num chunk so. Se travar no login, avisa o Matheus.' }
  @{ quem = 'marcelo'; txt = 'Voce e op nivel 1: o teleporte do Explorer''s Compass funciona, comando nao. Se /gamemode der ''sem permissao'', esta certo.' }
  @{ quem = 'marcelo'; txt = 'Testar: marcar uma waystone como Global e ver se o Matheus enxerga sem ter ido la.' }
  @{ quem = 'gabu'; txt = 'Voce tem 8 GB: seu perfil do Distant Horizons e o DH33_GABRIEL_8GB. Se o terreno distante pesar, avisa.' }
  @{ quem = 'gabu'; txt = 'Se quiser o contador de FPS na tela (fpsdisplay), pede pro Matheus - ele tirou sem perguntar e reconheceu o erro.' }
  @{ quem = 'fabio'; txt = 'Voce ainda nao esta no ops.json do servidor. Sem isso o teleporte do Explorer''s Compass nao funciona - pede pro Matheus.' }
  @{ quem = 'fabio'; txt = 'A waystone ''Tumulo do Fabio'' ainda esta la, global.' }
  @{ quem = 'say'; txt = 'Poe uma waystone chamada exatamente ''base'', minuscula, e marca Global. Ja existe uma - confirma que esta global.' }
  @{ quem = 'say'; txt = 'Seu mundo tem 169 pecas de Aquamirae: o labirinto de gelo e a Cornelia estao no SEU servidor, nao no dos Brothers.' }
  @{ quem = 'say'; txt = 'Seu PC nao tem placa dedicada. Seu perfil do DH e o DH33_SAY_8GB_sem_dGPU - nao mexe nas opcoes de DH sem falar com o Matheus.' }
  @{ quem = 'say'; txt = 'O End e o Otherside do seu mundo ainda nao existem. Se quiser ir, o Matheus precisa gerar antes.' }
)
$PERKS = @(
  'Garrafa de XP: AGACHADO (Shift) + clique direito com uma garrafa de vidro na mao. So funciona se voce tiver 40 de XP bruto (nivel 4 saindo do zero). Custa meio coracao.'
  'Se a garrafa de XP der pouco nivel, e o MENDING: o XP conserta seu equipamento antes de virar experiencia, igual orbe de XP. Pra guardar nivel, bebe com o equipamento de Mending DESEQUIPADO.'
  'A garrafa de XP nao funciona se o meio coracao de dano te mataria. Cura primeiro.'
  'A garrafa de XP se BEBE, nao se joga no chao. Jogar no chao perde XP.'
  'Uma garrafa de XP guarda 4 niveis e paga o teleporte pro tumulo com sobra.'
  'Morreu longe? Abre a bussola da morte e paga 3 niveis pra voltar pro tumulo. Fica 5s parado e chega invencivel por 10s.'
  'Maca dourada encantada tem receita neste modpack, e devolve 3 coracoes de vida maxima.'
  'O Bundle voltou: 3 linha em cima, 6 couro embaixo.'
  'Item no chao dura 15 min. Os valiosos nao somem nunca. Lixo (pedra, terra, semente, ovo) some em 1-2 min.'
  'O mapa do Xaero e COMPARTILHADO: o que um explora aparece no mapa dos outros.'
  'Da pra pegar spawner e levar junto (PortableSpawner).'
  'Perto de farm com muito mob, o Too Many Entities esconde o excesso pra ganhar FPS. Configuravel no Mod Menu.'
  'O servidor dos Brothers tem Bumblezone e Otherside (Deeper Dark) gerados. Ja foi?'
  'O Ancient City mais perto da base dos Brothers fica em X -264 Z 504.'
  'Tem 4 Void Blossom no mapa dos Brothers. O mais perto: X -680 Z 328.'
  '3 Gauntlet no Nether dos Brothers: -280/-792, -872/-296, -952/-872.'
  'O Stalker do Deeper Dark ja tem templo gerado no Otherside.'
  'Barco de obsidiana anda na LAVA. Nao flutua em agua.'
  'O IPN tem 5 perfis de inventario com tecla rapida: Combate, Mineracao, Exploracao.'
  'Da pra travar um slot do inventario (IPN) e a ordenacao automatica pula ele.'
  'Tem lista de tarefas compartilhada no servidor (TeamTasks): o que um cria, os outros veem.'
  'Da pra juntar 3 pocoes numa Potion Blending Combiner.'
  '2 slabs iguais viram bloco cheio de volta (Deslabification).'
  'Se voce roda Chunky e voa ao mesmo tempo, o Distant Horizons deixa buracos no terreno. Roda o Chunky, espera acabar, depois voa.'
  'O primeiro boot depois de atualizar o Distant Horizons e lento: ele converte o banco de terreno. Deixa terminar.'
  'Nao mexa nas opcoes do Distant Horizons por conta propria - tem um perfil pronto pra sua maquina.'
)

# ---------------- utilidades ----------------
function CfgLer($k) {
    if (-not (Test-Path -LiteralPath $CFG)) { return $null }
    foreach ($l in (Get-Content -LiteralPath $CFG)) {
        $p = $l -split '=', 2
        if ($p.Count -eq 2 -and $p[0] -eq $k) { return $p[1] }
    }
    return $null
}
function CfgGravar($k, $v) {
    $ls = @()
    if (Test-Path -LiteralPath $CFG) {
        foreach ($l in (Get-Content -LiteralPath $CFG)) {
            if (($l -split '=', 2)[0] -ne $k) { $ls += $l }
        }
    }
    $ls += ($k + '=' + $v)
    $ls | Set-Content -LiteralPath $CFG -Encoding UTF8
}
function Baixar($rel) {
    $u = $BASE_URL.TrimEnd('/') + '/' + $rel
    return (Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 20).Content
}
function ModId($jar) {
    try {
        $z = [System.IO.Compression.ZipFile]::OpenRead($jar)
        $e = $z.GetEntry('fabric.mod.json')
        if (-not $e) { $z.Dispose(); return $null }
        $sr = New-Object System.IO.StreamReader($e.Open())
        $txt = $sr.ReadToEnd(); $sr.Close(); $z.Dispose()
        $m = [regex]::Match($txt, '"id"\s*:\s*"([^"]+)"')
        if ($m.Success) { return $m.Groups[1].Value }
    } catch { }
    return $null
}

# ---------------- AUTO-UPDATE do proprio launcher ----------------
# baixa launcher.ps1 do GitHub; se a versao for maior, salva como
# launcher.new.ps1 e o JOGAR.bat troca na proxima abertura.
try {
    $remoto = Baixar 'launcher.ps1'
    $mv = [regex]::Match($remoto, '(?m)^\$VERSAO\s*=\s*(\d+)')
    if ($mv.Success -and [int]$mv.Groups[1].Value -gt $VERSAO) {
        Set-Content -LiteralPath (Join-Path $AQUI 'launcher.new.ps1') -Value $remoto -Encoding UTF8
        [System.Windows.MessageBox]::Show(
            "Saiu uma versao nova do launcher (v$($mv.Groups[1].Value)).`n`nEle vai fechar e abrir atualizado.",
            'Atualizando o launcher') | Out-Null
        Start-Process -FilePath (Join-Path $AQUI 'JOGAR.bat')
        try { Stop-Transcript | Out-Null } catch { }
        exit 0
    }
} catch { }

# ---------------- lista de mods: GitHub, com queda pro embutido ----------------
$origemLista = 'embutida (sem internet ou repo ainda nao criado)'
try {
    $txt = Baixar 'lista.txt'
    $novoE = @(); $novoS = @()
    foreach ($l in ($txt -split "`r?`n")) {
        $p = $l -split "`t"
        if ($p[0] -eq 'MOD' -and $p.Count -ge 6) { $novoE += @{ n = $p[1]; sha = $p[3].ToLower(); url = $p[5] } }
        elseif ($p[0] -eq 'SAI' -and $p.Count -ge 2) { $novoS += $p[1] }
    }
    if ($novoE.Count -gt 0) { $ENTRAM = $novoE; $SAEM = $novoS; $origemLista = 'GitHub' }
} catch { }
try { $m = Baixar 'mural.txt'
      $nm = @(); foreach ($l in ($m -split "`r?`n")) { $p = $l -split "`t"; if ($p.Count -ge 2) { $nm += @{ quem = $p[0]; txt = $p[1] } } }
      if ($nm.Count -gt 0) { $MURAL = $nm } } catch { }
try { $pk = (Baixar 'perks.txt') -split "`r?`n" | Where-Object { $_.Trim() -ne '' }
      if ($pk.Count -gt 0) { $PERKS = $pk } } catch { }

# ---------------- janela ----------------
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Modpack dos Brothers" Height="620" Width="860"
        WindowStartupLocation="CenterScreen" Background="#1b1b1f" ResizeMode="CanMinimize">
  <Grid Margin="14">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/><RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>
    <StackPanel Grid.Row="0">
      <TextBlock x:Name="TTitulo" Text="MODPACK DOS BROTHERS" Foreground="#7fd4ff"
                 FontSize="22" FontWeight="Bold"/>
      <TextBlock x:Name="TSub" Text="" Foreground="#8a8a92" FontSize="11" Margin="0,2,0,0"/>
    </StackPanel>
    <StackPanel Grid.Row="1" Margin="0,12,0,8">
      <TextBlock x:Name="TStatus" Text="Preparando..." Foreground="#e8e8ec" FontSize="13"/>
      <ProgressBar x:Name="PB" Height="18" Margin="0,6,0,0" Minimum="0" Maximum="100"
                   Foreground="#4ec9b0" Background="#2a2a30" BorderThickness="0"/>
    </StackPanel>
    <Grid Grid.Row="2">
      <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
      <Border Grid.Column="0" Background="#232329" CornerRadius="6" Margin="0,0,7,0">
        <DockPanel Margin="10">
          <TextBlock DockPanel.Dock="Top" Text="O QUE FALTA VOCE FAZER" Foreground="#ffd479"
                     FontWeight="Bold" FontSize="12" Margin="0,0,0,6"/>
          <ScrollViewer VerticalScrollBarVisibility="Auto">
            <ItemsControl x:Name="LMural">
              <ItemsControl.ItemTemplate><DataTemplate>
                <TextBlock Text="{Binding}" Foreground="#e0e0e6" TextWrapping="Wrap" Margin="0,0,0,7" FontSize="12"/>
              </DataTemplate></ItemsControl.ItemTemplate>
            </ItemsControl>
          </ScrollViewer>
        </DockPanel>
      </Border>
      <Border Grid.Column="1" Background="#232329" CornerRadius="6" Margin="7,0,0,0">
        <DockPanel Margin="10">
          <TextBlock DockPanel.Dock="Top" Text="VOCE SABIA?" Foreground="#8ee6a0"
                     FontWeight="Bold" FontSize="12" Margin="0,0,0,6"/>
          <TextBlock x:Name="TPerk" Text="" Foreground="#cfe8d4" TextWrapping="Wrap" FontSize="13"/>
        </DockPanel>
      </Border>
    </Grid>
    <Grid Grid.Row="3" Margin="0,12,0,0">
      <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
      <TextBlock x:Name="TRodape" Grid.Column="0" Text="" Foreground="#6f6f78" FontSize="11" VerticalAlignment="Center"/>
      <Button x:Name="BJogar" Grid.Column="1" Content="JOGAR" Width="190" Height="46"
              FontSize="19" FontWeight="Bold" Foreground="#10231a" Background="#4ec9b0"
              BorderThickness="0" IsEnabled="False"/>
    </Grid>
  </Grid>
</Window>
"@
$w = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$TStatus = $w.FindName('TStatus'); $PB = $w.FindName('PB'); $BJogar = $w.FindName('BJogar')
$LMural = $w.FindName('LMural');   $TPerk = $w.FindName('TPerk')
$TSub = $w.FindName('TSub');       $TRodape = $w.FindName('TRodape')

function UI($texto, $pct) {
    $TStatus.Text = $texto
    if ($pct -ge 0) { $PB.Value = $pct }
    $w.Dispatcher.Invoke([action]{}, [Windows.Threading.DispatcherPriority]::Background)
}

# ---------------- quem e voce ----------------
$EU = CfgLer 'perfil'
if (-not $EU) {
    $op = '1'
    try {
        $op = [Microsoft.VisualBasic.Interaction]::InputBox(
            "Quem esta neste computador?`n`n1 = Marcelo (Tensei)`n2 = Gabu (Gabutre)`n3 = Fabio (fabium)`n4 = Say (sayu)",
            'Primeira vez', '1')
    } catch {
        # se o InputBox nao existir nesta maquina, pergunta pelo console
        $op = Read-Host 'Quem e voce? 1=Marcelo 2=Gabu 3=Fabio 4=Say'
    }
    switch ($op) { '1'{$EU='marcelo'} '2'{$EU='gabu'} '3'{$EU='fabio'} '4'{$EU='say'} default{$EU='todos'} }
    CfgGravar 'perfil' $EU
}
$TSub.Text = "perfil: $EU   |   instalacao: $MC   |   lista: $origemLista   |   launcher v$VERSAO"

# ---------------- mural e dica ----------------
$meus = New-Object System.Collections.ArrayList
foreach ($m in $MURAL) { if ($m.quem -eq $EU -or $m.quem -eq 'todos') { [void]$meus.Add('- ' + $m.txt) } }
if ($meus.Count -eq 0) { [void]$meus.Add('- nada pendente. bom jogo!') }
$LMural.ItemsSource = $meus
if ($PERKS.Count -gt 0) { $TPerk.Text = ($PERKS | Get-Random) }
$timer = New-Object Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(7)
$timer.Add_Tick({ if ($PERKS.Count -gt 0) { $TPerk.Text = ($PERKS | Get-Random) } })
$timer.Start()

# ---------------- o trabalho ----------------
$w.Add_ContentRendered({
    if (-not (Test-Path -LiteralPath $MODS)) {
        UI 'ERRO: nao achei a pasta mods. O launcher tem que ficar em .minecraft\_LAUNCHER\' 0
        return
    }
    if (Get-Process -Name javaw, java -ErrorAction SilentlyContinue) {
        UI 'FECHE O MINECRAFT E O LAUNCHER, depois abra este de novo.' 0
        return
    }
    $rem = 0; $novos = 0; $falhas = 0

    UI 'Removendo mods aposentados...' 5
    foreach ($n in $SAEM) {
        $p = Join-Path $MODS $n
        if (-not (Test-Path -LiteralPath $p)) { continue }
        if (-not (Test-Path -LiteralPath $LIXO)) { New-Item -ItemType Directory -Path $LIXO -Force | Out-Null }
        Move-Item -LiteralPath $p -Destination (Join-Path $LIXO $n) -Force
        $rem++
    }

    $i = 0
    foreach ($m in $ENTRAM) {
        $i++
        $pct = 5 + [int](70 * $i / [Math]::Max(1, $ENTRAM.Count))
        $dest = Join-Path $MODS $m.n
        if (Test-Path -LiteralPath $dest) {
            if ((Get-FileHash -LiteralPath $dest -Algorithm SHA1).Hash.ToLower() -eq $m.sha) {
                UI ("Ja atualizado: " + $m.n) $pct; continue
            }
        }
        UI ("Baixando " + $m.n + " ...") $pct
        $tmp = Join-Path $env:TEMP ('_dl_' + [guid]::NewGuid().ToString() + '.part')
        try { Invoke-WebRequest -Uri $m.url -OutFile $tmp -UseBasicParsing -TimeoutSec 900 }
        catch { $falhas++; continue }
        if ((Get-FileHash -LiteralPath $tmp -Algorithm SHA1).Hash.ToLower() -ne $m.sha) {
            Remove-Item -LiteralPath $tmp -Force; $falhas++; continue
        }
        $idNovo = ModId $tmp
        if ($idNovo) {
            foreach ($v in (Get-ChildItem -LiteralPath $MODS -Filter '*.jar')) {
                if ($v.Name -eq $m.n) { continue }
                if ((ModId $v.FullName) -ne $idNovo) { continue }
                if (-not (Test-Path -LiteralPath $LIXO)) { New-Item -ItemType Directory -Path $LIXO -Force | Out-Null }
                Move-Item -LiteralPath $v.FullName -Destination (Join-Path $LIXO $v.Name) -Force
            }
        }
        Move-Item -LiteralPath $tmp -Destination $dest -Force
        $novos++
    }

    UI 'Conferindo o terreno distante (Distant Horizons)...' 80
    $dhRaiz = Join-Path $MC 'Distant_Horizons_server_data'
    $dhFix = 0
    if (Test-Path -LiteralPath $dhRaiz) {
        foreach ($srv in (Get-ChildItem -LiteralPath $dhRaiz -Directory)) {
            $dirs = Get-ChildItem -LiteralPath $srv.FullName -Directory
            foreach ($v in ($dirs | Where-Object { $_.Name -notlike '*@@*' })) {
                $sql = Get-ChildItem -LiteralPath $v.FullName -Filter 'DistantHorizons.sqlite*' -ErrorAction SilentlyContinue
                if (-not $sql) { continue }
                $par = $dirs | Where-Object { $_.Name -like ('*@@' + $v.Name) } | Select-Object -First 1
                if (-not $par) { continue }
                if (Get-ChildItem -LiteralPath $par.FullName -Filter 'DistantHorizons.sqlite*' -ErrorAction SilentlyContinue) { continue }
                foreach ($f in $sql) { Move-Item -LiteralPath $f.FullName -Destination $par.FullName -Force }
                if (-not (Get-ChildItem -LiteralPath $v.FullName -Force)) { Remove-Item -LiteralPath $v.FullName -Force }
                $dhFix++
            }
        }
    }

    UI 'Ajustando o Distant Horizons pra sua maquina...' 88
    $toml = Join-Path $MC 'config\DistantHorizons.toml'
    if ($DHPERFIL.ContainsKey($EU) -and (Test-Path -LiteralPath $toml)) {
        $pf = $DHPERFIL[$EU]; $t = Get-Content -LiteralPath $toml -Raw; $o = $t
        $t = [regex]::Replace($t, '(?m)^(\s*)lodChunkRenderDistanceRadius = .*$', ('${1}lodChunkRenderDistanceRadius = ' + $pf.radius))
        $t = [regex]::Replace($t, '(?m)^(\s*)maxHorizontalResolution = .*$',      ('${1}maxHorizontalResolution = "' + $pf.res + '"'))
        $t = [regex]::Replace($t, '(?m)^(\s*)numberOfThreads = .*$',              ('${1}numberOfThreads = ' + $pf.threads))
        $t = [regex]::Replace($t, '(?m)^(\s*)threadRunTimeRatio = .*$',           ('${1}threadRunTimeRatio = "' + $pf.ratio + '"'))
        if ($t -ne $o) {
            if (-not (Test-Path -LiteralPath ($toml + '.bkp'))) { Copy-Item -LiteralPath $toml -Destination ($toml + '.bkp') }
            Set-Content -LiteralPath $toml -Value $t -NoNewline
        }
    }

    UI 'Ligando o teleporte do mapa com custo de XP...' 94
    foreach ($sub in @('config\xaero\world-map\profiles', 'config\xaero\minimap\profiles')) {
        $dir = Join-Path $MC $sub
        if (-not (Test-Path -LiteralPath $dir)) { continue }
        foreach ($f in (Get-ChildItem -LiteralPath $dir -Filter '*.cfg' -ErrorAction SilentlyContinue)) {
            $t = Get-Content -LiteralPath $f.FullName -Raw; $o = $t
            $t = [regex]::Replace($t, '(?m)^map_teleport_allowed = .*$', 'map_teleport_allowed = true')
            $t = [regex]::Replace($t, '(?m)^default_map_teleport_command_format = .*$', 'default_map_teleport_command_format = /tpcusto {x} {y} {z}')
            $t = [regex]::Replace($t, '(?m)^default_waypoint_teleport_format = .*$', 'default_waypoint_teleport_format = /tpcusto {x} {y} {z}')
            if ($t -ne $o) {
                if (-not (Test-Path -LiteralPath ($f.FullName + '.bkp'))) { Copy-Item -LiteralPath $f.FullName -Destination ($f.FullName + '.bkp') }
                Set-Content -LiteralPath $f.FullName -Value $t -NoNewline
            }
        }
    }
    $xaSrv = Join-Path $MC 'xaero\minimap'
    if (Test-Path -LiteralPath $xaSrv) {
        foreach ($d in (Get-ChildItem -LiteralPath $xaSrv -Directory -ErrorAction SilentlyContinue)) {
            $f = Join-Path $d.FullName 'config.txt'
            if (-not (Test-Path -LiteralPath $f)) { continue }
            $t = Get-Content -LiteralPath $f -Raw; $o = $t
            $t = [regex]::Replace($t, '(?m)^teleportationEnabled:false$', 'teleportationEnabled:true')
            if ($t -ne $o) { Set-Content -LiteralPath $f -Value $t -NoNewline }
        }
    }

    $msg = "Pronto. baixados: $novos  ·  removidos: $rem  ·  DH consertado: $dhFix"
    if ($falhas -gt 0) { $msg += "  ·  $falhas falha(s) - rode de novo depois" }
    UI $msg 100
    $TRodape.Text = "log completo em _LAUNCHER\ultimo-run.log"
    $BJogar.IsEnabled = $true
})

# ---------------- botao JOGAR ----------------
$BJogar.Add_Click({
    $sk = CfgLer 'sklauncher'
    if (-not $sk -or -not (Test-Path -LiteralPath $sk)) {
        $sk = $null
        foreach ($d in @($MC, [Environment]::GetFolderPath('Desktop'), (Join-Path $env:USERPROFILE 'Downloads'), $env:LOCALAPPDATA)) {
            if (-not $d -or -not (Test-Path -LiteralPath $d)) { continue }
            $c = Get-ChildItem -LiteralPath $d -Filter 'sklauncher*' -ErrorAction SilentlyContinue |
                 Where-Object { $_.Extension -eq '.jar' -or $_.Extension -eq '.exe' } | Select-Object -First 1
            if ($c) { $sk = $c.FullName; break }
        }
        if ($sk) { CfgGravar 'sklauncher' $sk }
    }
    if (-not $sk) {
        [System.Windows.MessageBox]::Show('Nao achei o SKLauncher. Abra ele na mao desta vez.','SKLauncher') | Out-Null
        return
    }
    if ([System.IO.Path]::GetExtension($sk).ToLower() -eq '.jar') {
        $jw = $null
        $rt = Join-Path $MC 'runtime'
        if (Test-Path -LiteralPath $rt) { $jw = Get-ChildItem -LiteralPath $rt -Filter 'javaw.exe' -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 }
        if ($jw) { Start-Process -FilePath $jw.FullName -ArgumentList @('-jar', $sk) -WorkingDirectory $MC }
        else     { Start-Process -FilePath 'javaw' -ArgumentList @('-jar', $sk) -WorkingDirectory $MC }
    } else { Start-Process -FilePath $sk }
    $w.Close()
})

[void]$w.ShowDialog()
try { Stop-Transcript | Out-Null } catch { }
