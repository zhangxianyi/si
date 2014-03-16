macro zxymin(len1, len2)
{
    if (len1 > len2)
    {
        minLen = len2
    }
    else
    {
        minLen = len1
    }

    return minLen
}

macro score_of_strsim(szShortstr, szLongstr)
{
    var minLen
    var len1
    var len2
    len1 = strlen(szShortstr)
    len2 = strlen(szLongstr)
    minLen = zxymin(len1, len2)
    i = 0
    while(i<minLen)
    {
        if (szShortstr[i] != szLongstr[i])
        {
            break
        }
        i = i + 1
    }
    return i
}

macro jumptoInclude(hbuf, szline)
{
    var start
    var end
    var s
    var ln
    var output_buffer
    var count
    var maxln 
    var imaxScore  
    var szCurbufname   
	var symbol_record
	var iscore
	
    start = strrchr(szline, "/")
    if(start == -1)
    {
        start = strchr(szline, "'")
    }
    if(start == -1)
    {
        return
    }
    
    end = strstr(szline, "';")
    if(end == -1)
    {
        return
    }
    
    s = strmid(szline, start + 1, end)
    output_buffer = NewBuf("output")
    count = GetSymbolLocationEx (s, output_buffer, True, True, True)
    if(count == 0)
    {
        CloseBuf (output_buffer)
        return
    }
    
    ln = 0
    maxln = 0
    imaxScore = 0
    szCurbufname = GetBufName (hbuf)
    szCurbufname = tolower(szCurbufname)
    while (ln < count)
    {
        symbol_record = GetBufLine (output_buffer, ln)
        if (szCurbufname == tolower(symbol_record.File))
        {
            maxln = ln
            break
        }

        iscore = score_of_strsim(szCurbufname, tolower(symbol_record.File))
        if (iscore > imaxScore)
        {
            imaxScore = iscore
            maxln = ln
        }
        ln = ln + 1
    }
    symbol_record = GetBufLine (output_buffer, maxln)
    OpenMiscFile(symbol_record.File)
    CloseBuf (output_buffer)

    return
}

macro jumptoDefScore()
{
    var ln
    var hbuf
    var hwnd
    var ich 
    var symbol  
	var szline
	var ret
    var output_buffer
    var count
    var maxln 
    var imaxScore  
    var szCurbufname   
	var symbol_record
	var iscore
	
    hbuf = GetCurrentBuf()
    if (hbuf == hNil)
    {
        return
    }

    hwnd = GetCurrentWnd()
    if (hwnd == hNil)
    {
        return
    }

    szline = GetBufLine(hbuf, GetBufLnCur (hbuf))
    ret = strstr(szline, "include")
    if(ret != -1)
    {
        jumptoInclude(hbuf, szline)
        return
    }

    ln = GetBufLnCur (hbuf)
    ich = GetWndSelIchFirst (hwnd)
    symbol = GetSymbolFromCursor (hbuf, ln, ich)
    if(symbol == "")
    {
        return
    }

    /* Msg(symbol) */
    if((symbol.Type == "Method Prototype") || (symbol.Type == "Parameter"))
    {
        RunCmd ("Jump to Definition")
        return
    }

    output_buffer = NewBuf("output")
    if (output_buffer == hNil)
    {
        return
    }

    count = GetSymbolLocationEx (symbol.Symbol, output_buffer, True, True, True)
    if(count <= 1)
    {
        CloseBuf (output_buffer)
        RunCmd ("Jump to Definition")
        return
    }

    ln = 0
    maxln = 0
    imaxScore = 0
    szCurbufname = GetBufName (hbuf)
    szCurbufname = tolower(szCurbufname)
    while (ln < count)
    {
        symbol_record = GetBufLine (output_buffer, ln)
        if (szCurbufname == tolower(symbol_record.File))
        {
            maxln = ln
            break
        }

        iscore = score_of_strsim(szCurbufname, tolower(symbol_record.File))
        if (iscore > imaxScore)
        {
            imaxScore = iscore
            maxln = ln
        }
        ln = ln + 1
    }
    symbol_record = GetBufLine (output_buffer, maxln)
    JumpToLocation (symbol_record)

    CloseBuf (output_buffer)
}

macro getSymbolInfo()
{
    var hbuf
    hbuf = GetCurrentBuf()
    if (hbuf == hNil)
    {
        return
    }

    hwnd = GetCurrentWnd()
    if (hwnd == hNil)
    {
        return
    }

    var ln
    ln = GetBufLnCur (hbuf)
    var ich
    ich = GetWndSelIchFirst (hwnd)
    var symbol
    symbol = GetSymbolFromCursor (hbuf, ln, ich)
    if(symbol == "")
    {
        return
    }

    Msg(symbol.Type)
    var output_buffer
    output_buffer = NewBuf("getSymbolInfo.output")
    if (output_buffer == hNil)
    {
        return
    }

    var count
    count = GetSymbolLocationEx (symbol.Symbol, output_buffer, True, True, True)
    Msg(count)
    var ln
    ln = 0
    var symbol_record
    while (ln < count)
    {
        Msg(GetBufLine (output_buffer, ln))
        ln = ln + 1
    }
    SetCurrentBuf (output_buffer)
}

macro GuessJumpLink()
{
    hbuf = GetCurrentBuf()
    if(hNil == hbuf)
    {
	msg("no file")
	return
    }

    line = GetBufLnCur (hbuf)
    link = GetSourceLink (hbuf, line)
    if (link != "")
    {
	Runcmd("Jump To Link")
	return
    }

    nEndofline = GetBufLineCount(hbuf)
    step = 1
    bForward = True
    bForwardStop = False
    bBackwardStop = False
    bOnePassDone = False

    while(1)
    {
	if (bForwardStop && bBackwardStop)
	{
	    return
	}

	if (bForward)
	{
	    ln = line + step
	}
	else
	{
	    ln = line - step
	}

	if(ln < 1)
	{
	    bBackwardStop = True
	    ln = line + step
	}

	if(ln >= nEndofline)
	{
	    bForwardStop = True
	    ln = line - step
	}

	lntext = GetBufLine(hbuf, ln)
	if (lntext == "")
	{
	    if(bForward)
	    {
		bForwardStop = True
	    }
	    else
	    {
		bBackwardStop = True
	    }
	}

	link = GetSourceLink (hbuf, ln)
	if (link != "")
	{
	    hbuf = OpenBuf(link.file)
	    SetBufIns (hbuf, link.ln, 0)
	    SetCurrentBuf(hbuf)
	    return
	    sFile = "Insight3.exe"
	    sExtraParams = cat(" -i +", link.ln+1)
	    sExtraParams = cat(sExtraParams, " ")
	    sExtraParams = cat(sExtraParams, link.File)
	    ShellExecute ("open", sFile, sExtraParams, "", 1) 
	    return
	}

	if (bOnePassDone)
	{
	    bOnePassDone = False
	    step = step + 1
	}
	else
	{
	    bOnePassDone = True
	}

	if ((!bForwardStop) && (!bBackwardStop))
	{
	    bForward = !bForward
	}
	else
	{
	    if(bForwardStop)
	    {
		bForward = False
	    }
	    if(bBackwardStop)
	    {
		bForward = True 
	    }
	}
    }
}

macro jumptosymbolIn()
{
    /* msg(GetCurSymbol ()) */
    JumpToSymbolDef (GetCurSymbol ())
}
