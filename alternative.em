/* ÇÐ»».c.h/.cpp.hÎÄ¼þ */

macro myalternative()
{
    hbuf =GetCurrentBuf()
    if (hNil == hbuf)
    {
        Msg("no buffer")
        return
    }

    fname = GetBufName (hbuf)
    pos = strrchr(fname, ".")
    if (-1 == pos)
    {
        Msg("no suffix")
        return
    }

    prefn = strmid(fname, 0, pos)
    suffix=tolower(fname[pos+1])
    if ("h" == suffix)
    {
        alterfn = cat(prefn, ".c")
        hbuf = OpenBuf(alterfn)
        if (hNil == hbuf)
        {
            alterfn = cat(prefn, ".cpp")
        }
    }
    else if (("c" == suffix) || ("cpp" == suffix))
    {
        alterfn = cat(prefn, ".h")
    }
    else
    {
        /* debug("alternative.dump") */
        Msg("only support .h/.c/.cpp!")
        return
    }

    hbuf = OpenBuf(alterfn)
    if (hNil == hbuf)
    {
        Msg("not found")
        return
    }

    OpenMiscFile(alterfn)
}

