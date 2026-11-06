# ================================================================
#   LAUNCHER DO MODPACK DOS BROTHERS  -  v18 (R#254)
#   Mora em  .minecraft\_LAUNCHER\  e acha a instalacao subindo
#   um nivel. Se atualiza sozinho a partir do GitHub.
#   v18: visual "Minecraft raiz" (texturas lidas do jar do jogo de
#   cada PC, fontes OFL baixadas do GitHub), prints da pasta
#   screenshots, dicas por grupo, mensagens novas, SKLauncher
#   aberto igual ao atalho dele (JRE proprio em %APPDATA%\sklauncher).
#   ARQUIVO EM UTF-8 COM BOM (tem acento nas mensagens).
# ================================================================
$ErrorActionPreference = 'Stop'
$AQUI    = Split-Path -Parent $MyInvocation.MyCommand.Path
$MC      = Split-Path -Parent $AQUI
$MODS    = Join-Path $MC 'mods'
$CFG     = Join-Path $AQUI 'launcher.cfg'
$LIXO    = Join-Path $MC '_mods-removidos'
$LOG     = Join-Path $AQUI 'ultimo-run.log'
$CACHE   = Join-Path $AQUI 'cache'      # ultima lista/pacote/dicas/mural que deu certo (pra quando estiver sem internet)
$FONTES  = Join-Path $AQUI 'fontes'     # fontes baixadas do GitHub
$PUBLICO = Join-Path $AQUI 'publico'    # so existe no PC do Matheus: le dali em vez do GitHub (testa antes de subir)
$SHOTS   = Join-Path $MC 'screenshots'
try { Start-Transcript -LiteralPath $LOG -Force | Out-Null } catch { }
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }
$ProgressPreference = 'SilentlyContinue'
Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
Add-Type -AssemblyName PresentationCore, WindowsBase -ErrorAction SilentlyContinue
Add-Type -AssemblyName Microsoft.VisualBasic -ErrorAction SilentlyContinue

$VERSAO = 18   # sobe a cada mudanca minha; o auto-update compara com o do GitHub
$BASE_URL = 'https://raw.githubusercontent.com/mmcadora/mc-modpack/refs/heads/main'
Write-Host ('LAUNCHER v' + $VERSAO + ' · ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' · ' + $env:USERNAME)

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
  @{ n = 'TaxFreeLevels-1.4.23-fabric-1.20.1.jar'; sha = '36a816dd8d1cc1e3f52d12793b5197339ad97cf2'; url = 'https://cdn.modrinth.com/data/jCBrrLTs/versions/R7TeQeOo/TaxFreeLevels-1.4.23-fabric-1.20.1.jar' }
  @{ n = 'Controlling-fabric-1.20.1-12.0.2.jar'; sha = '8d6badebb7f2aea04793c92174dafa946b13f1e9'; url = 'https://cdn.modrinth.com/data/xv94TkTM/versions/6ipZLQSK/Controlling-fabric-1.20.1-12.0.2.jar' }
  @{ n = 'Searchables-fabric-1.20.1-1.0.3.jar'; sha = 'd7cbd06088a90f8adfd4bb9a99d1c256bcdf22a1'; url = 'https://cdn.modrinth.com/data/fuuu3xnx/versions/eh4IBlu2/Searchables-fabric-1.20.1-1.0.3.jar' }
  @{ n = 'trashcans-1.1.1a-fabric-mc1.20.4.jar'; sha = 'c7b37868c9aae658cac9c578f7a520d089a3a822'; url = 'https://cdn.modrinth.com/data/4QrnfueM/versions/JJTVcWnj/trashcans-1.1.1a-fabric-mc1.20.4.jar' }
)
$SAEM = @(
  'trashcans-1.1.0-fabric-mc1.20.4.jar'
  'EasyAnvils-v8.0.2-1.20.1-Fabric.jar'
  'emi-1.1.24+1.20.1+fabric.jar'
  'nearbycrafting-1.0.3.jar'
  'recipebookaccess-1.1.0.jar'
  'DistantHorizons-2.1.2-a-1.20.1-forge-fabric.jar'
  'iris-1.7.2+mc1.20.1.jar'
)
# R#156: endereco do servidor dos Brothers. VAZIO = nao mexe em nada (igual a v12).
# Quem liga e a linha  SERVIDOR<TAB>host:porta  no lista.txt do GitHub, no dia da mudanca.
$SERVIDOR = $null
# id do mundo dos Brothers no Xaero (servidor-fabric-2\world\xaeromap.txt)
$XAERO_ID = '-1059433244'
$DHPERFIL = @{
  marcelo = @{ radius = 192; res = 'BLOCK'; threads = 6; ratio = '0.8' }
  gabu = @{ radius = 128; res = 'TWO_BLOCKS'; threads = 3; ratio = '0.6' }
  fabio = @{ radius = 128; res = 'TWO_BLOCKS'; threads = 3; ratio = '0.6' }
  dahmer = @{ radius = 128; res = 'TWO_BLOCKS'; threads = 3; ratio = '0.6' }   # R#163: PC dele desconhecido -> perfil medio
  say = @{ radius = 96; res = 'FOUR_BLOCKS'; threads = 2; ratio = '0.4' }
  matheus = @{ radius = 256; res = 'BLOCK'; threads = 8; ratio = '0.9' }
}
# nome antigo da pasta de LOD (campo "effects") -> nome novo (caminho da dimensao)
$DHNOMES = @{
  'otherside_effects'         = 'otherside'
  'dimension_special_effects' = 'the_bumblezone'
}
# R#254: base mostrada no topo (o lista.txt pode trocar com a linha  BASE<TAB>b|s<TAB>texto)
$BASES = @{ b = 'Base: X 6180 · Z 2040'; s = 'Base: X 800 · Z -400' }

# dicas embutidas (valem se o GitHub e o cache falharem). Formato: GRUPO<TAB>texto  (t todos · b Brothers · s Say)
$PERKS_TXT = @'
t	Teleporte: clique direito no mapa (M) ou num waypoint (U). Custa 3 níveis, sempre: perto, longe ou entre dimensões.
t	Garrafa de XP: AGACHADO (Shift) + clique direito com garrafa de vidro na mão. Precisa já ter 100 de XP bruto (nível 8 saindo do zero); com menos, não acontece nada e não aparece mensagem.
t	Garrafa de XP rendeu pouco? É o Mending consertando seu equipamento antes. Pra guardar nível, bebe DESEQUIPADO.
t	Beber garrafa de XP: SEGURA o clique direito (leva 0,4 s). Agachado bebe a pilha toda de uma vez.
t	A garrafa de XP devolve exatamente os 100 de XP que custou: é cofre, não fonte. Serve pra não perder XP ao morrer.
t	100 de XP bruto é meio nível no nível 20 e um terço de nível no 50. Não está rendendo menos: é a curva do Minecraft.
t	Garrafa de XP se bebe, não se joga: jogar no chão perde quase tudo.
t	A garrafa de XP não sai se o meio coração de dano te mataria. Cura primeiro.
t	Morreu longe? Abre a bússola da morte e paga 3 níveis pra voltar. Fica 5 s parado e chega com 15 s de invencibilidade.
t	Item no chão: valioso (diamante, netherite, encantado, equipamento de chefe, shulker) nunca some. Lixo (pedra, terra, areia, semente, graveto) some em 30 s a 3 min. O resto dura 15 min.
t	Bundle: na bancada, 3 linhas na fileira de cima e 6 couros nas duas de baixo.
b	Maçã dourada encantada: maçã dourada no centro, pérola do End em cima, 4 blocos de ferro dos lados e 3 blocos de ouro embaixo. Devolve 3 corações de vida máxima.
b	Maçã encantada sem ouro: maçã dourada + 1 drop de chefe (Heart of the Deep, Soul Crystal, Ancient Anima, Crystal Fruit, Void Thorn ou Treasure Pouch), em qualquer posição.
t	Poção acima do vanilla: na bancada, poção forte + 1 Essência de Chefe = 1 nível acima (Força e Velocidade até IV, Regeneração e Cura até III).
t	Poção do Mestre Tartaruga + 1 Essência de Chefe = Resistência sem a lentidão. Mais Essência sobe até Resistência III.
t	Poção feita com Essência não pode voltar pro suporte de poções: o jogo refaz a poção e ela perde o efeito.
t	Essência de Chefe: chefe com Ascensão I ou mais dá Essências pra CADA um que bateu nele (Ascensão X = 10 cada).
t	Waystone, sharestone, warp plate e pergaminho não têm receita aqui: só achando no mundo.
t	Bússola do Explorador (acha estrutura): bússola no centro, 4 tijolos de pedra rachados nos lados e 4 teias nos cantos.
t	Molde de melhoria do Warden duplica: molde em cima, sculk no centro e 7 diamantes em volta = 2 moldes.
t	Barco de obsidiana anda na LAVA e não flutua em água. Receita: 5 obsidianas no formato de barco.
t	Potion Blending Combiner junta 3 poções numa só. Receita: suporte de poções no centro e 7 lingotes de ferro em volta (o do meio de cima fica vazio).
t	Netherrack no forno (ou no alto-forno) vira tijolo do Nether.
t	Pra entrar na Bumblezone: jogue uma pérola do End numa colmeia ou num ninho de abelha.
t	O mapa do Xaero é COMPARTILHADO: o que um explora aparece no mapa dos outros.
t	Dá pra pegar spawner e levar junto (PortableSpawner).
t	Perto de farm com muito mob, o Too Many Entities esconde o excesso pra ganhar FPS. Configurável no Mod Menu.
t	O IPN tem 5 perfis de inventário com tecla rápida: Combate, Mineração, Exploração.
t	Dá pra travar um slot do inventário (IPN) e a ordenação automática pula ele.
t	Tem lista de tarefas compartilhada no servidor (TeamTasks): o que um cria, os outros veem.
t	2 lajes iguais viram bloco cheio de volta (Deslabification).
t	A Cornelia (chefe do Aquamirae) vive no labirinto de gelo, no fundo do oceano frio.
b	O Brothers tem Bumblezone e Otherside (Deeper Dark) gerados. Já foi?
b	A Ancient City mais perto da base velha (X 151 Z 396) fica em X -264 Z 504.
b	Tem 4 Void Blossom no mapa dos Brothers. O mais perto da base velha: X -680 Z 328.
b	3 Gauntlet no Nether dos Brothers: -280/-792, -872/-296, -952/-872.
b	O Stalker do Deeper Dark já tem templo gerado no Otherside.
t	Se você roda Chunky e voa ao mesmo tempo, o Distant Horizons deixa buracos no terreno.
t	O primeiro boot depois de atualizar o Distant Horizons é lento: ele converte o banco de terreno. Deixa terminar.
t	Não mexa nas opções do Distant Horizons por conta própria: tem um perfil pronto pra sua máquina.
'@

# fontes (OFL) que o launcher baixa de  <BASE_URL>/fontes/  pra .\fontes\
$FONTES_LISTA = @(
  @{ n = 'BrosFigtree500.ttf'; sha = '25cc3de91cb9eece440eb6d28642b499d8e6c9f3' }
  @{ n = 'BrosFigtree600.ttf'; sha = 'cd9738ba3bfccdad5451ba42e7fcd26ab77efac2' }
  @{ n = 'BrosFigtree700.ttf'; sha = '9ed85edfe771012f444cc1982d5f2720f7a8d50c' }
  @{ n = 'BrosFigtree800.ttf'; sha = '798764589dc55e17b055a94f285929b48a2e5914' }
  @{ n = 'BrosNunito300.ttf'; sha = 'c46eac8db678c2c3acbdd079bb7112fa6fbaa560' }
  @{ n = 'BrosNunito600.ttf'; sha = 'd161ce2a6f391521127b2134d14cff1162d2d885' }
  @{ n = 'BrosNunito700.ttf'; sha = '9527e058a8c03c7539dafedc6f64cede3c8e00db' }
  @{ n = 'BrosNunito800.ttf'; sha = '28fb0873e9144eed8652c517815c762aba653003' }
  @{ n = 'BrosPixelify500.ttf'; sha = '12619b22ac9c7a1b496d26ed4e22c9557e676050' }
  @{ n = 'BrosPixelify700.ttf'; sha = '8325455947eaca4f6dfa3b7e83030a4b7970401f' }
  @{ n = 'PressStart2P-Regular.ttf'; sha = '53d0ade1ecbf01bb7237f435c6f524f62bd30b9f' }
  @{ n = 'VT323-Regular.ttf'; sha = '5b82551f049f002f6f30e6fd1af157d22062d77f' }
)
$FONTE_FAM = @{
  nunito   = @{ 300 = 'BrosNunito300'; 600 = 'BrosNunito600'; 700 = 'BrosNunito700'; 800 = 'BrosNunito800' }
  figtree  = @{ 500 = 'BrosFigtree500'; 600 = 'BrosFigtree600'; 700 = 'BrosFigtree700'; 800 = 'BrosFigtree800' }
  pixelify = @{ 500 = 'BrosPixelify500'; 700 = 'BrosPixelify700' }
  vt323    = @{ 400 = 'VT323' }
  press    = @{ 400 = 'Press Start 2P' }
}
$FONTE_ARQ = @{ 'VT323' = 'VT323-Regular.ttf'; 'Press Start 2P' = 'PressStart2P-Regular.ttf' }

