/* switch current word, such as */
/* BOOL_TRUE,BOOL_FALSE         */
/* ERROR_SUCCESS,ERROR_FAILED   */
macro switch_word()
{
    hbuf = GetCurrentBuf()
    ln = GetBufLnCur (hbuf)
    hwnd = GetCurrentWnd ()
    ich = GetWndSelIchFirst (hwnd)
    symbol=GetSymbolFromCursor (hbuf, ln, ich)
    if(symbol != "")
    {
        Msg(symbol)
    }
    s=GetBufSelText (hbuf)
    if(s == "")
    {
        runcmd("Select Word")
        s=GetBufSelText (hbuf)
    }
    Msg(s)

    if(s == "BOOL_TRUE")
    {
        SetBufSelText (hbuf, "BOOL_FALSE")
        return
    }

    if(s == "BOOL_FALSE")
    {
        SetBufSelText (hbuf, "BOOL_TRUE")
        return
    }

    if(s == "ERROR_SUCCESS")
    {
        SetBufSelText (hbuf, "ERROR_FAILED")
        return
    }

    if(s == "ERROR_FAILED")
    {
        SetBufSelText (hbuf, "ERROR_SUCCESS")
        return
    }
}

macro zxyhighlightword()
{
    hbuf = GetCurrentBuf ()
    sel = GetBufSelText(hbuf)
    if(sel == "")
    {
        RunCmd("select word")
        sel = GetBufSelText(hbuf)
    }
    RunCmd("highlight word")
    SetReg(highlighttext, sel)
}

macro zxyYankhighlightText()
{
    hbuf = GetCurrentBuf ()
    sel = GetReg(highlighttext)
    SetBufSelText(hbuf, sel)
}

macro zxySearchHighlightForward()
{
    sel = GetReg(highlighttext)
    LoadSearchPattern(sel, 1, 0, 1)
    RunCmd("Search Forward")
}

macro zxySearchHighlightBackward()
{
    sel = GetReg(highlighttext)
    LoadSearchPattern(sel, 1, 0, 1)
    RunCmd("Search Backward")
}

macro zxycopy()
{
    hprj = GetCurrentProj()
    if(GetReg(ForceUseSysClipboard) == true)
    {
        SetReg(projname, GetProjName(hprj))
    }
    RunCmd("Copy")
}

macro zxypaste()
{
    hprj = GetCurrentProj()
    if(GetReg(ForceUseSysClipboard) == true)
    {
        if(GetReg(projname) == GetProjName(hprj))
        {
            RunCmd("Paste")
            return
        }
        RunCmd("SaveClipboard2File")
        zxyGetSysClipboard()
    }

    RunCmd("Paste")
}

macro zxyUseSysClipboardSwitch()
{
    SetReg(ForceUseSysClipboard, !GetReg(ForceUseSysClipboard))
}

macro zxyGetFn()
{
    hbuf = GetCurrentBuf()
    if (hbuf == hNil)
    {
        return
    }
    path = GetBufName(hbuf)
    idx = strrchr(path, "\\")
    fn = strmid(path, idx + 1, strlen(path))
    
    Msg(fn)
    hbufClip = GetBufHandle("Clipboard")
    ClearBuf(hbufClip)
    AppendBufLine(hbufClip, fn)
    CloseBuf(hbufClip)
}

macro zxyGetSysClipboard()
{
    hbufClip = GetBufHandle("Clipboard")
    hbufClipfile = OpenBuf("D:\\skill\\Apps\\insight3\\macros\\clipboard")
    ClearBuf(hbufClip)
    total_ln = GetBufLineCount(hbufClipfile)
    ln = 0
    while(ln < total_ln)
    {
        AppendBufLine(hbufClip, GetBufLine(hbufClipfile, ln))
        ln = ln + 1
    }
    CloseBuf(hbufClipfile)
}
