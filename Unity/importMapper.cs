using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;
using System.Text;

public class Mapper : MonoBehaviour
{

    /*
        DIRECTION
        IN = 1
        OUT = 2

        MPR_BOOL            = 'b',   0x62 !< Boolean value. 
        MPR_TYPE            = 'c',   0x63 !< libmapper data type. 
        MPR_DBL             = 'd',   0x64 !< 64-bit floating point. 
        MPR_FLT             = 'f',   0x66 !< 32-bit floating point. 
        MPR_INT64           = 'h',   0x68 !< 64-bit integer. 
        MPR_INT32           = 'i',   0x69 !< 32-bit integer
        MPR_STR             = 's',   0x73 !< String. 
        MPR_TIME            = 't',   0x74 !< 64-bit NTP timestamp. 
        MPR_PTR             = 'v',   0x76 !< pointer. 
        MPR_NULL            = 'N'    0x4E !< NULL value. 

    */

    IntPtr dev = IntPtr.Zero;
    IntPtr sig = IntPtr.Zero;
    private float myValue;

    // Define libmapper function for new device
    [DllImport ("mapper")]
    private static extern IntPtr mpr_dev_new(String name_prefix, int graph);
    [DllImport ("mapper")]
    private static extern int mpr_dev_poll(IntPtr dev, int block_ms);
    [DllImport ("mapper")]
    private static extern IntPtr mpr_sig_new(IntPtr parent_dev, int dir, String name, int length,
                    int type, int unit, int min, int max,
                    int num_inst, int h, int events);
    [DllImport ("mapper")]                
    private static extern float mpr_sig_get_value(IntPtr signal, int instance, int time);

    // Start is called before the first frame update
    void Start()
    {
        dev = mpr_dev_new("Test", 0);
        sig = mpr_sig_new(dev, 1, "test_sig", 1, 102, 0, 0, 0, 0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {   
        mpr_dev_poll(dev, 0);   
        myValue = mpr_sig_get_value(sig, 0, 0);     
    }

    // Normalized update function, called once every physics update (instead of per frame)
    private void FixedUpdate()
    {
       
    }

}