# ---------------- visual (R#254: o mesmo pra todo mundo; a engrenagem so muda pra quem quiser) ----------------
$PADRAO = [ordered]@{ fundo = 'obsidiana'; topo = 'grama'; placa = 'carmesim'; texto = 'nunito'; titulo = 'texto'; tam = 'p' }
$OPCOES = [ordered]@{
  fundo  = @{ nome = 'Fundo';             tipo = 'textura'; ops = @(@('obsidiana', 'Obsidiana'), @('pedregulho', 'Pedregulho'), @('pedra', 'Pedra'), @('ardosia', 'Ardósia'), @('tabuas', 'Tábuas')) }
  topo   = @{ nome = 'Topo';              tipo = 'textura'; ops = @(@('grama', 'Grama'), @('neve', 'Neve'), @('areia', 'Areia'), @('nether', 'Nether')) }
  placa  = @{ nome = 'Placas das dicas';  tipo = 'textura'; ops = @(@('carvalho', 'Carvalho'), @('abeto', 'Abeto'), @('betula', 'Bétula'), @('carmesim', 'Carmesim')) }
  texto  = @{ nome = 'Letra do texto';    tipo = 'letra';   ops = @(@('figtree', 'Figtree'), @('nunito', 'Nunito'), @('vt323', 'VT323'), @('pixelify', 'Pixelify')) }
  titulo = @{ nome = 'Letra dos títulos'; tipo = 'letra';   ops = @(@('press', 'Pixel quadrada'), @('vt323', 'Pixel fina'), @('texto', 'Igual ao texto')) }
  tam    = @{ nome = 'Tamanho do texto';  tipo = 'letra';   ops = @(@('p', 'Pequeno'), @('m', 'Normal'), @('g', 'Grande')) }
}
# textura do jar do jogo -> cor de reserva (se o jar nao for achado)
$TEX = @{
  obsidian = '#15101F'; cobblestone = '#7A7A7A'; stone = '#7F7F7F'; deepslate = '#4A4A50'; oak_planks = '#A2824E'
  spruce_planks = '#6B5030'; birch_planks = '#C5B47B'; crimson_planks = '#6A344B'; grass_block_side = '#6A9B3C'; dirt = '#866043'
  grass_block_snow = '#E8F4F4'; sand = '#DBD3A0'; sandstone = '#D6C992'; crimson_nylium_side = '#7D1F1F'; netherrack = '#6F3434'
}
$FUNDO_TEX = @{ obsidiana = 'obsidian'; pedregulho = 'cobblestone'; pedra = 'stone'; ardosia = 'deepslate'; tabuas = 'oak_planks' }
$TOPO_TEX  = @{ grama = @('grass_block_side', 'dirt'); neve = @('grass_block_snow', 'dirt'); areia = @('sand', 'sandstone'); nether = @('crimson_nylium_side', 'netherrack') }
$PLACA_TEX = @{ carvalho = 'oak_planks'; abeto = 'spruce_planks'; betula = 'birch_planks'; carmesim = 'crimson_planks' }
$PLACA_ESCURA = @{ abeto = $true; carmesim = $true }
$CORES = @{ verde = @('#80FF20', '#C6FF8E', '#3C9A00'); vermelho = @('#FF5555', '#FFA3A3', '#A01010'); amarelo = @('#FFD23F', '#FFF09A', '#A37F00') }

# ---------------- utilidades ----------------
function CfgLer($k) {
    if (-not (Test-Path -LiteralPath $CFG)) { return $null }
    foreach ($l in (Get-Content -LiteralPath $CFG)) {
        $p = $l -split '=', 2
        if ($p.Count -eq 2 -and $p[0].Trim([char]0xFEFF) -eq $k) { return $p[1] }
    }
    return $null
}
function CfgGravar($k, $v) {
    $ls = @()
    if (Test-Path -LiteralPath $CFG) {
        foreach ($l in (Get-Content -LiteralPath $CFG)) {
            if (($l -split '=', 2)[0].Trim([char]0xFEFF) -ne $k) { $ls += $l }
        }
    }
    if ($null -ne $v) { $ls += ($k + '=' + $v) }
    $ls | Set-Content -LiteralPath $CFG -Encoding UTF8
}
function CfgApagar($k) { if ($null -ne (CfgLer $k)) { CfgGravar $k $null } }

function TextoUtf8([byte[]]$b) {
    $t = [Text.Encoding]::UTF8.GetString($b)
    return $t.TrimStart([char]0xFEFF)
}
function BaixarBytes($rel) {
    $u = $BASE_URL.TrimEnd('/') + '/' + $rel
    $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 20
    return ,($r.RawContentStream.ToArray())
}
function Baixar($rel) { return (TextoUtf8 (BaixarBytes $rel)) }
# local (publico\, so no PC do Matheus) -> GitHub -> cache. origem: local | github | cache | $null
function BaixarGuardado([string]$rel) {
    $loc = Join-Path $PUBLICO $rel
    if (Test-Path -LiteralPath $loc) {
        return @{ txt = (TextoUtf8 ([IO.File]::ReadAllBytes($loc))); origem = 'local' }
    }
    $p = Join-Path $CACHE $rel
    try {
        $t = Baixar $rel
        if (-not (Test-Path -LiteralPath $CACHE)) { New-Item -ItemType Directory -Path $CACHE -Force | Out-Null }
        [IO.File]::WriteAllText($p, $t, (New-Object Text.UTF8Encoding($false)))
        return @{ txt = $t; origem = 'github' }
    } catch {
        Write-Host ('BAIXAR ' + $rel + ': ' + $_.Exception.Message)
        if (Test-Path -LiteralPath $p) { return @{ txt = (TextoUtf8 ([IO.File]::ReadAllBytes($p))); origem = 'cache' } }
        return @{ txt = $null; origem = $null }
    }
}
function LerGuardado([string]$rel) {   # sem rede: pro primeiro desenho da janela
    foreach ($d in @($PUBLICO, $CACHE)) {
        $p = Join-Path $d $rel
        if (Test-Path -LiteralPath $p) { try { return (TextoUtf8 ([IO.File]::ReadAllBytes($p))) } catch { } }
    }
    return $null
}
function ModJson($jar) {
    try {
        $z = [System.IO.Compression.ZipFile]::OpenRead($jar)
        try {
            $e = $z.GetEntry('fabric.mod.json')
            if (-not $e) { return $null }
            $sr = New-Object System.IO.StreamReader($e.Open())
            $txt = $sr.ReadToEnd(); $sr.Close()
            return $txt
        } finally { $z.Dispose() }
    } catch { return $null }
}
function ModId($jar) {
    $txt = ModJson $jar
    if (-not $txt) { return $null }
    $m = [regex]::Match($txt, '"id"\s*:\s*"([^"]+)"')
    if ($m.Success) { return $m.Groups[1].Value }
    return $null
}
function NomeDeArquivo([string]$n) {
    $b = [IO.Path]::GetFileNameWithoutExtension($n)
    $b = ($b -split '[-_+ ](?=v?\d)')[0]
    $b = $b -replace '(?i)[-_ ]?(fabric|forge|quilt|mc)$', ''
    $b = ($b -replace '[-_]', ' ').Trim()
    if (-not $b) { return $n }
    return $b
}
function ModNome($jar) {
    $txt = ModJson $jar
    if ($txt) {
        $mn = [regex]::Match($txt, '"name"\s*:\s*"([^"]+)"')
        $mv = [regex]::Match($txt, '"version"\s*:\s*"([^"]+)"')
        if ($mn.Success) {
            if ($mv.Success -and $mv.Groups[1].Value -notmatch '\$') { return ($mn.Groups[1].Value + ' ' + $mv.Groups[1].Value) }
            return $mn.Groups[1].Value
        }
    }
    return (NomeDeArquivo (Split-Path -Leaf $jar))
}
function Juntar($itens, [int]$max = 3) {
    $l = @($itens)
    if ($l.Count -eq 0) { return '' }
    if ($l.Count -gt $max) { return (($l[0..($max - 1)] -join ', ') + ' e mais ' + ($l.Count - $max)) }
    if ($l.Count -eq 1) { return [string]$l[0] }
    return ((($l[0..($l.Count - 2)]) -join ', ') + ' e ' + $l[$l.Count - 1])
}
function JogoAberto {
    # so o JOGO trava os .jar: o SKLauncher e os servidores (java) nao contam
    try {
        foreach ($p in @(Get-CimInstance Win32_Process -Filter "Name='javaw.exe' OR Name='java.exe'" -ErrorAction Stop)) {
            if ([string]$p.CommandLine -match 'KnotClient|net\.minecraft\.client\.main|--accessToken') { return $true }
        }
        return $false
    } catch {
        return [bool](Get-Process -Name javaw -ErrorAction SilentlyContinue)
    }
}
function SKAberto {
    try {
        foreach ($p in @(Get-CimInstance Win32_Process -Filter "Name='javaw.exe' OR Name='java.exe' OR Name LIKE 'sklauncher%'" -ErrorAction Stop)) {
            if (([string]$p.CommandLine + ' ' + [string]$p.Name) -match '(?i)sklauncher') { return $true }
        }
    } catch { }
    return $false
}

