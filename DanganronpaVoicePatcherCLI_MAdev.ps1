# Danganronpa Voice Patcher 1.0 By MA_Dev
# CeLestIa EDITION 
 try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$ansiEnabled = $true
try {
    Add-Type -Name NativeConsole -Namespace Danganronpa -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("kernel32.dll")]
public static extern System.IntPtr GetStdHandle(int nStdHandle);
[System.Runtime.InteropServices.DllImport("kernel32.dll")]
public static extern bool GetConsoleMode(System.IntPtr hConsoleHandle, out uint lpMode);
[System.Runtime.InteropServices.DllImport("kernel32.dll")]
public static extern bool SetConsoleMode(System.IntPtr hConsoleHandle, uint dwMode);
'@ -ErrorAction Stop
    $stdOutHandle = [Danganronpa.NativeConsole]::GetStdHandle(-11)
    $mode = 0
    [Danganronpa.NativeConsole]::GetConsoleMode($stdOutHandle, [ref]$mode) | Out-Null
    [Danganronpa.NativeConsole]::SetConsoleMode($stdOutHandle, ($mode -bor 0x0004)) | Out-Null
} catch {
    $ansiEnabled = $false
}

$ESC = [char]27
function Rgb([int]$r, [int]$g, [int]$b) { if ($ansiEnabled) { "$ESC[38;2;${r};${g};${b}m" } else { '' } }

$RESET = if ($ansiEnabled) { "$ESC[0m" } else { '' }
$BOLD  = if ($ansiEnabled) { "$ESC[1m" } else { '' }
$DIM   = if ($ansiEnabled) { "$ESC[2m" } else { '' }

$AMBER = Rgb 217 162 86
$EN    = Rgb 134 167 217
$JP    = Rgb 224 128 100
$INK   = Rgb 236 231 218
$MIST  = Rgb 143 136 116
$OK    = Rgb 122 191 106
$ERRC  = Rgb 224 100 100

$CHECK = [char]0x2713
$CROSS = [char]0x2717

# Offsets de Danganronpa: Trigger Happy Havoc (PC/Steam)
$Global:FLAG_OFFSET     = 119680   # 0 = ingles, 1 = japones (Personaje de la prueba: Touko Fukawa)
$Global:SUM_FROM        = 800
$Global:SUM_TO          = 240784
$Global:CHECKSUM_OFFSET = 240784
$Global:MIN_SLOT_LENGTH = $Global:CHECKSUM_OFFSET + 1
$Global:DEFAULT_SAVE_PATH = Join-Path $env:USERPROFILE 'Documents\My Games\Danganronpa\savedata.vfs'
# Patrones (best effort) del nombre del proceso del juego
$Global:GAME_PROCESS_PATTERNS = @('*danganronpa*', '*trigger*happy*')
# W Touko

