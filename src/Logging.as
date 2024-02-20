void NotifyWarn(const string &in msg) {
    UI::ShowNotification("Altered Random Map Picker", msg, vec4(1, .5, .1, .5), 6000);
}

void NotifyInfo(const string &in msg) {
    UI::ShowNotification("Altered Random Map Picker", msg, vec4(.2, .8, .5, .3), 6000);
}

enum LogLevel {
    Info,
    InfoG,
    Warn,
    Error,
    Test,
    _,
    D
};

[Setting category="DEV" name="Show debug logs"]
bool doDevLogging = true;

void log(const string &in msg, LogLevel level = LogLevel::Info, int line = -1) {
    string lineInfo = line >= 0 ? "" + line : " ";
    if (doDevLogging) {
        switch(level) {
            case LogLevel::Info: 
                print("\\$0ff[INFO]  " + " \\$z" + "\\$0cc"+lineInfo+" \\$z" + msg); 
                break;
            case LogLevel::InfoG: 
                print("\\$0f0[INFO-G]" + " \\$z" + "\\$0c0"+lineInfo+" \\$z" + msg); 
                break;
            case LogLevel::Warn: 
                print("\\$ff0[WARN]  " + " \\$z" + "\\$cc0"+lineInfo+" \\$z" + msg); 
                break;
            case LogLevel::Error: 
                print("\\$f00[ERROR] " + " \\$z" + "\\$c00"+lineInfo+" \\$z" + msg); 
                break;
            case LogLevel::Test: 
                print("\\$aaa[Testing] " + " \\$z" + "\\$c00"+lineInfo+" \\$z" + msg); 
                break;
            case LogLevel::_: 
                print("\\$333[Placeholder] " + " \\$z" + "\\$c00"+lineInfo+" \\$z" + msg); 
                break;
            case LogLevel::D:
                print("\\$777[D]  " + " \\$z" + "\\$0c0"+lineInfo+" \\$z" + msg); 
                break;
        }
    }
}