# ---------------- R#156 · apontar pro servidor novo (v13) ----------------
# Liga SO se o lista.txt do GitHub tiver a linha  SERVIDOR<TAB>host:porta.
# 1) Xaero: a pasta de waypoints e "Multiplayer_" + host SEM porta (lido no
#    bytecode do Xaero). Trocar de endereco = pasta nova e vazia. Aqui a gente
#    acha a pasta que tem o mundo dos Brothers (arquivo mw$<id>_*.txt, id do
#    world\xaeromap.txt do servidor) e copia pro nome novo, SEM sobrescrever nada.
# 2) servers.dat: acha a entrada que usa esse mesmo host e troca SO o endereco.
#    O NOME fica -> o Distant Horizons (serverFolderNameMode = NAME_ONLY) acha
#    o LOD de sempre. Sem entrada achada, cria "Brothers (NeonHost)".
# O NBT e lido guardando os BYTES originais de cada valor: o arquivo volta
# identico, menos o endereco trocado (nome com acento/emoji nao e recodificado).
$NBT_TAM = @{ 1 = 1; 2 = 2; 3 = 4; 4 = 8; 5 = 4; 6 = 8 }
function NbtU16([byte[]]$b, [int]$i) { return ([int]$b[$i] * 256) + [int]$b[$i + 1] }
function NbtI32([byte[]]$b, [int]$i) {
    return ([int]$b[$i] -shl 24) -bor ([int]$b[$i + 1] -shl 16) -bor ([int]$b[$i + 2] -shl 8) -bor [int]$b[$i + 3]
}
function NbtFatia([byte[]]$b, [int]$i, [int]$n) {
    $r = New-Object byte[] ([Math]::Max(0, $n))
    if ($n -gt 0) { [Array]::Copy($b, $i, $r, 0, $n) }
    return ,$r
}
function NbtStr([string]$txt) {
    $raw = [Text.Encoding]::UTF8.GetBytes($txt)
    return @{ t = 8; raw = $raw; txt = $txt }
}
function NbtLe([byte[]]$b, [int]$t) {
    $i = $script:nbtI
    if ($NBT_TAM.ContainsKey($t)) {
        $n = $NBT_TAM[$t]; $script:nbtI = $i + $n
        return @{ t = $t; raw = (NbtFatia $b $i $n) }
    }
    if ($t -eq 8) {
        $n = NbtU16 $b $i; $script:nbtI = $i + 2 + $n
        $raw = NbtFatia $b ($i + 2) $n
        return @{ t = 8; raw = $raw; txt = [Text.Encoding]::UTF8.GetString($raw) }
    }
    if ($t -eq 7 -or $t -eq 11 -or $t -eq 12) {
        $n = NbtI32 $b $i; $larg = 1
        if ($t -eq 11) { $larg = 4 }
        if ($t -eq 12) { $larg = 8 }
        $tot = 4 + $n * $larg; $script:nbtI = $i + $tot
        return @{ t = $t; raw = (NbtFatia $b $i $tot) }
    }
    if ($t -eq 9) {
        $et = [int]$b[$i]; $n = NbtI32 $b ($i + 1); $script:nbtI = $i + 5
        $itens = New-Object System.Collections.ArrayList
        for ($k = 0; $k -lt $n; $k++) { [void]$itens.Add((NbtLe $b $et)) }
        return @{ t = 9; et = $et; itens = $itens }
    }
    if ($t -eq 10) {
        $campos = New-Object System.Collections.ArrayList
        while ($true) {
            $tt = [int]$b[$script:nbtI]; $script:nbtI = $script:nbtI + 1
            if ($tt -eq 0) { break }
            $nome = NbtLe $b 8
            $val = NbtLe $b $tt
            [void]$campos.Add(@{ t = $tt; nome = $nome; v = $val })
        }
        return @{ t = 10; campos = $campos }
    }
    throw ('tag NBT desconhecida: ' + $t)
}
function NbtEscreve($ms, $no) {
    if ($no.t -eq 8) {
        $n = $no.raw.Length
        $ms.WriteByte([byte](($n -shr 8) -band 255)); $ms.WriteByte([byte]($n -band 255))
        if ($n -gt 0) { $ms.Write($no.raw, 0, $n) }
        return
    }
    if ($no.t -eq 9) {
        $ms.WriteByte([byte]$no.et); $c = $no.itens.Count
        foreach ($s in 24, 16, 8, 0) { $ms.WriteByte([byte](($c -shr $s) -band 255)) }
        foreach ($it in $no.itens) { NbtEscreve $ms $it }
        return
    }
    if ($no.t -eq 10) {
        foreach ($c in $no.campos) { $ms.WriteByte([byte]$c.t); NbtEscreve $ms $c.nome; NbtEscreve $ms $c.v }
        $ms.WriteByte(0)
        return
    }
    if ($no.raw.Length -gt 0) { $ms.Write($no.raw, 0, $no.raw.Length) }
}
function NbtAbre([byte[]]$b) {
    $script:nbtI = 1
    $nome = NbtLe $b 8
    $raiz = NbtLe $b ([int]$b[0])
    return @{ t0 = [int]$b[0]; nome = $nome; raiz = $raiz }
}
function NbtBytes($doc) {
    $ms = New-Object System.IO.MemoryStream
    $ms.WriteByte([byte]$doc.t0); NbtEscreve $ms $doc.nome; NbtEscreve $ms $doc.raiz
    return ,($ms.ToArray())
}
function NbtCampo($comp, [string]$nome) {
    foreach ($c in $comp.campos) { if ($c.nome.txt -eq $nome) { return $c } }
    return $null
}
function HostDe([string]$end) {
    $h = $end.Trim()
    if ($h.IndexOf(':') -ge 0 -and $h.IndexOf(':') -eq $h.LastIndexOf(':')) { $h = $h.Substring(0, $h.LastIndexOf(':')) }
    return $h.TrimEnd('.').ToLower()
}
function XaeroPasta([string]$end) {
    $h = HostDe $end
    $h = $h.Replace(':', [string][char]0x00A7).Replace('_', '%us%').Replace('/', '%fs%').Replace('\', '%bs%')
    return ('Multiplayer_' + $h)
}
function XaeroHost([string]$pasta) {
    $h = $pasta.Substring('Multiplayer_'.Length)
    return $h.Replace('%us%', '_').Replace([string][char]0x00A7, ':').Replace('%fs%', '/').Replace('%bs%', '\').ToLower()
}
function XaeroComBrothers([string]$tipo) {
    $raiz = Join-Path (Join-Path $MC 'xaero') $tipo
    $r = @()
    if (-not (Test-Path -LiteralPath $raiz)) { return $r }
    foreach ($d in (Get-ChildItem -LiteralPath $raiz -Directory -Filter 'Multiplayer_*' -ErrorAction SilentlyContinue)) {
        $achou = $null
        if ($tipo -eq 'minimap') {
            $achou = Get-ChildItem -LiteralPath $d.FullName -Recurse -File -Filter ('mw$' + $XAERO_ID + '_*.txt') -ErrorAction SilentlyContinue |
                     Sort-Object LastWriteTime -Descending | Select-Object -First 1
        } else {
            $achou = Get-ChildItem -LiteralPath $d.FullName -Directory -ErrorAction SilentlyContinue |
                     ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Directory -Filter ('mw$' + $XAERO_ID) -ErrorAction SilentlyContinue } |
                     Sort-Object LastWriteTime -Descending | Select-Object -First 1
        }
        if ($achou) { $r += @{ pasta = $d; quando = $achou.LastWriteTime } }
    }
    return $r
}
function ApontarServidor([string]$novo) {
    $rel = @()
    $nomeNovo = XaeroPasta $novo
    $hostNovo = HostDe $novo
    # hosts que HOJE guardam o mundo dos Brothers no Xaero (e por onde a pessoa entra)
    $hosts = @()
    foreach ($c in @(XaeroComBrothers 'minimap')) {
        $h = XaeroHost $c.pasta.Name
        if ($h -ne $hostNovo) { $hosts += $h }
    }
    $rel += ('hosts antigos do Brothers no Xaero: ' + ($hosts -join ', '))

    # 1 - Xaero
    foreach ($tipo in 'minimap', 'world-map') {
        $cands = @(XaeroComBrothers $tipo)
        $jaTem = $false
        foreach ($c in $cands) { if ($c.pasta.Name -eq $nomeNovo) { $jaTem = $true } }
        if ($jaTem) { $rel += ($tipo + ': ja existe em ' + $nomeNovo); continue }
        $orig = $cands | Sort-Object { $_.quando } -Descending | Select-Object -First 1
        if (-not $orig) { $rel += ($tipo + ': nada do Brothers pra copiar'); continue }
        $dest = Join-Path (Join-Path (Join-Path $MC 'xaero') $tipo) $nomeNovo
        & robocopy $orig.pasta.FullName $dest /E /XC /XN /XO /R:1 /W:1 /NFL /NDL /NJH /NJS /NP | Out-Null
        if ($LASTEXITCODE -lt 8) { $rel += ($tipo + ': ' + $orig.pasta.Name + ' -> ' + $nomeNovo) }
        else { throw ('robocopy falhou em ' + $tipo + ' (codigo ' + $LASTEXITCODE + ')') }
    }

    # 2 - servers.dat
    $f = Join-Path $MC 'servers.dat'
    if (Test-Path -LiteralPath $f) {
        $doc = NbtAbre ([IO.File]::ReadAllBytes($f))
    } else {
        $doc = @{ t0 = 10; nome = (NbtStr ''); raiz = @{ t = 10; campos = (New-Object System.Collections.ArrayList) } }
    }
    $lista = NbtCampo $doc.raiz 'servers'
    if (-not $lista) {
        $lista = @{ t = 9; nome = (NbtStr 'servers'); v = @{ t = 9; et = 10; itens = (New-Object System.Collections.ArrayList) } }
        [void]$doc.raiz.campos.Add($lista)
    }
    $itens = $lista.v.itens
    $ja = $false; $alvo = $null; $porHost = @(); $porNome = @()
    foreach ($s in $itens) {
        if ($s.t -ne 10) { continue }
        $ip = NbtCampo $s 'ip'; $nm = NbtCampo $s 'name'
        if (-not $ip) { continue }
        if ($ip.v.txt.Trim().ToLower() -eq $novo.Trim().ToLower()) { $ja = $true }
        if ($hosts -contains (HostDe $ip.v.txt)) { $porHost += $s }
        if ($nm -and $nm.v.txt -match 'brother') { $porNome += $s }
    }
    if ($ja) { $rel += 'servers.dat: ja aponta pro endereco novo'; return $rel }
    if ($porHost.Count -eq 1) { $alvo = $porHost[0] }
    elseif ($porHost.Count -gt 1) {
        foreach ($s in $porHost) { if ((-not $alvo) -and ($porNome -contains $s)) { $alvo = $s } }
    }
    if ((-not $alvo) -and $porNome.Count -eq 1) { $alvo = $porNome[0] }
    if ($alvo) {
        $c = NbtCampo $alvo 'ip'; $antigo = $c.v.txt
        $c.v = NbtStr $novo
        $nm = NbtCampo $alvo 'name'; $rotulo = '?'
        if ($nm) { $rotulo = $nm.v.txt }
        $rel += ('servers.dat: "' + $rotulo + '" ' + $antigo + ' -> ' + $novo + ' (nome mantido = LOD do DH preservado)')
    } else {
        $novoS = @{ t = 10; campos = (New-Object System.Collections.ArrayList) }
        [void]$novoS.campos.Add(@{ t = 8; nome = (NbtStr 'name'); v = (NbtStr 'Brothers (NeonHost)') })
        [void]$novoS.campos.Add(@{ t = 8; nome = (NbtStr 'ip'); v = (NbtStr $novo) })
        if ($itens.Count -eq 0) { $lista.v.et = 10 }
        $itens.Insert(0, $novoS)
        $rel += 'servers.dat: nao achei a entrada antiga -> criei "Brothers (NeonHost)" (LOD do DH comeca do zero)'
    }
    $bkp = $f + '.pre_launcher_v13'
    if ((Test-Path -LiteralPath $f) -and -not (Test-Path -LiteralPath $bkp)) { Copy-Item -LiteralPath $f -Destination $bkp }
    [IO.File]::WriteAllBytes($f, (NbtBytes $doc))
    return $rel
}

# ---------------- auto-conserto: launcher salvo com acento quebrado ----------------
# (o v17 baixa o v18 como texto; se alguma maquina decodificar errado, os acentos viram lixo.
#  O padrao e montado por codigo pra este arquivo nao acusar a si mesmo.)
try {
    $euTxt = TextoUtf8 ([IO.File]::ReadAllBytes($MyInvocation.MyCommand.Path))
    $padraoQuebrado = [string][char]0xC3 + '[' + [char]0xA1 + [char]0xA3 + [char]0xA7 + [char]0xA9 + [char]0xAA + [char]0xB3 + [char]0xBA + ']'
    if ($euTxt -match $padraoQuebrado -and -not (Test-Path -LiteralPath (Join-Path $AQUI 'launcher.new.ps1'))) {
        $rb = BaixarBytes 'launcher.ps1'
        if (-not ((TextoUtf8 $rb) -match $padraoQuebrado)) {
            Write-Host 'AUTO-CONSERTO: launcher com acento quebrado -> baixei de novo do GitHub'
            [IO.File]::WriteAllBytes((Join-Path $AQUI 'launcher.new.ps1'), $rb)
            Start-Process -FilePath (Join-Path $AQUI 'JOGAR.bat')
            try { Stop-Transcript | Out-Null } catch { }
            exit 0
        }
    }
} catch { Write-Host ('AUTO-CONSERTO: ' + $_.Exception.Message) }

# ---------------- quem e voce ----------------
# R#131: o cfg carimba o usuario do Windows; se nao for desta maquina, ele e descartado inteiro.
if ((Test-Path -LiteralPath $CFG) -and ((CfgLer 'usuario') -ne $env:USERNAME)) {
    Remove-Item -LiteralPath $CFG -Force -ErrorAction SilentlyContinue
}
$EU = CfgLer 'perfil'
if (-not $EU) {
    $op = '1'
    try {
        $op = [Microsoft.VisualBasic.Interaction]::InputBox(
            "Quem está neste computador?`n`n1 = Marcelo (Tensei)`n2 = Gabu (Gabutre)`n3 = Fábio (fabium)`n4 = Say (sasayuyu)`n5 = Matheus (mmcadora)`n6 = Dahmer (dahmerdummer420)",
            'Primeira vez', '1')
    } catch {
        $op = Read-Host 'Quem e voce? 1=Marcelo 2=Gabu 3=Fabio 4=Say 5=Matheus 6=Dahmer'
    }
    switch ($op) { '1'{$EU='marcelo'} '2'{$EU='gabu'} '3'{$EU='fabio'} '4'{$EU='say'} '5'{$EU='matheus'} '6'{$EU='dahmer'} default{$EU='todos'} }
    CfgGravar 'perfil' $EU
    CfgGravar 'usuario' $env:USERNAME
}
function GrupoDoPerfil { if ($EU -eq 'say') { return 's' }; if ($EU -eq 'matheus') { return '*' }; return 'b' }
Write-Host ('PERFIL: ' + $EU + ' (grupo ' + (GrupoDoPerfil) + ')')

$script:VIS = [ordered]@{}
foreach ($k in $PADRAO.Keys) {
    $v = CfgLer ('v18_' + $k)
    $ok = $false
    if ($v) { foreach ($o in $OPCOES[$k].ops) { if ($o[0] -eq $v) { $ok = $true } } }
    if ($ok) { $script:VIS[$k] = $v } else { $script:VIS[$k] = $PADRAO[$k] }
}

# ---------------- fontes e texturas ----------------
function GarantirFontes {
    if (-not (Test-Path -LiteralPath $FONTES)) { New-Item -ItemType Directory -Path $FONTES -Force | Out-Null }
    $ok = 0; $rede = $true
    foreach ($f in $FONTES_LISTA) {
        $p = Join-Path $FONTES $f.n
        if ((Test-Path -LiteralPath $p) -and ((Get-FileHash -LiteralPath $p -Algorithm SHA1).Hash.ToLower() -eq $f.sha)) { $ok++; continue }
        $loc = Join-Path (Join-Path $PUBLICO 'fontes') $f.n
        try {
            $tmp = $p + '.part'
            if (Test-Path -LiteralPath $loc) { Copy-Item -LiteralPath $loc -Destination $tmp -Force }
            elseif ($rede) { Invoke-WebRequest -Uri ($BASE_URL.TrimEnd('/') + '/fontes/' + $f.n) -OutFile $tmp -UseBasicParsing -TimeoutSec 15 }
            else { continue }
            if ((Get-FileHash -LiteralPath $tmp -Algorithm SHA1).Hash.ToLower() -eq $f.sha) { Move-Item -LiteralPath $tmp -Destination $p -Force; $ok++ }
            else { Remove-Item -LiteralPath $tmp -Force; Write-Host ('FONTE com sha1 errado: ' + $f.n) }
        } catch { Write-Host ('FONTE: ' + $f.n + ' - ' + $_.Exception.Message); $rede = $false }
    }
    Write-Host ('FONTES: ' + $ok + '/' + $FONTES_LISTA.Count)
}
$script:IMG = @{}
function CarregarTexturas {
    $cands = @()
    $j0 = Join-Path $MC 'versions\1.20.1\1.20.1.jar'
    if (Test-Path -LiteralPath $j0) { $cands += $j0 }
    $vd = Join-Path $MC 'versions'
    if (Test-Path -LiteralPath $vd) {
        foreach ($d in (Get-ChildItem -LiteralPath $vd -Directory -ErrorAction SilentlyContinue)) {
            $j = Join-Path $d.FullName ($d.Name + '.jar')
            if ((Test-Path -LiteralPath $j) -and ($cands -notcontains $j)) { $cands += $j }
        }
    }
    foreach ($j in $cands) {
        try {
            $z = [IO.Compression.ZipFile]::OpenRead($j)
            try {
                foreach ($k in @($TEX.Keys)) {
                    if ($script:IMG.ContainsKey($k)) { continue }
                    $e = $z.GetEntry('assets/minecraft/textures/block/' + $k + '.png')
                    if (-not $e) { continue }
                    $ms = New-Object IO.MemoryStream
                    $s = $e.Open(); $s.CopyTo($ms); $s.Close(); $ms.Position = 0
                    $bi = New-Object Windows.Media.Imaging.BitmapImage
                    $bi.BeginInit(); $bi.CacheOption = [Windows.Media.Imaging.BitmapCacheOption]::OnLoad; $bi.StreamSource = $ms; $bi.EndInit(); $bi.Freeze()
                    $script:IMG[$k] = $bi
                }
            } finally { $z.Dispose() }
        } catch { Write-Host ('TEXTURA: ' + $j + ' - ' + $_.Exception.Message) }
        if ($script:IMG.Count -eq $TEX.Count) { break }
    }
    Write-Host ('TEXTURAS: ' + $script:IMG.Count + '/' + $TEX.Count + ' (o resto vira cor lisa)')
}
function Cor([string]$h) {
    $b = New-Object Windows.Media.SolidColorBrush([Windows.Media.ColorConverter]::ConvertFromString($h))
    $b.Freeze(); return $b
}
# R#255: o TileMode=Tile do WPF deixava uma linha da fileira de cima na emenda (a "linha verde" entre a grama e a
# terra). Agora cada pincel e UMA imagem ja ladrilhada (16 px por bloco), esticada sem suavizar e sem repetir.
$script:PIXCACHE = @{}; $script:PINCACHE = @{}
function Pixels([string]$k) {
    if ($script:PIXCACHE.ContainsKey($k)) { return $script:PIXCACHE[$k] }
    $fc = New-Object Windows.Media.Imaging.FormatConvertedBitmap
    $fc.BeginInit(); $fc.Source = $script:IMG[$k]; $fc.DestinationFormat = [Windows.Media.PixelFormats]::Bgra32; $fc.EndInit()
    $tw = $fc.PixelWidth; $th = $fc.PixelHeight
    $buf = New-Object byte[] ($tw * $th * 4)
    $fc.CopyPixels($buf, $tw * 4, 0)
    $r = @{ w = $tw; h = $th; px = $buf }
    $script:PIXCACHE[$k] = $r
    return $r
}
function Mosaico([string[]]$linhas, [int]$cols, [int]$rows) {
    # $linhas[0] = textura da 1a fileira; a ultima da lista se repete nas fileiras de baixo
    $t0 = Pixels $linhas[0]; $tw = $t0.w; $th = $t0.h
    $largPx = $cols * $tw; $altPx = $rows * $th; $stride = $largPx * 4
    $out = New-Object byte[] ($stride * $altPx)
    $faixas = @{}
    for ($r = 0; $r -lt $rows; $r++) {
        $k = $linhas[[Math]::Min($r, $linhas.Count - 1)]
        if (-not $faixas.ContainsKey($k)) {
            $t = Pixels $k
            if ($t.w -ne $tw -or $t.h -ne $th) { $t = $t0 }
            $fx = New-Object byte[] ($stride * $th)
            for ($y = 0; $y -lt $th; $y++) {
                for ($c = 0; $c -lt $cols; $c++) { [Array]::Copy($t.px, $y * $tw * 4, $fx, $y * $stride + $c * $tw * 4, $tw * 4) }
            }
            $faixas[$k] = $fx
        }
        [Array]::Copy($faixas[$k], 0, $out, $r * $th * $stride, $th * $stride)
    }
    $bs = [Windows.Media.Imaging.BitmapSource]::Create($largPx, $altPx, 96, 96, [Windows.Media.PixelFormats]::Bgra32, $null, $out, $stride)
    $bs.Freeze()
    return @{ img = $bs; w = $largPx; h = $altPx; tw = $tw }
}
function PincelDe($mo, [double]$px, [double]$x0 = 0, [double]$y0 = 0) {
    $b = New-Object Windows.Media.ImageBrush($mo.img)
    $b.TileMode = [Windows.Media.TileMode]::None
    $b.Stretch = [Windows.Media.Stretch]::Fill
    $b.AlignmentX = [Windows.Media.AlignmentX]::Left; $b.AlignmentY = [Windows.Media.AlignmentY]::Top
    $b.ViewportUnits = [Windows.Media.BrushMappingMode]::Absolute
    $e = $px / $mo.tw
    $b.Viewport = New-Object Windows.Rect($x0, $y0, ($mo.w * $e), ($mo.h * $e))
    [Windows.Media.RenderOptions]::SetBitmapScalingMode($b, [Windows.Media.BitmapScalingMode]::NearestNeighbor)
    $b.Freeze()
    return $b
}
function Pincel([string]$k, [double]$px, [int]$cols = 20, [int]$rows = 14) { return (PincelTopo $k $k $px $cols $rows) }
function PincelTopo([string]$cima, [string]$baixo, [double]$px, [int]$cols = 20, [int]$rows = 3) {
    if (-not ($script:IMG.ContainsKey($cima) -and $script:IMG.ContainsKey($baixo))) { return (Cor $TEX[$cima]) }
    $ch = $cima + '|' + $baixo + '|' + $px + '|' + $cols + '|' + $rows
    if ($script:PINCACHE.ContainsKey($ch)) { return $script:PINCACHE[$ch] }
    try { $b = PincelDe (Mosaico @($cima, $baixo) $cols $rows) $px }
    catch { Write-Host ('PINCEL ' + $ch + ': ' + $_.Exception.Message); $b = Cor $TEX[$cima] }
    $script:PINCACHE[$ch] = $b
    return $b
}
$script:FAMCACHE = @{}
function Fonte([string]$k, [int]$peso) {
    $tab = $FONTE_FAM[$k]
    if (-not $tab) { $tab = $FONTE_FAM['nunito'] }
    $melhor = $null; $dist = 9999
    foreach ($p in $tab.Keys) { $d = [Math]::Abs([int]$p - $peso); if ($d -lt $dist) { $dist = $d; $melhor = $p } }
    $nome = $tab[$melhor]
    $chave = $k + '|' + $peso
    if ($script:FAMCACHE.ContainsKey($chave)) { return $script:FAMCACHE[$chave] }
    $arq = $FONTE_ARQ[$nome]; if (-not $arq) { $arq = $nome + '.ttf' }
    $r = $null
    if (Test-Path -LiteralPath (Join-Path $FONTES $arq)) {
        try {
            $base = New-Object Uri(($FONTES.TrimEnd('\') + '\'))
            $ff = New-Object Windows.Media.FontFamily($base, ('./' + $arq + '#' + $nome))
            $r = @{ fam = $ff; peso = [Windows.FontWeights]::Normal }
        } catch { Write-Host ('FONTE ' + $nome + ': ' + $_.Exception.Message) }
    }
    if (-not $r) {
        $sub = 'Segoe UI'; if ($k -eq 'vt323' -or $k -eq 'press') { $sub = 'Consolas' }
        $r = @{ fam = (New-Object Windows.Media.FontFamily($sub)); peso = [Windows.FontWeight]::FromOpenTypeWeight([Math]::Max(100, [Math]::Min(900, $peso))) }
    }
    $script:FAMCACHE[$chave] = $r
    return $r
}
function PorFonte($tb, $f, [double]$px) { $tb.FontFamily = $f.fam; $tb.FontWeight = $f.peso; $tb.FontSize = [Math]::Round($px) }

GarantirFontes
CarregarTexturas

# ---------------- dicas e recados ----------------
function LerPerks([string]$txt) {
    $r = New-Object Collections.ArrayList
    $g = GrupoDoPerfil
    if (-not $txt) { return ,$r }
    foreach ($l in ($txt -split "`r?`n")) {
        $l = $l.Trim()
        if (-not $l -or $l.StartsWith('#')) { continue }
        $p = $l -split "`t", 2
        if ($p.Count -eq 2 -and $p[0].Trim().Length -le 5) { $gr = $p[0].Trim().ToLower(); $tx = $p[1].Trim() } else { $gr = 't'; $tx = $l }
        if ($gr -eq 't' -or $gr -eq 'todos' -or $g -eq '*' -or $gr -eq $g) { [void]$r.Add($tx) }
    }
    return ,$r
}
function LerMural([string]$txt) {
    $r = New-Object Collections.ArrayList
    if (-not $txt) { return ,$r }
    foreach ($l in ($txt -split "`r?`n")) {
        if (-not $l.Trim() -or $l.TrimStart().StartsWith('#')) { continue }
        $p = $l -split "`t", 2
        if ($p.Count -lt 2 -or -not $p[1].Trim()) { continue }
        $q = $p[0].Trim().ToLower()
        if ($q -eq 'todos' -or $q -eq $EU) { [void]$r.Add($p[1].Trim()) }
    }
    return ,$r
}
$script:DICAS = LerPerks (LerGuardado 'perks.txt')
if ($script:DICAS.Count -eq 0) { $script:DICAS = LerPerks $PERKS_TXT }
$script:RECADOS = LerMural (LerGuardado 'mural.txt')
$script:TXTBASE = $BASES['b']; if ((GrupoDoPerfil) -eq 's') { $script:TXTBASE = $BASES['s'] }

# ---------------- janela ----------------
$ESTILOS = @'
    <DropShadowEffect x:Key="Sombra" ShadowDepth="2" Direction="315" BlurRadius="0" Color="Black" Opacity="1"/>
    <DropShadowEffect x:Key="Sombra3" ShadowDepth="3" Direction="315" BlurRadius="0" Color="Black" Opacity="1"/>
    <Style x:Key="MC" TargetType="Button">
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Focusable" Value="False"/>
      <Setter Property="Background" Value="#7F7F7F"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="{TemplateBinding Background}" BorderBrush="Black" BorderThickness="3">
              <Grid>
                <ContentPresenter HorizontalAlignment="Stretch" VerticalAlignment="Stretch" RecognizesAccessKey="False"/>
                <Border BorderBrush="#73FFFFFF" BorderThickness="3,3,0,0" IsHitTestVisible="False"/>
                <Border BorderBrush="#73000000" BorderThickness="0,0,3,4" IsHitTestVisible="False"/>
                <Border x:Name="Hl" BorderBrush="White" BorderThickness="3" Visibility="Collapsed" IsHitTestVisible="False"/>
              </Grid>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Hl" Property="Visibility" Value="Visible"/></Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter TargetName="Bd" Property="Opacity" Value="0.45"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="MCp" TargetType="Button">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Focusable" Value="False"/>
      <Setter Property="Background" Value="#7F7F7F"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="{TemplateBinding Background}" BorderBrush="Black" BorderThickness="2">
              <Grid>
                <ContentPresenter HorizontalAlignment="Stretch" VerticalAlignment="Stretch" RecognizesAccessKey="False"/>
                <Border BorderBrush="#73FFFFFF" BorderThickness="2,2,0,0" IsHitTestVisible="False"/>
                <Border BorderBrush="#73000000" BorderThickness="0,0,2,2" IsHitTestVisible="False"/>
                <Border x:Name="Hl" BorderBrush="White" BorderThickness="2" Visibility="Collapsed" IsHitTestVisible="False"/>
              </Grid>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Hl" Property="Visibility" Value="Visible"/></Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter TargetName="Bd" Property="Opacity" Value="0.45"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Plano" TargetType="Button">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Focusable" Value="False"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button"><ContentPresenter/></ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
'@
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Modpack dos Brothers" SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen"
        ResizeMode="CanMinimize" Background="Black" UseLayoutRounding="True" SnapsToDevicePixels="True">
  <Window.Resources>
$ESTILOS
  </Window.Resources>
  <Viewbox x:Name="VB" Stretch="Uniform">
  <Grid x:Name="GRaiz" Width="860" Height="620" ClipToBounds="True">
    <Grid.RowDefinitions>
      <RowDefinition Height="100"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/><RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>

    <Border Grid.Row="0" BorderBrush="Black" BorderThickness="0,0,0,4">
      <Grid>
        <Rectangle x:Name="RTopo"/>
        <StackPanel Margin="24,16,0,0" VerticalAlignment="Top" HorizontalAlignment="Left">
          <TextBlock x:Name="TTitulo" Text="MODPACK DOS BROTHERS" Foreground="White" Effect="{StaticResource Sombra3}"/>
          <TextBlock x:Name="TBase" Text="" Foreground="#FFFF55" Margin="0,8,0,0" Effect="{StaticResource Sombra}"/>
        </StackPanel>
        <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,18,20,0">
          <Button x:Name="BTela" Style="{StaticResource MC}" Width="52" Height="52" Margin="0,0,8,0" ToolTip="Tela cheia (F11)">
            <Grid><Viewbox x:Name="PTelaAbrir" Width="22" Height="22" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M2,6 V2 H6 M10,2 H14 V6 M14,10 V14 H10 M6,14 H2 V10"/></Grid></Viewbox><Viewbox x:Name="PTelaSair" Width="22" Height="22" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}" Visibility="Collapsed"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M6,2 V6 H2 M14,6 H10 V2 M10,14 V10 H14 M2,10 H6 V14"/></Grid></Viewbox></Grid>
          </Button>
          <Button x:Name="BConfig" Style="{StaticResource MC}" Width="52" Height="52" ToolTip="Configurações">
            <Viewbox Width="28" Height="28" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Fill="White" Data="M6.58,2.69 L6.7,0.61 A7.5,7.5 0 0 1 9.3,0.61 L9.42,2.69 A5.5,5.5 0 0 1 10.75,3.24 L12.3,1.86 A7.5,7.5 0 0 1 14.14,3.7 L12.76,5.25 A5.5,5.5 0 0 1 13.31,6.58 L15.39,6.7 A7.5,7.5 0 0 1 15.39,9.3 L13.31,9.42 A5.5,5.5 0 0 1 12.76,10.75 L14.14,12.3 A7.5,7.5 0 0 1 12.3,14.14 L10.75,12.76 A5.5,5.5 0 0 1 9.42,13.31 L9.3,15.39 A7.5,7.5 0 0 1 6.7,15.39 L6.58,13.31 A5.5,5.5 0 0 1 5.25,12.76 L3.7,14.14 A7.5,7.5 0 0 1 1.86,12.3 L3.24,10.75 A5.5,5.5 0 0 1 2.69,9.42 L0.61,9.3 A7.5,7.5 0 0 1 0.61,6.7 L2.69,6.58 A5.5,5.5 0 0 1 3.24,5.25 L1.86,3.7 A7.5,7.5 0 0 1 3.7,1.86 L5.25,3.24 A5.5,5.5 0 0 1 6.58,2.69 Z M10.3,8 A2.3,2.3 0 1 0 5.7,8 A2.3,2.3 0 1 0 10.3,8 Z"/></Grid></Viewbox>
          </Button>
        </StackPanel>
      </Grid>
    </Border>

    <StackPanel Grid.Row="1" Margin="24,18,24,4">
      <Border Height="16" Background="#2B2B2B" BorderBrush="Black" BorderThickness="3">
        <Grid>
          <Grid>
            <Grid.ColumnDefinitions><ColumnDefinition x:Name="CFill" Width="0*"/><ColumnDefinition x:Name="CResto" Width="100*"/></Grid.ColumnDefinitions>
            <Border x:Name="BFill" Grid.Column="0" BorderThickness="0,3,0,0"><Border x:Name="BFillIn" BorderThickness="0,0,0,3"/></Border>
          </Grid>
          <UniformGrid x:Name="USeg" Columns="18" Rows="1" IsHitTestVisible="False"/>
        </Grid>
      </Border>
      <TextBlock x:Name="TStatus" Text="Preparando…" Foreground="White" HorizontalAlignment="Center" TextAlignment="Center"
                 TextWrapping="Wrap" Margin="0,8,0,0" Effect="{StaticResource Sombra}"/>
      <TextBlock x:Name="TDetalhe" Text="" Foreground="#D2D2D2" HorizontalAlignment="Center" TextAlignment="Center"
                 TextWrapping="Wrap" Margin="0,2,0,0" Visibility="Collapsed" Effect="{StaticResource Sombra}"/>
    </StackPanel>

    <Border x:Name="BRecado" Grid.Row="2" Margin="24,6,24,0" BorderBrush="Black" BorderThickness="3" Padding="12,6" Visibility="Collapsed">
      <DockPanel>
        <TextBlock x:Name="TRecadoRot" DockPanel.Dock="Left" Text="RECADO" Foreground="#FFFF55" Margin="0,0,10,0" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/>
        <TextBlock x:Name="TRecado" Text="" Foreground="White" TextWrapping="Wrap" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/>
      </DockPanel>
    </Border>

    <Grid Grid.Row="3" Margin="24,10,24,4">
      <Grid.ColumnDefinitions><ColumnDefinition Width="*"/><ColumnDefinition Width="16"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
      <DockPanel Grid.Column="0">
        <DockPanel DockPanel.Dock="Top" Margin="0,0,0,8" MinHeight="34">
          <TextBlock x:Name="TPrintsTit" Text="SUAS PRINTS" Foreground="#55FFFF" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/>
        </DockPanel>
        <Border x:Name="BMoldura" BorderBrush="Black" BorderThickness="3,3,3,7" Padding="7">
          <DockPanel>
            <DockPanel DockPanel.Dock="Bottom" Margin="0,7,0,0">
              <StackPanel DockPanel.Dock="Right" Orientation="Horizontal" Margin="16,0,0,0">
                <Button x:Name="BPrAntes" Style="{StaticResource MCp}" Width="30" Height="26" ToolTip="Print anterior"><Viewbox Width="12" Height="12" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M10,3 L5,8 L10,13"/></Grid></Viewbox></Button>
                <TextBlock x:Name="TPrintPag" Text="" Foreground="White" MinWidth="50" TextAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/>
                <Button x:Name="BPrDepois" Style="{StaticResource MCp}" Width="30" Height="26" ToolTip="Próxima print"><Viewbox Width="12" Height="12" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M6,3 L11,8 L6,13"/></Grid></Viewbox></Button>
                <Button x:Name="BPrCheia" Style="{StaticResource MCp}" Width="30" Height="26" Margin="6,0,0,0" ToolTip="Ver em tela cheia"><Viewbox Width="12" Height="12" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M2,6 V2 H6 M10,2 H14 V6 M14,10 V14 H10 M6,14 H2 V10"/></Grid></Viewbox></Button>
              </StackPanel>
              <TextBlock x:Name="TPrintData" Text="" Foreground="White" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/>
            </DockPanel>
            <Border x:Name="BFoto" BorderBrush="Black" BorderThickness="3" Background="Black" Cursor="Hand" ToolTip="Clique pra ver em tela cheia">
              <Grid>
                <Image x:Name="IPrint" Stretch="UniformToFill" RenderOptions.BitmapScalingMode="HighQuality"/>
                <TextBlock x:Name="TPrintVazio" Text="Nenhuma print ainda: aperte F2 no jogo." Foreground="#DDDDDD" HorizontalAlignment="Center"
                           VerticalAlignment="Center" TextWrapping="Wrap" TextAlignment="Center" Margin="12" Visibility="Collapsed"/>
              </Grid>
            </Border>
          </DockPanel>
        </Border>
      </DockPanel>
      <DockPanel Grid.Column="2">
        <DockPanel DockPanel.Dock="Top" Margin="0,0,0,8">
          <StackPanel DockPanel.Dock="Right" Orientation="Horizontal">
            <Button x:Name="BDiAntes" Style="{StaticResource MC}" Width="44" Height="34" ToolTip="Dicas anteriores">
              <Viewbox Width="14" Height="14" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M10,3 L5,8 L10,13"/></Grid></Viewbox></Button>
            <TextBlock x:Name="TDicaPag" Text="" Foreground="White" MinWidth="58" TextAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/>
            <Button x:Name="BDiDepois" Style="{StaticResource MC}" Width="44" Height="34" ToolTip="Próximas dicas">
              <Viewbox Width="14" Height="14" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M6,3 L11,8 L6,13"/></Grid></Viewbox></Button>
          </StackPanel>
          <TextBlock x:Name="TDicasTit" Text="VOCÊ SABIA?" Foreground="#FFFF55" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/>
        </DockPanel>
        <StackPanel DockPanel.Dock="Top">
          <Border x:Name="BDica1" BorderBrush="Black" BorderThickness="3,3,3,7" Padding="12,8" Margin="0,0,0,8"><TextBlock x:Name="TDica1" TextWrapping="Wrap"/></Border>
          <Border x:Name="BDica2" BorderBrush="Black" BorderThickness="3,3,3,7" Padding="12,8" Margin="0,0,0,8"><TextBlock x:Name="TDica2" TextWrapping="Wrap"/></Border>
          <Border x:Name="BDica3" BorderBrush="Black" BorderThickness="3,3,3,7" Padding="12,8" Margin="0,0,0,8"><TextBlock x:Name="TDica3" TextWrapping="Wrap"/></Border>
        </StackPanel>
        <Grid/>
      </DockPanel>
    </Grid>

    <Grid Grid.Row="4" Margin="24,6,24,16">
      <TextBlock x:Name="TCanto" Text="" Foreground="#A8A8A8" HorizontalAlignment="Left" VerticalAlignment="Bottom" Margin="0,0,0,2"/>
      <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
        <TextBlock x:Name="LMesmo" Text="jogar mesmo assim" Foreground="#D0D0D0" TextDecorations="Underline" Cursor="Hand"
                   VerticalAlignment="Center" Margin="0,0,14,0" Visibility="Collapsed" Effect="{StaticResource Sombra}"/>
        <Button x:Name="BAcao" Style="{StaticResource MC}" Height="60" MinWidth="230" Visibility="Collapsed">
          <TextBlock x:Name="TAcao" Text="" Foreground="White" Margin="18,0" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/></Button>
        <Button x:Name="BJogar" Style="{StaticResource MC}" Width="280" Height="60" Margin="12,0,0,0" IsEnabled="False" Background="Transparent">
          <Grid>
            <Rectangle x:Name="RJog"/>
            <TextBlock x:Name="TJogar" Text="JOGAR" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra3}"/>
          </Grid>
        </Button>
      </StackPanel>
    </Grid>

    <Grid x:Name="GConfig" Grid.RowSpan="5" Background="#A6000000" Visibility="Collapsed">
      <Border Width="780" MaxHeight="590" HorizontalAlignment="Center" VerticalAlignment="Center" Background="#C6C6C6" BorderBrush="Black" BorderThickness="3">
        <Border BorderBrush="White" BorderThickness="3,3,0,0">
          <Border BorderBrush="#555555" BorderThickness="0,0,3,3" Padding="16,12">
            <DockPanel>
              <DockPanel DockPanel.Dock="Top" Margin="0,0,0,10">
                <Button x:Name="BConfigX" DockPanel.Dock="Right" Style="{StaticResource MC}" Width="44" Height="44" ToolTip="Fechar">
                  <Viewbox Width="16" Height="16" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M3,3 L13,13 M13,3 L3,13"/></Grid></Viewbox></Button>
                <TextBlock x:Name="TConfigTit" Text="Configurações" Foreground="#3F3F3F" VerticalAlignment="Center"/>
              </DockPanel>
              <DockPanel DockPanel.Dock="Bottom" Margin="0,10,0,0" LastChildFill="False">
                <Button x:Name="BPadrao" DockPanel.Dock="Right" Style="{StaticResource MC}" Height="44">
                  <TextBlock x:Name="TPadrao" Text="Voltar ao padrão" Foreground="White" Margin="16,0" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"/></Button>
              </DockPanel>
              <UniformGrid x:Name="UGrupos" Columns="2"/>
            </DockPanel>
          </Border>
        </Border>
      </Border>
    </Grid>
  </Grid>
  </Viewbox>
</Window>
"@

try {
    $w = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
} catch {
    Write-Host ('ERRO NA JANELA: ' + $_.Exception.ToString())
    [System.Windows.MessageBox]::Show(("O launcher v$VERSAO deu erro ao abrir a janela:`n`n" + $_.Exception.Message + "`n`nManda o arquivo _LAUNCHER\ultimo-run.log pro Matheus."), 'Launcher') | Out-Null
    try { Stop-Transcript | Out-Null } catch { }
    exit 1
}
foreach ($n in @('VB','GRaiz','RTopo','TTitulo','TBase','BTela','PTelaAbrir','PTelaSair','BConfig','CFill','CResto','BFill','BFillIn','USeg','TStatus','TDetalhe',
                 'BRecado','TRecadoRot','TRecado','BPrAntes','TPrintPag','BPrDepois','BPrCheia','TPrintsTit',
                 'BMoldura','TPrintData','BFoto','IPrint','TPrintVazio','BDiAntes','TDicaPag','BDiDepois','TDicasTit',
                 'BDica1','BDica2','BDica3','TDica1','TDica2','TDica3','TCanto','LMesmo','BAcao','TAcao','BJogar','RJog','TJogar',
                 'GConfig','BConfigX','TConfigTit','BPadrao','TPadrao','UGrupos')) {
    Set-Variable -Name $n -Value $w.FindName($n) -Scope Script
}
$script:BDICA = @($BDica1, $BDica2, $BDica3)
$script:TDICA = @($TDica1, $TDica2, $TDica3)
for ($i = 0; $i -lt 18; $i++) {
    $sg = New-Object Windows.Controls.Border
    $sg.BorderBrush = Cor '#B3000000'
    if ($i -lt 17) { $sg.BorderThickness = New-Object Windows.Thickness(0, 0, 3, 0) }
    [void]$USeg.Children.Add($sg)
}

function Pump { try { $w.Dispatcher.Invoke([action]{}, [Windows.Threading.DispatcherPriority]::Background) } catch { } }
function Espera([int]$ms) {
    $fim = [DateTime]::Now.AddMilliseconds($ms)
    while ([DateTime]::Now -lt $fim) { Pump; if ($script:fechou) { return }; Start-Sleep -Milliseconds 40 }
}
function Barra([double]$p) {
    $p = [Math]::Max(0, [Math]::Min(100, $p))
    $CFill.Width = New-Object Windows.GridLength($p, [Windows.GridUnitType]::Star)
    $CResto.Width = New-Object Windows.GridLength((100 - $p), [Windows.GridUnitType]::Star)
}
function CorBarra([string]$c) {
    $x = $CORES[$c]; if (-not $x) { $x = $CORES['verde'] }
    $BFillIn.Background = Cor $x[0]; $BFill.BorderBrush = Cor $x[1]; $BFillIn.BorderBrush = Cor $x[2]
}
function UI([string]$msg, [double]$pct = -1, [string]$det = '', [string]$cor = '') {
    $TStatus.Text = $msg
    if ($det) { $TDetalhe.Text = $det; $TDetalhe.Visibility = 'Visible' } else { $TDetalhe.Text = ''; $TDetalhe.Visibility = 'Collapsed' }
    if ($pct -ge 0) { Barra $pct }
    if ($cor) { CorBarra $cor }
    if ($det) { Write-Host ('TELA: ' + $msg + ' | ' + $det) } else { Write-Host ('TELA: ' + $msg) }
    Pump
}
function Estado([string]$s) {
    $script:estado = $s
    $BAcao.Visibility = 'Collapsed'; $LMesmo.Visibility = 'Collapsed'; $BJogar.Visibility = 'Visible'; $TJogar.Text = 'JOGAR'
    switch ($s) {
        'trabalhando' { $BJogar.IsEnabled = $false }
        'esperando'   { $BJogar.IsEnabled = $false; $TJogar.Text = 'ESPERANDO…' }
        'pronto'      { $BJogar.IsEnabled = $true }
        'parado'      { $BJogar.IsEnabled = $false }
        'falha'       { $BJogar.Visibility = 'Collapsed'; $script:acao = 'tentar'; $TAcao.Text = 'TENTAR DE NOVO'; $BAcao.Visibility = 'Visible'; $LMesmo.Visibility = 'Visible' }
        'falta'       { $BJogar.Visibility = 'Collapsed'; $script:acao = 'log'; $TAcao.Text = 'MOSTRAR O LOG'; $BAcao.Visibility = 'Visible'; $LMesmo.Visibility = 'Visible' }
        'sk'          { $BJogar.Visibility = 'Collapsed'; $script:acao = 'sk'; $TAcao.Text = 'ESCOLHER O SKLAUNCHER'; $BAcao.Visibility = 'Visible' }
    }
}

# ---------------- visual ----------------
function Letra($tb, [int]$peso, [double]$em) {
    $base = @{ p = 13; m = 15; g = 17 }[$script:VIS.tam]
    $f = 1.0; if ($script:VIS.texto -eq 'vt323') { $f = 1.3 }
    PorFonte $tb (Fonte $script:VIS.texto $peso) ($base * $em * $f)
}
function Titulo($tb, [double]$px) {
    switch ($script:VIS.titulo) {
        'press' { PorFonte $tb (Fonte 'press' 400) ($px * 0.85) }
        'vt323' { PorFonte $tb (Fonte 'vt323' 400) ($px * 1.45) }
        default { $f = 1.0; if ($script:VIS.texto -eq 'vt323') { $f = 1.3 }; PorFonte $tb (Fonte $script:VIS.texto 800) ($px * $f) }
    }
}
function AplicarVisual {
    $v = $script:VIS
    $GRaiz.Background = Pincel $FUNDO_TEX[$v.fundo] 48 18 13
    FundoJanela
    $t = $TOPO_TEX[$v.topo]; $RTopo.Fill = PincelTopo $t[0] $t[1] 48 18 2
    $RJog.Fill = PincelTopo 'grass_block_side' 'dirt' 48 6 2
    $pedra = Pincel 'stone' 48 7 2
    foreach ($b in @($BTela, $BConfig, $BPrAntes, $BPrDepois, $BPrCheia, $BDiAntes, $BDiDepois, $BAcao, $BConfigX, $BPadrao)) { $b.Background = $pedra }
    $BRecado.Background = Pincel 'stone' 48 18 3
    $BMoldura.Background = Pincel 'spruce_planks' 64 7 6
    $pl = Pincel $PLACA_TEX[$v.placa] 64 7 3
    $escura = $PLACA_ESCURA.ContainsKey($v.placa)
    for ($i = 0; $i -lt 3; $i++) {
        $script:BDICA[$i].Background = $pl
        if ($escura) { $script:TDICA[$i].Foreground = Cor '#FFFFFF'; $script:TDICA[$i].Effect = $w.FindResource('Sombra') }
        else { $script:TDICA[$i].Foreground = Cor '#000000'; $script:TDICA[$i].Effect = $null }
        Letra $script:TDICA[$i] 700 1.0
    }
    Letra $TBase 800 1.2; Letra $TStatus 800 1.5; Letra $TDetalhe 600 1.0
    Letra $TRecadoRot 800 0.95; Letra $TRecado 700 1.0
    Letra $TPrintsTit 800 1.15; Letra $TDicasTit 800 1.15; Letra $TPrintPag 700 1.0; Letra $TDicaPag 700 1.0
    Letra $TPrintData 700 0.92; Letra $TPrintVazio 700 1.0
    Letra $TAcao 800 1.3; Letra $LMesmo 700 0.95
    Titulo $TTitulo 24; Titulo $TJogar 24
    PorFonte $TCanto (Fonte 'nunito' 300) 11
    PorFonte $TConfigTit (Fonte 'press' 400) 14
    PorFonte $TPadrao (Fonte 'nunito' 800) 14
    $script:porPag = 3; if ($v.tam -eq 'g') { $script:porPag = 2 }
}
function MontarConfig {
    $UGrupos.Children.Clear()
    foreach ($k in $OPCOES.Keys) {
        $g = $OPCOES[$k]
        $sp = New-Object Windows.Controls.StackPanel
        $sp.Margin = New-Object Windows.Thickness(0, 0, 18, 12)
        $tl = New-Object Windows.Controls.TextBlock
        $tl.Text = $g.nome; $tl.Foreground = Cor '#3F3F3F'; $tl.Margin = New-Object Windows.Thickness(0, 0, 0, 5)
        PorFonte $tl (Fonte 'nunito' 800) 14
        $wp = New-Object Windows.Controls.WrapPanel
        foreach ($o in $g.ops) {
            $val = $o[0]; $rot = $o[1]
            $sel = ($script:VIS[$k] -eq $val)
            $b = New-Object Windows.Controls.Button
            $b.Style = $w.FindResource('Plano'); $b.Tag = ($k + '|' + $val); $b.Margin = New-Object Windows.Thickness(0, 0, 8, 4)
            $col = New-Object Windows.Controls.StackPanel
            $sw = New-Object Windows.Controls.Border
            $sw.BorderThickness = New-Object Windows.Thickness(3)
            if ($sel) { $sw.BorderBrush = Cor '#FFFFFF' } else { $sw.BorderBrush = Cor '#000000' }
            $sw.HorizontalAlignment = 'Center'
            if ($g.tipo -eq 'textura') {
                $tx = $null
                if ($k -eq 'fundo') { $tx = $FUNDO_TEX[$val] } elseif ($k -eq 'topo') { $tx = $TOPO_TEX[$val][0] } else { $tx = $PLACA_TEX[$val] }
                $sw.Width = 52; $sw.Height = 52; $sw.Background = Pincel $tx 48 2 2
            } else {
                $sw.MinWidth = 52; $sw.Height = 40; $sw.Background = Cor '#8B8B8B'; $sw.Padding = New-Object Windows.Thickness(8, 0, 8, 0)
                $aa = New-Object Windows.Controls.TextBlock
                $aa.Text = 'Aa'; $aa.Foreground = Cor '#FFFFFF'; $aa.HorizontalAlignment = 'Center'; $aa.VerticalAlignment = 'Center'
                if ($k -eq 'texto') { $px = 15; if ($val -eq 'vt323') { $px = 20 }; PorFonte $aa (Fonte $val 700) $px }
                elseif ($k -eq 'titulo') {
                    if ($val -eq 'press') { PorFonte $aa (Fonte 'press' 400) 11 } elseif ($val -eq 'vt323') { PorFonte $aa (Fonte 'vt323' 400) 20 } else { PorFonte $aa (Fonte $script:VIS.texto 800) 15 }
                } else { PorFonte $aa (Fonte 'nunito' 800) (@{ p = 12; m = 15; g = 19 }[$val]) }
                $sw.Child = $aa
            }
            $cap = New-Object Windows.Controls.TextBlock
            $cap.Text = $rot; $cap.Foreground = Cor '#3F3F3F'; $cap.HorizontalAlignment = 'Center'; $cap.TextAlignment = 'Center'
            $cap.Margin = New-Object Windows.Thickness(0, 3, 0, 0)
            PorFonte $cap (Fonte 'nunito' 700) 12
            [void]$col.Children.Add($sw); [void]$col.Children.Add($cap)
            if ($PADRAO[$k] -eq $val) {
                $pd = New-Object Windows.Controls.TextBlock
                $pd.Text = '(padrão)'; $pd.Foreground = Cor '#5A5A5A'; $pd.HorizontalAlignment = 'Center'
                PorFonte $pd (Fonte 'nunito' 600) 11
                [void]$col.Children.Add($pd)
            }
            $b.Content = $col
            $b.Add_Click({ param($s, $e) $p = ([string]$s.Tag).Split('|'); Escolher $p[0] $p[1] })
            [void]$wp.Children.Add($b)
        }
        [void]$sp.Children.Add($tl); [void]$sp.Children.Add($wp)
        [void]$UGrupos.Children.Add($sp)
    }
}
function Escolher([string]$k, [string]$v) {
    $script:VIS[$k] = $v
    if ($PADRAO[$k] -eq $v) { CfgApagar ('v18_' + $k) } else { CfgGravar ('v18_' + $k) $v }
    AplicarVisual; MontarConfig; MostrarDicas
}

# ---------------- tela cheia do launcher (R#255: abre sempre em janela; botao no topo ou F11) ----------------
$script:cheio = $false
function FundoJanela {
    # fora da area 860x620 (so aparece em tela cheia): o mesmo fundo, na mesma escala e alinhado com o de dentro
    if (-not $script:cheio) { $w.Background = Cor '#000000'; return }
    $k = $FUNDO_TEX[$script:VIS.fundo]
    if (-not $script:IMG.ContainsKey($k)) { $w.Background = Cor $TEX[$k]; return }
    $larg = $w.ActualWidth; $alt = $w.ActualHeight
    if ($larg -le 0 -or $alt -le 0) { return }
    $s = [Math]::Min($larg / 860, $alt / 620); $tile = 48 * $s
    $ox = ($larg - 860 * $s) / 2; $oy = ($alt - 620 * $s) / 2
    $x0 = $ox - [Math]::Ceiling($ox / $tile) * $tile; $y0 = $oy - [Math]::Ceiling($oy / $tile) * $tile
    $cols = [int][Math]::Ceiling(($larg - $x0) / $tile) + 1; $rows = [int][Math]::Ceiling(($alt - $y0) / $tile) + 1
    try { $w.Background = PincelDe (Mosaico @($k) $cols $rows) $tile $x0 $y0 } catch { $w.Background = Cor $TEX[$k] }
}
function AlternarTela {
    if (-not $script:cheio) {
        $script:cheio = $true
        $w.SizeToContent = [Windows.SizeToContent]::Manual
        $w.WindowStyle = [Windows.WindowStyle]::None
        $w.ResizeMode = [Windows.ResizeMode]::NoResize
        $w.WindowState = [Windows.WindowState]::Maximized
        $PTelaAbrir.Visibility = 'Collapsed'; $PTelaSair.Visibility = 'Visible'; $BTela.ToolTip = 'Voltar pra janela (F11 ou Esc)'
        Pump; FundoJanela
    } else {
        $script:cheio = $false
        $w.WindowState = [Windows.WindowState]::Normal
        $w.WindowStyle = [Windows.WindowStyle]::SingleBorderWindow
        $w.ResizeMode = [Windows.ResizeMode]::CanMinimize
        $w.SizeToContent = [Windows.SizeToContent]::WidthAndHeight
        $PTelaAbrir.Visibility = 'Visible'; $PTelaSair.Visibility = 'Collapsed'; $BTela.ToolTip = 'Tela cheia (F11)'
        FundoJanela; Pump
        $wa = [Windows.SystemParameters]::WorkArea
        $w.Left = $wa.Left + [Math]::Max(0, ($wa.Width - $w.ActualWidth) / 2)
        $w.Top = $wa.Top + [Math]::Max(0, ($wa.Height - $w.ActualHeight) / 2)
    }
}

# ---------------- prints ----------------
$script:prints = @(); $script:pi = 0
function ListarPrints {
    $script:prints = @()
    if (Test-Path -LiteralPath $SHOTS) {
        $script:prints = @(Get-ChildItem -LiteralPath $SHOTS -File -ErrorAction SilentlyContinue |
                           Where-Object { $_.Extension -match '^\.(png|jpe?g)$' } | Sort-Object LastWriteTime -Descending)
    }
}
function DataDaPrint($f) {
    $m = [regex]::Match($f.Name, '^(\d{4})-(\d{2})-(\d{2})_(\d{2})\.(\d{2})')
    if ($m.Success) {
        $d = $m.Groups[3].Value + '/' + $m.Groups[2].Value
        if ($m.Groups[1].Value -ne (Get-Date).Year.ToString()) { $d += '/' + $m.Groups[1].Value }
        return ($d + ' · ' + $m.Groups[4].Value + ':' + $m.Groups[5].Value)
    }
    return $f.LastWriteTime.ToString('dd/MM · HH:mm')
}
function Imagem([string]$p, [int]$larg) {
    $bi = New-Object Windows.Media.Imaging.BitmapImage
    $bi.BeginInit()
    $bi.CacheOption = [Windows.Media.Imaging.BitmapCacheOption]::OnLoad
    $bi.CreateOptions = [Windows.Media.Imaging.BitmapCreateOptions]::IgnoreColorProfile
    $bi.UriSource = New-Object Uri($p)
    if ($larg -gt 0) { $bi.DecodePixelWidth = $larg }
    $bi.EndInit(); $bi.Freeze()
    return $bi
}
function MostrarPrint {
    $n = $script:prints.Count
    if ($n -eq 0) {
        $IPrint.Source = $null; $TPrintVazio.Visibility = 'Visible'; $TPrintData.Text = ''; $TPrintPag.Text = ''
        foreach ($b in @($BPrAntes, $BPrDepois, $BPrCheia)) { $b.IsEnabled = $false }
        return
    }
    $script:pi = (($script:pi % $n) + $n) % $n
    $TPrintVazio.Visibility = 'Collapsed'
    try { $IPrint.Source = Imagem $script:prints[$script:pi].FullName 960 } catch { $IPrint.Source = $null; Write-Host ('PRINT: ' + $_.Exception.Message) }
    $TPrintData.Text = DataDaPrint $script:prints[$script:pi]
    $TPrintPag.Text = ($script:pi + 1).ToString() + '/' + $n
}
function TelaCheia {
    if ($script:prints.Count -eq 0) { return }
    [xml]$fx = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Prints" WindowStyle="None" WindowState="Maximized" ResizeMode="NoResize" Background="Black" ShowInTaskbar="False">
  <Window.Resources>
$ESTILOS
  </Window.Resources>
  <Grid>
    <Image x:Name="IG" Stretch="Uniform" RenderOptions.BitmapScalingMode="HighQuality"/>
    <Border VerticalAlignment="Bottom" HorizontalAlignment="Left" Background="#99000000" Padding="18,8" Margin="20,0,0,20">
      <TextBlock x:Name="TGData" Foreground="White"/>
    </Border>
    <Button x:Name="BGX" Style="{StaticResource MC}" Width="56" Height="56" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,20,20,0" ToolTip="Fechar (Esc)">
      <Viewbox Width="20" Height="20" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M3,3 L13,13 M13,3 L3,13"/></Grid></Viewbox></Button>
    <Button x:Name="BGA" Style="{StaticResource MC}" Width="56" Height="56" HorizontalAlignment="Left" VerticalAlignment="Center" Margin="20,0,0,0" ToolTip="Anterior (seta)">
      <Viewbox Width="22" Height="22" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M10,3 L5,8 L10,13"/></Grid></Viewbox></Button>
    <Button x:Name="BGD" Style="{StaticResource MC}" Width="56" Height="56" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,20,0" ToolTip="Próxima (seta)">
      <Viewbox Width="22" Height="22" HorizontalAlignment="Center" VerticalAlignment="Center" Effect="{StaticResource Sombra}"><Grid Width="16" Height="16"><Path Stroke="White" StrokeThickness="2" StrokeStartLineCap="Square" StrokeEndLineCap="Square" StrokeLineJoin="Miter" Data="M6,3 L11,8 L6,13"/></Grid></Viewbox></Button>
  </Grid>
</Window>
"@
    $script:fw = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $fx))
    $script:fw.Owner = $w
    $script:fwIG = $script:fw.FindName('IG'); $script:fwData = $script:fw.FindName('TGData')
    $pedra = Pincel 'stone' 48 2 2
    foreach ($nb in @('BGX', 'BGA', 'BGD')) { $script:fw.FindName($nb).Background = $pedra }
    PorFonte $script:fwData (Fonte $script:VIS.texto 700) 18
    $script:fw.FindName('BGX').Add_Click({ $script:fw.Close() })
    $script:fw.FindName('BGA').Add_Click({ $script:pi--; FwMostrar })
    $script:fw.FindName('BGD').Add_Click({ $script:pi++; FwMostrar })
    $script:fw.Add_KeyDown({ param($s, $e)
        if ($e.Key -eq [Windows.Input.Key]::Escape) { $script:fw.Close() }
        elseif ($e.Key -eq [Windows.Input.Key]::Left) { $script:pi--; FwMostrar }
        elseif ($e.Key -eq [Windows.Input.Key]::Right) { $script:pi++; FwMostrar }
    })
    $script:fwIG.Add_MouseLeftButtonUp({ $script:fw.Close() })
    FwMostrar
    [void]$script:fw.ShowDialog()
    MostrarPrint
}
function FwMostrar {
    $n = $script:prints.Count
    $script:pi = (($script:pi % $n) + $n) % $n
    try { $script:fwIG.Source = Imagem $script:prints[$script:pi].FullName 0 } catch { $script:fwIG.Source = $null; Write-Host ('PRINT: ' + $_.Exception.Message) }
    $script:fwData.Text = (DataDaPrint $script:prints[$script:pi]) + '    ' + ($script:pi + 1) + '/' + $n
}

# ---------------- dicas e recado na tela ----------------
$script:di = 0; $script:ri = 0; $script:porPag = 3
function MostrarDicas {
    $n = $script:DICAS.Count; $pp = $script:porPag
    $pags = [Math]::Max(1, [int][Math]::Ceiling($n / $pp))
    $script:di = (($script:di % $pags) + $pags) % $pags
    for ($i = 0; $i -lt 3; $i++) {
        $k = $script:di * $pp + $i
        if ($i -lt $pp -and $k -lt $n) { $script:TDICA[$i].Text = $script:DICAS[$k]; $script:BDICA[$i].Visibility = 'Visible' }
        else { $script:BDICA[$i].Visibility = 'Collapsed' }
    }
    if ($n -gt 0) { $TDicaPag.Text = ($script:di + 1).ToString() + '/' + $pags } else { $TDicaPag.Text = '' }
}
function MostrarRecado {
    $n = $script:RECADOS.Count
    if ($n -eq 0) { $BRecado.Visibility = 'Collapsed'; return }
    $script:ri = (($script:ri % $n) + $n) % $n
    $TRecado.Text = $script:RECADOS[$script:ri]
    $BRecado.Visibility = 'Visible'
}

# ---------------- SKLauncher (R#253/JOG: abrir igual ao atalho dele) ----------------
function CandidatosSK {
    $l = @()
    $esc = CfgLer 'sklauncher_escolhido'
    if ($esc -and (Test-Path -LiteralPath $esc)) { $l += $esc }
    $ad = Join-Path $env:APPDATA 'sklauncher'
    foreach ($nm in @('SKlauncher.jar', 'sklauncher.jar', 'SKlauncher.exe')) { $p = Join-Path $ad $nm; if (Test-Path -LiteralPath $p) { $l += $p; break } }
    $c = CfgLer 'sklauncher'
    if ($c -and (Test-Path -LiteralPath $c)) { $l += $c }
    foreach ($d in @($MC, [Environment]::GetFolderPath('Desktop'), (Join-Path $env:USERPROFILE 'Downloads'), $env:LOCALAPPDATA)) {
        if (-not $d -or -not (Test-Path -LiteralPath $d)) { continue }
        $x = Get-ChildItem -LiteralPath $d -Filter 'sklauncher*' -ErrorAction SilentlyContinue |
             Where-Object { $_.Extension -eq '.jar' -or $_.Extension -eq '.exe' } | Select-Object -First 1
        if ($x) { $l += $x.FullName }
    }
    $u = @(); foreach ($x in $l) { if ($u -notcontains $x) { $u += $x } }
    return ,$u
}
function JavaPara([string]$jar) {
    $dir = Split-Path -Parent $jar
    foreach ($j in @((Join-Path $dir 'jre\bin\javaw.exe'), (Join-Path $env:APPDATA 'sklauncher\jre\bin\javaw.exe'))) {
        if (Test-Path -LiteralPath $j) { return $j }
    }
    $rt = Join-Path $MC 'runtime'
    if (Test-Path -LiteralPath $rt) {
        $jw = Get-ChildItem -LiteralPath $rt -Filter 'javaw.exe' -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($jw) { return $jw.FullName }
    }
    return 'javaw'
}
$script:abrindo = $false
function AbrirSK {
    if ($script:abrindo) { return }
    $script:abrindo = $true
    try {
        $BJogar.IsEnabled = $false
        if (SKAberto) { UI 'O SKLauncher já está aberto: é só jogar por ele.' -1; Espera 1500; $w.Close(); return }
        foreach ($arq in (CandidatosSK)) {
            UI 'Abrindo o SKLauncher…' -1
            try {
                $dir = Split-Path -Parent $arq
                if ($arq -match '(?i)\.jar$') {
                    $java = JavaPara $arq
                    Write-Host ('SKLAUNCHER: ' + $java + ' -jar ' + $arq)
                    $p = Start-Process -FilePath $java -ArgumentList @('-Xmx512M', '-jar', ('"' + $arq + '"')) -WorkingDirectory $dir -PassThru
                } else {
                    Write-Host ('SKLAUNCHER: ' + $arq)
                    $p = Start-Process -FilePath $arq -WorkingDirectory $dir -PassThru
                }
                Espera 5000
                if ((-not $p.HasExited) -or (SKAberto)) {
                    Write-Host ('SKLAUNCHER: abriu (' + $arq + ')')
                    CfgGravar 'sklauncher' $arq
                    try { Stop-Transcript | Out-Null } catch { }
                    $w.Close(); return
                }
                Write-Host ('SKLAUNCHER: fechou sozinho, codigo ' + $p.ExitCode + ' (' + $arq + ')')
            } catch { Write-Host ('SKLAUNCHER: ' + $arq + ' - ' + $_.Exception.Message) }
        }
        UI 'Não consegui abrir o SKLauncher.' -1 'Escolha o arquivo dele (SKlauncher.jar ou .exe) no botão, ou abra ele na mão desta vez.' 'vermelho'
        Estado 'sk'
    } finally { $script:abrindo = $false }
}
function EscolherSK {
    $dlg = New-Object Microsoft.Win32.OpenFileDialog
    $dlg.Title = 'Onde está o SKLauncher?'
    $dlg.Filter = 'SKLauncher (*.jar;*.exe)|*.jar;*.exe'
    $ad = Join-Path $env:APPDATA 'sklauncher'
    if (Test-Path -LiteralPath $ad) { $dlg.InitialDirectory = $ad }
    if ($dlg.ShowDialog($w) -eq $true) {
        CfgGravar 'sklauncher_escolhido' $dlg.FileName
        Write-Host ('SKLAUNCHER escolhido: ' + $dlg.FileName)
        Estado 'pronto'; AbrirSK
    }
}

# ---------------- o trabalho ----------------
function BaixarArquivo([string]$url, [string]$dest) {
    $wc = New-Object Net.WebClient
    $wc.Headers.Add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) launcher-brothers')
    $t = $wc.DownloadFileTaskAsync($url, $dest)
    $ini = [DateTime]::Now
    while (-not $t.IsCompleted) {
        Pump; Start-Sleep -Milliseconds 40
        if ($script:fechou -or ([DateTime]::Now - $ini).TotalSeconds -gt 900) { $wc.CancelAsync(); break }
    }
    while (-not $t.IsCompleted) { Start-Sleep -Milliseconds 20 }
    $wc.Dispose()
    if ($t.IsFaulted) { throw $t.Exception.GetBaseException() }
    if ($t.IsCanceled) { throw (New-Object Exception 'download cancelado') }
}
$script:ocupado = $false
function Trabalho {
    if ($script:ocupado) { return }
    $script:ocupado = $true
    try { TrabalhoDentro }
    catch {
        Write-Host ('ERRO GERAL: ' + $_.Exception.ToString())
        UI 'Deu um erro no launcher.' 100 'O botão abre a pasta com o log marcado: manda pro Matheus.' 'vermelho'
        Estado 'falta'
    } finally { $script:ocupado = $false }
}
function TrabalhoDentro {
    Estado 'trabalhando'; CorBarra 'verde'
    if (-not (Test-Path -LiteralPath $MODS)) {
        UI 'Não achei a pasta mods.' 0 'Este launcher tem que ficar dentro de .minecraft\_LAUNCHER.' 'vermelho'
        Estado 'parado'; return
    }

    # 1. launcher novo?  (salva os BYTES: nada de re-codificar o texto)
    UI 'Procurando launcher novo…' 2
    try {
        $rb = BaixarBytes 'launcher.ps1'
        $mv = [regex]::Match((TextoUtf8 $rb), '(?m)^\$VERSAO\s*=\s*(\d+)')
        if ($mv.Success -and [int]$mv.Groups[1].Value -gt $VERSAO) {
            [IO.File]::WriteAllBytes((Join-Path $AQUI 'launcher.new.ps1'), $rb)
            UI ('Launcher novo (v' + $mv.Groups[1].Value + ') baixado. Abrindo de novo…') 100
            Espera 1500
            Start-Process -FilePath (Join-Path $AQUI 'JOGAR.bat')
            $script:reiniciando = $true
            $w.Close(); return
        }
    } catch { Write-Host ('AUTO-UPDATE: ' + $_.Exception.Message) }

    # 2. jogo aberto: espera fechar (o servidor e o SKLauncher nao contam)
    if (JogoAberto) {
        UI 'Feche o Minecraft pra eu conferir os mods.' 0 'Assim que ele fechar, eu continuo sozinho.'
        Estado 'esperando'
        while (JogoAberto) { Espera 2000; if ($script:fechou) { return } }
        Estado 'trabalhando'
    }

    # 3. listas (local > GitHub > cache)
    UI 'Baixando a lista de mods…' 4
    $script:semNet = $false
    $lis = BaixarGuardado 'lista.txt'
    if ($lis.origem -ne 'github' -and $lis.origem -ne 'local') { $script:semNet = $true }
    Write-Host ('LISTA: ' + $(if ($lis.origem) { $lis.origem } else { 'embutida' }))
    if ($lis.txt) {
        $novoE = @(); $novoS = @()
        foreach ($l in ($lis.txt -split "`r?`n")) {
            $p = $l -split "`t"
            if ($p[0] -eq 'MOD' -and $p.Count -ge 6) { $novoE += @{ n = $p[1]; sha = $p[2].Trim().ToLower(); url = $p[5].Trim() } }
            elseif ($p[0] -eq 'SAI' -and $p.Count -ge 2) { $novoS += $p[1] }
            elseif ($p[0] -eq 'SERVIDOR' -and $p.Count -ge 2 -and $p[1].Trim() -ne '') { $script:SERVIDOR = $p[1].Trim() }
            elseif ($p[0] -eq 'XAERO' -and $p.Count -ge 2 -and $p[1].Trim() -ne '') { $script:XAERO_ID = $p[1].Trim() }
            elseif ($p[0] -eq 'BASE' -and $p.Count -ge 3 -and $p[2].Trim() -ne '') {
                if ($p[1].Trim() -eq (GrupoDoPerfil) -or ((GrupoDoPerfil) -eq '*' -and $p[1].Trim() -eq 'b')) { $script:TXTBASE = $p[2].Trim(); $TBase.Text = $script:TXTBASE }
            }
        }
        if ($novoE.Count -gt 0) { $script:ENTRAM = $novoE; $script:SAEM = $novoS }
    }
    $pk = BaixarGuardado 'perks.txt'
    if ($pk.txt) { $d = LerPerks $pk.txt; if ($d.Count -gt 0) { $script:DICAS = $d; MostrarDicas } }
    $mu = BaixarGuardado 'mural.txt'
    if ($mu.origem) { $script:RECADOS = LerMural $mu.txt; MostrarRecado }

    # 4. mods que sairam do pacote
    $rem = 0; $saiu = @(); $falhaNomes = @(); $falhas = 0; $motivos = @(); $chegou = @()
    foreach ($n in $script:SAEM) {
        $p = Join-Path $MODS $n
        if (-not (Test-Path -LiteralPath $p)) { continue }
        UI ('Tirando ' + (NomeDeArquivo $n) + ', que saiu do pacote…') 6
        $saiu += (ModNome $p)
        if (-not (Test-Path -LiteralPath $LIXO)) { New-Item -ItemType Directory -Path $LIXO -Force | Out-Null }
        Move-Item -LiteralPath $p -Destination (Join-Path $LIXO $n) -Force
        $rem++
    }

    # 5. mods que entram (so baixa o que falta ou mudou)
    UI 'Conferindo seus mods…' 8
    $faltando = @()
    foreach ($m in $script:ENTRAM) {
        $dest = Join-Path $MODS $m.n
        if ((Test-Path -LiteralPath $dest) -and ((Get-FileHash -LiteralPath $dest -Algorithm SHA1).Hash.ToLower() -eq $m.sha)) { continue }
        $faltando += $m
    }
    $i = 0
    foreach ($m in $faltando) {
        $i++
        if ($script:fechou) { return }
        $nome = NomeDeArquivo $m.n
        UI ('Baixando ' + $nome + ' (' + $i + ' de ' + $faltando.Count + ')…') (8 + [int](66 * ($i - 1) / [Math]::Max(1, $faltando.Count)))
        $tmp = Join-Path $env:TEMP ('_dl_' + [guid]::NewGuid().ToString() + '.part')
        $baixou = $false; $erro = ''
        foreach ($tentativa in 1, 2) {
            try { BaixarArquivo $m.url $tmp; $baixou = $true; break }
            catch { $erro = $_.Exception.Message; Write-Host ('FALHA DOWNLOAD [' + $m.n + '] tentativa ' + $tentativa + ': ' + $erro); Espera 2000 }
        }
        if (-not $baixou) { $falhas++; $falhaNomes += $nome; $motivos += ('baixar ' + $m.n + ': ' + $erro); continue }
        $hReal = (Get-FileHash -LiteralPath $tmp -Algorithm SHA1).Hash.ToLower()
        if ($hReal -ne $m.sha) {
            Write-Host ('FALHA HASH [' + $m.n + '] esperado=' + $m.sha + ' obtido=' + $hReal)
            Remove-Item -LiteralPath $tmp -Force; $falhas++; $falhaNomes += $nome; $motivos += ('hash de ' + $m.n); continue
        }
        $idNovo = ModId $tmp
        if ($idNovo) {
            foreach ($v in (Get-ChildItem -LiteralPath $MODS -Filter '*.jar')) {
                if ($v.Name -eq $m.n) { continue }
                if ((ModId $v.FullName) -ne $idNovo) { continue }
                if (-not (Test-Path -LiteralPath $LIXO)) { New-Item -ItemType Directory -Path $LIXO -Force | Out-Null }
                Write-Host ('TROCA: ' + $v.Name + ' -> ' + $m.n)
                Move-Item -LiteralPath $v.FullName -Destination (Join-Path $LIXO $v.Name) -Force
            }
        }
        Move-Item -LiteralPath $tmp -Destination (Join-Path $MODS $m.n) -Force
        $chegou += (ModNome (Join-Path $MODS $m.n))
        Write-Host ('BAIXADO: ' + $m.n)
    }

    # 6. Distant Horizons e mapa (igual ao v17)
    $SERVIDOR = $script:SERVIDOR; $XAERO_ID = $script:XAERO_ID
    UI 'Ajustando o Distant Horizons e o mapa pra você…' 80
    $dhRaiz = Join-Path $MC 'Distant_Horizons_server_data'
    $dhFix = 0
    if (Test-Path -LiteralPath $dhRaiz) {
        foreach ($srv in (Get-ChildItem -LiteralPath $dhRaiz -Directory)) {
            $dirs = Get-ChildItem -LiteralPath $srv.FullName -Directory
            foreach ($v in ($dirs | Where-Object { $_.Name -notlike '*@@*' })) {
                $sql = Get-ChildItem -LiteralPath $v.FullName -Filter 'DistantHorizons.sqlite*' -ErrorAction SilentlyContinue
                if (-not $sql) { continue }
                # R#135: o DH 2.x nomeava a pasta pelo campo "effects" do dimension_type,
                # e o 3.3 nomeia pelo caminho da dimensao. Coincide no overworld e no
                # nether, e NAO coincide em dimensao modada - por isso a mensagem de LOD
                # continuava aparecendo no Bumblezone e no Otherside mesmo depois de
                # rodar o launcher. Nomes conferidos nos dimension_type dos jars:
                #   deeperdarker:otherside_effects            -> @@otherside
                #   the_bumblezone:dimension_special_effects  -> @@the_bumblezone
                $alvo = $v.Name
                if ($DHNOMES.ContainsKey($v.Name)) { $alvo = $DHNOMES[$v.Name] }
                $par = $dirs | Where-Object { $_.Name -like ('*@@' + $alvo) } | Select-Object -First 1
                if (-not $par) { continue }
                if (Get-ChildItem -LiteralPath $par.FullName -Filter 'DistantHorizons.sqlite*' -ErrorAction SilentlyContinue) { continue }
                foreach ($f in $sql) { Move-Item -LiteralPath $f.FullName -Destination $par.FullName -Force }
                if (-not (Get-ChildItem -LiteralPath $v.FullName -Force)) { Remove-Item -LiteralPath $v.FullName -Force }
                $dhFix++
            }
        }
    }

    UI 'Ajustando o Distant Horizons e o mapa pra você…' 88
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

    # R#156: so roda se o lista.txt tiver a linha SERVIDOR (dia da mudanca pro host)
    # R#161 (v14): a linha SERVIDOR e do BROTHERS. A Say nao joga la -> nao mexe na lista nem no Xaero dela
    $srvMsg = ''
    if ($SERVIDOR -and $EU -ne 'say') {
        UI ('Apontando pro servidor novo: ' + $SERVIDOR + '…') 91
        try {
            foreach ($x in (ApontarServidor $SERVIDOR)) { Write-Host ('SERVIDOR: ' + $x) }
            $srvMsg = "  ·  servidor: $SERVIDOR"
        } catch {
            $erro = $_.Exception.Message
            Write-Host ('FALHA SERVIDOR: ' + $erro)
            $falhas++; $motivos += ('servidor novo: ' + $erro)
        }
    }

    UI 'Ajustando o Distant Horizons e o mapa pra você…' 94
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

    # 7. mods do pacote (os que NAO vem pelo lista.txt): so AVISA
    UI 'Conferindo os mods do pacote…' 96
    $esperados = @(); $faltam = @(); $sobram = @()
    try {
        $pac = BaixarGuardado 'pacote.txt'
        if ($pac.txt) {
            $grupo = 'b'
            if ($EU -eq 'say') { $grupo = 's' }
            if ($EU -eq 'matheus') { $grupo = '' }
            foreach ($l in ($pac.txt -split "`r?`n")) {
                $p = $l -split "`t"
                if ($p[0] -ne 'PAC' -or $p.Count -lt 3) { continue }
                if ($grupo -eq '' -or (($p[1] -split ',') -contains $grupo)) { $esperados += $p[2].Trim() }
            }
        }
    } catch { Write-Host ('PACOTE: nao conferido - ' + $_.Exception.Message) }
    $tem = @{}
    foreach ($v in (Get-ChildItem -LiteralPath $MODS -Filter '*.jar')) { $tem[$v.Name] = $true }
    $esp = @{}
    foreach ($e in $esperados) { $esp[$e] = $true }
    foreach ($m in $script:ENTRAM) { $esp[$m.n] = $true }
    $faltam = @($esperados | Where-Object { -not $tem.ContainsKey($_) })
    $sobram = @($tem.Keys | Where-Object { -not $esp.ContainsKey($_) })
    foreach ($x in $faltam) { Write-Host ('PACOTE FALTANDO: ' + $x) }
    foreach ($x in $sobram) { Write-Host ('A MAIS (ok, so aviso): ' + $x) }
    $total = $esp.Count
    $noLugar = @($esp.Keys | Where-Object { $tem.ContainsKey($_) }).Count
    Write-Host ('RESUMO: no lugar ' + $noLugar + '/' + $total + ' · baixados ' + $chegou.Count + ' · removidos ' + $rem + ' · DH consertado ' + $dhFix + ' · a mais ' + $sobram.Count + ' · falhas ' + $falhas + $srvMsg)
    foreach ($x in $motivos) { Write-Host ('MOTIVO: ' + $x) }

    # 8. o que a pessoa le
    $pctOk = 100; if ($total -gt 0) { $pctOk = 100 * $noLugar / $total }
    if ($falhaNomes.Count -gt 0) {
        $q = 'mods'; if ($falhaNomes.Count -eq 1) { $q = 'mod' }
        UI ('Não consegui baixar ' + $falhaNomes.Count + ' ' + $q + ': ' + (Juntar $falhaNomes) + '.') $pctOk 'Confere a internet e tenta de novo. Se repetir, manda o log pro Matheus.' 'vermelho'
        Estado 'falha'
    } elseif ($faltam.Count -gt 0) {
        $nomes = @($faltam | ForEach-Object { NomeDeArquivo $_ })
        if ($faltam.Count -eq 1) { $frase = 'Falta 1 mod do pacote: ' } else { $frase = 'Faltam ' + $faltam.Count + ' mods do pacote: ' }
        UI ($frase + (Juntar $nomes) + '.') $pctOk 'Eles vêm no zip do pacote. O botão abre a pasta com o log marcado: manda pro Matheus.' 'vermelho'
        Estado 'falta'
    } elseif ($falhas -gt 0) {
        UI 'Deu erro ao ajustar o jogo.' 100 'O botão abre a pasta com o log marcado: manda pro Matheus.' 'vermelho'
        Estado 'falta'
    } elseif ($script:semNet) {
        UI 'Sem internet: conferi com a última lista guardada.' 100 ([string]$noLugar + ' de ' + $total + ' no lugar. Se saiu mod novo hoje, você só pega com internet.') 'amarelo'
        Estado 'pronto'
    } else {
        $det = ''
        if ($chegou.Count -gt 0) { $det = 'Chegou agora: ' + (Juntar $chegou) + '.' }
        if ($saiu.Count -gt 0) { if ($det) { $det += '   ' }; $det += 'Saiu: ' + (Juntar $saiu) + '.' }
        UI ([string]$noLugar + ' de ' + $total + ' mods no lugar. Pode jogar!') 100 $det 'verde'
        Estado 'pronto'
    }
}

