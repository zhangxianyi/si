//Siring - bookmark.em
//                                         
//Copyright (C) 2012 Crabant Yang
//                                         
//This file is part of Siring.                                                       
//                                                                                   
//    Siring is free software: you can redistribute it and/or modify                 
//    it under the terms of the GNU General Public License as published by           
//    the Free Software Foundation, either version 3 of the License, or              
//    (at your option) any later version.                                            
//                                                                                   
//    Siring is distributed in the hope that it will be useful,                      
//    but WITHOUT ANY WARRANTY; without even the implied warranty of                 
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                  
//    GNU General Public License for more details.                                   
//                                                                                   
//    You should have received a copy of the GNU General Public License              
//    along with Siring.  If not, see <http://www.gnu.org/licenses/>.

macro nullIndex()
{
    return 99999
}
macro gotoBookmark( i)
{
    var count
    count = BookmarksCount()

    if( i < 0)
        return nullIndex()

    if( i > count -1)
    {
        if( count > 0)
            i = 0
        else
        return nullIndex()
    }

    var bookmark
    bookmark = BookmarksItem(i)

    OpenMiscFile( bookmark.File)
    var hwnd
    hwnd = GetCurrentWnd ()
    ScrollWndToLine( hwnd, bookmark.ln)
    ScrollWndVert( hwnd, 20)
    var buf
    buf = GetCurrentBuf ()
    SetBufIns( buf, bookmark.ln, 0)
}

macro getTmpName()
{
    var tmpdir
    tmpdir = GetEnv( "temp")
    var filename 
    filename= cat( tmpdir, "\\bookmark.buf")
    //filename = "bookmark_tmp_$%^.buf"
    return filename
}
macro setBkIndex( index)
{
    var buf
    var filename
    filename = getTmpName()
    buf = GetBufHandle( filename)

    PutBufLine( buf, 0, index) 
    SetBufDirty( buf, 0)
}
macro getBkIndex()
{
    var buf
    var filename
    filename = getTmpName()
    buf = GetBufHandle( filename)

    var index
    index = GetBufLine( buf, 0)
    return index
}
macro initBkBuf()
{
    var filename
    var buf
    filename = getTmpName()
    buf = GetBufHandle( filename)
    if( buf == hNil)
    {
        buf = NewBuf(filename) 
        AppendBufLine( buf, nullIndex())
        SaveBufAs( buf,filename)
        buf = OpenBuf( filename)
        SetBufDirty( buf, 0)
    }
}

macro bkIndexNext( index)
{
    var count
    count = BookmarksCount()

    if( count <= 0)
        return nullIndex()
    if( index == nullIndex())
        return 0
    if( index >= count -1)
        return 0
    index = index +1
    return index
}

macro bkIndexPrevious( index)
{
    var count
    count = BookmarksCount()

    if( count <= 0)
        return nullIndex()
    if( index == nullIndex())
        return count -1
    if( index <= 0)
        return count -1
    if( index > count -1)
        return count -1
    index = index -1
    return index
}

macro bookmarkNext()
{
    initBkBuf()
    var index
    index = getBkIndex()
    index = bkIndexNext( index)
    gotoBookmark( index)
    setBkIndex( index)
}

macro bookmarkPrevious()
{
    initBkBuf()
    var index
    index = getBkIndex()
    index = bkIndexPrevious( index)
    gotoBookmark( index)
    setBkIndex( index)
}

macro setBookmark()
{
    var buf
    buf = GetCurrentBuf()
    var line
    line = GetBufLnCur( buf)
    var filename
    filename = GetBufName( buf)
    var bookmark
    bookmark = BookmarksLookupLine( filename, line)
    if( bookmark == "")  //set bookmark
    {
        var bkname
        bkname = cat( filename, line)
        BookmarksAdd( bkname, filename, line, 0)
    }
    else //unset bookmark
    {
        BookmarksDelete( bookmark.Name)
    }
}