# ---------------- Strings de la UI (en / es / ja) ----------------
$Global:I18N = @{
    en = @{
        banner_subtitle     = "Voice language editor - Trigger Happy Havoc (CLI)"
        made_by             = "Made by"
        col_lang            = "LANGUAGE"
        col_size            = "SIZE"
        col_checksum        = "CHECKSUM"
        col_preview         = "PREVIEW"
        crc_ok              = "OK"
        crc_bad             = "INVALID"
        lang_en             = "English"
        lang_ja             = "Japanese"
        lang_unknown        = "Unknown"
        menu_slot           = "Slot: {0}"
        menu_current        = "(currently: {0})"
        menu_to_en          = "[1] Switch to English"
        menu_to_en_same     = "[1] Switch to English (already in this language)"
        menu_to_ja          = "[2] Switch to Japanese"
        menu_to_ja_same     = "[2] Switch to Japanese (already in this language)"
        menu_back           = "[0] Back"
        confirm_prompt      = "Confirm? (y/n)"
        yes_regex           = "^[yY]"
        game_running        = "The game seems to be running. Close it before continuing: it may overwrite the change when it exits."
        q_continue          = "Continue anyway?"
        checksum_warn       = "The current checksum of '{0}' does not match its contents (damaged save or different format)."
        q_recalc            = "Continue and recalculate the checksum anyway?"
        backup_ok           = "Backup verified: {0}"
        backup_fail         = "Could not create the backup. Nothing was modified."
        done                = "Done. '{0}' is now set to {1}. Change applied and verified."
        steam_note          = "If you use Steam Cloud, make sure it does not restore the old save when syncing."
        apply_fail          = "Failed to apply the change: {0}"
        backup_at           = "The original is backed up at: {0}"
        path_detected       = "Detected: {0}"
        path_prompt_detect  = "savedata.vfs file (press Enter to use the detected one)"
        path_prompt         = "Path to savedata.vfs"
        no_path             = "No path given, exiting."
        file_not_found      = "File not found: {0}"
        read_fail           = "Could not read the file (is the game open?): {0}"
        no_slots            = "No recognizable save slots found in this file."
        choose_slot         = "Choose a slot (number), L for language, or Q to quit"
        invalid_option      = "Invalid option."
        flag_unexpected_ui  = "Unexpected language value ({0}). This slot cannot be modified safely."
        choose_option       = "Choose an option"
        already_en          = "Already set to English."
        already_ja          = "Already set to Japanese."
        q_switch_en         = "Switch '{0}' to English?"
        q_switch_ja         = "Switch '{0}' to Japanese?"
        goodbye             = "Goodbye."
        err_backup_mismatch = "The backup does not match the original (different size or hash)."
        err_invalid_lang    = "Invalid language value: {0}"
        err_file_changed    = "The file has changed since it was loaded. Reload it and try again."
        err_flag_unexpected = "The language flag has an unexpected value ({0}). Nothing was modified."
        err_tmp_mismatch    = "The temp copy does not match what was expected."
        err_verify_restored = "Post-write verification failed; the backup has been restored."
        err_verify          = "Post-write verification failed."
    }
    es = @{
        banner_subtitle     = "Editor de idioma de voz - Trigger Happy Havoc (CLI)"
        made_by             = "Hecho por"
        col_lang            = "IDIOMA"
        col_size            = "TAMAÑO"
        col_checksum        = "CHECKSUM"
        col_preview         = "VISTA PREVIA"
        crc_ok              = "OK"
        crc_bad             = "INVÁLIDO"
        lang_en             = "Inglés"
        lang_ja             = "Japonés"
        lang_unknown        = "Desconocido"
        menu_slot           = "Slot: {0}"
        menu_current        = "(actualmente: {0})"
        menu_to_en          = "[1] Cambiar a Inglés"
        menu_to_en_same     = "[1] Cambiar a Inglés (ya está en este idioma)"
        menu_to_ja          = "[2] Cambiar a Japonés"
        menu_to_ja_same     = "[2] Cambiar a Japonés (ya está en este idioma)"
        menu_back           = "[0] Volver"
        confirm_prompt      = "¿Confirmar? (s/n)"
        yes_regex           = "^[sSyY]"
        game_running        = "Parece que el juego está abierto. Ciérralo antes de continuar: al salir puede sobrescribir el cambio."
        q_continue          = "¿Continuar de todos modos?"
        checksum_warn       = "El checksum actual de '{0}' no coincide con su contenido (guardado dañado o formato distinto)."
        q_recalc            = "¿Continuar y recalcular el checksum igualmente?"
        backup_ok           = "Backup verificado: {0}"
        backup_fail         = "No se pudo crear el backup. No se modificó nada."
        done                = "Listo. '{0}' ahora está en {1}. Cambio aplicado y verificado."
        steam_note          = "Si usas Steam Cloud, comprueba que no restaure el guardado anterior al sincronizar."
        apply_fail          = "Fallo al aplicar el cambio: {0}"
        backup_at           = "El original está respaldado en: {0}"
        path_detected       = "Detectado: {0}"
        path_prompt_detect  = "Archivo savedata.vfs (Enter para usar el detectado)"
        path_prompt         = "Ruta del archivo savedata.vfs"
        no_path             = "Sin ruta, saliendo."
        file_not_found      = "No se encontró el archivo: {0}"
        read_fail           = "No se pudo leer el archivo (¿el juego está abierto?): {0}"
        no_slots            = "No se encontraron slots de guardado reconocibles en este archivo."
        choose_slot         = "Elige un slot (número), L para idioma o Q para salir"
        invalid_option      = "Opción inválida."
        flag_unexpected_ui  = "Valor de idioma inesperado ({0}). Este slot no se puede modificar con seguridad."
        choose_option       = "Elige una opción"
        already_en          = "Ya está en Inglés."
        already_ja          = "Ya está en Japonés."
        q_switch_en         = "¿Cambiar '{0}' a Inglés?"
        q_switch_ja         = "¿Cambiar '{0}' a Japonés?"
        goodbye             = "Hasta luego."
        err_backup_mismatch = "El backup no coincide con el original (tamaño o hash distinto)."
        err_invalid_lang    = "Valor de idioma inválido: {0}"
        err_file_changed    = "El archivo ha cambiado desde que se cargó. Vuelve a cargarlo e inténtalo de nuevo."
        err_flag_unexpected = "El flag de idioma tiene un valor inesperado ({0}). No se modifica nada."
        err_tmp_mismatch    = "La copia temporal no coincide con lo esperado."
        err_verify_restored = "La verificación posterior falló; se ha restaurado el backup."
        err_verify          = "La verificación posterior falló."
    }
# El japonés gritando de felicidad porque el programa está traducido a su idioma XD
    ja = @{
        banner_subtitle     = "ボイス言語エディタ - Trigger Happy Havoc (CLI)"
        made_by             = "制作:"
        col_lang            = "言語"
        col_size            = "サイズ"
        col_checksum        = "チェックサム"
        col_preview         = "プレビュー"
        crc_ok              = "OK"
        crc_bad             = "無効"
        lang_en             = "英語"
        lang_ja             = "日本語"
        lang_unknown        = "不明"
        menu_slot           = "スロット: {0}"
        menu_current        = "（現在: {0}）"
        menu_to_en          = "[1] 英語に切り替え"
        menu_to_en_same     = "[1] 英語に切り替え（すでに英語です）"
        menu_to_ja          = "[2] 日本語に切り替え"
        menu_to_ja_same     = "[2] 日本語に切り替え（すでに日本語です）"
        menu_back           = "[0] 戻る"
        confirm_prompt      = "よろしいですか？ (y/n)"
        yes_regex           = "^[yY]"
        game_running        = "ゲームが起動している可能性があります。続行する前に閉じてください。終了時に変更が上書きされることがあります。"
        q_continue          = "それでも続行しますか？"
        checksum_warn       = "'{0}' の現在のチェックサムが内容と一致しません（セーブデータの破損、または形式が異なる可能性があります）。"
        q_recalc            = "それでも再計算して続行しますか？"
        backup_ok           = "バックアップを検証しました: {0}"
        backup_fail         = "バックアップを作成できませんでした。何も変更していません。"
        done                = "完了しました。'{0}' は {1} になりました。変更は適用・検証済みです。"
        steam_note          = "Steam クラウドを使用している場合は、同期時に以前のセーブデータが復元されないか確認してください。"
        apply_fail          = "変更の適用に失敗しました: {0}"
        backup_at           = "元のファイルのバックアップ: {0}"
        path_detected       = "検出されたパス: {0}"
        path_prompt_detect  = "savedata.vfs のパス（Enter で検出されたパスを使用）"
        path_prompt         = "savedata.vfs のパス"
        no_path             = "パスが指定されなかったため終了します。"
        file_not_found      = "ファイルが見つかりません: {0}"
        read_fail           = "ファイルを読み取れませんでした（ゲームが起動中の可能性があります）: {0}"
        no_slots            = "このファイルに認識できるセーブスロットが見つかりませんでした。"
        choose_slot         = "スロット番号を入力 / L: 言語 / Q: 終了"
        invalid_option      = "無効な選択です。"
        flag_unexpected_ui  = "言語値が想定外です（{0}）。このスロットは安全に変更できません。"
        choose_option       = "選択してください"
        already_en          = "すでに英語です。"
        already_ja          = "すでに日本語です。"
        q_switch_en         = "'{0}' を英語に切り替えますか？"
        q_switch_ja         = "'{0}' を日本語に切り替えますか？"
        goodbye             = "終了します。"
        err_backup_mismatch = "バックアップが元のファイルと一致しません（サイズまたはハッシュが異なります）。"
        err_invalid_lang    = "無効な言語値: {0}"
        err_file_changed    = "読み込み後にファイルが変更されました。再読み込みしてもう一度お試しください。"
        err_flag_unexpected = "言語フラグの値が想定外です（{0}）。何も変更していません。"
        err_tmp_mismatch    = "一時ファイルの内容が期待と一致しません。"
        err_verify_restored = "書き込み後の検証に失敗したため、バックアップを復元しました。"
        err_verify          = "書き込み後の検証に失敗しました。"
    }
}

