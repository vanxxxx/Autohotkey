g_LastCtrlKeyDownTime := 0
g_AbortSendEsc := false
g_ControlRepeatDetected := false

; Hold `;` as a "modifier": while holding it, map h/j/k/l -> Left/Down/Up/Right (Vim style).
; Tap `;` alone to still type a semicolon.
g_SemiIsDown := false
g_SemiUsed := false

*`;::
    g_SemiIsDown := true
    g_SemiUsed := false
return

*`; Up::
    g_SemiIsDown := false
    if (!g_SemiUsed)
    {
        SendInput `;
    }
return

#If (g_SemiIsDown)
h::
    g_SemiUsed := true
    SendInput {Left}
return

j::
    g_SemiUsed := true
    SendInput {Down}
return

k::
    g_SemiUsed := true
    SendInput {Up}
return

l::
    g_SemiUsed := true
    SendInput {Right}
return
#If

*CapsLock::
    if (g_ControlRepeatDetected)
    {
        return
    }

    send,{Ctrl down}
    g_LastCtrlKeyDownTime := A_TickCount
    g_AbortSendEsc := false
    g_ControlRepeatDetected := true

    return

*CapsLock Up::
    send,{Ctrl up}
    g_ControlRepeatDetected := false
    if (g_AbortSendEsc)
    {
        return
    }
    current_time := A_TickCount
    time_elapsed := current_time - g_LastCtrlKeyDownTime
    if (time_elapsed <= 250)
    {
        if (WinActive("ahk_exe code.exe") || WinActive("ahk_exe cmd.exe")){
        SwitchIME(0x04090409) ; 英语(美国) 美式键盘
        }
        SendInput {Esc}
            }
    return
~esc::
if (WinActive("ahk_exe code.exe") || WinActive("ahk_exe cmd.exe")){
SwitchIME(0x04090409) ; 英语(美国) 美式键盘
SwitchIME(0x08040804) ; 中文(中国) 简体中文-美式键盘
return
}

SwitchIME(dwLayout){
    HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus,ctl,A
    SendMessage,0x50,0,HKL,%ctl%,A
}
