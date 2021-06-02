#!/usr/bin/env python

import tkinter
import sys
import mapper as mpr


dev = mpr.device("player_gui")

sig_player1 = dev.add_signal(mpr.DIR_OUT, "player1_out", 1, mpr.INT32)
sig_player2 = dev.add_signal(mpr.DIR_OUT, "player2_out", 1, mpr.INT32)

root = tkinter.Tk()
root.title("Pong Player Controller")
root.geometry("600x175")

# Create labels
p1_label = tkinter.Label(text="Player 1")
p2_label = tkinter.Label(text="Player 2")

def player1_up():
    sig_player1.set_value(-1)
def player1_down():
    sig_player1.set_value(1)
def player1_stop_movement(event):
    sig_player1.set_value(0)

def player2_up():
    sig_player2.set_value(-1)
def player2_down():
    sig_player2.set_value(1)
def player2_stop_movement(event):
    sig_player2.set_value(0)

# Create buttons
p1up = tkinter.Button(root, text="▲", height=3, width=3, anchor="w", command=player1_up)
p1down = tkinter.Button(root, text="▼", height=3, width=3, anchor="w", command=player1_down)
p2up = tkinter.Button(root, text="▲", height=3, width=3, anchor="e", command=player2_up)
p2down = tkinter.Button(root, text="▼", height=3, width=3, anchor="e", command=player2_down)

# Bind buttons to functions
p1up.bind('<ButtonRelease-1>', lambda event: player1_stop_movement())
p1down.bind('<ButtonRelease-1>', lambda event: player1_stop_movement())
p2up.bind('<ButtonRelease-1>', lambda event: player2_stop_movement())
p2down.bind('<ButtonRelease-1>', lambda event: player2_stop_movement())

# Place buttons and labels
p1up.grid(row=1, column=0)
p1down.grid(row=2, column=0)
p2up.grid(row=1, column=2)
p2down.grid(row=2, column=2)
p1_label.grid(row=0, column=0)
p2_label.grid(row=0, column=2)

# Add device information
name = tkinter.StringVar()
name.set("Waiting for device name...")
name_known = False
label = tkinter.Label(root, textvariable=name)
label.grid(row=3, column=1)

def do_poll():
    global name_known
    dev.poll(20)
    if dev.ready and not name_known:
        name.set('Device name: %s, listening on port %s'%(dev[mpr.PROP_NAME], dev[mpr.PROP_PORT]))
        name_known = True
    root.after(5, do_poll)

do_poll()
root.mainloop()