$Global:CurrentLang = switch ((Get-UICulture).TwoLetterISOLanguageName) { 'es' { 'es' } 'ja' { 'ja' } default { 'en' } }

function T {
    param([string]$Key)
    $tbl = $Global:I18N[$Global:CurrentLang]
    if ($tbl -and $tbl.ContainsKey($Key)) { return $tbl[$Key] }
    return $Global:I18N['en'][$Key]
}

function Get-LangLabel {
    param($FlagVal)
    switch ([int]$FlagVal) {
        0 { return (T 'lang_en') }
        1 { return (T 'lang_ja') }
        default { return "$(T 'lang_unknown') ($FlagVal)" }
    }
}

function Parse-VfsEntries {
    param([byte[]]$Bytes)
    $entries = New-Object System.Collections.Generic.List[object]
    $offset = 0
    $len = $Bytes.Length
    while ($offset + 8 -le $len) {
        $nameLen = [System.BitConverter]::ToUInt32($Bytes, $offset)
        if ($nameLen -eq 0 -or $nameLen -gt 260 -or ($offset + 4 + $nameLen + 4) -gt $len) { break }
        $name = [System.Text.Encoding]::ASCII.GetString($Bytes, $offset + 4, [int]$nameLen)
        if ($name -notmatch '^[\x20-\x7E]+$') { break }
        $dataLenOffset = $offset + 4 + $nameLen
        $dataLen = [System.BitConverter]::ToUInt32($Bytes, $dataLenOffset)
        $dataOffset = $dataLenOffset + 4
        if ($dataOffset + $dataLen -gt $len) { break }
        $entries.Add([PSCustomObject]@{
            Name   = $name
            Offset = $dataOffset
            Length = $dataLen
        })
        $offset = $dataOffset + $dataLen
    }
    return $entries
}

