package main;

import (
	"fmt"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
)

type Window struct {
	group int
	num int
	last_accessed int
	name string
}

const (
	CurrentGroup int = iota
	PreviousGroup
	OldGroup
)

type Group struct {
	num int
	status int
	name string
}

type Ratpoison struct {
	command string
	current_group int
	groups []Group
}

func NewRatpoison(command string) *Ratpoison {
	return &Ratpoison{command, 0, []Group{}}
}

func (r *Ratpoison) Call(args ...string) (string, error) {
	a := []string{}
	for i := range args {
		a = append(a, "-c", args[i])
	}
	//fmt.Println("Calling: ", a)
	c := exec.Command(r.command, a...)
	b, err := c.Output()
	return string(b), err
}

func (r *Ratpoison) GetGroups() {
	o, _ := r.Call("groups");
	arr := strings.Split(o, "\n")
	rx := regexp.MustCompile("([0-9]+)(.)(.+)");
	for i := range arr {
		if arr[i] == "" {
			break
		}
		matches := rx.FindStringSubmatch(arr[i])
		if len(matches) != 4 {
			fmt.Println("Invalid length:", len(matches))
			continue
		}
		g := new(Group)
		g.num, _ = strconv.Atoi(matches[1])
		if matches[2] == "*" {
			r.current_group = g.num
			g.status = CurrentGroup;
		} else if matches[2] == "+" {
			g.status = PreviousGroup
		} else {
			g.status = OldGroup
		}
		g.name = matches[3]
		//fmt.Println("Adding group:", *g)
		r.groups = append(r.groups, *g)
	}
}

type GroupCb func(Group)
func (r *Ratpoison) WalkGroups(cb GroupCb) {
	if len(r.groups) == 0 {
		r.GetGroups()
	}
	cur := r.current_group
	for i := range r.groups {
		r.Call(fmt.Sprint("gselect ", r.groups[i].num))
		r.current_group = r.groups[i].num
		cb(r.groups[i])
	}
	r.Call(fmt.Sprint("gselect ", cur))
	r.current_group = cur
}

func (r *Ratpoison) GetWindows() ([]Window) {
	windows := []Window{}
	s, _ := r.Call("windows %n<|>%l<|>%t")
	ss := strings.Split(s, "\n")
	for i := range ss {
		if ss[i] == "" {
			continue
		}
		arr := strings.Split(ss[i], "<|>")
		//fmt.Println("\t", arr)
		if len(arr) != 3 {
			//fmt.Println("\tInvalid length: ", arr)
			continue;
		}
		w := new(Window)
		w.group = r.current_group
		w.num, _ = strconv.Atoi(arr[0])
		w.last_accessed, _ = strconv.Atoi(arr[1])
		w.name = arr[2]
		windows = append(windows, *w)
		//fmt.Println("\t", w)
	}
	return windows
}

