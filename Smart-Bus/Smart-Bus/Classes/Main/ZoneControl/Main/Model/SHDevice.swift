//
//  SHDevice.swift
//  Smart-Bus
//
//  Created by Mac on 2017/11/6.
//  Copyright © 2018 SmartHome. All rights reserved.
//

import UIKit

@objcMembers class SHDevice: NSObject {

    /// 子网ID
    var subNetID: UInt8 = 0
    
    /// 设备ID
    var deviceID: UInt8 = 0
    
    /// 设备类型
    var deviceType: UInt = 0
    
    /// 类型名称
    var deviceTypeName: String {        
        get {
            return typeNames[deviceType] ?? ""
        }
    }
    
    /// 备注说明
    var remark: String = ""
    
    override init() {
        super.init()
    }
    
    private lazy var typeNames: [UInt : String] = [
        
     1 : "SB-DN-D0610",
     2 : "SB-DN-D1210",
     3 : "SB-DN-D2405",
     4 : "SB-DN-D0620",
     5 : "SB-DN-D1210",
     6 : "SB-DN-D2405",
     7 : "SB-WL-D1210",
     8 : "SB-DN-D0620",
     9 : "SB-WL-D0610",

     11 : "SB-DN-R1220",
     12 : "SB-DN-R2420",
     13 : "SB-DN-48BNET",
     14 : "SB-DN-48BNET",
     15 : "SB-DN-D0602",
     16 : "SB-DN-48DMX",
     17 : "SB-DN-6B0-10v",
     18 : "SB-DN-48DMX",
     19 : "SB-DN-R1210",
    
     20 : "SB-DN-240DMX",
     21 : "SB-DN-512DMX",
     22 : "SB-DN-R1205",
     23 : "SB-DN-R0810",
     24 : "SB-P8",
     25 : "SB-DN-D0403",
     26 : "SB-WL-D2405",
     27 : "SB-WL-D0620",
     28 : "SB-DN-D0304",
     29 : "SB-MP24BUS",
    
     30 : "SB-DN-48BNET",
     31 : "SB-DN-48BNET",
     32 : "SB-DN-48DMX",
     33 : "SB-DN-SMS/IP",
     34 : "SB-DN-48BNET",
     35 : "SB-DN-6B0-10v",
    
     40 : "SB-DN-DALI48",
    
     50 : "SB-WS8",
     51 : "SB-WS8",
     52 : "SB-WS4",
     53 : "SB-WS4",
     54 : "SB-WS6",
     55 : "SB-WS6",
     56 : "SB-WS2",
     57 : "SB-WS2",
     58 : "SB-WS2",
     59 : "SB-MWH6",
    
     60 : "SB-WS8",
     61 : "SB-WS4",
     62 : "SB-MWH6",
     63 : "SB-WS4",
     64 : "SB-WS6",
     65 : "SB-WS6",
     66 : "SB-WS4",
     67 : "SB-WS4",
     68 : "SB-WS2",
     69 : "SB-WS1",
    
     70 : "SB-2RM-Part",
     71 : "SB-WS3",
     72 : "SB-WS3",
     73 : "SB-WS1",
     74 : "SB-WS4",
     75 : "SB-WS4",
     76 : "SB-WS6",
     77 : "SB-WS4",
     78 : "SB-AC-Edge",
     79 : "SB-DLP",
     
     80 : "SB-MS01R",
     81 : "SB-MS01L",
     82 : "SB-DLP",
     83 : "SB-AC-Edge",
     84 : "SB-DLP",
     85 : "SB-CTP",
     86 : "SB-DLP",
     87 : "SB-DLP",
     88 : "SB-DLP",
     89 : "SB-MWH6",
    
     90 : "SB-MS01R",
     91 : "SB-MS01R",
     92 : "SB-MS12",
     93 : "SB-DRY-4Z",
     94 : "SB-DN-IO6/6",
     95 : "SB-CMS-PIR",
     96 : "SB-MPE.2C",
     97 : "SB-WMS-PIR",
     98 : "SB-WMS-PIR",
     99 : "SB-CMS-PIR",
    
     100 : "SB-MT12IP",
     101 : "SB-MT12IP",
     102 : "SB-MT01IP",
     103 : "SB-MT12IP",
     104 : "SB-MT02IP",
     105 : "SB-MT02IP",
     108 : "SB-MT12IP",
     109 : "SB-DN-HVAC",
    
     110 : "SB-MT12IP",
     111 : "SB-DN-HVAC",
     112 : "SB-DN-HVAC",
     113 : "SB-DRY-32Z",
     114 : "SB-DRY-4Z",
     115 : "SB-DRY-4Z",
     116 : "SB-DRY-6Z",
     117 : "SB-DN-HVAC",
     118 : "SB-4Z-UN",
     119 : "SB-HVAC2-DN",
    
     120 : "SB-CMS-PIR",
     121 : "SB-4T-UN",
     122 : "SB-CMS-PIR",
     123 : "SB-CMS-PIR",
     124 : "SB-MTS.2C",
     125 : "SB-CMS-PIR",
     126 : "SB-CMS-PIR",
     127 : "SB-WMS-PIR",
     128 : "SB-DN-RS232N",
     129 : "SB-WMS-PIR",
    
     130 : "SB-WMS-PIR",
     131 : "SB-WMS-PIR",
     132 : "SB-WMS-PIR",
     133 : "SB-CMS-PIR",
     134 : "SB-MTS.2C",
     135 : "SB-WMS-PIR",
     
     147 : "SB-CDP",
     148 : "SB-DDP",
     149 : "SB-DDP",
    
     150 : "SB-DN-R1220",
     151 : "SB-DN-R2420",
     152 : "SB-DN-R0610",
     153 : "SB-DN-R0416",
     154 : "SB-DLP",
     155 : "SB-DLP-FH",
    
     192 : "SB-Mini-IO",
     198 : "SB-Ultrasonic",
    
     200 : "SB-DN-6RM-Part",

     236 : "SB-DN-1IP",
     237 : "SB-DN-4IP",
     238 : "SB-DN-8IP",
     239 :   "",
     
     240 : "SB-ArtSwitch",
     245 : "SB-WS1M",
     246 : "SB-WS2M",
     247 : "SB-WS2M",
     248 : "SB-WS4M",
     249 : "SB-WS8M",
    
     250 : "SB-WS6M",
     251 : "SB-WS5M",
     252 : "SB-WS4M",
     253 : "SB-WS3M",
     254 : "SB-WS2M",
     255 : "SB-WS1M",
     256 : "SB-WS3M",
     257 : "SB-WS2M",
     258 : "SB-WS1M",
     259 : "SB-WS2M",
    
     260 : "SB-WS6M",
     261 : "SB-WS1M",
     262 : "SB-WS2M",
     263 : "SB-WS2M",
     264 : "SB-WS3M",
     265 : "SB-WS4M",
     266 : "SB-WS5M",
     267 : "SB-WS6M",
     268 : "SB-WS5M",
     269 : "SB-WS3M",
    
     270 : "SB-WS1-Edge",
     271 : "SB-WS2-Edge",
     272 : "SB-WS3-Edge",
     273 : "SB-WS4-Edge",
     274 : "SB-FM-Edge",
     275 : "SB-1BS",
     276 : "SB-2BS",
     277 : "SB-2BS",
     278 : "SB-3BS",
     279 : "SB-4BS",
    
     280 : "SB-5BS",
     281 : "SB-6BS",
     282 : "SB-4BS",
     283 : "SB-6BS",
     284 : "SB-12BS",
     285 : "SB-MPN50",
     286 : "SB-MS104",
     287 : "SB-WS3M",
     288 : "SB-1B-TS",
     289 : "SB-2B-TS",
    
     290 : "SB-3B-TS",
     291 : "SB-1B-SL",
     292 : "SB-2B-SL",
     293 : "SB-3B-SL",
     294 : "SB-Slider",
     295 : "SB-Strata",
     296 : "SB-Melody",
     297 : "SB-People Counter",
     299 : "SB-IRMacro-UN",
    
     300 : "SB-IR-EM",
     301 : "SB-IR-EM",
     302 : "SB-IR-EM",
     303 : "SB-IR-EM",
     304 : "SB-IR-EM",
     305 : "SB-CMS-8in1",
     306 : "SB-IR-UN",
     307 : "SB-CMS-6in1",
     308 : "SB-CMS-10in1",
     309 : "SB-9in1T-CL",
    
     310 : "SB-CMS-THL",
     311 : "SB-CMS-LA",
     312 : "SB-CMS-TIR",
     313 : "SB-6in1TL-CL",
     314 : "SB-5in1TL-CL",
     315 : "SB-6in1TS-CL",
     316 : "SB-5in1TS-CL",
     317 : "SB-Microwave-CL",
     319 : "SB-8in1E-CL",
    
     320 : "SB-9in1T-CL",
     321 : "SB-6in1TL-CL",
     322 : "SB-5in1TL-CL",
     323 : "SB-6in1TS-CL",
     324 : "SB-5in1TS-CL",
     325 : "SB-MAGIC-BOX",
     355 : "SB-SWAVE-TC",
    
     400 : "SB-MAIR01",
     410 : "SB-RLY4c16A-DN",
     411 : "SB-RLY4c20A-DN",
     412 : "SB-RLY8c16A-DN",
     423 : "SB-RLY4c16A-DN",
     424 : "SB-RLY4c16A-DN",
     425 : "SB-RLY6c16A-DN",
     426 : "SB-RLY6c16A-DN",
     427 : "SB-DN-R0820",
     428 : "SB-RLY8c16A-DN",
     429 : "SB-DN-R1220",
    
     430 : "SB-DN-R1220",
     431 : "SB-DN-R1205",
     432 : "SB-DN-R2420",
     433 : "SB-DN-R0416",
     434 : "SB-RLY4c20A-DN",
     435 : "SB-DN-R0410",
     436 : "SB-DN-R0810",
     437 : "SB-DN-R0425",
     438 : "SB-2R-UN",
     439 : "SB-3R-UN",
    
     440 : "SB-RLY12c10A-DN",
     441 : "SB-ESR24-DN",
     442 : "SB-ESR28-DN",
     443 : "SB-DN-1B0-10v",
     445 : "SB-CAT1D1R-TS",
     446 : "SB-CAT3R-TS",
     447 : "SB-ESR10-DN",
     450 : "SB-DDPS",
     451 : "SB-DDPS",
     452 : "SB-NDP",
     460 : "SB-PIR+",
     
     500 : "SB-WL-TL7",
     550 : "SB-DIM8c1A-DN",
     599 : "SB-6FAN5S-DN",
    
     600 : "SB-DIM6c2A-DN",
     601 : "SB-DIM4c3A-DN",
     602 : "SB-DIM2c6A-DN",
     603 : "SB-DN-RMIX10",
     604 : "SB-DLP",
     605 : "SB-DLP",
     606 : "SB-DN-D0T203",
     607 : "SB-DN-D0T402",
     608 : "SB-DN-D0T601",
    
     700 : "SB-DN-2Motor",
     701 : "SB-DN-2Motor",
     702 : "SB-DN-2Motor",
     703 : "SB-DN-2Motor",
     704 : "SB-DN-2Motor",
     705 : "SB-DN-2Motor",
     
     800 : "SB-MDMXI08",
     850 : "SB-DN-96DMX",
     851 : "SB-DN-96DMX",
     898 : "SB-4LED-DCV",
     899 : "SB-DN-PM5",
    
     900 : "SB-DN-PM5",
     901 : "SB-Z-AUDIO",
     902 : "SB-ZAudio2-DN",
     950 : "SB-MHAI",
     951 : "SB-MCM",
     952 : "SB-IPIR-DN",
     970 : "SB-SMS",
     975 : "WI-MOTE",
     976 : "LI-MOTE",
     980 : "SB-Power Strip",
    
     1000 : "SB-DN-EIB",
     1001 : "SB-DN-EIB",
     1005 : "SB-MBUS-SAMSUNG",
     1006 : "SB-C-BUS",
     1007 : "SB-DN-RS232N",
     1008 : "SB-DN-RS232N",
     1009 : "SB-DN-RS232N",
     1010 : "SB-IR-Learn",
     1011 : "SB-DN-EIB",
     1012 : "SB-DN-EIB",
     1013 : "SB-DN-RS232IP-PRO",
     1015 : "SB-DN-VideoPlay",
     1016 : "SB-DN-RS232N",
     1017 : "SB-DN-RS232N-MC",
     
     1100 : "SB-DN-Logic960",
     1101 : "SB-DN-Logic960",
     1102 : "SB-DN-Logic960",
     1103 : "SB-DN-Logic960",
     1104 : "SB-DN-Logic960",
     1105 : "SB-DN-Logic960",
     1106 : "SB-Logic2-DN",
     1107 : "SB-Logic2-DN",
     1108 : "SB-Logic2-DN",
     1109 : "SB-Logic2-DN",
    
     1200 : "SB-DN-RS232N",
     1201 : "SB-RSIP-DN",
    
     1300 : "SB-Bridge",
    
     2000 : "SB_1D1R_TC",
     2001 : "SB_2D1R_TC",
     2002 : "SB_1D2R_TC",
     2003 : "SB_3R_TC",
     2004 : "SB_2R_TC",
    
     3049 : "SB-SEC250K-DN",
     3050 : "SB-WS1m",
     3051 : "SB-WS2m",
     3052 : "SB-WS3m",
     3053 : "SB-WS4m",
     3054 : "SB-3S-Bell",
     3055 : "SB-DN-SEC250K",
     3056 : "SB-3S-Bell",
     3057 : "SB-CRD-MSTR",
     3058 : "SB-CRD-MSTR",
     3059 : "SB-3S-Bell",
     3060 : "SB-CRD-MSTR",
     3061 : "SB-3S-Bell-XS",
     3062 : "SB-RF-MSTR",
     3063 : "SB-RF-MSTR",
     3064 : "SB-RF-MSTR",
     3065 : "SB-RF-MSTR",
     3066 : "SB-RF-MSTR",
    
     3100 : "SB-3 in 1 Sensors",
    
     3200 : "SB-3SBXS-WL",
     3201 : "SB-BedSd-UN",
     3202 : "SB-3SCARD-WL",
     3203 : "SB-HAPower-WL",
     3204 : "SB-IMPULSE-UN",
    
     3300 : "CSP",
     3301 : "WIMORE",
     3302 : "Android-IR",
     
     5000 : "SB-3SBXS-WL",
     5001 : "SB-3SBXS-WL",
    
     5010 : "SB-3SCARD-WL",
     5020 : "SB-ZMIX23-DN",
     5021 : "SB-MIX24-DN",
     5030 : "SB-BEDSD-UN",
     5040 : "SB-AUX-WL",
    
     5300 : "C-TOUCH",
    
     5400 : "SB-24Z-UN",
    
     5500 : "SB-CurrentSensor",
    
     65532: "",
     65534: ""
    ]
}