function Get-HeaderPreview {
    param([byte[]]$Bytes, [int]$Offset, [int]$PreviewLen = 200)
    $end = [Math]::Min($Offset + $PreviewLen, $Bytes.Length)
    $chars = for ($i = $Offset; $i -lt $end; $i++) {
        $b = $Bytes[$i]
        if ($b -ge 32 -and $b -le 126) { [char]$b } else { ' ' }
    }
    (( -join $chars) -replace '\s+', ' ').Trim()
}

function Get-SaveSlots {
    param([byte[]]$Bytes)
    $entries = Parse-VfsEntries -Bytes $Bytes
    $slots = @()
    foreach ($e in $entries) {
        if ($e.Name -match '^data\d+\.bin$' -and $e.Length -ge $Global:MIN_SLOT_LENGTH) {
            $flagVal = $Bytes[$e.Offset + $Global:FLAG_OFFSET]
            $lang = switch ($flagVal) {
                0 { 'Ingles' }
                1 { 'Japones' }
                default { "Desconocido ($flagVal)" }
            }
            $slots += [PSCustomObject]@{
                Name    = $e.Name
                Offset  = $e.Offset
                Length  = $e.Length
                FlagVal = $flagVal
                Lang    = $lang
                Preview = Get-HeaderPreview -Bytes $Bytes -Offset $e.Offset
                ChecksumOk = Test-SlotChecksum -Bytes $Bytes -SlotOffset $e.Offset
            }
        }
    }
    return $slots
}

