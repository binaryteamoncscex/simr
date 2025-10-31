; ModuleID = 'marshal_methods.x86.ll'
source_filename = "marshal_methods.x86.ll"
target datalayout = "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i686-unknown-linux-android21"

%struct.MarshalMethodName = type {
	i64, ; uint64_t id
	ptr ; char* name
}

%struct.MarshalMethodsManagedClass = type {
	i32, ; uint32_t token
	ptr ; MonoClass klass
}

@assembly_image_cache = dso_local local_unnamed_addr global [222 x ptr] zeroinitializer, align 4

; Each entry maps hash of an assembly name to an index into the `assembly_image_cache` array
@assembly_image_cache_hashes = dso_local local_unnamed_addr constant [444 x i32] [
	i32 2616222, ; 0: System.Net.NetworkInformation.dll => 0x27eb9e => 173
	i32 10166715, ; 1: System.Net.NameResolution.dll => 0x9b21bb => 172
	i32 39109920, ; 2: Newtonsoft.Json.dll => 0x254c520 => 85
	i32 42639949, ; 3: System.Threading.Thread => 0x28aa24d => 209
	i32 67008169, ; 4: zh-Hant\Microsoft.Maui.Controls.resources => 0x3fe76a9 => 33
	i32 68219467, ; 5: System.Security.Cryptography.Primitives => 0x410f24b => 200
	i32 72070932, ; 6: Microsoft.Maui.Graphics.dll => 0x44bb714 => 84
	i32 93082064, ; 7: SIMRAdmin => 0x58c51d0 => 139
	i32 117431740, ; 8: System.Runtime.InteropServices => 0x6ffddbc => 192
	i32 122350210, ; 9: System.Threading.Channels.dll => 0x74aea82 => 207
	i32 142721839, ; 10: System.Net.WebHeaderCollection => 0x881c32f => 179
	i32 147669188, ; 11: Plugin.Firebase.Core.dll => 0x8cd40c4 => 87
	i32 149972175, ; 12: System.Security.Cryptography.Primitives.dll => 0x8f064cf => 200
	i32 165246403, ; 13: Xamarin.AndroidX.Collection.dll => 0x9d975c3 => 108
	i32 182336117, ; 14: Xamarin.AndroidX.SwipeRefreshLayout.dll => 0xade3a75 => 126
	i32 195452805, ; 15: vi/Microsoft.Maui.Controls.resources.dll => 0xba65f85 => 30
	i32 199333315, ; 16: zh-HK/Microsoft.Maui.Controls.resources.dll => 0xbe195c3 => 31
	i32 205061960, ; 17: System.ComponentModel => 0xc38ff48 => 149
	i32 220171995, ; 18: System.Diagnostics.Debug => 0xd1f8edb => 153
	i32 230752869, ; 19: Microsoft.CSharp.dll => 0xdc10265 => 140
	i32 231409092, ; 20: System.Linq.Parallel => 0xdcb05c4 => 166
	i32 246610117, ; 21: System.Reflection.Emit.Lightweight => 0xeb2f8c5 => 186
	i32 261882112, ; 22: DocumentFormat.OpenXml.Framework.dll => 0xf9c0100 => 41
	i32 280992041, ; 23: cs/Microsoft.Maui.Controls.resources.dll => 0x10bf9929 => 2
	i32 317674968, ; 24: vi\Microsoft.Maui.Controls.resources => 0x12ef55d8 => 30
	i32 318968648, ; 25: Xamarin.AndroidX.Activity.dll => 0x13031348 => 104
	i32 331603304, ; 26: SixLabors.Fonts => 0x13c3dd68 => 91
	i32 336156722, ; 27: ja/Microsoft.Maui.Controls.resources.dll => 0x14095832 => 15
	i32 342366114, ; 28: Xamarin.AndroidX.Lifecycle.Common => 0x146817a2 => 115
	i32 356389973, ; 29: it/Microsoft.Maui.Controls.resources.dll => 0x153e1455 => 14
	i32 364956269, ; 30: Grpc.Net.Common => 0x15c0ca6d => 61
	i32 367780167, ; 31: System.IO.Pipes => 0x15ebe147 => 164
	i32 371306672, ; 32: Grpc.Core.Api.dll => 0x1621b0b0 => 59
	i32 375677976, ; 33: System.Net.ServicePoint.dll => 0x16646418 => 177
	i32 379916513, ; 34: System.Threading.Thread.dll => 0x16a510e1 => 209
	i32 382771021, ; 35: Microsoft.Bcl.Memory.dll => 0x16d09f4d => 66
	i32 385762202, ; 36: System.Memory.dll => 0x16fe439a => 168
	i32 391886110, ; 37: Grpc.Net.Client.dll => 0x175bb51e => 60
	i32 393699800, ; 38: Firebase => 0x177761d8 => 45
	i32 395744057, ; 39: _Microsoft.Android.Resource.Designer => 0x17969339 => 34
	i32 435591531, ; 40: sv/Microsoft.Maui.Controls.resources.dll => 0x19f6996b => 26
	i32 442565967, ; 41: System.Collections => 0x1a61054f => 146
	i32 450948140, ; 42: Xamarin.AndroidX.Fragment.dll => 0x1ae0ec2c => 114
	i32 451504562, ; 43: System.Security.Cryptography.X509Certificates => 0x1ae969b2 => 201
	i32 456227837, ; 44: System.Web.HttpUtility.dll => 0x1b317bfd => 211
	i32 459347974, ; 45: System.Runtime.Serialization.Primitives.dll => 0x1b611806 => 196
	i32 465846621, ; 46: mscorlib => 0x1bc4415d => 216
	i32 469710990, ; 47: System.dll => 0x1bff388e => 215
	i32 485463106, ; 48: Microsoft.IdentityModel.Abstractions => 0x1cef9442 => 75
	i32 498788369, ; 49: System.ObjectModel => 0x1dbae811 => 181
	i32 500358224, ; 50: id/Microsoft.Maui.Controls.resources.dll => 0x1dd2dc50 => 13
	i32 503918385, ; 51: fi/Microsoft.Maui.Controls.resources.dll => 0x1e092f31 => 7
	i32 507148113, ; 52: Xamarin.Google.Android.DataTransport.TransportApi.dll => 0x1e3a7751 => 132
	i32 513247710, ; 53: Microsoft.Extensions.Primitives.dll => 0x1e9789de => 74
	i32 525008092, ; 54: SkiaSharp.dll => 0x1f4afcdc => 92
	i32 539058512, ; 55: Microsoft.Extensions.Logging => 0x20216150 => 71
	i32 540030774, ; 56: System.IO.FileSystem.dll => 0x20303736 => 163
	i32 545304856, ; 57: System.Runtime.Extensions => 0x2080b118 => 190
	i32 548916678, ; 58: Microsoft.Bcl.AsyncInterfaces => 0x20b7cdc6 => 65
	i32 592146354, ; 59: pt-BR/Microsoft.Maui.Controls.resources.dll => 0x234b6fb2 => 21
	i32 597488923, ; 60: CommunityToolkit.Maui => 0x239cf51b => 37
	i32 610194910, ; 61: System.Reactive.dll => 0x245ed5de => 102
	i32 613668793, ; 62: System.Security.Cryptography.Algorithms => 0x2493d7b9 => 199
	i32 627609679, ; 63: Xamarin.AndroidX.CustomView => 0x2568904f => 112
	i32 627931235, ; 64: nl\Microsoft.Maui.Controls.resources => 0x256d7863 => 19
	i32 646990296, ; 65: Google.Cloud.Firestore.V1.dll => 0x269049d8 => 54
	i32 662205335, ; 66: System.Text.Encodings.Web.dll => 0x27787397 => 204
	i32 663517072, ; 67: Xamarin.AndroidX.VersionedParcelable => 0x278c7790 => 127
	i32 672442732, ; 68: System.Collections.Concurrent => 0x2814a96c => 142
	i32 683518922, ; 69: System.Net.Security => 0x28bdabca => 176
	i32 688181140, ; 70: ca/Microsoft.Maui.Controls.resources.dll => 0x2904cf94 => 1
	i32 690569205, ; 71: System.Xml.Linq.dll => 0x29293ff5 => 212
	i32 706645707, ; 72: ko/Microsoft.Maui.Controls.resources.dll => 0x2a1e8ecb => 16
	i32 709557578, ; 73: de/Microsoft.Maui.Controls.resources.dll => 0x2a4afd4a => 4
	i32 722857257, ; 74: System.Runtime.Loader.dll => 0x2b15ed29 => 193
	i32 759454413, ; 75: System.Net.Requests => 0x2d445acd => 175
	i32 762598435, ; 76: System.IO.Pipes.dll => 0x2d745423 => 164
	i32 775507847, ; 77: System.IO.Compression => 0x2e394f87 => 162
	i32 777317022, ; 78: sk\Microsoft.Maui.Controls.resources => 0x2e54ea9e => 25
	i32 789151979, ; 79: Microsoft.Extensions.Options => 0x2f0980eb => 73
	i32 804715423, ; 80: System.Data.Common => 0x2ff6fb9f => 152
	i32 823281589, ; 81: System.Private.Uri.dll => 0x311247b5 => 182
	i32 830298997, ; 82: System.IO.Compression.Brotli => 0x317d5b75 => 161
	i32 856800933, ; 83: Plugin.Firebase.CloudMessaging.dll => 0x3311bea5 => 86
	i32 904024072, ; 84: System.ComponentModel.Primitives.dll => 0x35e25008 => 147
	i32 926902833, ; 85: tr/Microsoft.Maui.Controls.resources.dll => 0x373f6a31 => 28
	i32 955402788, ; 86: Newtonsoft.Json => 0x38f24a24 => 85
	i32 965247473, ; 87: Plugin.Firebase.Core => 0x398881f1 => 87
	i32 967690846, ; 88: Xamarin.AndroidX.Lifecycle.Common.dll => 0x39adca5e => 115
	i32 975874589, ; 89: System.Xml.XDocument => 0x3a2aaa1d => 214
	i32 987214855, ; 90: System.Diagnostics.Tools => 0x3ad7b407 => 156
	i32 992768348, ; 91: System.Collections.dll => 0x3b2c715c => 146
	i32 994442037, ; 92: System.IO.FileSystem => 0x3b45fb35 => 163
	i32 1012816738, ; 93: Xamarin.AndroidX.SavedState.dll => 0x3c5e5b62 => 125
	i32 1019214401, ; 94: System.Drawing => 0x3cbffa41 => 159
	i32 1028951442, ; 95: Microsoft.Extensions.DependencyInjection.Abstractions => 0x3d548d92 => 70
	i32 1029334545, ; 96: da/Microsoft.Maui.Controls.resources.dll => 0x3d5a6611 => 3
	i32 1035644815, ; 97: Xamarin.AndroidX.AppCompat => 0x3dbaaf8f => 105
	i32 1036536393, ; 98: System.Drawing.Primitives.dll => 0x3dc84a49 => 158
	i32 1044663988, ; 99: System.Linq.Expressions.dll => 0x3e444eb4 => 165
	i32 1049751285, ; 100: Google.Api.CommonProtos.dll => 0x3e91eef5 => 46
	i32 1052210849, ; 101: Xamarin.AndroidX.Lifecycle.ViewModel.dll => 0x3eb776a1 => 117
	i32 1082857460, ; 102: System.ComponentModel.TypeConverter => 0x408b17f4 => 148
	i32 1083751839, ; 103: System.IO.Packaging => 0x4098bd9f => 99
	i32 1084122840, ; 104: Xamarin.Kotlin.StdLib => 0x409e66d8 => 137
	i32 1098259244, ; 105: System => 0x41761b2c => 215
	i32 1118262833, ; 106: ko\Microsoft.Maui.Controls.resources => 0x42a75631 => 16
	i32 1145085672, ; 107: System.Linq.Async.dll => 0x44409ee8 => 100
	i32 1162065116, ; 108: Microsoft.Bcl.Memory => 0x4543b4dc => 66
	i32 1168523401, ; 109: pt\Microsoft.Maui.Controls.resources => 0x45a64089 => 22
	i32 1178241025, ; 110: Xamarin.AndroidX.Navigation.Runtime.dll => 0x463a8801 => 122
	i32 1201029973, ; 111: StarkbankEcdsa => 0x47964355 => 96
	i32 1203173028, ; 112: Grpc.Net.Client => 0x47b6f6a4 => 60
	i32 1203215381, ; 113: pl/Microsoft.Maui.Controls.resources.dll => 0x47b79c15 => 20
	i32 1208641965, ; 114: System.Diagnostics.Process => 0x480a69ad => 155
	i32 1214827643, ; 115: CommunityToolkit.Mvvm => 0x4868cc7b => 39
	i32 1234928153, ; 116: nb/Microsoft.Maui.Controls.resources.dll => 0x499b8219 => 18
	i32 1260983243, ; 117: cs\Microsoft.Maui.Controls.resources => 0x4b2913cb => 2
	i32 1292843635, ; 118: DocumentFormat.OpenXml.Framework => 0x4d0f3a73 => 41
	i32 1293217323, ; 119: Xamarin.AndroidX.DrawerLayout.dll => 0x4d14ee2b => 113
	i32 1309284514, ; 120: Plugin.FirebasePushNotification => 0x4e0a18a2 => 88
	i32 1324164729, ; 121: System.Linq => 0x4eed2679 => 167
	i32 1333047053, ; 122: Xamarin.Firebase.Common => 0x4f74af0d => 130
	i32 1338318188, ; 123: ExcelNumberFormat.dll => 0x4fc51d6c => 42
	i32 1338781641, ; 124: DocumentFormat.OpenXml.dll => 0x4fcc2fc9 => 40
	i32 1373134921, ; 125: zh-Hans\Microsoft.Maui.Controls.resources => 0x51d86049 => 32
	i32 1376866003, ; 126: Xamarin.AndroidX.SavedState => 0x52114ed3 => 125
	i32 1379779777, ; 127: System.Resources.ResourceManager => 0x523dc4c1 => 188
	i32 1390396154, ; 128: ClosedXML.Parser.dll => 0x52dfc2fa => 36
	i32 1406073936, ; 129: Xamarin.AndroidX.CoordinatorLayout => 0x53cefc50 => 109
	i32 1408764838, ; 130: System.Runtime.Serialization.Formatters.dll => 0x53f80ba6 => 195
	i32 1411638395, ; 131: System.Runtime.CompilerServices.Unsafe => 0x5423e47b => 189
	i32 1430672901, ; 132: ar\Microsoft.Maui.Controls.resources => 0x55465605 => 0
	i32 1433687999, ; 133: SendGrid.dll => 0x557457bf => 90
	i32 1437713837, ; 134: Grpc.Auth => 0x55b1c5ad => 58
	i32 1452070440, ; 135: System.Formats.Asn1.dll => 0x568cd628 => 160
	i32 1453312822, ; 136: System.Diagnostics.Tools.dll => 0x569fcb36 => 156
	i32 1455549312, ; 137: LiveCharts => 0x56c1eb80 => 63
	i32 1457743152, ; 138: System.Runtime.Extensions.dll => 0x56e36530 => 190
	i32 1458022317, ; 139: System.Net.Security.dll => 0x56e7a7ad => 176
	i32 1460893475, ; 140: System.IdentityModel.Tokens.Jwt => 0x57137723 => 98
	i32 1461004990, ; 141: es\Microsoft.Maui.Controls.resources => 0x57152abe => 6
	i32 1461234159, ; 142: System.Collections.Immutable.dll => 0x5718a9ef => 143
	i32 1462112819, ; 143: System.IO.Compression.dll => 0x57261233 => 162
	i32 1469204771, ; 144: Xamarin.AndroidX.AppCompat.AppCompatResources => 0x57924923 => 106
	i32 1470490898, ; 145: Microsoft.Extensions.Primitives => 0x57a5e912 => 74
	i32 1479771757, ; 146: System.Collections.Immutable => 0x5833866d => 143
	i32 1480492111, ; 147: System.IO.Compression.Brotli.dll => 0x583e844f => 161
	i32 1493001747, ; 148: hi/Microsoft.Maui.Controls.resources.dll => 0x58fd6613 => 10
	i32 1498168481, ; 149: Microsoft.IdentityModel.JsonWebTokens.dll => 0x594c3ca1 => 76
	i32 1514721132, ; 150: el/Microsoft.Maui.Controls.resources.dll => 0x5a48cf6c => 5
	i32 1536837071, ; 151: Twilio.dll => 0x5b9a45cf => 103
	i32 1543031311, ; 152: System.Text.RegularExpressions.dll => 0x5bf8ca0f => 206
	i32 1551623176, ; 153: sk/Microsoft.Maui.Controls.resources.dll => 0x5c7be408 => 25
	i32 1622152042, ; 154: Xamarin.AndroidX.Loader.dll => 0x60b0136a => 119
	i32 1623212457, ; 155: SkiaSharp.Views.Maui.Controls => 0x60c041a9 => 94
	i32 1624863272, ; 156: Xamarin.AndroidX.ViewPager2 => 0x60d97228 => 129
	i32 1634654947, ; 157: CommunityToolkit.Maui.Core.dll => 0x616edae3 => 38
	i32 1636350590, ; 158: Xamarin.AndroidX.CursorAdapter => 0x6188ba7e => 111
	i32 1639515021, ; 159: System.Net.Http.dll => 0x61b9038d => 169
	i32 1639986890, ; 160: System.Text.RegularExpressions => 0x61c036ca => 206
	i32 1657153582, ; 161: System.Runtime => 0x62c6282e => 197
	i32 1658251792, ; 162: Xamarin.Google.Android.Material.dll => 0x62d6ea10 => 133
	i32 1677501392, ; 163: System.Net.Primitives.dll => 0x63fca3d0 => 174
	i32 1679769178, ; 164: System.Security.Cryptography => 0x641f3e5a => 202
	i32 1701541528, ; 165: System.Diagnostics.Debug.dll => 0x656b7698 => 153
	i32 1729485958, ; 166: Xamarin.AndroidX.CardView.dll => 0x6715dc86 => 107
	i32 1736233607, ; 167: ro/Microsoft.Maui.Controls.resources.dll => 0x677cd287 => 23
	i32 1743415430, ; 168: ca\Microsoft.Maui.Controls.resources => 0x67ea6886 => 1
	i32 1763938596, ; 169: System.Diagnostics.TraceSource.dll => 0x69239124 => 157
	i32 1766324549, ; 170: Xamarin.AndroidX.SwipeRefreshLayout => 0x6947f945 => 126
	i32 1770582343, ; 171: Microsoft.Extensions.Logging.dll => 0x6988f147 => 71
	i32 1776026572, ; 172: System.Core.dll => 0x69dc03cc => 151
	i32 1780572499, ; 173: Mono.Android.Runtime.dll => 0x6a216153 => 220
	i32 1782161461, ; 174: Grpc.Core.Api => 0x6a39a035 => 59
	i32 1782862114, ; 175: ms\Microsoft.Maui.Controls.resources => 0x6a445122 => 17
	i32 1788241197, ; 176: Xamarin.AndroidX.Fragment => 0x6a96652d => 114
	i32 1793755602, ; 177: he\Microsoft.Maui.Controls.resources => 0x6aea89d2 => 9
	i32 1796167890, ; 178: Microsoft.Bcl.AsyncInterfaces.dll => 0x6b0f58d2 => 65
	i32 1808609942, ; 179: Xamarin.AndroidX.Loader => 0x6bcd3296 => 119
	i32 1813058853, ; 180: Xamarin.Kotlin.StdLib.dll => 0x6c111525 => 137
	i32 1813201214, ; 181: Xamarin.Google.Android.Material => 0x6c13413e => 133
	i32 1818569960, ; 182: Xamarin.AndroidX.Navigation.UI.dll => 0x6c652ce8 => 123
	i32 1824175904, ; 183: System.Text.Encoding.Extensions => 0x6cbab720 => 203
	i32 1824722060, ; 184: System.Runtime.Serialization.Formatters => 0x6cc30c8c => 195
	i32 1828688058, ; 185: Microsoft.Extensions.Logging.Abstractions.dll => 0x6cff90ba => 72
	i32 1842015223, ; 186: uk/Microsoft.Maui.Controls.resources.dll => 0x6dcaebf7 => 29
	i32 1853025655, ; 187: sv\Microsoft.Maui.Controls.resources => 0x6e72ed77 => 26
	i32 1858542181, ; 188: System.Linq.Expressions => 0x6ec71a65 => 165
	i32 1866604563, ; 189: RBush.dll => 0x6f422013 => 89
	i32 1870277092, ; 190: System.Reflection.Primitives => 0x6f7a29e4 => 187
	i32 1875935024, ; 191: fr\Microsoft.Maui.Controls.resources => 0x6fd07f30 => 8
	i32 1900519031, ; 192: Grpc.Auth.dll => 0x71479e77 => 58
	i32 1900610850, ; 193: System.Resources.ResourceManager.dll => 0x71490522 => 188
	i32 1908813208, ; 194: Xamarin.GooglePlayServices.Basement => 0x71c62d98 => 135
	i32 1910275211, ; 195: System.Collections.NonGeneric.dll => 0x71dc7c8b => 144
	i32 1927897671, ; 196: System.CodeDom.dll => 0x72e96247 => 97
	i32 1933215285, ; 197: Xamarin.Firebase.Messaging.dll => 0x733a8635 => 131
	i32 1939592360, ; 198: System.Private.Xml.Linq => 0x739bd4a8 => 183
	i32 1968388702, ; 199: Microsoft.Extensions.Configuration.dll => 0x75533a5e => 67
	i32 1986222447, ; 200: Microsoft.IdentityModel.Tokens.dll => 0x7663596f => 78
	i32 2003115576, ; 201: el\Microsoft.Maui.Controls.resources => 0x77651e38 => 5
	i32 2011961780, ; 202: System.Buffers.dll => 0x77ec19b4 => 141
	i32 2019465201, ; 203: Xamarin.AndroidX.Lifecycle.ViewModel => 0x785e97f1 => 117
	i32 2025202353, ; 204: ar/Microsoft.Maui.Controls.resources.dll => 0x78b622b1 => 0
	i32 2045470958, ; 205: System.Private.Xml => 0x79eb68ee => 184
	i32 2055257422, ; 206: Xamarin.AndroidX.Lifecycle.LiveData.Core.dll => 0x7a80bd4e => 116
	i32 2066184531, ; 207: de\Microsoft.Maui.Controls.resources => 0x7b277953 => 4
	i32 2070888862, ; 208: System.Diagnostics.TraceSource => 0x7b6f419e => 157
	i32 2079903147, ; 209: System.Runtime.dll => 0x7bf8cdab => 197
	i32 2090596640, ; 210: System.Numerics.Vectors => 0x7c9bf920 => 180
	i32 2127167465, ; 211: System.Console => 0x7ec9ffe9 => 150
	i32 2129483829, ; 212: Xamarin.GooglePlayServices.Base.dll => 0x7eed5835 => 134
	i32 2142473426, ; 213: System.Collections.Specialized => 0x7fb38cd2 => 145
	i32 2159891885, ; 214: Microsoft.Maui => 0x80bd55ad => 82
	i32 2166698602, ; 215: ClosedXML => 0x8125326a => 35
	i32 2169148018, ; 216: hu\Microsoft.Maui.Controls.resources => 0x814a9272 => 12
	i32 2178612968, ; 217: System.CodeDom => 0x81dafee8 => 97
	i32 2181898931, ; 218: Microsoft.Extensions.Options.dll => 0x820d22b3 => 73
	i32 2188602587, ; 219: Microcharts.Maui => 0x82736cdb => 64
	i32 2192057212, ; 220: Microsoft.Extensions.Logging.Abstractions => 0x82a8237c => 72
	i32 2193016926, ; 221: System.ObjectModel.dll => 0x82b6c85e => 181
	i32 2201107256, ; 222: Xamarin.KotlinX.Coroutines.Core.Jvm.dll => 0x83323b38 => 138
	i32 2201231467, ; 223: System.Net.Http => 0x8334206b => 169
	i32 2207618523, ; 224: it\Microsoft.Maui.Controls.resources => 0x839595db => 14
	i32 2210798277, ; 225: SendGrid => 0x83c61ac5 => 90
	i32 2216717168, ; 226: Firebase.Auth.dll => 0x84206b70 => 44
	i32 2225974570, ; 227: Twilio => 0x84adad2a => 103
	i32 2266799131, ; 228: Microsoft.Extensions.Configuration.Abstractions => 0x871c9c1b => 68
	i32 2270573516, ; 229: fr/Microsoft.Maui.Controls.resources.dll => 0x875633cc => 8
	i32 2279755925, ; 230: Xamarin.AndroidX.RecyclerView.dll => 0x87e25095 => 124
	i32 2295906218, ; 231: System.Net.Sockets => 0x88d8bfaa => 178
	i32 2298471582, ; 232: System.Net.Mail => 0x88ffe49e => 171
	i32 2303942373, ; 233: nb\Microsoft.Maui.Controls.resources => 0x89535ee5 => 18
	i32 2305521784, ; 234: System.Private.CoreLib.dll => 0x896b7878 => 218
	i32 2340441535, ; 235: System.Runtime.InteropServices.RuntimeInformation.dll => 0x8b804dbf => 191
	i32 2353062107, ; 236: System.Net.Primitives => 0x8c40e0db => 174
	i32 2364201794, ; 237: SkiaSharp.Views.Maui.Core => 0x8ceadb42 => 95
	i32 2368005991, ; 238: System.Xml.ReaderWriter.dll => 0x8d24e767 => 213
	i32 2369706906, ; 239: Microsoft.IdentityModel.Logging => 0x8d3edb9a => 77
	i32 2371007202, ; 240: Microsoft.Extensions.Configuration => 0x8d52b2e2 => 67
	i32 2395872292, ; 241: id\Microsoft.Maui.Controls.resources => 0x8ece1c24 => 13
	i32 2397347608, ; 242: Google.LongRunning.dll => 0x8ee49f18 => 56
	i32 2401565422, ; 243: System.Web.HttpUtility => 0x8f24faee => 211
	i32 2427813419, ; 244: hi\Microsoft.Maui.Controls.resources => 0x90b57e2b => 10
	i32 2435356389, ; 245: System.Console.dll => 0x912896e5 => 150
	i32 2441199521, ; 246: Google.Cloud.Firestore => 0x9181bfa1 => 53
	i32 2458678730, ; 247: System.Net.Sockets.dll => 0x928c75ca => 178
	i32 2459001652, ; 248: System.Linq.Parallel.dll => 0x92916334 => 166
	i32 2471841756, ; 249: netstandard.dll => 0x93554fdc => 217
	i32 2475788418, ; 250: Java.Interop.dll => 0x93918882 => 219
	i32 2480646305, ; 251: Microsoft.Maui.Controls => 0x93dba8a1 => 80
	i32 2483742551, ; 252: Xamarin.Firebase.Messaging => 0x940ae757 => 131
	i32 2484371297, ; 253: System.Net.ServicePoint => 0x94147f61 => 177
	i32 2486847491, ; 254: Google.Api.Gax => 0x943a4803 => 47
	i32 2538310050, ; 255: System.Reflection.Emit.Lightweight.dll => 0x974b89a2 => 186
	i32 2550873716, ; 256: hr\Microsoft.Maui.Controls.resources => 0x980b3e74 => 11
	i32 2562349572, ; 257: Microsoft.CSharp => 0x98ba5a04 => 140
	i32 2570120770, ; 258: System.Text.Encodings.Web => 0x9930ee42 => 204
	i32 2585220780, ; 259: System.Text.Encoding.Extensions.dll => 0x9a1756ac => 203
	i32 2593496499, ; 260: pl\Microsoft.Maui.Controls.resources => 0x9a959db3 => 20
	i32 2595928349, ; 261: FirebaseAdmin => 0x9abab91d => 43
	i32 2605712449, ; 262: Xamarin.KotlinX.Coroutines.Core.Jvm => 0x9b500441 => 138
	i32 2617129537, ; 263: System.Private.Xml.dll => 0x9bfe3a41 => 184
	i32 2620871830, ; 264: Xamarin.AndroidX.CursorAdapter.dll => 0x9c375496 => 111
	i32 2625339995, ; 265: SkiaSharp.Views.Maui.Core.dll => 0x9c7b825b => 95
	i32 2626831493, ; 266: ja\Microsoft.Maui.Controls.resources => 0x9c924485 => 15
	i32 2629053246, ; 267: Google.Api.Gax.Rest => 0x9cb42b3e => 49
	i32 2635732976, ; 268: Google.Cloud.Firestore.dll => 0x9d1a17f0 => 53
	i32 2640290731, ; 269: Microsoft.IdentityModel.Logging.dll => 0x9d5fa3ab => 77
	i32 2663698177, ; 270: System.Runtime.Loader => 0x9ec4cf01 => 193
	i32 2664396074, ; 271: System.Xml.XDocument.dll => 0x9ecf752a => 214
	i32 2665622720, ; 272: System.Drawing.Primitives => 0x9ee22cc0 => 158
	i32 2673807045, ; 273: RBush => 0x9f5f0ec5 => 89
	i32 2676780864, ; 274: System.Data.Common.dll => 0x9f8c6f40 => 152
	i32 2717744543, ; 275: System.Security.Claims => 0xa1fd7d9f => 198
	i32 2724373263, ; 276: System.Runtime.Numerics.dll => 0xa262a30f => 194
	i32 2732626843, ; 277: Xamarin.AndroidX.Activity => 0xa2e0939b => 104
	i32 2735172069, ; 278: System.Threading.Channels => 0xa30769e5 => 207
	i32 2737747696, ; 279: Xamarin.AndroidX.AppCompat.AppCompatResources.dll => 0xa32eb6f0 => 106
	i32 2744327253, ; 280: Google.Api.Gax.Grpc.dll => 0xa3931c55 => 48
	i32 2752995522, ; 281: pt-BR\Microsoft.Maui.Controls.resources => 0xa41760c2 => 21
	i32 2757554483, ; 282: Google.Api.Gax.Grpc => 0xa45cf133 => 48
	i32 2758225723, ; 283: Microsoft.Maui.Controls.Xaml => 0xa4672f3b => 81
	i32 2764765095, ; 284: Microsoft.Maui.dll => 0xa4caf7a7 => 82
	i32 2778768386, ; 285: Xamarin.AndroidX.ViewPager.dll => 0xa5a0a402 => 128
	i32 2785988530, ; 286: th\Microsoft.Maui.Controls.resources => 0xa60ecfb2 => 27
	i32 2795602088, ; 287: SkiaSharp.Views.Android.dll => 0xa6a180a8 => 93
	i32 2801831435, ; 288: Microsoft.Maui.Graphics => 0xa7008e0b => 84
	i32 2806116107, ; 289: es/Microsoft.Maui.Controls.resources.dll => 0xa741ef0b => 6
	i32 2810250172, ; 290: Xamarin.AndroidX.CoordinatorLayout.dll => 0xa78103bc => 109
	i32 2818335264, ; 291: System.Linq.Async => 0xa7fc6220 => 100
	i32 2831556043, ; 292: nl/Microsoft.Maui.Controls.resources.dll => 0xa8c61dcb => 19
	i32 2839679515, ; 293: Google.LongRunning => 0xa942121b => 56
	i32 2847418871, ; 294: Xamarin.GooglePlayServices.Base => 0xa9b829f7 => 134
	i32 2853208004, ; 295: Xamarin.AndroidX.ViewPager => 0xaa107fc4 => 128
	i32 2861189240, ; 296: Microsoft.Maui.Essentials => 0xaa8a4878 => 83
	i32 2868488919, ; 297: CommunityToolkit.Maui.Core => 0xaaf9aad7 => 38
	i32 2877542466, ; 298: ClosedXML.dll => 0xab83d042 => 35
	i32 2893550578, ; 299: Google.Apis.Core => 0xac7813f2 => 52
	i32 2898407901, ; 300: System.Management => 0xacc231dd => 101
	i32 2905242038, ; 301: mscorlib.dll => 0xad2a79b6 => 216
	i32 2909740682, ; 302: System.Private.CoreLib => 0xad6f1e8a => 218
	i32 2912489636, ; 303: SkiaSharp.Views.Android => 0xad9910a4 => 93
	i32 2912646636, ; 304: Google.Api.CommonProtos => 0xad9b75ec => 46
	i32 2916838712, ; 305: Xamarin.AndroidX.ViewPager2.dll => 0xaddb6d38 => 129
	i32 2919462931, ; 306: System.Numerics.Vectors.dll => 0xae037813 => 180
	i32 2936686614, ; 307: SIMRAdmin.dll => 0xaf0a4816 => 139
	i32 2959614098, ; 308: System.ComponentModel.dll => 0xb0682092 => 149
	i32 2972252294, ; 309: System.Security.Cryptography.Algorithms.dll => 0xb128f886 => 199
	i32 2978675010, ; 310: Xamarin.AndroidX.DrawerLayout => 0xb18af942 => 113
	i32 2990604888, ; 311: Google.Apis => 0xb2410258 => 50
	i32 3038032645, ; 312: _Microsoft.Android.Resource.Designer.dll => 0xb514b305 => 34
	i32 3057625584, ; 313: Xamarin.AndroidX.Navigation.Common => 0xb63fa9f0 => 120
	i32 3058099980, ; 314: Xamarin.GooglePlayServices.Tasks => 0xb646e70c => 136
	i32 3059408633, ; 315: Mono.Android.Runtime => 0xb65adef9 => 220
	i32 3059793426, ; 316: System.ComponentModel.Primitives => 0xb660be12 => 147
	i32 3071899978, ; 317: Xamarin.Firebase.Common.dll => 0xb719794a => 130
	i32 3077302341, ; 318: hu/Microsoft.Maui.Controls.resources.dll => 0xb76be845 => 12
	i32 3084678329, ; 319: Microsoft.IdentityModel.Tokens => 0xb7dc74b9 => 78
	i32 3090735792, ; 320: System.Security.Cryptography.X509Certificates.dll => 0xb838e2b0 => 201
	i32 3099732863, ; 321: System.Security.Claims.dll => 0xb8c22b7f => 198
	i32 3103600923, ; 322: System.Formats.Asn1 => 0xb8fd311b => 160
	i32 3106263381, ; 323: Grpc.Net.Common.dll => 0xb925d155 => 61
	i32 3118851116, ; 324: ExcelNumberFormat => 0xb9e5e42c => 42
	i32 3124832203, ; 325: System.Threading.Tasks.Extensions => 0xba4127cb => 208
	i32 3155362983, ; 326: Xamarin.Google.Android.DataTransport.TransportApi => 0xbc1304a7 => 132
	i32 3159123045, ; 327: System.Reflection.Primitives.dll => 0xbc4c6465 => 187
	i32 3178803400, ; 328: Xamarin.AndroidX.Navigation.Fragment.dll => 0xbd78b0c8 => 121
	i32 3178908327, ; 329: SixLabors.Fonts.dll => 0xbd7a4aa7 => 91
	i32 3203277885, ; 330: Google.Api.Gax.dll => 0xbeee243d => 47
	i32 3220365878, ; 331: System.Threading => 0xbff2e236 => 210
	i32 3230466174, ; 332: Xamarin.GooglePlayServices.Basement.dll => 0xc08d007e => 135
	i32 3240169105, ; 333: LiveCharts.dll => 0xc1210e91 => 63
	i32 3258312781, ; 334: Xamarin.AndroidX.CardView => 0xc235e84d => 107
	i32 3265893370, ; 335: System.Threading.Tasks.Extensions.dll => 0xc2a993fa => 208
	i32 3271840132, ; 336: StarkbankEcdsa.dll => 0xc3045184 => 96
	i32 3305363605, ; 337: fi\Microsoft.Maui.Controls.resources => 0xc503d895 => 7
	i32 3312457198, ; 338: Microsoft.IdentityModel.JsonWebTokens => 0xc57015ee => 76
	i32 3316684772, ; 339: System.Net.Requests.dll => 0xc5b097e4 => 175
	i32 3317135071, ; 340: Xamarin.AndroidX.CustomView.dll => 0xc5b776df => 112
	i32 3322403133, ; 341: Firebase.dll => 0xc607d93d => 45
	i32 3340387945, ; 342: SkiaSharp => 0xc71a4669 => 92
	i32 3346324047, ; 343: Xamarin.AndroidX.Navigation.Runtime => 0xc774da4f => 122
	i32 3357674450, ; 344: ru\Microsoft.Maui.Controls.resources => 0xc8220bd2 => 24
	i32 3358260929, ; 345: System.Text.Json => 0xc82afec1 => 205
	i32 3362522851, ; 346: Xamarin.AndroidX.Core => 0xc86c06e3 => 110
	i32 3366347497, ; 347: Java.Interop => 0xc8a662e9 => 219
	i32 3374999561, ; 348: Xamarin.AndroidX.RecyclerView => 0xc92a6809 => 124
	i32 3381016424, ; 349: da\Microsoft.Maui.Controls.resources => 0xc9863768 => 3
	i32 3395150330, ; 350: System.Runtime.CompilerServices.Unsafe.dll => 0xca5de1fa => 189
	i32 3401559547, ; 351: Plugin.FirebasePushNotification.dll => 0xcabfadfb => 88
	i32 3428513518, ; 352: Microsoft.Extensions.DependencyInjection.dll => 0xcc5af6ee => 69
	i32 3430777524, ; 353: netstandard => 0xcc7d82b4 => 217
	i32 3452344032, ; 354: Microsoft.Maui.Controls.Compatibility.dll => 0xcdc696e0 => 79
	i32 3453592554, ; 355: Google.Apis.Core.dll => 0xcdd9a3ea => 52
	i32 3463511458, ; 356: hr/Microsoft.Maui.Controls.resources.dll => 0xce70fda2 => 11
	i32 3471940407, ; 357: System.ComponentModel.TypeConverter.dll => 0xcef19b37 => 148
	i32 3473156932, ; 358: SkiaSharp.Views.Maui.Controls.dll => 0xcf042b44 => 94
	i32 3476120550, ; 359: Mono.Android => 0xcf3163e6 => 221
	i32 3479583265, ; 360: ru/Microsoft.Maui.Controls.resources.dll => 0xcf663a21 => 24
	i32 3484440000, ; 361: ro\Microsoft.Maui.Controls.resources => 0xcfb055c0 => 23
	i32 3485117614, ; 362: System.Text.Json.dll => 0xcfbaacae => 205
	i32 3499097210, ; 363: Google.Protobuf.dll => 0xd08ffc7a => 57
	i32 3509114376, ; 364: System.Xml.Linq => 0xd128d608 => 212
	i32 3539954161, ; 365: System.Net.HttpListener => 0xd2ff69f1 => 170
	i32 3580758918, ; 366: zh-HK\Microsoft.Maui.Controls.resources => 0xd56e0b86 => 31
	i32 3581231576, ; 367: ClosedXML.Parser => 0xd57541d8 => 36
	i32 3596207933, ; 368: LiteDB.dll => 0xd659c73d => 62
	i32 3598063517, ; 369: Google.Cloud.Firestore.V1 => 0xd676179d => 54
	i32 3608519521, ; 370: System.Linq.dll => 0xd715a361 => 167
	i32 3612435020, ; 371: System.Management.dll => 0xd751624c => 101
	i32 3621458322, ; 372: Google.Api.Gax.Rest.dll => 0xd7db1192 => 49
	i32 3624195450, ; 373: System.Runtime.InteropServices.RuntimeInformation => 0xd804d57a => 191
	i32 3629588173, ; 374: LiteDB => 0xd8571ecd => 62
	i32 3641597786, ; 375: Xamarin.AndroidX.Lifecycle.LiveData.Core => 0xd90e5f5a => 116
	i32 3643446276, ; 376: tr\Microsoft.Maui.Controls.resources => 0xd92a9404 => 28
	i32 3643854240, ; 377: Xamarin.AndroidX.Navigation.Fragment => 0xd930cda0 => 121
	i32 3645630983, ; 378: Google.Protobuf => 0xd94bea07 => 57
	i32 3657292374, ; 379: Microsoft.Extensions.Configuration.Abstractions.dll => 0xd9fdda56 => 68
	i32 3660523487, ; 380: System.Net.NetworkInformation => 0xda2f27df => 173
	i32 3672681054, ; 381: Mono.Android.dll => 0xdae8aa5e => 221
	i32 3697841164, ; 382: zh-Hant/Microsoft.Maui.Controls.resources.dll => 0xdc68940c => 33
	i32 3700591436, ; 383: Microsoft.IdentityModel.Abstractions.dll => 0xdc928b4c => 75
	i32 3724971120, ; 384: Xamarin.AndroidX.Navigation.Common.dll => 0xde068c70 => 120
	i32 3731644420, ; 385: System.Reactive => 0xde6c6004 => 102
	i32 3732100267, ; 386: System.Net.NameResolution => 0xde7354ab => 172
	i32 3748608112, ; 387: System.Diagnostics.DiagnosticSource => 0xdf6f3870 => 154
	i32 3757995660, ; 388: Google.Cloud.Location.dll => 0xdffe768c => 55
	i32 3786282454, ; 389: Xamarin.AndroidX.Collection => 0xe1ae15d6 => 108
	i32 3792276235, ; 390: System.Collections.NonGeneric => 0xe2098b0b => 144
	i32 3793997468, ; 391: Google.Apis.Auth.dll => 0xe223ce9c => 51
	i32 3800979733, ; 392: Microsoft.Maui.Controls.Compatibility => 0xe28e5915 => 79
	i32 3802395368, ; 393: System.Collections.Specialized.dll => 0xe2a3f2e8 => 145
	i32 3817368567, ; 394: CommunityToolkit.Maui.dll => 0xe3886bf7 => 37
	i32 3822443793, ; 395: DocumentFormat.OpenXml => 0xe3d5dd11 => 40
	i32 3823082795, ; 396: System.Security.Cryptography.dll => 0xe3df9d2b => 202
	i32 3841636137, ; 397: Microsoft.Extensions.DependencyInjection.Abstractions.dll => 0xe4fab729 => 70
	i32 3844307129, ; 398: System.Net.Mail.dll => 0xe52378b9 => 171
	i32 3849253459, ; 399: System.Runtime.InteropServices.dll => 0xe56ef253 => 192
	i32 3870376305, ; 400: System.Net.HttpListener.dll => 0xe6b14171 => 170
	i32 3885497537, ; 401: System.Net.WebHeaderCollection.dll => 0xe797fcc1 => 179
	i32 3889960447, ; 402: zh-Hans/Microsoft.Maui.Controls.resources.dll => 0xe7dc15ff => 32
	i32 3896106733, ; 403: System.Collections.Concurrent.dll => 0xe839deed => 142
	i32 3896760992, ; 404: Xamarin.AndroidX.Core.dll => 0xe843daa0 => 110
	i32 3921031405, ; 405: Xamarin.AndroidX.VersionedParcelable.dll => 0xe9b630ed => 127
	i32 3928044579, ; 406: System.Xml.ReaderWriter => 0xea213423 => 213
	i32 3931092270, ; 407: Xamarin.AndroidX.Navigation.UI => 0xea4fb52e => 123
	i32 3952357212, ; 408: System.IO.Packaging.dll => 0xeb942f5c => 99
	i32 3955647286, ; 409: Xamarin.AndroidX.AppCompat.dll => 0xebc66336 => 105
	i32 3970018735, ; 410: Xamarin.GooglePlayServices.Tasks.dll => 0xeca1adaf => 136
	i32 3979528423, ; 411: Plugin.Firebase.CloudMessaging => 0xed32c8e7 => 86
	i32 3980434154, ; 412: th/Microsoft.Maui.Controls.resources.dll => 0xed409aea => 27
	i32 3987592930, ; 413: he/Microsoft.Maui.Controls.resources.dll => 0xedadd6e2 => 9
	i32 4003436829, ; 414: System.Diagnostics.Process.dll => 0xee9f991d => 155
	i32 4024013275, ; 415: Firebase.Auth => 0xefd991db => 44
	i32 4025784931, ; 416: System.Memory => 0xeff49a63 => 168
	i32 4046471985, ; 417: Microsoft.Maui.Controls.Xaml.dll => 0xf1304331 => 81
	i32 4054681211, ; 418: System.Reflection.Emit.ILGeneration => 0xf1ad867b => 185
	i32 4056144661, ; 419: Google.Cloud.Location => 0xf1c3db15 => 55
	i32 4059682726, ; 420: Google.Apis.dll => 0xf1f9d7a6 => 50
	i32 4068434129, ; 421: System.Private.Xml.Linq.dll => 0xf27f60d1 => 183
	i32 4073602200, ; 422: System.Threading.dll => 0xf2ce3c98 => 210
	i32 4082882467, ; 423: Google.Apis.Auth => 0xf35bd7a3 => 51
	i32 4094352644, ; 424: Microsoft.Maui.Essentials.dll => 0xf40add04 => 83
	i32 4099507663, ; 425: System.Drawing.dll => 0xf45985cf => 159
	i32 4100113165, ; 426: System.Private.Uri => 0xf462c30d => 182
	i32 4102112229, ; 427: pt/Microsoft.Maui.Controls.resources.dll => 0xf48143e5 => 22
	i32 4125707920, ; 428: ms/Microsoft.Maui.Controls.resources.dll => 0xf5e94e90 => 17
	i32 4126470640, ; 429: Microsoft.Extensions.DependencyInjection => 0xf5f4f1f0 => 69
	i32 4147896353, ; 430: System.Reflection.Emit.ILGeneration.dll => 0xf73be021 => 185
	i32 4150914736, ; 431: uk\Microsoft.Maui.Controls.resources => 0xf769eeb0 => 29
	i32 4151237749, ; 432: System.Core => 0xf76edc75 => 151
	i32 4177102269, ; 433: FirebaseAdmin.dll => 0xf8f985bd => 43
	i32 4181436372, ; 434: System.Runtime.Serialization.Primitives => 0xf93ba7d4 => 196
	i32 4182413190, ; 435: Xamarin.AndroidX.Lifecycle.ViewModelSavedState.dll => 0xf94a8f86 => 118
	i32 4189085287, ; 436: Microcharts.Maui.dll => 0xf9b05e67 => 64
	i32 4213026141, ; 437: System.Diagnostics.DiagnosticSource.dll => 0xfb1dad5d => 154
	i32 4260525087, ; 438: System.Buffers => 0xfdf2741f => 141
	i32 4263231520, ; 439: System.IdentityModel.Tokens.Jwt.dll => 0xfe1bc020 => 98
	i32 4271975918, ; 440: Microsoft.Maui.Controls.dll => 0xfea12dee => 80
	i32 4274623895, ; 441: CommunityToolkit.Mvvm.dll => 0xfec99597 => 39
	i32 4274976490, ; 442: System.Runtime.Numerics => 0xfecef6ea => 194
	i32 4292120959 ; 443: Xamarin.AndroidX.Lifecycle.ViewModelSavedState => 0xffd4917f => 118
], align 4

