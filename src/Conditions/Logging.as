void NotifyWarn(const string &in msg) {
    UI::ShowNotification("Plugin Name", msg, vec4(1, .5, .1, .5), 6000);
}

void NotifyInfo(const string &in msg) {
    UI::ShowNotification("Plugin Name", msg, vec4(.2, .8, .5, .3), 6000);
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

[Setting category="~DEV" name="Show default OP logs"]
bool showDefaultLogs = false;

[Setting category="~DEV" name="Show Debug logs"]
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

[Setting category="~DEV" name="Show Debug logs (D)"]
bool showDLogs = true;

[Setting category="~DEV" name="Show Placeholder logs (PLACEHOLDER)"]
bool showPlaceholderLogs = true;


void log(const string &in msg, LogLevel level = LogLevel::Info, int line = -1) {
    string lineInfo = line >= 0 ? " " + tostring(line) : "";
    int lineLength = lineInfo.Length - 1;
    string extraSpaces = "";
    if (lineLength == 1) {        // 1 character
        extraSpaces = "   ";      // Three extra spaces
    } else if (lineLength == 2) { // 2 characters
        extraSpaces = "  ";       // Two extra spaces
    } else if (lineLength == 3) { // 3 characters
        extraSpaces = " ";        // One extra space
    }
    lineInfo += extraSpaces;

    bool doLog = false;

    switch(level) {
        case LogLevel::Info:  doLog = showInfoLogs;        break;
        case LogLevel::InfoG: doLog = showInfoGLogs;       break;
        case LogLevel::Warn:  doLog = showWarnLogs;        break;
        case LogLevel::Error: doLog = showErrorLogs;       break;
        case LogLevel::Test:  doLog = showTestLogs;        break;
        case LogLevel::D:     doLog = showDLogs;           break;
        case LogLevel::_:     doLog = showPlaceholderLogs; break;
    }

    if (!showDebugLogs) return;

    if (doLog) {
        switch(level) {
            case LogLevel::Info:  if(!showDefaultLogs) { print("\\$0ff[INFO]  " +       "\\$z" + "\\$0cc" + lineInfo + "\\$z" + msg); } else { trace(msg); } break;
            case LogLevel::InfoG: if(!showDefaultLogs) { print("\\$0f0[INFO-G]" +       "\\$z" + "\\$0c0" + lineInfo + "\\$z" + msg); } else { trace(msg); } break;
            case LogLevel::Warn:  if(!showDefaultLogs) { print("\\$ff0[WARN]  " +       "\\$z" + "\\$cc0" + lineInfo + "\\$z" + msg); } else { warn(msg);  } break;
            case LogLevel::Error: if(!showDefaultLogs) { print("\\$f00[ERROR] " +       "\\$z" + "\\$c00" + lineInfo + "\\$z" + msg); } else { error(msg); } break;
            case LogLevel::Test:  if(!showDefaultLogs) { print("\\$aaa[TEST]  " +       "\\$z" + "\\$aaa" + lineInfo + "\\$z" + msg); } else { trace(msg); } break;
            case LogLevel::D:     if(!showDefaultLogs) { print("\\$777[D]     " +       "\\$z" + "\\$777" + lineInfo + "\\$z" + msg); } else { trace(msg); } break;
            case LogLevel::_:     if(!showDefaultLogs) { print("\\$333[PLACEHOLDER] " + "\\$z" + "\\$333" + lineInfo + "\\$z" + msg); } else { trace(msg); } break;
        }
    }
}
