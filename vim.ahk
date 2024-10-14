g_LastCtrlKeyDownTime := 0
g_AbortSendEsc := false
g_ControlRepeatDetected := false
g_last_single_quotes_time := 0
Toggle :=0
*'::
    Toggle = 1
    g_last_single_quotes_time := A_TickCount
    return
*' Up::
    Toggle = 0
    qtime_elapsed := A_TickCount - g_last_single_quotes_time
    if (qtime_elapsed <= 200)
    {
        SendInput '
    }
    return

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
#if Toggle
a::Send 1
s::Send 2
d::Send 3
f::Send 4
g::Send 5
h::Send 6
j::Send 7
k::Send 8
l::Send 9
`;::Send 0
#if