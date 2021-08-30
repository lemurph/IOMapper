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
        private static extern IntPtr mpr_sig_new(IntPtr parent_dev, Direction dir, String name, int length,
                        Type type, int unit, int min, int max, int num_inst, int h, int events);
        [DllImport ("mapper")]                
        public static extern IntPtr mpr_sig_get_value(IntPtr signal, int instance, int time);
        [DllImport ("mapper")]
        public static extern void mpr_sig_set_value(IntPtr signal, int id, int len, Type type, IntPtr val);
        [DllImport ("mapper")]
        private static extern int mpr_sig_reserve_inst(IntPtr sig, int num_reservations, int[] ids, IntPtr[] values);
        [DllImport ("mapper")]
        public static extern void mpr_sig_release_inst(IntPtr sig, int id);
        [DllImport ("mapper")]
        public static extern int mpr_sig_get_inst_is_active(IntPtr sig, int id);
        
        // Function overloads to allow calling the function without unnecessary parameters 
        public static IntPtr mpr_dev_new(String name_prefix) {
            return mpr_dev_new(name_prefix, 0);
        }
        public static int mpr_dev_poll(IntPtr dev) {
            return mpr_dev_poll(dev, 0);
        }
        public static int mpr_sig_reserve_inst(IntPtr sig, int num_reservations) {
            return mpr_sig_reserve_inst(sig, num_reservations, null, null);
        }
        public static IntPtr mpr_sig_new(IntPtr parent_dev, Direction dir, String name, int length, Type type) {
            return mpr_sig_new(parent_dev, dir, name, length, type, 0, 0, 0, 0, 0, 0);
        }
        public static IntPtr mpr_sig_get_value(IntPtr signal) {
            return mpr_sig_get_value(signal, 0, 0);
        }
        public static IntPtr mpr_sig_get_value(IntPtr signal, int instance) {
            return mpr_sig_get_value(signal, instance, 0);
        }
    }
}




