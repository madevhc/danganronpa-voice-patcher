Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml, System.Windows.Forms

trap {
    $unexpected = if ($Global:I18N) { T 'unexpected_error' } else { 'Unexpected error:' }
    [System.Windows.MessageBox]::Show("$unexpected`n`n$($_.Exception.Message)", 'Danganronpa Voice Patch - Error', 'OK', 'Error') | Out-Null
    break
}

Add-Type -Name Win32Console -Namespace DanganronpaWin32 -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
[DllImport("kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
'@
$consoleHwnd = [DanganronpaWin32.Win32Console]::GetConsoleWindow()
if ($consoleHwnd -ne [IntPtr]::Zero) {
    [DanganronpaWin32.Win32Console]::ShowWindow($consoleHwnd, 0) | Out-Null
}

# Offsets documentados para Danganronpa: Trigger Happy Havoc (PC/Steam), relativos al inicio de cada slot dentro del VFS.
$Global:FLAG_OFFSET     = 119680   # 0 = ingles, 1 = japones
$Global:SUM_FROM        = 800
$Global:SUM_TO          = 240784
$Global:CHECKSUM_OFFSET = 240784
$Global:MIN_SLOT_LENGTH = $Global:CHECKSUM_OFFSET + 1
$Global:DEFAULT_SAVE_PATH = Join-Path $env:USERPROFILE 'Documents\My Games\Danganronpa\savedata.vfs'
# Patrones (best effort) del nombre del proceso del juego; ajustalos si el ejecutable se llama distinto.
$Global:GAME_PROCESS_PATTERNS = @('*danganronpa*', '*trigger*happy*')

# ---------------- UI strings (en / es / ja) ----------------
# Keep this file saved as UTF-8 WITH BOM so Windows PowerShell reads the Japanese text correctly.
$Global:I18N = @{
    en = @{
        subtitle            = "Voice language editor for Trigger Happy Havoc saves"
        made_by             = "Made by"
        browse              = "Browse"
        load                = "Load"
        select_slot         = "Select a slot from the list"
        to_en               = "Switch to English"
        to_ja               = "Switch to Japanese"
        selected_slot       = "Selected slot: {0}  -  currently {1}"
        lang_en             = "English"
        lang_ja             = "Japanese"
        lang_unknown        = "Unknown"
        no_slots            = "No recognizable save slots found in this file."
        err_not_found       = "File not found:`n{0}"
        err_read            = "Could not read the file (is the game open?):`n{0}"
        unexpected_error    = "Unexpected error:"
        log_no_slots        = "No slots found in {0}"
        log_loaded          = "Loaded {0} slot(s) from {1}"
        log_warn_checksum   = "WARNING: the checksum of {0} does not match its contents."
        log_warn_flag       = "WARNING: {0} has an unexpected language value ({1}); it cannot be modified."
        filter_all          = "All files"
        game_running_title  = "Game running"
        game_running_msg    = "The game seems to be running.`n`nClose it before continuing: it may overwrite the change when it exits.`n`nContinue anyway?"
        checksum_title      = "Checksum mismatch"
        checksum_msg        = "The current checksum of '{0}' does not match its contents (damaged save or different format).`n`nContinue and recalculate it anyway?"
        confirm_title       = "Confirm change"
        confirm_msg         = "Switch the voice of '{0}' to {1}?`n`nA verified backup of the whole file will be created before writing.`n`nIf you use Steam Cloud, check afterwards that it does not restore the previous save."
        error_title         = "Error"
        log_backup_ok       = "Backup verified: {0}"
        log_backup_err      = "ERROR: could not create the backup, no change was applied: {0}"
        dlg_backup_err      = "Could not create the backup. The file was not modified.`n`n{0}"
        log_changed         = "Slot {0}: voice language changed to {1} (verified after writing)"
        log_success         = "Change applied successfully."
        done_title          = "Change applied"
        done_msg            = "Done. '{0}' is now set to {1}.`n`nBackup: {2}"
        log_apply_err       = "ERROR while applying the change: {0}"
        dlg_fail            = "Failed to apply the change:`n{0}`n`nThe original is backed up at:`n{1}"
        err_backup_mismatch = "The backup does not match the original (different size or hash)."
        err_invalid_lang    = "Invalid language value: {0}"
        err_file_changed    = "The file has changed since it was loaded. Reload it and try again."
        err_flag_unexpected = "The language flag has an unexpected value ({0}). Nothing was modified."
        err_tmp_mismatch    = "The temp copy does not match what was expected."
        err_verify_restored = "Post-write verification failed; the backup has been restored."
        err_verify          = "Post-write verification failed."
    }
    es = @{
        subtitle            = "Editor de idioma de voz para saves de Trigger Happy Havoc"
        made_by             = "Hecho por"
        browse              = "Examinar"
        load                = "Cargar"
        select_slot         = "Selecciona un slot de la lista"
        to_en               = "Cambiar a Inglés"
        to_ja               = "Cambiar a Japonés"
        selected_slot       = "Slot seleccionado: {0}  -  actualmente en {1}"
        lang_en             = "Inglés"
        lang_ja             = "Japonés"
        lang_unknown        = "Desconocido"
        no_slots            = "No se encontraron slots de guardado reconocibles en este archivo."
        err_not_found       = "No se encontró el archivo:`n{0}"
        err_read            = "No se pudo leer el archivo (¿el juego está abierto?):`n{0}"
        unexpected_error    = "Error inesperado:"
        log_no_slots        = "No se encontraron slots en {0}"
        log_loaded          = "Cargados {0} slot(s) desde {1}"
        log_warn_checksum   = "AVISO: el checksum de {0} no coincide con su contenido."
        log_warn_flag       = "AVISO: {0} tiene un valor de idioma inesperado ({1}); no se podrá modificar."
        filter_all          = "Todos los archivos"
        game_running_title  = "Juego abierto"
        game_running_msg    = "Parece que el juego está abierto.`n`nCiérralo antes de continuar: al salir puede sobrescribir el cambio.`n`n¿Continuar de todos modos?"
        checksum_title      = "El checksum no coincide"
        checksum_msg        = "El checksum actual de '{0}' no coincide con su contenido (guardado dañado o formato distinto).`n`n¿Continuar y recalcularlo igualmente?"
        confirm_title       = "Confirmar cambio"
        confirm_msg         = "¿Cambiar la voz de '{0}' a {1}?`n`nSe creará un backup verificado del archivo completo antes de escribir.`n`nSi usas Steam Cloud, comprueba después que no restaure el guardado anterior."
        error_title         = "Error"
        log_backup_ok       = "Backup verificado: {0}"
        log_backup_err      = "ERROR: no se pudo crear el backup, no se aplicó ningún cambio: {0}"
        dlg_backup_err      = "No se pudo crear el backup. No se modificó el archivo.`n`n{0}"
        log_changed         = "Slot {0}: idioma de voz cambiado a {1} (verificado tras escribir)"
        log_success         = "Cambio aplicado con éxito."
        done_title          = "Cambio aplicado"
        done_msg            = "Listo. '{0}' ahora está en {1}.`n`nBackup: {2}"
        log_apply_err       = "ERROR al aplicar el cambio: {0}"
        dlg_fail            = "Fallo al aplicar el cambio:`n{0}`n`nEl original está respaldado en:`n{1}"
        err_backup_mismatch = "El backup no coincide con el original (tamaño o hash distinto)."
        err_invalid_lang    = "Valor de idioma inválido: {0}"
        err_file_changed    = "El archivo ha cambiado desde que se cargó. Vuelve a cargarlo e inténtalo de nuevo."
        err_flag_unexpected = "El flag de idioma tiene un valor inesperado ({0}). No se modifica nada."
        err_tmp_mismatch    = "La copia temporal no coincide con lo esperado."
        err_verify_restored = "La verificación posterior falló; se ha restaurado el backup."
        err_verify          = "La verificación posterior falló."
    }
    ja = @{
        subtitle            = "Trigger Happy Havoc セーブデータ用 ボイス言語エディタ"
        made_by             = "制作:"
        browse              = "参照"
        load                = "読み込み"
        select_slot         = "リストからスロットを選択してください"
        to_en               = "英語に切り替え"
        to_ja               = "日本語に切り替え"
        selected_slot       = "選択中のスロット: {0}  -  現在のボイス: {1}"
        lang_en             = "英語"
        lang_ja             = "日本語"
        lang_unknown        = "不明"
        no_slots            = "このファイルに認識できるセーブスロットが見つかりませんでした。"
        err_not_found       = "ファイルが見つかりません:`n{0}"
        err_read            = "ファイルを読み取れませんでした（ゲームが起動中の可能性があります）:`n{0}"
        unexpected_error    = "予期しないエラー:"
        log_no_slots        = "{0} にスロットが見つかりません"
        log_loaded          = "{1} から {0} 個のスロットを読み込みました"
        log_warn_checksum   = "警告: {0} のチェックサムが内容と一致しません。"
        log_warn_flag       = "警告: {0} の言語値が想定外です（{1}）。変更できません。"
        filter_all          = "すべてのファイル"
        game_running_title  = "ゲーム起動中"
        game_running_msg    = "ゲームが起動している可能性があります。`n`n続行する前にゲームを閉じてください。終了時に変更が上書きされることがあります。`n`nそれでも続行しますか？"
        checksum_title      = "チェックサム不一致"
        checksum_msg        = "'{0}' の現在のチェックサムが内容と一致しません（セーブデータの破損、または形式が異なる可能性があります）。`n`nそれでも再計算して続行しますか？"
        confirm_title       = "変更の確認"
        confirm_msg         = "'{0}' のボイスを {1} に切り替えますか？`n`n書き込み前に、ファイル全体の検証済みバックアップを作成します。`n`nSteam クラウドを使用している場合は、後で以前のセーブデータが復元されていないか確認してください。"
        error_title         = "エラー"
        log_backup_ok       = "バックアップを検証しました: {0}"
        log_backup_err      = "エラー: バックアップを作成できなかったため、変更は適用されていません: {0}"
        dlg_backup_err      = "バックアップを作成できませんでした。ファイルは変更されていません。`n`n{0}"
        log_changed         = "スロット {0}: ボイス言語を {1} に変更しました（書き込み後に検証済み）"
        log_success         = "変更を適用しました。"
        done_title          = "変更を適用しました"
        done_msg            = "完了しました。'{0}' は {1} になりました。`n`nバックアップ: {2}"
        log_apply_err       = "変更の適用中にエラーが発生しました: {0}"
        dlg_fail            = "変更を適用できませんでした:`n{0}`n`n元のファイルのバックアップ:`n{1}"
        err_backup_mismatch = "バックアップが元のファイルと一致しません（サイズまたはハッシュが異なります）。"
        err_invalid_lang    = "無効な言語値: {0}"
        err_file_changed    = "読み込み後にファイルが変更されました。再読み込みしてもう一度お試しください。"
        err_flag_unexpected = "言語フラグの値が想定外です（{0}）。何も変更していません。"
        err_tmp_mismatch    = "一時ファイルの内容が期待と一致しません。"
        err_verify_restored = "書き込み後の検証に失敗したため、バックアップを復元しました。"
        err_verify          = "書き込み後の検証に失敗しました。"
    }
}

# Default UI language from the Windows display language (es / ja, otherwise en). The header buttons change it.
$Global:GITHUB_URL = 'https://github.com/madevhc/'
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

    # El archivo pudo cambiar desde que se cargo (el juego, Steam Cloud...): se revalida el slot.
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

    # Escritura atomica: primero a un temporal verificado y luego reemplazo del original.
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

    # Verificacion posterior: el archivo final debe ser exactamente lo que se pretendia escribir.
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

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Danganronpa Voice Patch"
        Height="720" Width="880" MinHeight="600" MinWidth="740"
        Background="#1a1815" WindowStartupLocation="CenterScreen"
        FontFamily="Segoe UI, Yu Gothic UI, Meiryo UI">
  <Window.Resources>
    <Style x:Key="PillButton" TargetType="Button">
      <Setter Property="Foreground" Value="#16140f"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Padding" Value="18,11"/>
      <Setter Property="BorderThickness" Value="0"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="bd" Background="{TemplateBinding Background}" CornerRadius="6">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="{TemplateBinding Padding}"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="bd" Property="Opacity" Value="0.85"/>
              </Trigger>
              <Trigger Property="IsEnabled" Value="False">
                <Setter TargetName="bd" Property="Background" Value="#2c2818"/>
                <Setter Property="Foreground" Value="#6c6656"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="GhostButton" TargetType="Button" BasedOn="{StaticResource PillButton}">
      <Setter Property="Background" Value="#2b271e"/>
      <Setter Property="Foreground" Value="#ece7da"/>
    </Style>
    <Style TargetType="ScrollBar">
      <Setter Property="Background" Value="#1a1815"/>
    </Style>
  </Window.Resources>

  <Grid Margin="28">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="160"/>
    </Grid.RowDefinitions>

    <Grid Grid.Row="0" Margin="0,0,0,20">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="Auto"/>
      </Grid.ColumnDefinitions>
      <StackPanel Grid.Column="0">
        <TextBlock Text="DANGANRONPA VOICE PATCH" FontSize="12" FontWeight="Bold" Foreground="#d9a256" Margin="0,0,0,4" FontFamily="Consolas"/>
        <TextBlock x:Name="TxtSubtitle" Text="Voice language editor for Trigger Happy Havoc saves" FontSize="20" FontWeight="Bold" Foreground="#ece7da" TextWrapping="Wrap"/>
        <StackPanel x:Name="LinkGithub" Orientation="Horizontal" Margin="0,6,0,0" Cursor="Hand" Background="Transparent" HorizontalAlignment="Left">
          <TextBlock x:Name="TxtMadeBy" Text="Made by" FontSize="10.5" Foreground="#8f8874" FontFamily="Consolas, MS Gothic" VerticalAlignment="Center"/>
          <Path x:Name="IcoGithub" Width="13" Height="13" Margin="8,0,5,0" Stretch="Uniform" Fill="#8f8874" VerticalAlignment="Center" Data="F1 M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/>
          <TextBlock x:Name="TxtAuthor" Text="MA_Dev" FontSize="10.5" Foreground="#8f8874" FontFamily="Consolas, MS Gothic" VerticalAlignment="Center"/>
        </StackPanel>
      </StackPanel>
      <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Top" Margin="16,0,0,0">
        <Button x:Name="BtnLangEN" Content="EN" Style="{StaticResource PillButton}" Background="#2b271e" Foreground="#ece7da" FontSize="12" Padding="10,4" Margin="0,0,6,0"/>
        <Button x:Name="BtnLangES" Content="ES" Style="{StaticResource PillButton}" Background="#2b271e" Foreground="#ece7da" FontSize="12" Padding="10,4" Margin="0,0,6,0"/>
        <Button x:Name="BtnLangJA" Content="日本語" Style="{StaticResource PillButton}" Background="#2b271e" Foreground="#ece7da" FontSize="12" Padding="10,4"/>
      </StackPanel>
    </Grid>
    <Grid Grid.Row="1" Margin="0,0,0,18">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*"/>
        <ColumnDefinition Width="Auto"/>
        <ColumnDefinition Width="Auto"/>
      </Grid.ColumnDefinitions>
      <Border Grid.Column="0" Background="#221f19" BorderBrush="#3a352a" BorderThickness="1" CornerRadius="6" Margin="0,0,10,0">
        <TextBox x:Name="TxtPath" Background="Transparent" Foreground="#ece7da" CaretBrush="#d9a256" BorderThickness="0" Padding="12,10" VerticalContentAlignment="Center" FontSize="13"/>
      </Border>
      <Button x:Name="BtnBrowse" Grid.Column="1" Content="Browse" Style="{StaticResource GhostButton}" Margin="0,0,8,0"/>
      <Button x:Name="BtnLoad" Grid.Column="2" Content="Load" Background="#d9a256" Style="{StaticResource PillButton}"/>
    </Grid>

    <Border Grid.Row="2" Background="#100f0b" BorderBrush="#2c2818" BorderThickness="1" CornerRadius="8" Padding="4">
      <ScrollViewer VerticalScrollBarVisibility="Auto">
        <StackPanel x:Name="SlotListPanel" Margin="8"/>
      </ScrollViewer>
    </Border>

    <Border Grid.Row="3" Background="#221f19" BorderBrush="#3a352a" BorderThickness="1" CornerRadius="8" Padding="16" Margin="0,16,0,16">
      <StackPanel>
        <TextBlock x:Name="LblSelected" Text="Select a slot from the list" Foreground="#c3bca9" FontSize="13" Margin="0,0,0,12"/>
        <StackPanel Orientation="Horizontal">
          <Button x:Name="BtnToEnglish" Content="Switch to English" Background="#86a7d9" Style="{StaticResource PillButton}" IsEnabled="False" Margin="0,0,10,0"/>
          <Button x:Name="BtnToJapanese" Content="Switch to Japanese" Background="#e08064" Style="{StaticResource PillButton}" IsEnabled="False"/>
        </StackPanel>
      </StackPanel>
    </Border>

    <Border Grid.Row="4" Background="#100f0b" BorderBrush="#2c2818" BorderThickness="1" CornerRadius="8" Padding="12">
      <ScrollViewer VerticalScrollBarVisibility="Auto">
        <TextBlock x:Name="LogText" FontFamily="Consolas, MS Gothic" FontSize="12" Foreground="#c3bca9" TextWrapping="Wrap"/>
      </ScrollViewer>
    </Border>
  </Grid>
</Window>
'@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$txtPath       = $window.FindName('TxtPath')
$btnBrowse     = $window.FindName('BtnBrowse')
$btnLoad       = $window.FindName('BtnLoad')
$slotListPanel = $window.FindName('SlotListPanel')
$lblSelected   = $window.FindName('LblSelected')
$btnToEnglish  = $window.FindName('BtnToEnglish')
$btnToJapanese = $window.FindName('BtnToJapanese')
$logText       = $window.FindName('LogText')
$txtSubtitle   = $window.FindName('TxtSubtitle')
$txtMadeBy     = $window.FindName('TxtMadeBy')
$btnLangEN     = $window.FindName('BtnLangEN')
$btnLangES     = $window.FindName('BtnLangES')
$btnLangJA     = $window.FindName('BtnLangJA')
$linkGithub    = $window.FindName('LinkGithub')
$icoGithub     = $window.FindName('IcoGithub')
$txtAuthor     = $window.FindName('TxtAuthor')

if (Test-Path $Global:DEFAULT_SAVE_PATH) { $txtPath.Text = $Global:DEFAULT_SAVE_PATH }

$colorEn           = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#86a7d9')
$colorJp           = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#e08064')
$colorCard         = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#221f19')
$colorCardSelected = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#2b271e')
$colorLine         = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#3a352a')
$colorAmber        = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#d9a256')
$colorInk          = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#ece7da')
$colorMist         = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#8f8874')
$colorDark         = [System.Windows.Media.BrushConverter]::new().ConvertFromString('#16140f')

$script:currentSlots  = @()
$script:currentPath   = $null
$script:selectedIndex = -1
$script:cardBorders   = @()
$script:showingEmpty  = $false

function Write-Log {
    param([string]$Text)
    $logText.Text += "[$(Get-Date -Format 'HH:mm:ss')] $Text`r`n"
}

function New-SlotCard {
    param($Slot, [int]$Index)

    $border = New-Object System.Windows.Controls.Border
    $border.CornerRadius = 8
    $border.Background = $colorCard
    $border.BorderBrush = $colorLine
    $border.BorderThickness = 1
    $border.Padding = 14
    $border.Margin = '0,0,0,8'
    $border.Cursor = [System.Windows.Input.Cursors]::Hand

    $grid = New-Object System.Windows.Controls.Grid
    $colAccent = New-Object System.Windows.Controls.ColumnDefinition
    $colAccent.Width = 4
    $colMain = New-Object System.Windows.Controls.ColumnDefinition
    $colMain.Width = '*'
    $colBadge = New-Object System.Windows.Controls.ColumnDefinition
    $colBadge.Width = 'Auto'
    $grid.ColumnDefinitions.Add($colAccent)
    $grid.ColumnDefinitions.Add($colMain)
    $grid.ColumnDefinitions.Add($colBadge)

    $accentColor = if ($Slot.FlagVal -eq 1) { $colorJp } else { $colorEn }

    $accent = New-Object System.Windows.Controls.Border
    $accent.Background = $accentColor
    $accent.CornerRadius = 2
    $accent.Margin = '0,0,12,0'
    [System.Windows.Controls.Grid]::SetColumn($accent, 0)
    $grid.Children.Add($accent) | Out-Null

    $stack = New-Object System.Windows.Controls.StackPanel
    $stack.VerticalAlignment = 'Center'
    [System.Windows.Controls.Grid]::SetColumn($stack, 1)

    $nameBlock = New-Object System.Windows.Controls.TextBlock
    $nameBlock.Text = $Slot.Name
    $nameBlock.FontWeight = 'Bold'
    $nameBlock.FontSize = 14
    $nameBlock.Foreground = $colorInk
    $stack.Children.Add($nameBlock) | Out-Null

    $previewBlock = New-Object System.Windows.Controls.TextBlock
    $previewBlock.Text = $Slot.Preview
    $previewBlock.FontSize = 12
    $previewBlock.Foreground = $colorMist
    $previewBlock.Margin = '0,4,0,0'
    $previewBlock.TextTrimming = 'CharacterEllipsis'
    $stack.Children.Add($previewBlock) | Out-Null

    $grid.Children.Add($stack) | Out-Null

    $badge = New-Object System.Windows.Controls.Border
    $badge.Background = $accentColor
    $badge.CornerRadius = 10
    $badge.Padding = '10,4'
    $badge.VerticalAlignment = 'Center'
    [System.Windows.Controls.Grid]::SetColumn($badge, 2)
    $badgeText = New-Object System.Windows.Controls.TextBlock
    $badgeText.Text = (Get-LangLabel -FlagVal $Slot.FlagVal).ToUpper()
    $badgeText.FontSize = 11
    $badgeText.FontWeight = 'Bold'
    $badgeText.Foreground = $colorDark
    $badge.Child = $badgeText
    $grid.Children.Add($badge) | Out-Null

    $border.Child = $grid

    $border.Tag = $Index
    $border.Add_MouseLeftButtonUp({ Select-Slot -Index $this.Tag })

    return $border
}

function Select-Slot {
    param([int]$Index)
    $script:selectedIndex = $Index
    for ($i = 0; $i -lt $script:cardBorders.Count; $i++) {
        if ($i -eq $Index) {
            $script:cardBorders[$i].BorderBrush = $colorAmber
            $script:cardBorders[$i].BorderThickness = 2
            $script:cardBorders[$i].Background = $colorCardSelected
        } else {
            $script:cardBorders[$i].BorderBrush = $colorLine
            $script:cardBorders[$i].BorderThickness = 1
            $script:cardBorders[$i].Background = $colorCard
        }
    }
    $slot = $script:currentSlots[$Index]
    $lblSelected.Text = ((T 'selected_slot') -f $slot.Name, (Get-LangLabel -FlagVal $slot.FlagVal))
    $btnToEnglish.IsEnabled = ($slot.FlagVal -eq 1)
    $btnToJapanese.IsEnabled = ($slot.FlagVal -eq 0)
}

function Render-SlotCards {
    $slotListPanel.Children.Clear()
    $script:cardBorders = @()
    for ($i = 0; $i -lt $script:currentSlots.Count; $i++) {
        $card = New-SlotCard -Slot $script:currentSlots[$i] -Index $i
        $slotListPanel.Children.Add($card) | Out-Null
        $script:cardBorders += $card
    }
    if ($script:selectedIndex -ge 0) { Select-Slot -Index $script:selectedIndex }
}

function Update-LangButtons {
    $map = @{ en = $btnLangEN; es = $btnLangES; ja = $btnLangJA }
    foreach ($code in $map.Keys) {
        if ($code -eq $Global:CurrentLang) {
            $map[$code].Background = $colorAmber
            $map[$code].Foreground = $colorDark
        } else {
            $map[$code].Background = $colorCardSelected
            $map[$code].Foreground = $colorInk
        }
    }
}

function Apply-Language {
    param([string]$Code)
    $Global:CurrentLang = $Code
    $txtSubtitle.Text = (T 'subtitle')
    $txtMadeBy.Text   = (T 'made_by')
    $btnBrowse.Content     = (T 'browse')
    $btnLoad.Content       = (T 'load')
    $btnToEnglish.Content  = (T 'to_en')
    $btnToJapanese.Content = (T 'to_ja')
    Update-LangButtons

    if ($script:showingEmpty) {
        $slotListPanel.Children.Clear()
        $empty = New-Object System.Windows.Controls.TextBlock
        $empty.Text = (T 'no_slots')
        $empty.Foreground = $colorMist
        $empty.Margin = 16
        $slotListPanel.Children.Add($empty) | Out-Null
        $lblSelected.Text = (T 'select_slot')
    } elseif ($script:cardBorders.Count -gt 0) {
        Render-SlotCards
        if ($script:selectedIndex -lt 0) { $lblSelected.Text = (T 'select_slot') }
    } else {
        $lblSelected.Text = (T 'select_slot')
    }
}

function Refresh-SlotList {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        [System.Windows.MessageBox]::Show(((T 'err_not_found') -f $Path), (T 'error_title'), 'OK', 'Error') | Out-Null
        return
    }
    try {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
    } catch {
        [System.Windows.MessageBox]::Show(((T 'err_read') -f $_.Exception.Message), (T 'error_title'), 'OK', 'Error') | Out-Null
        return
    }

    $slots = Get-SaveSlots -Bytes $bytes
    $slotListPanel.Children.Clear()
    $script:cardBorders = @()
    $script:selectedIndex = -1
    $btnToEnglish.IsEnabled = $false
    $btnToJapanese.IsEnabled = $false
    $lblSelected.Text = (T 'select_slot')

    if ($slots.Count -eq 0) {
        $empty = New-Object System.Windows.Controls.TextBlock
        $empty.Text = (T 'no_slots')
        $empty.Foreground = $colorMist
        $empty.Margin = 16
        $slotListPanel.Children.Add($empty) | Out-Null
        $script:showingEmpty = $true
        Write-Log ((T 'log_no_slots') -f $Path)
        return
    }

    $script:showingEmpty = $false
    $script:currentSlots = $slots
    $script:currentPath = $Path
    for ($i = 0; $i -lt $slots.Count; $i++) {
        $card = New-SlotCard -Slot $slots[$i] -Index $i
        $slotListPanel.Children.Add($card) | Out-Null
        $script:cardBorders += $card
    }
    Write-Log ((T 'log_loaded') -f $slots.Count, $Path)
    foreach ($s in $slots) {
        if (-not $s.ChecksumOk) { Write-Log ((T 'log_warn_checksum') -f $s.Name) }
        if ($s.FlagVal -ne 0 -and $s.FlagVal -ne 1) { Write-Log ((T 'log_warn_flag') -f $s.Name, $s.FlagVal) }
    }
}

$btnBrowse.Add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Filter = "savedata.vfs|savedata.vfs|$(T 'filter_all')|*.*"
    $initDir = Split-Path $Global:DEFAULT_SAVE_PATH -Parent
    if (Test-Path $initDir) { $dlg.InitialDirectory = $initDir }
    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtPath.Text = $dlg.FileName
    }
})

