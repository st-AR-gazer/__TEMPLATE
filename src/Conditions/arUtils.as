// Fun Utils I use from time to time

namespace _Text {
    int NthLastIndexOf(const string &in str, const string &in value, int n) {
        int index = -1;
        for (int i = str.Length - 1; i >= 0; --i) {
            if (str.SubStr(i, value.Length) == value) {
                if (n == 1) {
                    index = i;
                    break;
                }
                --n;
            }
        }
        return index;
    }
}

namespace _UI {
    void SimpleTooltip(const string &in msg) {
        if (UI::IsItemHovered()) {
            UI::SetNextWindowSize(400, 0, UI::Cond::Appearing);
            UI::BeginTooltip();
            UI::TextWrapped(msg);
            UI::EndTooltip();
        }
    }

    void DisabledButton(const string &in text, const vec2 &in size = vec2 ( )) {
        UI::BeginDisabled();
        UI::Button(text, size);
        UI::EndDisabled();
    }

    bool DisabledButton(bool disabled, const string &in text, const vec2 &in size = vec2 ( )) {
        if (disabled) {
            DisabledButton(text, size);
            return false;
        } else {
            return UI::Button(text, size);
        }
    }
}

namespace _IO {
    namespace Directory {
        bool IsDirectory(const string &in path) {
            if (path.EndsWith("/") || path.EndsWith("\\")) return true;
            return false;
        }
        
        string GetParentDirectoryName(const string &in path) {
            string trimmedPath = path;

            if (!IsDirectory(trimmedPath)) {
                return _IO::File::GetFilePathWithoutFileName(trimmedPath);
            }

            if (trimmedPath.EndsWith("/") || trimmedPath.EndsWith("\\")) {
                trimmedPath = trimmedPath.SubStr(0, trimmedPath.Length - 1);
            }
            
            int index = trimmedPath.LastIndexOf("/");
            int index2 = trimmedPath.LastIndexOf("\\");

            index = Math::Max(index, index2);

            if (index == -1) {
                return "";
            }

            return trimmedPath.SubStr(index + 1);
        }
    }

    namespace File {
        bool IsFile(const string &in path) {
            if (IO::FileExists(path)) return true;
            return false;
        }

        void WriteFile(string _path, const string &in content, bool verbose = false) {
            string path = _path;
            if (verbose) log("Writing to file: " + path, LogLevel::Info, 84, "WriteFile");

            if (path.EndsWith("/") || path.EndsWith("\\")) { log("Invalid file path: " + path, LogLevel::Error, 86, "WriteFile"); return; }

            IO::File file;
            file.Open(path, IO::FileMode::Write);
            file.Write(content);
            file.Close();
        }

        string GetFilePathWithoutFileName(const string &in path) {
            int index = path.LastIndexOf("/");
            int index2 = path.LastIndexOf("\\");

            index = Math::Max(index, index2);

            if (index == -1) {
                return "";
            }
        
            return path.SubStr(0, index);
        }

        void WriteJsonFile(const string &in path, const Json::Value &in value) {
            string content = Json::Write(value);
            WriteFile(path, content);
        }

        // Read from file
        string ReadFileToEnd(const string &in path, bool verbose = false) {
            if (verbose) log("Reading file: " + path, LogLevel::Info, 114, "ReadFileToEnd");
            if (!IO::FileExists(path)) { log("File does not exist: " + path, LogLevel::Error, 115, "ReadFileToEnd"); return ""; }

            IO::File file(path, IO::FileMode::Read);
            string content = file.ReadToEnd();
            file.Close();
            return content;
        }
        
        string ReadSourceFileToEnd(const string &in path, bool verbose = false) {
            if (!IO::FileExists(path)) { log("File does not exist: " + path, LogLevel::Error, 124, "ReadSourceFileToEnd"); return ""; }

            IO::FileSource f(path);
            string content = f.ReadToEnd();
            return content;
        }

        // Move file
        void CopySourceFileToNonSource(const string &in originalPath, const string &in storagePath, bool verbose = false) {
            if (verbose) log("Moving the file content", LogLevel::Info, 133, "CopySourceFileToNonSource");
            
            string fileContents = ReadSourceFileToEnd(originalPath);
            WriteFile(storagePath, fileContents);

            if (verbose) log("Finished moving the file", LogLevel::Info, 138, "CopySourceFileToNonSource");

            // TODO: Must check how IO::Move works with source files
        }

        // Copy file
        void CopyFileTo(const string &in source, const string &in destination, bool verbose = false) {
            if (!IO::FileExists(source)) { if (verbose) log("Source file does not exist: " + source, LogLevel::Error, 145, "CopyFileTo"); return; }
            if (IO::FileExists(destination)) { if (verbose) log("Destination file already exists: " + destination, LogLevel::Error, 146, "CopyFileTo"); return; }

            string content = ReadFileToEnd(source, verbose);
            WriteFile(destination, content, verbose);
        }

