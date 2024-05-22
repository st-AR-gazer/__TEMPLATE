namespace Text
{
    int LastIndexOf(const string &in str, const string &in value) {
        int lastIndex = -1;
        int index = str.IndexOf(value);
        while (index != -1) {
            lastIndex = index;
            index = str.IndexOf(value, lastIndex + 1);
        }
        return lastIndex;
    }
}
