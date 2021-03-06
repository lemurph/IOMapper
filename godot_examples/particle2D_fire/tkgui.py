#!/usr/bin/env python

import tkinter
import sys
import mapper as mpr

def on_gui_change(x):
    sig_out.set_value(float(x))

dev = mpr.device("tkgui")

sig_out = dev.add_signal(mpr.DIR_OUT, "output", 1, mpr.FLT, None, 0, 100)

ui = tkinter.Tk()
ui.title("libmapper Python GUI demo")

name = tkinter.StringVar()
name.set("Waiting for device name...")
name_known = False
label = tkinter.Label(ui, textvariable=name)
label.pack()

w = tkinter.Scale(ui, from_=0, to=100, label='signal0',
                  orient=tkinter.HORIZONTAL, length=300,
                  command=on_gui_change)
w.pack()

def do_poll():
    global name_known
    dev.poll(20)
    if dev.ready and not name_known:
        name.set('Device name: %s, listening on port %s'%(dev[mpr.PROP_NAME], dev[mpr.PROP_PORT]))
        name_known = True
    ui.after(5, do_poll)

do_poll()
ui.mainloop()
