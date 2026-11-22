// Steward updater for WoW: Forever. Double-click it: it finds your AddOns folder, checks the version of Steward on
// GitHub against the one you have, and if there's a newer one downloads it and swaps it in. Your settings live in WoW's
// WTF folder and are not touched. Source: github.com/nickmgoo-afk/Catan (updater/main.go).
package main

import (
	"archive/zip"
	"bufio"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
	"time"
)

const (
	zipURL = "https://github.com/nickmgoo-afk/Catan/raw/main/Steward.zip"
	tocURL = "https://github.com/nickmgoo-afk/Catan/raw/main/Steward/Steward.toc"
)

var in = bufio.NewReader(os.Stdin)

func say(f string, a ...interface{}) { fmt.Printf(f+"\n", a...) }

func finish(code int) {
	fmt.Print("\nPress Enter to close.")
	in.ReadString('\n')
	os.Exit(code)
}

func fail(f string, a ...interface{}) {
	say("")
	say("Something went wrong: "+f, a...)
	finish(1)
}

func isDir(p string) bool { st, err := os.Stat(p); return err == nil && st.IsDir() }

// the AddOns folder of WoW: Forever, or "" if not found
func addonsFrom(p string) string {
	p = filepath.Clean(strings.Trim(strings.TrimSpace(p), `"`))
	cands := []string{
		p,
		filepath.Join(p, "AddOns"),
		filepath.Join(p, "Interface", "AddOns"),
		filepath.Join(p, "_forever_", "Interface", "AddOns"),
	}
	for _, c := range cands {
		if strings.EqualFold(filepath.Base(c), "AddOns") && isDir(c) {
			return c
		}
	}
	return ""
}

func configPath() string {
	exe, err := os.Executable()
	if err != nil {
		return ""
	}
	return filepath.Join(filepath.Dir(exe), "StewardUpdater-folder.txt")
}

func findAddons() string {
	// 1. where it was last time
	if cp := configPath(); cp != "" {
		if b, err := os.ReadFile(cp); err == nil {
			if a := addonsFrom(string(b)); a != "" {
				return a
			}
		}
	}
	// 2. this program sits inside the WoW folder (or its AddOns folder)
	if exe, err := os.Executable(); err == nil {
		d := filepath.Dir(exe)
		for i := 0; i < 5 && d != filepath.Dir(d); i++ {
			if a := addonsFrom(d); a != "" {
				return a
			}
			d = filepath.Dir(d)
		}
	}
	// 3. the usual places
	for _, drive := range []string{"C", "D", "E", "F"} {
		for _, base := range []string{`\Program Files (x86)\World of Warcraft`, `\Program Files\World of Warcraft`, `\World of Warcraft`, `\Games\World of Warcraft`, `\Battle.net\World of Warcraft`} {
			if a := addonsFrom(filepath.Join(drive+":", base, "_forever_")); a != "" {
				return a
			}
		}
	}
	return ""
}

func versionIn(text string) string {
	m := regexp.MustCompile(`(?m)^##\s*Version:\s*([0-9][0-9.]*)`).FindStringSubmatch(text)
	if m == nil {
		return ""
	}
	return m[1]
}

// -1, 0, 1 like a > b
func cmpVersion(a, b string) int {
	pa, pb := strings.Split(a, "."), strings.Split(b, ".")
	for i := 0; i < len(pa) || i < len(pb); i++ {
		var x, y int
		if i < len(pa) {
			x, _ = strconv.Atoi(pa[i])
		}
		if i < len(pb) {
			y, _ = strconv.Atoi(pb[i])
		}
		if x != y {
			if x > y {
				return 1
			}
			return -1
		}
	}
	return 0
}

var client = &http.Client{Timeout: 10 * time.Minute}

