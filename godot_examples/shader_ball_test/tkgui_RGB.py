#!/usr/bin/env python

import tkinter
import sys
import mapper as mpr

def on_r_change(x):
    sig_r.set_value(float(int(x)/100))
def on_g_change(x):
    sig_g.set_value(float(int(x)/100))
def on_b_change(x):
    sig_b.set_value(float(int(x)/100))
def toggle_physics():
    if (sig_physics.value() == 1):
        sig_physics.set_value(0)
    elif (sig_physics.value() == 0):
        sig_physics.set_value(1)




dev = mpr.device("tkgui")

sig_physics = dev.add_signal(mpr.DIR_OUT, "physics", 1, mpr.INT32, None, 0, 1)
sig_physics.set_value(0)
sig_r = dev.add_signal(mpr.DIR_OUT, "r", 1, mpr.FLT, None, 0, 1)
sig_g = dev.add_signal(mpr.DIR_OUT, "g", 1, mpr.FLT, None, 0, 1)
sig_b = dev.add_signal(mpr.DIR_OUT, "b", 1, mpr.FLT, None, 0, 1)

ui = tkinter.Tk()
ui.title("RGB godot_mapper Demo")

name = tkinter.StringVar()
name.set("Waiting for device name...")
name_known = False
label = tkinter.Label(ui, textvariable=name)
label.pack()

physics_button = tkinter.Button(ui, text="Toggle Physics", height=1, width=10, anchor="s", command=toggle_physics)

r = tkinter.Scale(ui, from_=0, to=100, label='R',
                  orient=tkinter.HORIZONTAL, length=300,
                  command=on_r_change)
g = tkinter.Scale(ui, from_=0, to=100, label='G',
                  orient=tkinter.HORIZONTAL, length=300,
                  command=on_g_change)
b = tkinter.Scale(ui, from_=0, to=100, label='B',
                  orient=tkinter.HORIZONTAL, length=300,
                  command=on_b_change)
r.pack()
g.pack()
b.pack()
physics_button.pack()

def do_poll():
    global name_known
    dev.poll(20)
    if dev.ready and not name_known:
        name.set('Device name: %s, listening on port %s'%(dev[mpr.PROP_NAME], dev[mpr.PROP_PORT]))
        name_known = True
    ui.after(5, do_poll)

do_poll()
ui.mainloop()
