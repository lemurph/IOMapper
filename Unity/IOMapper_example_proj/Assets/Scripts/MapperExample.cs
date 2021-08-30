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
    private ParticleSystem ps;
    
    // Start is called before the first frame update
    void Start()
    {
        // Store particle system in ps
        ps = GetComponent<ParticleSystem>();
        
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
                float fval = *(float*)myValue;
                // Change value of particle system gravity
                var main = ps.main;
                main.gravityModifier = fval/50;  
            }
        }     
    }
    
    // Normalized update function, called once every physics update (instead of per frame)
    private void FixedUpdate()
    {

        
          
    }
}
