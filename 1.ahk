; ==============================================================================
; 初始设置
; ==============================================================================
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
g_LastCtrlKeyDownTime := 0
g_AbortSendEsc := false
g_ControlRepeatDetected := false

; ==============================================================================
; CapsLock 部分
; ==============================================================================
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
            SwitchIME(0x04090409)
        }
        SendInput {Esc}
    }
    return

; ==============================================================================
; Esc 部分
; ==============================================================================
~esc::
    if (WinActive("ahk_exe code.exe") || WinActive("ahk_exe cmd.exe")){
        SwitchIME(0x04090409)
    }
    return

; ==============================================================================
; 【核心修复】分号 (;) 映射功能
; ==============================================================================

; 1. 定义组合键 - 分号作为修饰键时的行为
; -----------------------------------------------------------
#If !GetKeyState("Ctrl", "P") && !GetKeyState("Alt", "P") && !GetKeyState("Win", "P")
    SC027 & h::Send {Blind}{Left}
    SC027 & j::Send {Blind}{Down}
    SC027 & l::Send {Blind}{Right}
    SC027 & k::Send {Blind}{Up}
    
    ; 单独按下分号
    SC027::Send {;}
    
    ; Shift + 分号 = 冒号
    +SC027::Send {:}
#If

; 2. 允许 Ctrl/Alt/Win + 分号 正常工作
; -----------------------------------------------------------
^SC027::Send ^{;}
!SC027::Send !{;}
#SC027::Send #{;}

; 额外的常见组合键支持
^+SC027::Send ^+{;}
!+SC027::Send !+{;}

; ==============================================================================
; 辅助函数
; ==============================================================================
SwitchIME(dwLayout){
    HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus,ctl,A
    SendMessage,0x50,0,HKL,%ctl%,A
}