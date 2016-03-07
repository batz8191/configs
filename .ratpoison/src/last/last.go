package main

import (
	"fmt"
	"sort"
)

type WindowSlice []Window
func (w WindowSlice) Len() int { return len(w) }
func (w WindowSlice) Less(i, j int) bool { return w[i].last_accessed < w[j].last_accessed; }
func (w WindowSlice) Swap(i, j int) { w[i], w[j] = w[j], w[i] }
func (w WindowSlice) Sort() { sort.Sort(w) }

func main() {
	rp := NewRatpoison("ratpoison")
	windows := []Window{}
	rp.WalkGroups(func(g Group) () {
		wins := rp.GetWindows()
		windows = append(windows, wins...)
	})
	sort.Sort(WindowSlice(windows))
	last := windows[len(windows) - 2]
	fmt.Println("last=", last, " current=", rp.current_group)
	if last.group != rp.current_group {
		rp.Call("select -", fmt.Sprint("gselect ", last.group), fmt.Sprint("select ", last.num))
	} else {
		rp.Call(fmt.Sprint("select ", last.num))
	}
}