func get(url string) (*http.Response, error) {
	req, err := http.NewRequest("GET", url+"?t="+strconv.FormatInt(time.Now().Unix(), 10), nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("User-Agent", "StewardUpdater")
	req.Header.Set("Cache-Control", "no-cache")
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	if resp.StatusCode != 200 {
		resp.Body.Close()
		return nil, fmt.Errorf("GitHub answered %s", resp.Status)
	}
	return resp, nil
}

func extract(zipFile, dest string) error {
	r, err := zip.OpenReader(zipFile)
	if err != nil {
		return err
	}
	defer r.Close()
	root := filepath.Clean(dest) + string(os.PathSeparator)
	n := 0
	for _, f := range r.File {
		name := filepath.FromSlash(f.Name)
		target := filepath.Join(dest, name)
		if !strings.HasPrefix(filepath.Clean(target)+string(os.PathSeparator), root) {
			return fmt.Errorf("the download holds a bad path: %s", f.Name)
		}
		if f.FileInfo().IsDir() {
			os.MkdirAll(target, 0755)
			continue
		}
		os.MkdirAll(filepath.Dir(target), 0755)
		src, err := f.Open()
		if err != nil {
			return err
		}
		out, err := os.Create(target)
		if err != nil {
			src.Close()
			return err
		}
		_, err = io.Copy(out, src)
		src.Close()
		out.Close()
		if err != nil {
			return err
		}
		n++
	}
	if n == 0 {
		return fmt.Errorf("the download was empty")
	}
	return nil
}

func main() {
	say("Steward updater")
	say("===============")
	say("")

	addons := findAddons()
	for addons == "" {
		say("I couldn't find World of Warcraft: Forever's AddOns folder.")
		say(`Paste the path of your WoW folder (the one with _forever_ in it), then press Enter.`)
		say(`For example:  C:\Program Files (x86)\World of Warcraft`)
		fmt.Print("> ")
		line, _ := in.ReadString('\n')
		if strings.TrimSpace(line) == "" {
			finish(1)
		}
		addons = addonsFrom(line)
		if addons == "" {
			say("That folder has no Interface\\AddOns inside. Try again.\n")
		}
	}
	if cp := configPath(); cp != "" {
		os.WriteFile(cp, []byte(addons), 0644)
	}
	say("AddOns folder: %s", addons)

	mine := ""
	dir := filepath.Join(addons, "Steward")
	if b, err := os.ReadFile(filepath.Join(dir, "Steward.toc")); err == nil {
		mine = versionIn(string(b))
	}
	if mine == "" {
		say("Steward installed: none")
	} else {
		say("Steward installed: %s", mine)
	}

	resp, err := get(tocURL)
	if err != nil {
		fail("couldn't reach GitHub (%v). Check your internet connection.", err)
	}
	b, _ := io.ReadAll(resp.Body)
	resp.Body.Close()
	latest := versionIn(string(b))
	if latest == "" {
		fail("couldn't read the newest version number from GitHub.")
	}
	say("Newest on GitHub:  %s", latest)
	if mine != "" && cmpVersion(mine, latest) >= 0 {
		say("")
		say("You're up to date. Nothing to do.")
		finish(0)
	}

	say("")
	say("Downloading Steward %s (about 24 MB)...", latest)
	resp, err = get(zipURL)
	if err != nil {
		fail("the download failed (%v).", err)
	}
	tmp, err := os.CreateTemp("", "Steward-*.zip")
	if err != nil {
		fail("couldn't make a temporary file (%v).", err)
	}
	_, err = io.Copy(tmp, resp.Body)
	resp.Body.Close()
	tmp.Close()
	defer os.Remove(tmp.Name())
	if err != nil {
		fail("the download stopped part way (%v). Try again.", err)
	}

	say("Unpacking...")
	stage := filepath.Join(addons, ".Steward-update")
	os.RemoveAll(stage)
	if err := extract(tmp.Name(), stage); err != nil {
		os.RemoveAll(stage)
		if os.IsPermission(err) {
			fail("Windows wouldn't let me write to the AddOns folder. Right-click StewardUpdater and choose \"Run as administrator\".")
		}
		fail("couldn't unpack the download (%v).", err)
	}
	newDir := filepath.Join(stage, "Steward")
	nb, err := os.ReadFile(filepath.Join(newDir, "Steward.toc"))
	if err != nil || versionIn(string(nb)) == "" {
		os.RemoveAll(stage)
		fail("the download doesn't look like Steward. Nothing was changed.")
	}

	say("Installing...")
	old := ""
	if isDir(dir) {
		old = filepath.Join(addons, ".Steward-old")
		os.RemoveAll(old)
		if err := os.Rename(dir, old); err != nil {
			os.RemoveAll(stage)
			fail("couldn't move the old Steward aside (%v). Close WoW and try again, or run as administrator.", err)
		}
	}
	if err := os.Rename(newDir, dir); err != nil {
		if old != "" {
			os.Rename(old, dir) // put the old one back
		}
		os.RemoveAll(stage)
		fail("couldn't put the new Steward in place (%v). Your old Steward is unchanged.", err)
	}
	os.RemoveAll(stage)
	if old != "" {
		os.RemoveAll(old)
	}

	say("")
	say("Done: Steward %s is installed.", versionIn(string(nb)))
	say("If WoW is open, close it and start it again.")
	finish(0)
}
