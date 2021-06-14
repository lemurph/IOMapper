#!/usr/bin/env python

# Adapted from code found at https://stackoverflow.com/questions/64069914/get-specific-frequency-from-audio-input-using-pyaudio

import tkinter
import sys
import mapper as mpr
import pyaudio
import numpy as np


# Initialize device and signal
dev = mpr.device("microphone")
frequency = dev.add_signal(mpr.DIR_OUT, "frequency", 1, mpr.FLT, None, None, None)

# Audio variables
CHUNK = 4096
RATE = 44100
power = 12

# Opens audio stream
p = pyaudio.PyAudio()
stream=p.open(format=pyaudio.paInt16,channels=1,rate=RATE,input=True,frames_per_buffer=CHUNK)

while True:

    # Poll device
    dev.poll()

    # Reads the data
    data = np.fromstring(stream.read(CHUNK),dtype=np.int16)

    # Calculates the peak of the frequency
    peak = np.average(np.abs(data))*2

    # Shows the bars for amplitude
    bars = "#"*int(50*peak/2**power)

    # Calculates the frequency from with the peak ws
    data = data * np.hanning(len(data)) 
    fft = abs(np.fft.fft(data).real)
    fft = fft[:int(len(fft)/2)]
    freq = np.fft.fftfreq(CHUNK,1.0/RATE)
    freq = freq[:int(len(freq)/2)]
    freqPeak = freq[np.where(fft==np.max(fft))[0][0]]+1

    # Shows the peak frequency and the bars for the amplitude; sets frequency signal value to freqPeak
    print("peak frequency: %d Hz"%freqPeak + " "+bars)
    frequency.set_value(freqPeak)
stream.stop_stream()
stream.close()
p.terminate()