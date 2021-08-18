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
    private float myValue;
    
    // Start is called before the first frame update
    void Start()
    {
        dev = IOMapper.mpr_dev_new("Test", 0);
        sig = IOMapper.mpr_sig_new(dev, IOMapper.Direction.INCOMING, "test_sig", 1, IOMapper.Type.FLOAT, 0, 0, 0, 0, 0, 0);
    }
    
    // Update is called once per frame
    void Update()
    {   
        IOMapper.mpr_dev_poll(dev, 0);   
        myValue = IOMapper.mpr_sig_get_value(sig, 0, 0);     
    }
    
    // Normalized update function, called once every physics update (instead of per frame)
    private void FixedUpdate()
    {
    
    }
}