$btnLoad.Add_Click({ Refresh-SlotList -Path $txtPath.Text })

function Apply-VoiceChange {
    param([int]$TargetValue, [string]$TargetLabel)
    if ($script:selectedIndex -lt 0) { return }
    $slot = $script:currentSlots[$script:selectedIndex]

    if (Test-GameRunning) {
        $r = [System.Windows.MessageBox]::Show((T 'game_running_msg'), (T 'game_running_title'), 'YesNo', 'Warning')
        if ($r -ne 'Yes') { return }
    }
    if (-not $slot.ChecksumOk) {
        $r = [System.Windows.MessageBox]::Show(((T 'checksum_msg') -f $slot.Name), (T 'checksum_title'), 'YesNo', 'Warning')
        if ($r -ne 'Yes') { return }
    }

    $confirm = [System.Windows.MessageBox]::Show(((T 'confirm_msg') -f $slot.Name, $TargetLabel), (T 'confirm_title'), 'YesNo', 'Question')
    if ($confirm -ne 'Yes') { return }

    $backupPath = $null
    try {
        $backupPath = Backup-SaveFile -Path $script:currentPath
        Write-Log ((T 'log_backup_ok') -f $backupPath)
    } catch {
        Write-Log ((T 'log_backup_err') -f $_.Exception.Message)
        [System.Windows.MessageBox]::Show(((T 'dlg_backup_err') -f $_.Exception.Message), (T 'error_title'), 'OK', 'Error') | Out-Null
        return
    }

    try {
        Set-SlotVoiceLanguage -Path $script:currentPath -SlotName $slot.Name -SlotOffset $slot.Offset -TargetValue $TargetValue -BackupPath $backupPath | Out-Null
        Write-Log ((T 'log_changed') -f $slot.Name, $TargetLabel)
        Refresh-SlotList -Path $script:currentPath
        Write-Log (T 'log_success')
        [System.Windows.MessageBox]::Show(((T 'done_msg') -f $slot.Name, $TargetLabel, $backupPath), (T 'done_title'), 'OK', 'Information') | Out-Null
    } catch {
        Write-Log ((T 'log_apply_err') -f $_.Exception.Message)
        [System.Windows.MessageBox]::Show(((T 'dlg_fail') -f $_.Exception.Message, $backupPath), (T 'error_title'), 'OK', 'Error') | Out-Null
    }
}

