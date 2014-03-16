event DocumentOpen(sFile)
{
    CloseOldWindows()
    restoreBookmarkFromFile()
}

/* 启动时从文件中恢复标签 */
event ProjectOpen(sProject)
{
    restoreBookmarkFromFile()
}

/* 关闭工程时保存书签 */
event ProjectClose(sProject)
{
    if(IsBufDirty (getBookmarkHandle()))
    {
        SaveBuf (getBookmarkHandle())
    }
}

/* Reload File时书签会被删除 */
event AppCommand(sCommand)
{
    if("setBookmark" == sCommand)
    {
        saveBookmark()
    }
    else if("Reload File" == sCommand)
    {
        restoreBookmarkFromFile()
    }
    /* msg(sCommand) */
}

/* 文件关闭时书签会被删除 */
event DocumentClose(sFile)
{
    if(getBookmarkFileName() != sFile)
    {
        restoreBookmarkFromFile()
    }
}