function Get-SlotChecksum {
    param([byte[]]$Bytes, [int]$SlotOffset)
    [long]$sum = 0
    $from = $SlotOffset + $Global:SUM_FROM
    $to   = $SlotOffset + $Global:SUM_TO
    for ($i = $from; $i -lt $to; $i++) {
        $sum += $Bytes[$i]
    }
    return [int]($sum % 256)
}

function Set-ChecksumForSlot {
    param([byte[]]$Bytes, [int]$SlotOffset)
    $sum = Get-SlotChecksum -Bytes $Bytes -SlotOffset $SlotOffset
    $Bytes[$SlotOffset + $Global:CHECKSUM_OFFSET] = [byte]$sum
    return $sum
}

function Test-SlotChecksum {
    param([byte[]]$Bytes, [int]$SlotOffset)
    $expected = Get-SlotChecksum -Bytes $Bytes -SlotOffset $SlotOffset
    return ($Bytes[$SlotOffset + $Global:CHECKSUM_OFFSET] -eq $expected)
}

function Get-BytesHash {
    param([byte[]]$Bytes)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { return [System.BitConverter]::ToString($sha.ComputeHash($Bytes)) } finally { $sha.Dispose() }
}

function Test-GameRunning {
    foreach ($pat in $Global:GAME_PROCESS_PATTERNS) {
        if (@(Get-Process -Name $pat -ErrorAction SilentlyContinue).Count -gt 0) { return $true }
    }
    return $false
}

function Backup-SaveFile {
    param([string]$Path)
    $backupPath = "$Path.bak_$(Get-Date -Format yyyyMMdd_HHmmss_fff)"
    Copy-Item -LiteralPath $Path -Destination $backupPath -ErrorAction Stop
    $backupOk = $false
    try {
        $src = [System.IO.File]::ReadAllBytes($Path)
        $dst = [System.IO.File]::ReadAllBytes($backupPath)
        $backupOk = ($src.Length -eq $dst.Length) -and ((Get-BytesHash -Bytes $src) -eq (Get-BytesHash -Bytes $dst))
    } catch {
        $backupOk = $false
    }
    if (-not $backupOk) {
        Remove-Item -LiteralPath $backupPath -Force -ErrorAction SilentlyContinue
        throw (T 'err_backup_mismatch')
    }
    return $backupPath
}

function Set-SlotVoiceLanguage {
    param([string]$Path, [string]$SlotName, [int]$SlotOffset, [int]$TargetValue, [string]$BackupPath = '')
    if ($TargetValue -ne 0 -and $TargetValue -ne 1) { throw ((T 'err_invalid_lang') -f $TargetValue) }
    $bytes = [System.IO.File]::ReadAllBytes($Path)

    # El archivo pudo cambiar desde que se cargo (el juego, Steam Cloud...): se revalida el slot
    $entry = Parse-VfsEntries -Bytes $bytes | Where-Object { $_.Name -eq $SlotName } | Select-Object -First 1
    if (-not $entry -or [int]$entry.Offset -ne $SlotOffset -or $entry.Length -lt $Global:MIN_SLOT_LENGTH) {
        throw (T 'err_file_changed')
    }
    $current = $bytes[$SlotOffset + $Global:FLAG_OFFSET]
    if ($current -ne 0 -and $current -ne 1) {
        throw ((T 'err_flag_unexpected') -f $current)
    }

    $bytes[$SlotOffset + $Global:FLAG_OFFSET] = [byte]$TargetValue
    $sum = Set-ChecksumForSlot -Bytes $bytes -SlotOffset $SlotOffset
    $expectedHash = Get-BytesHash -Bytes $bytes

    $tmp = "$Path.tmp_$PID"
    try {
        [System.IO.File]::WriteAllBytes($tmp, $bytes)
        $written = [System.IO.File]::ReadAllBytes($tmp)
        if ((Get-BytesHash -Bytes $written) -ne $expectedHash) { throw (T 'err_tmp_mismatch') }
        [System.IO.File]::Replace($tmp, $Path, [NullString]::Value)
    } catch {
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
        throw
    }

    # Verificacion posterior: el archivo final debe ser exactamente lo que se pretendia escribir
    $final = [System.IO.File]::ReadAllBytes($Path)
    if ((Get-BytesHash -Bytes $final) -ne $expectedHash) {
        if ($BackupPath -and (Test-Path -LiteralPath $BackupPath)) {
            Copy-Item -LiteralPath $BackupPath -Destination $Path -Force
            throw (T 'err_verify_restored')
        }
        throw (T 'err_verify')
    }
    return $sum
}