@assembly_image_cache_indices = dso_local local_unnamed_addr constant [444 x i32] [
	i32 173, ; 0
	i32 172, ; 1
	i32 85, ; 2
	i32 209, ; 3
	i32 33, ; 4
	i32 200, ; 5
	i32 84, ; 6
	i32 139, ; 7
	i32 192, ; 8
	i32 207, ; 9
	i32 179, ; 10
	i32 87, ; 11
	i32 200, ; 12
	i32 108, ; 13
	i32 126, ; 14
	i32 30, ; 15
	i32 31, ; 16
	i32 149, ; 17
	i32 153, ; 18
	i32 140, ; 19
	i32 166, ; 20
	i32 186, ; 21
	i32 41, ; 22
	i32 2, ; 23
	i32 30, ; 24
	i32 104, ; 25
	i32 91, ; 26
	i32 15, ; 27
	i32 115, ; 28
	i32 14, ; 29
	i32 61, ; 30
	i32 164, ; 31
	i32 59, ; 32
	i32 177, ; 33
	i32 209, ; 34
	i32 66, ; 35
	i32 168, ; 36
	i32 60, ; 37
	i32 45, ; 38
	i32 34, ; 39
	i32 26, ; 40
	i32 146, ; 41
	i32 114, ; 42
	i32 201, ; 43
	i32 211, ; 44
	i32 196, ; 45
	i32 216, ; 46
	i32 215, ; 47
	i32 75, ; 48
	i32 181, ; 49
	i32 13, ; 50
	i32 7, ; 51
	i32 132, ; 52
	i32 74, ; 53
	i32 92, ; 54
	i32 71, ; 55
	i32 163, ; 56
	i32 190, ; 57
	i32 65, ; 58
	i32 21, ; 59
	i32 37, ; 60
	i32 102, ; 61
	i32 199, ; 62
	i32 112, ; 63
	i32 19, ; 64
	i32 54, ; 65
	i32 204, ; 66
	i32 127, ; 67
	i32 142, ; 68
	i32 176, ; 69
	i32 1, ; 70
	i32 212, ; 71
	i32 16, ; 72
	i32 4, ; 73
	i32 193, ; 74
	i32 175, ; 75
	i32 164, ; 76
	i32 162, ; 77
	i32 25, ; 78
	i32 73, ; 79
	i32 152, ; 80
	i32 182, ; 81
	i32 161, ; 82
	i32 86, ; 83
	i32 147, ; 84
	i32 28, ; 85
	i32 85, ; 86
	i32 87, ; 87
	i32 115, ; 88
	i32 214, ; 89
	i32 156, ; 90
	i32 146, ; 91
	i32 163, ; 92
	i32 125, ; 93
	i32 159, ; 94
	i32 70, ; 95
	i32 3, ; 96
	i32 105, ; 97
	i32 158, ; 98
	i32 165, ; 99
	i32 46, ; 100
	i32 117, ; 101
	i32 148, ; 102
	i32 99, ; 103
	i32 137, ; 104
	i32 215, ; 105
	i32 16, ; 106
	i32 100, ; 107
	i32 66, ; 108
	i32 22, ; 109
	i32 122, ; 110
	i32 96, ; 111
	i32 60, ; 112
	i32 20, ; 113
	i32 155, ; 114
	i32 39, ; 115
	i32 18, ; 116
	i32 2, ; 117
	i32 41, ; 118
	i32 113, ; 119
	i32 88, ; 120
	i32 167, ; 121
	i32 130, ; 122
	i32 42, ; 123
	i32 40, ; 124
	i32 32, ; 125
	i32 125, ; 126
	i32 188, ; 127
	i32 36, ; 128
	i32 109, ; 129
	i32 195, ; 130
	i32 189, ; 131
	i32 0, ; 132
	i32 90, ; 133
	i32 58, ; 134
	i32 160, ; 135
	i32 156, ; 136
	i32 63, ; 137
	i32 190, ; 138
	i32 176, ; 139
	i32 98, ; 140
	i32 6, ; 141
	i32 143, ; 142
	i32 162, ; 143
	i32 106, ; 144
	i32 74, ; 145
	i32 143, ; 146
	i32 161, ; 147
	i32 10, ; 148
	i32 76, ; 149
	i32 5, ; 150
	i32 103, ; 151
	i32 206, ; 152
	i32 25, ; 153
	i32 119, ; 154
	i32 94, ; 155
	i32 129, ; 156
	i32 38, ; 157
	i32 111, ; 158
	i32 169, ; 159
	i32 206, ; 160
	i32 197, ; 161
	i32 133, ; 162
	i32 174, ; 163
	i32 202, ; 164
	i32 153, ; 165
	i32 107, ; 166
	i32 23, ; 167
	i32 1, ; 168
	i32 157, ; 169
	i32 126, ; 170
	i32 71, ; 171
	i32 151, ; 172
	i32 220, ; 173
	i32 59, ; 174
	i32 17, ; 175
	i32 114, ; 176
	i32 9, ; 177
	i32 65, ; 178
	i32 119, ; 179
	i32 137, ; 180
	i32 133, ; 181
	i32 123, ; 182
	i32 203, ; 183
	i32 195, ; 184
	i32 72, ; 185
	i32 29, ; 186
	i32 26, ; 187
	i32 165, ; 188
	i32 89, ; 189
	i32 187, ; 190
	i32 8, ; 191
	i32 58, ; 192
	i32 188, ; 193
	i32 135, ; 194
	i32 144, ; 195
	i32 97, ; 196
	i32 131, ; 197
	i32 183, ; 198
	i32 67, ; 199
	i32 78, ; 200
	i32 5, ; 201
	i32 141, ; 202
	i32 117, ; 203
	i32 0, ; 204
	i32 184, ; 205
	i32 116, ; 206
	i32 4, ; 207
	i32 157, ; 208
	i32 197, ; 209
	i32 180, ; 210
	i32 150, ; 211
	i32 134, ; 212
	i32 145, ; 213
	i32 82, ; 214
	i32 35, ; 215
	i32 12, ; 216
	i32 97, ; 217
	i32 73, ; 218
	i32 64, ; 219
	i32 72, ; 220
	i32 181, ; 221
	i32 138, ; 222
	i32 169, ; 223
	i32 14, ; 224
	i32 90, ; 225
	i32 44, ; 226
	i32 103, ; 227
	i32 68, ; 228
	i32 8, ; 229
	i32 124, ; 230
	i32 178, ; 231
	i32 171, ; 232
	i32 18, ; 233
	i32 218, ; 234
	i32 191, ; 235
	i32 174, ; 236
	i32 95, ; 237
	i32 213, ; 238
	i32 77, ; 239
	i32 67, ; 240
	i32 13, ; 241
	i32 56, ; 242
	i32 211, ; 243
	i32 10, ; 244
	i32 150, ; 245
	i32 53, ; 246
	i32 178, ; 247
	i32 166, ; 248
	i32 217, ; 249
	i32 219, ; 250
	i32 80, ; 251
	i32 131, ; 252
	i32 177, ; 253
	i32 47, ; 254
	i32 186, ; 255
	i32 11, ; 256
	i32 140, ; 257
	i32 204, ; 258
	i32 203, ; 259
	i32 20, ; 260
	i32 43, ; 261
	i32 138, ; 262
	i32 184, ; 263
	i32 111, ; 264
	i32 95, ; 265
	i32 15, ; 266
	i32 49, ; 267
	i32 53, ; 268
	i32 77, ; 269
	i32 193, ; 270
	i32 214, ; 271
	i32 158, ; 272
	i32 89, ; 273
	i32 152, ; 274
	i32 198, ; 275
	i32 194, ; 276
	i32 104, ; 277
	i32 207, ; 278
	i32 106, ; 279
	i32 48, ; 280
	i32 21, ; 281
	i32 48, ; 282
	i32 81, ; 283
	i32 82, ; 284
	i32 128, ; 285
	i32 27, ; 286
	i32 93, ; 287
	i32 84, ; 288
	i32 6, ; 289
	i32 109, ; 290
	i32 100, ; 291
	i32 19, ; 292
	i32 56, ; 293
	i32 134, ; 294
	i32 128, ; 295
	i32 83, ; 296
	i32 38, ; 297
	i32 35, ; 298
	i32 52, ; 299
	i32 101, ; 300
	i32 216, ; 301
	i32 218, ; 302
	i32 93, ; 303
	i32 46, ; 304
	i32 129, ; 305
	i32 180, ; 306
	i32 139, ; 307
	i32 149, ; 308
	i32 199, ; 309
	i32 113, ; 310
	i32 50, ; 311
	i32 34, ; 312
	i32 120, ; 313
	i32 136, ; 314
	i32 220, ; 315
	i32 147, ; 316
	i32 130, ; 317
	i32 12, ; 318
	i32 78, ; 319
	i32 201, ; 320
	i32 198, ; 321
	i32 160, ; 322
	i32 61, ; 323
	i32 42, ; 324
	i32 208, ; 325
	i32 132, ; 326
	i32 187, ; 327
	i32 121, ; 328
	i32 91, ; 329
	i32 47, ; 330
	i32 210, ; 331
	i32 135, ; 332
	i32 63, ; 333
	i32 107, ; 334
	i32 208, ; 335
	i32 96, ; 336
	i32 7, ; 337
	i32 76, ; 338
	i32 175, ; 339
	i32 112, ; 340
	i32 45, ; 341
	i32 92, ; 342
	i32 122, ; 343
	i32 24, ; 344
	i32 205, ; 345
	i32 110, ; 346
	i32 219, ; 347
	i32 124, ; 348
	i32 3, ; 349
	i32 189, ; 350
	i32 88, ; 351
	i32 69, ; 352
	i32 217, ; 353
	i32 79, ; 354
	i32 52, ; 355
	i32 11, ; 356
	i32 148, ; 357
	i32 94, ; 358
	i32 221, ; 359
	i32 24, ; 360
	i32 23, ; 361
	i32 205, ; 362
	i32 57, ; 363
	i32 212, ; 364
	i32 170, ; 365
	i32 31, ; 366
	i32 36, ; 367
	i32 62, ; 368
	i32 54, ; 369
	i32 167, ; 370
	i32 101, ; 371
	i32 49, ; 372
	i32 191, ; 373
	i32 62, ; 374
	i32 116, ; 375
	i32 28, ; 376
	i32 121, ; 377
	i32 57, ; 378
	i32 68, ; 379
	i32 173, ; 380
	i32 221, ; 381
	i32 33, ; 382
	i32 75, ; 383
	i32 120, ; 384
	i32 102, ; 385
	i32 172, ; 386
	i32 154, ; 387
	i32 55, ; 388
	i32 108, ; 389
	i32 144, ; 390
	i32 51, ; 391
	i32 79, ; 392
	i32 145, ; 393
	i32 37, ; 394
	i32 40, ; 395
	i32 202, ; 396
	i32 70, ; 397
	i32 171, ; 398
	i32 192, ; 399
	i32 170, ; 400
	i32 179, ; 401
	i32 32, ; 402
	i32 142, ; 403
	i32 110, ; 404
	i32 127, ; 405
	i32 213, ; 406
	i32 123, ; 407
	i32 99, ; 408
	i32 105, ; 409
	i32 136, ; 410
	i32 86, ; 411
	i32 27, ; 412
	i32 9, ; 413
	i32 155, ; 414
	i32 44, ; 415
	i32 168, ; 416
	i32 81, ; 417
	i32 185, ; 418
	i32 55, ; 419
	i32 50, ; 420
	i32 183, ; 421
	i32 210, ; 422
	i32 51, ; 423
	i32 83, ; 424
	i32 159, ; 425
	i32 182, ; 426
	i32 22, ; 427
	i32 17, ; 428
	i32 69, ; 429
	i32 185, ; 430
	i32 29, ; 431
	i32 151, ; 432
	i32 43, ; 433
	i32 196, ; 434
	i32 118, ; 435
	i32 64, ; 436
	i32 154, ; 437
	i32 141, ; 438
	i32 98, ; 439
	i32 80, ; 440
	i32 39, ; 441
	i32 194, ; 442
	i32 118 ; 443
], align 4

