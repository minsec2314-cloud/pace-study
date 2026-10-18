Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()
$form = New-Object System.Windows.Forms.Form
$form.Text = 'PACE - Groq API setup'
$form.Size = New-Object System.Drawing.Size(540,300)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(24,20)
$label.Size = New-Object System.Drawing.Size(475,60)
$label.Text = 'Paste your Groq API key below. It stays in the ignored local .dev.vars file. Do not share it in chat. Your adult account operator must manage this key.'
$form.Controls.Add($label)
$inputBox = New-Object System.Windows.Forms.TextBox
$inputBox.Location = New-Object System.Drawing.Point(24,90)
$inputBox.Size = New-Object System.Drawing.Size(475,28)
$inputBox.UseSystemPasswordChar = $true
$form.Controls.Add($inputBox)
$status = New-Object System.Windows.Forms.Label
$status.Location = New-Object System.Drawing.Point(24,132)
$status.Size = New-Object System.Drawing.Size(475,40)
$form.Controls.Add($status)
$save = New-Object System.Windows.Forms.Button
$save.Text = 'Save securely'
$save.Location = New-Object System.Drawing.Point(350,190)
$save.Size = New-Object System.Drawing.Size(150,35)
$save.Add_Click({
 $apiValue = $inputBox.Text.Trim()
 if ($apiValue -notmatch '^gsk_[A-Za-z0-9_-]{20,250}$') { $status.Text = 'Check the key. A Groq key normally begins with gsk_.'; return }
 $destination = Join-Path $PSScriptRoot '.dev.vars'
 [System.IO.File]::WriteAllText($destination, ('GROQ_API_KEY=' + $apiValue + [Environment]::NewLine), (New-Object System.Text.UTF8Encoding($false)))
 $inputBox.Clear()
 [System.Windows.Forms.MessageBox]::Show('Saved locally. You may close this window.','PACE') | Out-Null
 $form.Close()
})
$form.Controls.Add($save)
$form.AcceptButton = $save
[void]$form.ShowDialog()
