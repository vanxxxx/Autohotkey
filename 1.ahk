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
; CapsLock 部分 (保持原样，修复语法)
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
    ; 修复了这里的断行计算
    time_elapsed := current_time - g_LastCtrlKeyDownTime
    
    if (time_elapsed <= 250)
    {
        if (WinActive("ahk_exe code.exe") || WinActive("ahk_exe cmd.exe")){
            SwitchIME(0x04090409) ; 英语(美国)
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
; 使用 SC027 代表分号键，避免与 AHK 注释符号冲突
; 映射: j=左, k=下, l=右, i=上
; ==============================================================================

; 1. 定义组合键 (此时分号作为修饰键，按住不放不会输出字符)
; -----------------------------------------------------------
SC027 & j::Send {Blind}{Left}
SC027 & k::Send {Blind}{Down}
SC027 & l::Send {Blind}{Right}
SC027 & i::Send {Blind}{Up}

; 2. 处理单独按下分号的情况
; -----------------------------------------------------------
; 当你“松开”分号键，且期间没有按jkli时，输出分号
SC027::Send {;} 

; 3. 处理 Shift + 分号 (冒号/引号)
; -----------------------------------------------------------
; 只要按住Shift再按分号，立即输出冒号，不需要等待松开
+SC027::Send {Blind}{:} 

; ==============================================================================
; 辅助函数
; ==============================================================================
SwitchIME(dwLayout){
    HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus,ctl,A
    SendMessage,0x50,0,HKL,%ctl%,A
}