@marshal_methods_number_of_classes = dso_local local_unnamed_addr constant i32 0, align 4

@marshal_methods_class_cache = dso_local local_unnamed_addr global [0 x %struct.MarshalMethodsManagedClass] zeroinitializer, align 4

; Names of classes in which marshal methods reside
@mm_class_names = dso_local local_unnamed_addr constant [0 x ptr] zeroinitializer, align 4

@mm_method_names = dso_local local_unnamed_addr constant [1 x %struct.MarshalMethodName] [
	%struct.MarshalMethodName {
		i64 0, ; id 0x0; name: 
		ptr @.MarshalMethodName.0_name; char* name
	} ; 0
], align 8

; get_function_pointer (uint32_t mono_image_index, uint32_t class_index, uint32_t method_token, void*& target_ptr)
@get_function_pointer = internal dso_local unnamed_addr global ptr null, align 4

; Functions

; Function attributes: "min-legal-vector-width"="0" mustprogress "no-trapping-math"="true" nofree norecurse nosync nounwind "stack-protector-buffer-size"="8" uwtable willreturn
define void @xamarin_app_init(ptr nocapture noundef readnone %env, ptr noundef %fn) local_unnamed_addr #0
{
	%fnIsNull = icmp eq ptr %fn, null
	br i1 %fnIsNull, label %1, label %2

1: ; preds = %0
	%putsResult = call noundef i32 @puts(ptr @.str.0)
	call void @abort()
	unreachable 

2: ; preds = %1, %0
	store ptr %fn, ptr @get_function_pointer, align 4, !tbaa !3
	ret void
}

