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
    D,
    _
};

[Setting category="~DEV" name="Show debug logs"]
bool doDevLogging = false;

[Setting category="~DEV" name="Show Debug logs (D)"]
bool showDebugLogs = true;

[Setting category="~DEV" name="Show Info logs (INFO)"]
bool showInfoLogs = true;

[Setting category="~DEV" name="Show InfoG logs (INFO-G)"]
bool showInfoGLogs = true;

[Setting category="~DEV" name="Show Warn logs (WARN)"]
bool showWarnLogs = true;

[Setting category="~DEV" name="Show Error logs (ERROR)"]
bool showErrorLogs = true;

[Setting category="~DEV" name="Show Test logs (TEST)"]
bool showTestLogs = true;

[Setting category="~DEV" name="Show Placeholder logs (PLACEHOLDER)"]
bool showPlaceholderLogs = true;


void log(const string &in msg, LogLevel level = LogLevel::Info, int line = -1) {
    string lineInfo = line >= 0 ? (" " + line) : " ";
    bool doLog = false;

    switch(level) {
        case LogLevel::Info:  doLog = showInfoLogs;        break;
        case LogLevel::InfoG: doLog = showInfoGLogs;       break;
        case LogLevel::Warn:  doLog = showWarnLogs;        break;
        case LogLevel::Error: doLog = showErrorLogs;       break;
        case LogLevel::Test:  doLog = showTestLogs;        break;
        case LogLevel::D:     doLog = showDebugLogs;       break;
        case LogLevel::_:     doLog = showPlaceholderLogs; break;
    }

    if (!doDevLogging) return;

    if (doLog) {
        switch(level) {
            case LogLevel::Info:  print("\\$0ff[INFO]  " +       "\\$z" + "\\$0cc" + lineInfo + "\\$z" + msg); break;
            case LogLevel::InfoG: print("\\$0f0[INFO-G]" +       "\\$z" + "\\$0c0" + lineInfo + "\\$z" + msg); break;
            case LogLevel::Warn:  print("\\$ff0[WARN]  " +       "\\$z" + "\\$cc0" + lineInfo + "\\$z" + msg); break;
            case LogLevel::Error: print("\\$f00[ERROR] " +       "\\$z" + "\\$c00" + lineInfo + "\\$z" + msg); break;
            case LogLevel::Test:  print("\\$aaa[TEST]  " +       "\\$z" + "\\$aaa" + lineInfo + "\\$z" + msg); break;
            case LogLevel::D:     print("\\$777[D]     " +       "\\$z" + "\\$777" + lineInfo + "\\$z" + msg); break;
            case LogLevel::_:     print("\\$333[PLACEHOLDER] " + "\\$z" + "\\$333" + lineInfo + "\\$z" + msg); break;
        }
    }
}
