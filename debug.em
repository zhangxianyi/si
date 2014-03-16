macro debug(filename)
{
    var hbufOutput

    hbufOutput = GetBufHandle (filename)
    if (hNil == hbufOutput)
    {
	hbufOutput = NewBuf (filename)
    }

    DumpMacroState(hbufOutput)
    SetCurrentBuf (hbufOutput)
}