; Strings
@.str.0 = private unnamed_addr constant [40 x i8] c"get_function_pointer MUST be specified\0A\00", align 1

;MarshalMethodName
@.MarshalMethodName.0_name = private unnamed_addr constant [1 x i8] c"\00", align 1

; External functions

; Function attributes: "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8"
declare void @abort() local_unnamed_addr #2

; Function attributes: nofree nounwind
declare noundef i32 @puts(ptr noundef) local_unnamed_addr #1
attributes #0 = { "min-legal-vector-width"="0" mustprogress "no-trapping-math"="true" nofree norecurse nosync nounwind "stack-protector-buffer-size"="8" "stackrealign" "target-cpu"="i686" "target-features"="+cx8,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "tune-cpu"="generic" uwtable willreturn }
attributes #1 = { nofree nounwind }
attributes #2 = { "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8" "stackrealign" "target-cpu"="i686" "target-features"="+cx8,+mmx,+sse,+sse2,+sse3,+ssse3,+x87" "tune-cpu"="generic" }

; Metadata
!llvm.module.flags = !{!0, !1, !7}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!llvm.ident = !{!2}
!2 = !{!"Xamarin.Android remotes/origin/release/8.0.4xx @ 82d8938cf80f6d5fa6c28529ddfbdb753d805ab4"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{i32 1, !"NumRegisterParameters", i32 0}