        // Rename file
        void RenameFile(const string &in filePath, const string &in newFileName, bool verbose = false) {
            if (verbose) log("Attempting to rename file: " + filePath, LogLevel::Info, 154, "RenameFile");
            if (!IO::FileExists(filePath)) { log("File does not exist: " + filePath, LogLevel::Error, 155, "RenameFile"); return; }

            string currentPath = filePath;
            string newPath;

            string sanitizedNewName = Path::SanitizeFileName(newFileName);

            if (Directory::IsDirectory(newPath)) {
                while (currentPath.EndsWith("/") || currentPath.EndsWith("\\")) {
                    currentPath = currentPath.SubStr(0, currentPath.Length - 1);
                }

                string parentDirectory = Path::GetDirectoryName(currentPath);
                newPath = Path::Join(parentDirectory, sanitizedNewName);
            } else {
                string directoryPath = Path::GetDirectoryName(currentPath);
                string extension = Path::GetExtension(currentPath);
                newPath = Path::Join(directoryPath, sanitizedNewName + extension);
            }

            IO::Move(currentPath, newPath);
        }
    }

    void OpenFolder(const string &in path, bool verbose = false) {
        if (IO::FolderExists(path)) {
            OpenExplorerPath(path);
        } else {
            if (verbose) log("Folder does not exist: " + path, LogLevel::Info, 183, "OpenFolder");
        }
    }
}

namespace _Game {
    bool IsMapLoaded() {
        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app.RootMap is null) return false;
        return true;
    }

    bool IsPlayingMap() {
        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app is null) return false;

        CSmArenaClient@ playground = cast<CSmArenaClient>(app.CurrentPlayground);
        return !(playground is null || playground.Arena.Players.Length == 0);
    }

    bool IsInEditor() {
        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app is null) return false;

        CSmArenaClient@ e = cast<CSmArenaClient>(app.Editor);
        if (e !is null) return true;
        return false;
    }

    bool IsPlayingInEditor() {
        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app is null) return false;

        CSmArenaClient@ e = cast<CSmArenaClient>(app.Editor);
        if (e is null) return false;
        
        CSmArenaClient@ playground = cast<CSmArenaClient>(app.CurrentPlayground);
        if (playground is null) return false;

        return true;
    }
}

namespace _Net {
    dictionary downloadedFilePaths;

    void DownloadFileToDestination(const string &in url, const string &in destination, const string &in key, const string &in overwriteFileName = "", bool noTmp = false) {
        string userdata = url + "|" + destination + "|" + key + "|" + overwriteFileName + "|" + noTmp;
        startnew(Hidden::CoroDownloadFileToDestination, userdata);
    }

    namespace Hidden {
        void CoroDownloadFileToDestination(const string &in userdata) {
            array<string> parts = userdata.Split("|");
            if (parts.Length != 5) {
                log("Invalid userdata format.", LogLevel::Error, 238, "CoroDownloadFileToDestination");
                return;
            }
            string url = parts[0];
            string destination = parts[1];
            string key = parts[2];
            string overwriteFileName = parts[3];
            // bool noTmp = parts[4] == "true";
            destination = Path::GetDirectoryName(destination);

            Net::HttpRequest@ request = Net::HttpRequest();
            request.Url = url;
            request.Method = Net::HttpMethod::Get;
            request.Start();

            while (!request.Finished()) {
                yield();
            }

            if (request.ResponseCode() == 200) {
                string content_disposition = Json::Write(request.ResponseHeaders().ToJson().Get("content-disposition"));
                string file_name = overwriteFileName;

                if (file_name == "") {
                    if (content_disposition != "") {
                        int index = content_disposition.IndexOf("filename=");
                        if (index != -1) {
                            file_name = content_disposition.SubStr(index + 9);
                            file_name = file_name.Trim();
                            file_name = file_name.Replace("\"", "");
                        }
                    } 
                    
                    if (file_name == "") {
                        file_name = Path::GetFileName(url);
                    }
                }

                destination = Path::Join(destination, file_name);
                if (destination.EndsWith("/") || destination.EndsWith("\\")) {
                    destination = destination.SubStr(0, destination.Length - 1);
                }

                string tmp_path = Path::Join(IO::FromUserGameFolder(""), file_name);

                request.SaveToFile(tmp_path);
                _IO::File::CopyFileTo(tmp_path, destination);

                if (!IO::FileExists(tmp_path)) { log("Failed to save file to: " + tmp_path, LogLevel::Error, 286, "CoroDownloadFileToDestination"); return; }
                if (!IO::FileExists(destination)) { log("Failed to move file to: " + destination, LogLevel::Error, 287, "CoroDownloadFileToDestination"); return; }

                IO::Delete(tmp_path);

                if (!IO::FileExists(tmp_path) && IO::FileExists(destination)) {
                    log("File downloaded successfully, saving " + file_name + " to: " + destination, LogLevel::Info, 292, "CoroDownloadFileToDestination");

                    downloadedFilePaths[key] = key;
                    downloadedFilePaths[key] = destination;

                    while (true) {
                        sleep(10000);
                        array<string> keys = downloadedFilePaths.GetKeys();
                        for (uint i = 0; i < keys.Length; i++) {
                            downloadedFilePaths.Delete(keys[i]);
                        }
                    }
                }
            } else {
                log("Failed to download file. Response code: " + request.ResponseCode(), LogLevel::Info, 306, "CoroDownloadFileToDestination");
            }
        }
    }
}