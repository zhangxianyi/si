event DocumentOpen(sFile)
{
    CloseOldWindows()
    restoreBookmarkFromFile()
}

/* ����ʱ���ļ��лָ���ǩ */
event ProjectOpen(sProject)
{
    restoreBookmarkFromFile()
}

/* �رչ���ʱ������ǩ */
event ProjectClose(sProject)
{
    if(IsBufDirty (getBookmarkHandle()))
    {
        SaveBuf (getBookmarkHandle())
    }
}

/* Reload Fileʱ��ǩ�ᱻɾ�� */
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

/* �ļ��ر�ʱ��ǩ�ᱻɾ�� */
event DocumentClose(sFile)
{
    if(getBookmarkFileName() != sFile)
    {
        restoreBookmarkFromFile()
    }
}
