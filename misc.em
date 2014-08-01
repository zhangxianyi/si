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
    global g_sz_highlight_text
    g_sz_highlight_text = sel
}

macro zxyYankhighlightText()
{
    global g_sz_highlight_text
    hbuf = GetCurrentBuf ()
    SetBufSelText(hbuf, g_sz_highlight_text)
}

macro zxySearch(cmd)
{
    hbuf = GetCurrentBuf ()
    sel = GetBufSelText(hbuf)
    if(sel == "")
    {
        sel = g_sz_search_text
    }

    if(sel == "")
    {
        RunCmd(cmd)
        return
    }

    global g_sz_search_text
    global g_b_fWholeWordsOnly
    if g_b_fWholeWordsOnly == nil
        g_b_fWholeWordsOnly = false
    LoadSearchPattern(sel, 1, 0, g_b_fWholeWordsOnly)
    RunCmd(cmd)
}

macro zxySearchForward()
{
    zxySearch("Search Forward")
}

macro zxySearchBackward()
{
    zxySearch("Search Backward")
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
