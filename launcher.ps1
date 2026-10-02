
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

$VERSAO = 16   # sobe a cada mudanca minha; o auto-update compara com o do GitHub
# >>>>>>  O MATHEUS PREENCHE ESTA LINHA DEPOIS DE CRIAR O REPO  <<<<<<
$BASE_URL = 'https://raw.githubusercontent.com/mmcadora/mc-modpack/refs/heads/main'
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
$MURAL = @(
  @{ quem = 'todos'; txt = 'Rode este launcher ANTES de abrir o jogo, sempre. Com o Minecraft FECHADO.' }
  @{ quem = 'todos'; txt = 'NOVO: da pra teleportar clicando no mapa (M) ou num waypoint (U). Custa 3 niveis de XP, sempre.' }
  @{ quem = 'todos'; txt = 'Garrafa de XP: AGACHE (Shift) + clique direito com garrafa de vidro. Precisa ja ter 100 de XP bruto (nivel 8) senao nao acontece nada. Pra beber, SEGURA o clique direito.' }
  @{ quem = 'todos'; txt = 'Se o terreno de longe sumir, feche o jogo e rode este launcher - ele conserta sozinho.' }
  @{ quem = 'marcelo'; txt = 'Voce e op nivel 1: o teleporte da bussola funciona, comando nao. Se /gamemode negar, esta certo.' }
  @{ quem = 'marcelo'; txt = 'Testar: marcar uma waystone como Global e ver se o Matheus enxerga sem ter ido la.' }
  @{ quem = 'gabu'; txt = 'Voce tem 8 GB. Seu Distant Horizons ja vem ajustado pra sua maquina - nao mexa nas opcoes dele.' }
  @{ quem = 'gabu'; txt = 'O contador de FPS (fpsdisplay) agora e seu tambem. Tem tecla pra ligar e desligar.' }
  @{ quem = 'fabio'; txt = 'Voce ja esta no ops.json - o teleporte da bussola do Explorer''s Compass funciona agora.' }
  @{ quem = 'fabio'; txt = 'A waystone ''Tumulo do Fabio'' continua la, global.' }
  @{ quem = 'say'; txt = 'Confirma se o botao de teleporte no inventario funciona. A waystone ''base'' ja esta global.' }
  @{ quem = 'say'; txt = 'Seu mundo tem 169 pecas de Aquamirae: o labirinto de gelo e a Cornelia estao no SEU servidor.' }
  @{ quem = 'say'; txt = 'Seu PC nao tem placa dedicada. O Distant Horizons ja vem ajustado - nao mexa nas opcoes.' }
  @{ quem = 'say'; txt = 'O End e o Otherside do seu mundo ainda nao existem. Se quiser ir, o Matheus precisa gerar antes.' }
)
$PERKS = @(
  'Teleporte: clique direito no mapa (M) ou num waypoint (U). Custa 3 niveis, sempre - perto, longe ou entre dimensoes.'
  'CRIAR garrafa de XP: AGACHADO (Shift) + clique direito com garrafa de vidro na mao. Voce precisa JA TER 100 de XP bruto guardado (nivel 8 saindo do zero). Com menos que isso nao acontece NADA, sem mensagem nenhuma - nao esta bugado.'
  'Se a garrafa de XP der pouco nivel, e o MENDING: o XP conserta seu equipamento antes de virar experiencia. Pra guardar nivel, bebe DESEQUIPADO.'
  'BEBER garrafa de XP: SEGURA o clique direito, nao clica rapido. Leva 0,4s e devolve a garrafa de vidro vazia.'
  'Beber AGACHADO bebe a PILHA TODA de uma vez. Em pe, bebe uma garrafa so. Cuidado com 30 garrafas na mao.'
  'A garrafa devolve exatamente os 100 de XP que custou. Ela e um cofre de XP, nao uma fonte - serve pra nao perder XP ao morrer.'
  '100 de XP bruto e meio nivel no nivel 20 e um terco de nivel no nivel 50. Nao esta rendendo menos, e a curva do Minecraft que sobe.'
  'A garrafa de XP se BEBE, nao se joga no chao. Jogar no chao perde quase tudo.'
  'A garrafa de XP nao funciona se o meio coracao de dano te mataria. Cura primeiro.'
  'Morreu longe? Abre a bussola da morte e paga 3 niveis pra voltar. Fica 5s parado e chega com 15s de invencibilidade.'
  'Nao quer se teleportar pro tumulo? /graves list, clica no tumulo e usa FETCH: traz as coisas ate voce, de graca.'
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
  'A Cornelia (chefe do Aquamirae) vive no labirinto de gelo, no fundo do oceano frio.'
  'Barco de obsidiana anda na LAVA. Nao flutua em agua.'
  'O IPN tem 5 perfis de inventario com tecla rapida: Combate, Mineracao, Exploracao.'
  'Da pra travar um slot do inventario (IPN) e a ordenacao automatica pula ele.'
  'Tem lista de tarefas compartilhada no servidor (TeamTasks): o que um cria, os outros veem.'
  'Da pra juntar 3 pocoes numa Potion Blending Combiner.'
  '2 slabs iguais viram bloco cheio de volta (Deslabification).'
  'Se voce roda Chunky e voa ao mesmo tempo, o Distant Horizons deixa buracos no terreno.'
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
        # R#131: era $p[3] -- o sha1 esta na coluna 2. $p[3] vale "0", entao
        # TODO download baixava certo e era rejeitado na conferencia de hash.
        if ($p[0] -eq 'MOD' -and $p.Count -ge 6) { $novoE += @{ n = $p[1]; sha = $p[2].Trim().ToLower(); url = $p[5].Trim() } }
        elseif ($p[0] -eq 'SAI' -and $p.Count -ge 2) { $novoS += $p[1] }
        elseif ($p[0] -eq 'SERVIDOR' -and $p.Count -ge 2 -and $p[1].Trim() -ne '') { $SERVIDOR = $p[1].Trim() }
        elseif ($p[0] -eq 'XAERO' -and $p.Count -ge 2 -and $p[1].Trim() -ne '') { $XAERO_ID = $p[1].Trim() }
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
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
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
# R#131: o launcher.cfg do Matheus foi junto no zip e o Fabio rodou como
# "perfil: matheus" (e com o caminho do sklauncher dele). O cfg agora carimba
# o usuario do Windows; se nao for desta maquina, ele e descartado inteiro.
if ((Test-Path -LiteralPath $CFG) -and ((CfgLer 'usuario') -ne $env:USERNAME)) {
    Remove-Item -LiteralPath $CFG -Force -ErrorAction SilentlyContinue
}
$EU = CfgLer 'perfil'
if (-not $EU) {
    $op = '1'
    try {
        $op = [Microsoft.VisualBasic.Interaction]::InputBox(
            "Quem esta neste computador?`n`n1 = Marcelo (Tensei)`n2 = Gabu (Gabutre)`n3 = Fabio (fabium)`n4 = Say (sasayuyu)`n5 = Matheus (mmcadora)`n6 = Dahmer (dahmerdummer420)",
            'Primeira vez', '1')
    } catch {
        # se o InputBox nao existir nesta maquina, pergunta pelo console
        $op = Read-Host 'Quem e voce? 1=Marcelo 2=Gabu 3=Fabio 4=Say 5=Matheus 6=Dahmer'
    }
    switch ($op) { '1'{$EU='marcelo'} '2'{$EU='gabu'} '3'{$EU='fabio'} '4'{$EU='say'} '5'{$EU='matheus'} '6'{$EU='dahmer'} default{$EU='todos'} }
    CfgGravar 'perfil' $EU
    CfgGravar 'usuario' $env:USERNAME
}
$TSub.Text = "perfil: $EU   |   instalacao: $MC   |   lista: $origemLista   |   launcher v$VERSAO"
if ($SERVIDOR) { $TSub.Text += "   |   servidor: $SERVIDOR" }

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
    $rem = 0; $novos = 0; $falhas = 0; $motivos = @(); $erro = ''

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
        # R#131: antes o motivo da falha morria no catch e nao dava pra
        # diagnosticar de longe. Agora cada falha escreve a causa no log.
        $baixou = $false
        foreach ($tentativa in 1, 2) {
            try {
                Invoke-WebRequest -Uri $m.url -OutFile $tmp -UseBasicParsing -TimeoutSec 900 `
                    -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) launcher-brothers'
                $baixou = $true; break
            } catch {
                $erro = $_.Exception.Message
                Write-Host ("FALHA DOWNLOAD [" + $m.n + "] tentativa " + $tentativa + ": " + $erro)
                Start-Sleep -Seconds 2
            }
        }
        if (-not $baixou) { $falhas++; $motivos += ('baixar ' + $m.n + ': ' + $erro); continue }
        $hReal = (Get-FileHash -LiteralPath $tmp -Algorithm SHA1).Hash.ToLower()
        if ($hReal -ne $m.sha) {
            Write-Host ("FALHA HASH [" + $m.n + "] esperado=" + $m.sha + " obtido=" + $hReal)
            $motivos += ('hash de ' + $m.n)
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

    # R#156: so roda se o lista.txt tiver a linha SERVIDOR (dia da mudanca pro host)
    # R#161 (v14): a linha SERVIDOR e do BROTHERS. A Say nao joga la -> nao mexe na lista nem no Xaero dela
    $srvMsg = ''
    if ($SERVIDOR -and $EU -ne 'say') {
        UI ('Apontando pro servidor novo: ' + $SERVIDOR + ' ...') 91
        try {
            foreach ($x in (ApontarServidor $SERVIDOR)) { Write-Host ('SERVIDOR: ' + $x) }
            $srvMsg = "  ·  servidor: $SERVIDOR"
        } catch {
            $erro = $_.Exception.Message
            Write-Host ('FALHA SERVIDOR: ' + $erro)
            $falhas++; $motivos += ('servidor novo: ' + $erro)
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

    $msg = "Pronto. baixados: $novos  ·  removidos: $rem  ·  DH consertado: $dhFix" + $srvMsg
    if ($falhas -gt 0) { $msg += "  ·  $falhas falha(s): " + (($motivos | Select-Object -First 2) -join ' / ') }
    UI $msg 100
    if ($falhas -gt 0) {
        $TRodape.Text = "NAO ENTRE NO SERVIDOR. Manda o _LAUNCHER\ultimo-run.log pro Matheus."
    } else {
        $TRodape.Text = "log completo em _LAUNCHER\ultimo-run.log"
    }
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
