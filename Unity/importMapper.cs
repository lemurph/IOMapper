using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;
using System.Text;

namespace Mapper {

    public class IOMapper
    {
        public enum Direction {
            INCOMING = 0x01,
            OUTGOING = 0x02,
            ANY = 0x03,
            BOTH = 0x04,
        }
        public enum Type {
            DOUBLE = 0x64,
            FLOAT = 0x66,
            INT32 = 0x69,
            INT64 = 0x68,
        }

        // Define libmapper function for new device
        [DllImport ("mapper")]
        public static extern IntPtr mpr_dev_new(String name_prefix, int graph);
        [DllImport ("mapper")]
        public static extern int mpr_dev_poll(IntPtr dev, int block_ms);
        [DllImport ("mapper")]
        public static extern IntPtr mpr_sig_new(IntPtr parent_dev, Direction dir, String name, int length,
                        Type type, int unit, int min, int max,
                        int num_inst, int h, int events);
        [DllImport ("mapper")]                
        public static extern float mpr_sig_get_value(IntPtr signal, int instance, int time);

    }
}