# Ancho en celdas de consola: los caracteres CJK ocupan 2 columnas
function Get-CellWidth {
    param([string]$Text)
    $w = 0
    foreach ($ch in $Text.ToCharArray()) {
        $c = [int]$ch
        if (($c -ge 0x1100 -and $c -le 0x115F) -or ($c -ge 0x2E80 -and $c -le 0xA4CF) -or ($c -ge 0xAC00 -and $c -le 0xD7A3) -or
            ($c -ge 0xF900 -and $c -le 0xFAFF) -or ($c -ge 0xFE30 -and $c -le 0xFE6F) -or ($c -ge 0xFF00 -and $c -le 0xFF60) -or
            ($c -ge 0xFFE0 -and $c -le 0xFFE6)) { $w += 2 } else { $w += 1 }
    }
    return $w
}

function Colorize {
    param([string]$Text, [string]$Color, [int]$Width)
    $pad = [Math]::Max(0, $Width - (Get-CellWidth -Text $Text))
    return "$Color$Text$(' ' * $pad)$RESET"
}
# 10/10 el arte ASCII oye, peak
function Write-Banner { 
    $art = @'
███▄ ▄███▓ ▄▄▄            ▓█████▄ ▓█████ ██▒   █▓
▓██▒▀█▀ ██▒▒████▄          ▒██▀ ██▌▓█   ▀▓██░   █▒
▓██    ▓██░▒██  ▀█▄        ░██   █▌▒███   ▓██  █▒░
▒██    ▒██ ░██▄▄▄▄██       ░▓█▄   ▌▒▓█  ▄  ▒██ █░░
▒██▒   ░██▒ ▓█   ▓██▒      ░▒████▓ ░▒████▒  ▒▀█░
░ ▒░   ░  ░ ▒▒   ▓▒█░       ▒▒▓  ▒ ░░ ▒░ ░  ░ ▐░
░  ░      ░  ▒   ▒▒ ░       ░ ▒  ▒  ░ ░  ░  ░ ░░
░      ░     ░   ▒          ░ ░  ░    ░       ░░
       ░         ░  ░         ░       ░  ░     ░
                            ░                 ░
'@
    Write-Host ""
    Write-Host "$AMBER$art$RESET"
    $rule = '-' * 74
    Write-Host "$AMBER$rule$RESET"
    Write-Host "  $BOLD$INK" -NoNewline; Write-Host "DANGANRONPA VOICE PATCH$RESET"
    Write-Host "  $MIST" -NoNewline; Write-Host "$(T 'banner_subtitle')$RESET"
    # Enlace a un bonito GitHub clicable
    $ghUrl  = 'https://github.com/madevhc/'
    $ghText = 'github.com/madevhc'
    if ($ansiEnabled -and $env:WT_SESSION) { $ghShown = "$ESC]8;;$ghUrl$ESC\$ghText$ESC]8;;$ESC\" } else { $ghShown = $ghText }
    Write-Host "  $MIST$(T 'made_by') MA_Dev  |  $ghShown$RESET"
    Write-Host "$AMBER$rule$RESET"
}

function Show-SlotTable {
    param($Slots)
    Write-Host ""
    $header = "  " + (Colorize '#' $MIST 4) + (Colorize 'SLOT' $MIST 16) + (Colorize (T 'col_lang') $MIST 12) + (Colorize (T 'col_size') $MIST 12) + (Colorize (T 'col_checksum') $MIST 14) + "$MIST$(T 'col_preview')$RESET"
    Write-Host $header
    Write-Host "$MIST  $('-' * 90)$RESET"
    for ($i = 0; $i -lt $Slots.Count; $i++) {
        $s = $Slots[$i]
        $langColor = if ($s.FlagVal -eq 1) { $JP } else { $EN }
        $langText = (Get-LangLabel -FlagVal $s.FlagVal).ToUpper()
        $idx = Colorize "$($i + 1)" $INK 4
        $name = Colorize $s.Name $INK 16
        $langCell = Colorize $langText $langColor 12
        $size = Colorize "$($s.Length) B" $MIST 12
        $crcCell = if ($s.ChecksumOk) { Colorize (T 'crc_ok') $OK 14 } else { Colorize (T 'crc_bad') $ERRC 14 }
        $preview = $s.Preview
        if ($preview.Length -gt 30) { $preview = $preview.Substring(0, 27) + '...' }
        Write-Host "  $idx$name$langCell$size$crcCell$MIST$preview$RESET"
    }
    Write-Host ""
}

function Show-ActionMenu {
    param($Slot)
    $cur = Get-LangLabel -FlagVal $Slot.FlagVal
    Write-Host ""
    Write-Host "  $AMBER${BOLD}$((T 'menu_slot') -f $Slot.Name)$RESET  $MIST$((T 'menu_current') -f $cur)$RESET"
    Write-Host ""
    if ($Slot.FlagVal -eq 0) {
        Write-Host "  ${DIM}${MIST}$(T 'menu_to_en_same')$RESET"
    } else {
        Write-Host "  $EN$(T 'menu_to_en')$RESET"
    }
    if ($Slot.FlagVal -eq 1) {
        Write-Host "  ${DIM}${MIST}$(T 'menu_to_ja_same')$RESET"
    } else {
        Write-Host "  $JP$(T 'menu_to_ja')$RESET"
    }
    Write-Host "  $MIST$(T 'menu_back')$RESET"
    Write-Host ""
}

function Confirm-Action {
    param([string]$Text)
    Write-Host ""
    Write-Host "  $AMBER$Text$RESET"
    $resp = Read-Host ("  " + (T 'confirm_prompt'))
    return ($resp -match (T 'yes_regex'))
}

function Select-UiLanguage {
    Write-Host ""
    Write-Host "  ${MIST}[1] English    [2] Español    [3] 日本語$RESET"
    $c = Read-Host "  Language / Idioma / 言語 (1-3)"
    switch ($c) {
        '1' { $Global:CurrentLang = 'en' }
        '2' { $Global:CurrentLang = 'es' }
        '3' { $Global:CurrentLang = 'ja' }
    }
}

function Invoke-VoiceChange {
    param([string]$Path, $Slot, [int]$TargetValue, [string]$TargetLabel)
    if (Test-GameRunning) {
        Write-Host "  $ERRC$CROSS $(T 'game_running')$RESET"
        if (-not (Confirm-Action (T 'q_continue'))) { return }
    }
    if (-not $Slot.ChecksumOk) {
        Write-Host "  $ERRC$CROSS $((T 'checksum_warn') -f $Slot.Name)$RESET"
        if (-not (Confirm-Action (T 'q_recalc'))) { return }
    }
    try {
        $backup = Backup-SaveFile -Path $Path
        Write-Host "  $MIST> $((T 'backup_ok') -f $backup)$RESET"
    } catch {
        Write-Host "  $ERRC$CROSS $(T 'backup_fail')$RESET"
        Write-Host "  $ERRC  $($_.Exception.Message)$RESET"
        return
    }
    try {
        Set-SlotVoiceLanguage -Path $Path -SlotName $Slot.Name -SlotOffset $Slot.Offset -TargetValue $TargetValue -BackupPath $backup | Out-Null
        Write-Host "  $OK$CHECK $((T 'done') -f $Slot.Name, $TargetLabel)$RESET"
        Write-Host "  $MIST  $(T 'steam_note')$RESET"
    } catch {
        Write-Host "  $ERRC$CROSS $((T 'apply_fail') -f $_.Exception.Message)$RESET"
        Write-Host "  $ERRC  $((T 'backup_at') -f $backup)$RESET"
    }
}

function Prompt-Path {
    Write-Host ""
    if (Test-Path $Global:DEFAULT_SAVE_PATH) {
        Write-Host "  $MIST $((T 'path_detected') -f $Global:DEFAULT_SAVE_PATH)$RESET"
        $resp = Read-Host ("  " + (T 'path_prompt_detect'))
        if ([string]::IsNullOrWhiteSpace($resp)) { return $Global:DEFAULT_SAVE_PATH }
        return $resp
    } else {
        return Read-Host ("  " + (T 'path_prompt'))
    }
}

# ---------------- El Main ----------------
Write-Banner
$path = Prompt-Path
if ([string]::IsNullOrWhiteSpace($path)) {
    Write-Host ""
    Write-Host "$ERRC  $(T 'no_path')$RESET"
    return
}

while ($true) {
    if (-not (Test-Path $path)) {
        Write-Host ""
        Write-Host "$ERRC  x $((T 'file_not_found') -f $path)$RESET"
        break
    }
    try {
        $bytes = [System.IO.File]::ReadAllBytes($path)
    } catch {
        Write-Host ""
        Write-Host "$ERRC  x $((T 'read_fail') -f $_.Exception.Message)$RESET"
        break
    }

    $slots = Get-SaveSlots -Bytes $bytes
    if ($slots.Count -eq 0) {
        Write-Host ""
        Write-Host "$ERRC  x $(T 'no_slots')$RESET"
        break
    }

    Show-SlotTable -Slots $slots
    $sel = Read-Host ("  " + (T 'choose_slot'))
    if ($sel -match '^[Qq]$') { break }
    if ($sel -match '^[Ll]$') { Select-UiLanguage; continue }
    if ($sel -notmatch '^\d+$' -or [int]$sel -lt 1 -or [int]$sel -gt $slots.Count) {
        Write-Host "$ERRC  x $(T 'invalid_option')$RESET"
        continue
    }
    $slot = $slots[[int]$sel - 1]
    if ($slot.FlagVal -ne 0 -and $slot.FlagVal -ne 1) {
        Write-Host "$ERRC  x $((T 'flag_unexpected_ui') -f $slot.FlagVal)$RESET"
        continue
    }

    while ($true) {
        Show-ActionMenu -Slot $slot
        $action = Read-Host ("  " + (T 'choose_option'))
        if ($action -eq '0' -or [string]::IsNullOrWhiteSpace($action)) { break }
        if ($action -eq '1') {
            if ($slot.FlagVal -eq 0) { Write-Host "  $MIST $(T 'already_en')$RESET"; continue }
            if (Confirm-Action ((T 'q_switch_en') -f $slot.Name)) {
                Invoke-VoiceChange -Path $path -Slot $slot -TargetValue 0 -TargetLabel (Get-LangLabel -FlagVal 0)
            }
            break
        }
        if ($action -eq '2') {
            if ($slot.FlagVal -eq 1) { Write-Host "  $MIST $(T 'already_ja')$RESET"; continue }
            if (Confirm-Action ((T 'q_switch_ja') -f $slot.Name)) {
                Invoke-VoiceChange -Path $path -Slot $slot -TargetValue 1 -TargetLabel (Get-LangLabel -FlagVal 1)
            }
            break
        }
        Write-Host "$ERRC  x $(T 'invalid_option')$RESET"
    }
}

Write-Host ""
Write-Host "$AMBER  $(T 'goodbye')$RESET"
Write-Host ""