# ---------------- montar a tela ----------------
$script:fechou = $false; $script:reiniciando = $false; $script:acao = ''
$script:ENTRAM = $ENTRAM; $script:SAEM = $SAEM; $script:SERVIDOR = $SERVIDOR; $script:XAERO_ID = $XAERO_ID
AplicarVisual
Barra 0; CorBarra 'verde'
$TBase.Text = $script:TXTBASE
$TCanto.Text = $EU + ' · launcher v' + $VERSAO
ListarPrints; MostrarPrint
MostrarDicas; MostrarRecado
Estado 'trabalhando'

$relogioDicas = New-Object Windows.Threading.DispatcherTimer
$relogioDicas.Interval = [TimeSpan]::FromSeconds(15)
$relogioDicas.Add_Tick({ $script:di++; MostrarDicas })
$relogioDicas.Start()
$relogioRecado = New-Object Windows.Threading.DispatcherTimer
$relogioRecado.Interval = [TimeSpan]::FromSeconds(8)
$relogioRecado.Add_Tick({ if ($script:RECADOS.Count -gt 1) { $script:ri++; MostrarRecado } })
$relogioRecado.Start()

$BDiAntes.Add_Click({ $script:di--; MostrarDicas; $relogioDicas.Stop(); $relogioDicas.Start() })
$BDiDepois.Add_Click({ $script:di++; MostrarDicas; $relogioDicas.Stop(); $relogioDicas.Start() })
$BPrAntes.Add_Click({ $script:pi--; MostrarPrint })
$BPrDepois.Add_Click({ $script:pi++; MostrarPrint })
$BPrCheia.Add_Click({ TelaCheia })
$BFoto.Add_MouseLeftButtonUp({ TelaCheia })
$BConfig.Add_Click({ MontarConfig; $GConfig.Visibility = 'Visible' })
$BConfigX.Add_Click({ $GConfig.Visibility = 'Collapsed' })
$GConfig.Add_MouseLeftButtonUp({ param($s, $e) if ($e.OriginalSource -eq $GConfig) { $GConfig.Visibility = 'Collapsed' } })
$BPadrao.Add_Click({
    foreach ($k in @($PADRAO.Keys)) { $script:VIS[$k] = $PADRAO[$k]; CfgApagar ('v18_' + $k) }
    AplicarVisual; MontarConfig; MostrarDicas
})
$BJogar.Add_Click({ AbrirSK })
$LMesmo.Add_MouseLeftButtonUp({ AbrirSK })
$BAcao.Add_Click({
    switch ($script:acao) {
        'tentar' { Trabalho }
        'log'    { try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,"' + $LOG + '"') } catch { } }
        'sk'     { EscolherSK }
    }
})
$w.Add_KeyDown({ param($s, $e)
    if ($e.Key -eq [Windows.Input.Key]::F11) { AlternarTela }
    elseif ($e.Key -eq [Windows.Input.Key]::Escape) {
        if ($GConfig.Visibility -eq 'Visible') { $GConfig.Visibility = 'Collapsed' } elseif ($script:cheio) { AlternarTela }
    }
})
$BTela.Add_Click({ AlternarTela })
$w.Add_SizeChanged({ if ($script:cheio) { FundoJanela } })
$w.Add_Closed({ $script:fechou = $true; $relogioDicas.Stop(); $relogioRecado.Stop() })
$w.Add_ContentRendered({ Trabalho })

try { [void]$w.ShowDialog() }
catch {
    Write-Host ('ERRO NA JANELA: ' + $_.Exception.ToString())
    [System.Windows.MessageBox]::Show(("O launcher v$VERSAO deu erro:`n`n" + $_.Exception.Message + "`n`nManda o arquivo _LAUNCHER\ultimo-run.log pro Matheus."), 'Launcher') | Out-Null
}
try { Stop-Transcript | Out-Null } catch { }
