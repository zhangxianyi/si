macro strrchr( s, c)
{
    var len
    var i
    len = strlen( s)
    i = len -1
    while( i >= 0)
    {
        if( c == s[i])
        return i;
        i = i - 1
    }
    return -1;
}

macro strchr( s, c)
{
    var len
    var i
    len = strlen( s)
    i = 0
    while( i < len )
    {
        if( c == s[i])
        return i;
        i = i + 1
    }
    return -1;
}

macro stridxNext(string, char, first)
{
    len = strlen(string)
    i = first

    while( i < len )
    {
        if (string[i] != char)
	{
	    i = i + 1
	}
	else
	{
	    break
	}
    }

    /* msg(i) */
    return i
}

macro strstr(str1,str2)
{
    i = 0
    j = 0
    len1 = strlen(str1)
    len2 = strlen(str2)
    if((len1 == 0) || (len2 == 0))
    {
        return -1
    }
    while( i < len1)
    {
        if(str1[i] == str2[j])
        {
            while(j < len2)
            {
                j = j + 1
                if(str1[i+j] != str2[j]) 
                {
                    break
                }
            }     
            if(j == len2)
            {
                return i
            }
            j = 0
        }
        i = i + 1      
    }  
    return -1
}

