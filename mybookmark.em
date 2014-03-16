/* 获取书签文件名 */
macro getBookmarkFileName()
{
    var hprj
    var spath
    var sdir
    var idx

    hprj = GetCurrentProj ()
	if(hprj == hNil)
	{
		return
	}
    spath = GetProjName (hprj)
    idx = strrchr(spath, "\\")
    sdir = strmid(spath, 0, idx)
    return cat(sdir, "\\bookmark")
}

/* 获取bookmark文件的句柄 */
macro getBookmarkHandle()
{
    var filename
    var hbuf

    filename = getBookmarkFileName()
    hbuf = OpenBuf(filename)
    if(hbuf == hNil)
    {
        hbuf = NewBuf (filename)
        SaveBufAs (hbuf, filename)
    }

    return hbuf
}

/* 显示书签文件 */
macro openBookmark()
{
    SetCurrentBuf (getBookmarkHandle())
}

/* 从书签文件中恢复 */
macro restoreBookmarkFromFile()
{
    var hbuf
    var count
    var i
    var idx1
    var idx2
    var name
    var filename
    var ln
    var ich
    var cSep
    var sRecord

    clearAllbookmarkInMem()

    i = 0
    cSep = ";"
    hbuf = getBookmarkHandle ()
    count = GetBufLineCount (hbuf)
    while (i < count)
    {
        sRecord = GetBufLine (hbuf, i)
        if(sRecord == "")
        {
            i = i + 1
            continue
        }

        idx1 = 0
        idx2 = stridxNext(sRecord, cSep, idx1)
        name = strmid (sRecord, idx1, idx2)

        idx1 = idx2 + 1
        idx2 = stridxNext(sRecord, cSep, idx1)
        filename = strmid (sRecord, idx1, idx2)

        idx1 = idx2 + 1
        idx2 = stridxNext(sRecord, cSep, idx1)
        ln = strmid (sRecord, idx1, idx2)

        idx1 = idx2 + 1
        idx2 = strlen(sRecord)
        ich = strmid (sRecord, idx1, idx2)

        OpenBuf(filename)
        BookmarksAdd (name, filename, ln, ich)
        i = i + 1
    }

    return
}

/* 保存书签到文件中 */
macro saveBookmark()
{
    var hbuf
    var cSep
    var count
    var i
    var bookmark
    var sRecord

    hbuf = getBookmarkHandle ()
    ClearBuf(hbuf)

    cSep = ";"
    count = BookmarksCount()

    i = 0
    while (i < count)
    {
        bookmark = BookmarksItem(i)
        sRecord = bookmark.name
        sRecord = cat(sRecord, cSep)
        sRecord = cat(sRecord, bookmark.File)
        sRecord = cat(sRecord, cSep)
        sRecord = cat(sRecord, bookmark.ln)
        sRecord = cat(sRecord, cSep)
        sRecord = cat(sRecord, bookmark.ich)
        AppendBufLine (hbuf, sRecord)
        i = i + 1
    }
    /* SaveBuf (hbuf) */
}

macro clearAllbookmarkInMem()
{
    var count
    var bookmark
    var i

    i = 0
    count = BookmarksCount()
    while (i < count)
    {
        bookmark = BookmarksItem(0)
        BookmarksDelete (bookmark.name)
        i = i + 1
    }
}

macro clearAllbookmarkFile()
{
    var hbuf

    hbuf = getBookmarkHandle ()
    ClearBuf(hbuf)
    /* SaveBuf (hbuf) */
}

/* 清除所有书签 */
macro clearAllbookmark()
{
    clearAllbookmarkInMem()
    clearAllbookmarkFile()
}

