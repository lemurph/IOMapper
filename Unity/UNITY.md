# Using IOMapper with Unity

### This is a basic example of creating a device and signal in Unity with IOMapper

The first step is to include the importMapper.cs script in your Unity project.

After that file is included, the following script will create a device, attatch a signal, and poll the device. It may be helpful to use MapperExample.cs and alter it as necessary

```C#
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;
using System.Text;

/* ~~~~~~~~~~~~~~~~~~~
    Example of usage 
   ~~~~~~~~~~~~~~~~~~~ */
using Mapper; 

public class MapperExample : MonoBehaviour {
    
    IntPtr dev = IntPtr.Zero;
    IntPtr sig = IntPtr.Zero;
    
    // Start is called before the first frame update
    void Start()
    {
        dev = IOMapper.mpr_dev_new("Test");
        sig = IOMapper.mpr_sig_new(dev, IOMapper.Direction.INCOMING, "test_sig", 1, IOMapper.Type.FLOAT);
    }
    
    // Update is called once per frame
    void Update()
    {   
        IOMapper.mpr_dev_poll(dev);
        IntPtr myValue = IOMapper.mpr_sig_get_value(sig);
        if (myValue != IntPtr.Zero) {
            unsafe {
                // float can be replaced with the type being used
                float floatValue = *(float*)myValue;
                /* Do something with floatValue */
            }
        }     
    }

}


```