$btnToEnglish.Add_Click({ Apply-VoiceChange -TargetValue 0 -TargetLabel (Get-LangLabel -FlagVal 0) })
$btnToJapanese.Add_Click({ Apply-VoiceChange -TargetValue 1 -TargetLabel (Get-LangLabel -FlagVal 1) })

$linkGithub.ToolTip = 'github.com/madevhc'
$linkGithub.Add_MouseLeftButtonUp({
    try { Start-Process $Global:GITHUB_URL } catch {}
})
$linkGithub.Add_MouseEnter({
    $txtAuthor.Foreground = $colorAmber
    $icoGithub.Fill = $colorAmber
    $txtAuthor.TextDecorations = [System.Windows.TextDecorations]::Underline
})
$linkGithub.Add_MouseLeave({
    $txtAuthor.Foreground = $colorMist
    $icoGithub.Fill = $colorMist
    $txtAuthor.TextDecorations = New-Object System.Windows.TextDecorationCollection
})

$btnLangEN.Add_Click({ Apply-Language -Code 'en' })
$btnLangES.Add_Click({ Apply-Language -Code 'es' })
$btnLangJA.Add_Click({ Apply-Language -Code 'ja' })

Apply-Language -Code $Global:CurrentLang

if ($txtPath.Text) { Refresh-SlotList -Path $txtPath.Text }

$window.ShowDialog() | Out-Null
