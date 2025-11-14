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

@assembly_image_cache = dso_local local_unnamed_addr global [386 x ptr] zeroinitializer, align 4

; Each entry maps hash of an assembly name to an index into the `assembly_image_cache` array
@assembly_image_cache_hashes = dso_local local_unnamed_addr constant [766 x i32] [
	i32 2616222, ; 0: System.Net.NetworkInformation.dll => 0x27eb9e => 68
	i32 10166715, ; 1: System.Net.NameResolution.dll => 0x9b21bb => 67
	i32 15721112, ; 2: System.Runtime.Intrinsics.dll => 0xefe298 => 108
	i32 32687329, ; 3: Xamarin.AndroidX.Lifecycle.Runtime => 0x1f2c4e1 => 285
	i32 34715100, ; 4: Xamarin.Google.Guava.ListenableFuture.dll => 0x211b5dc => 334
	i32 34839235, ; 5: System.IO.FileSystem.DriveInfo => 0x2139ac3 => 48
	i32 39109920, ; 6: Newtonsoft.Json.dll => 0x254c520 => 225
	i32 39485524, ; 7: System.Net.WebSockets.dll => 0x25a8054 => 80
	i32 42639949, ; 8: System.Threading.Thread => 0x28aa24d => 145
	i32 66541672, ; 9: System.Diagnostics.StackTrace => 0x3f75868 => 30
	i32 67008169, ; 10: zh-Hant\Microsoft.Maui.Controls.resources => 0x3fe76a9 => 381
	i32 68219467, ; 11: System.Security.Cryptography.Primitives => 0x410f24b => 124
	i32 72070932, ; 12: Microsoft.Maui.Graphics.dll => 0x44bb714 => 224
	i32 82292897, ; 13: System.Runtime.CompilerServices.VisualC.dll => 0x4e7b0a1 => 102
	i32 93082064, ; 14: SIMRAdmin => 0x58c51d0 => 0
	i32 101534019, ; 15: Xamarin.AndroidX.SlidingPaneLayout => 0x60d4943 => 303
	i32 103834273, ; 16: Xamarin.Firebase.Annotations.dll => 0x63062a1 => 315
	i32 117431740, ; 17: System.Runtime.InteropServices => 0x6ffddbc => 107
	i32 120558881, ; 18: Xamarin.AndroidX.SlidingPaneLayout.dll => 0x72f9521 => 303
	i32 122350210, ; 19: System.Threading.Channels.dll => 0x74aea82 => 139
	i32 134690465, ; 20: Xamarin.Kotlin.StdLib.Jdk7.dll => 0x80736a1 => 344
	i32 142721839, ; 21: System.Net.WebHeaderCollection => 0x881c32f => 77
	i32 147669188, ; 22: Plugin.Firebase.Core.dll => 0x8cd40c4 => 227
	i32 149972175, ; 23: System.Security.Cryptography.Primitives.dll => 0x8f064cf => 124
	i32 159306688, ; 24: System.ComponentModel.Annotations => 0x97ed3c0 => 13
	i32 165246403, ; 25: Xamarin.AndroidX.Collection.dll => 0x9d975c3 => 259
	i32 176265551, ; 26: System.ServiceProcess => 0xa81994f => 132
	i32 182336117, ; 27: Xamarin.AndroidX.SwipeRefreshLayout.dll => 0xade3a75 => 305
	i32 184328833, ; 28: System.ValueTuple.dll => 0xafca281 => 151
	i32 195452805, ; 29: vi/Microsoft.Maui.Controls.resources.dll => 0xba65f85 => 378
	i32 199333315, ; 30: zh-HK/Microsoft.Maui.Controls.resources.dll => 0xbe195c3 => 379
	i32 205061960, ; 31: System.ComponentModel => 0xc38ff48 => 18
	i32 209399409, ; 32: Xamarin.AndroidX.Browser.dll => 0xc7b2e71 => 257
	i32 220171995, ; 33: System.Diagnostics.Debug => 0xd1f8edb => 26
	i32 230216969, ; 34: Xamarin.AndroidX.Legacy.Support.Core.Utils.dll => 0xdb8d509 => 279
	i32 230752869, ; 35: Microsoft.CSharp.dll => 0xdc10265 => 1
	i32 231409092, ; 36: System.Linq.Parallel => 0xdcb05c4 => 59
	i32 231814094, ; 37: System.Globalization => 0xdd133ce => 42
	i32 246610117, ; 38: System.Reflection.Emit.Lightweight => 0xeb2f8c5 => 91
	i32 261689757, ; 39: Xamarin.AndroidX.ConstraintLayout.dll => 0xf99119d => 262
	i32 261882112, ; 40: DocumentFormat.OpenXml.Framework.dll => 0xf9c0100 => 179
	i32 276479776, ; 41: System.Threading.Timer.dll => 0x107abf20 => 147
	i32 278686392, ; 42: Xamarin.AndroidX.Lifecycle.LiveData.dll => 0x109c6ab8 => 281
	i32 280482487, ; 43: Xamarin.AndroidX.Interpolator => 0x10b7d2b7 => 278
	i32 280992041, ; 44: cs/Microsoft.Maui.Controls.resources.dll => 0x10bf9929 => 350
	i32 291076382, ; 45: System.IO.Pipes.AccessControl.dll => 0x1159791e => 54
	i32 298918909, ; 46: System.Net.Ping.dll => 0x11d123fd => 69
	i32 317674968, ; 47: vi\Microsoft.Maui.Controls.resources => 0x12ef55d8 => 378
	i32 318968648, ; 48: Xamarin.AndroidX.Activity.dll => 0x13031348 => 248
	i32 321597661, ; 49: System.Numerics => 0x132b30dd => 83
	i32 331603304, ; 50: SixLabors.Fonts => 0x13c3dd68 => 231
	i32 336156722, ; 51: ja/Microsoft.Maui.Controls.resources.dll => 0x14095832 => 363
	i32 342366114, ; 52: Xamarin.AndroidX.Lifecycle.Common => 0x146817a2 => 280
	i32 356389973, ; 53: it/Microsoft.Maui.Controls.resources.dll => 0x153e1455 => 362
	i32 360082299, ; 54: System.ServiceModel.Web => 0x15766b7b => 131
	i32 364956269, ; 55: Grpc.Net.Common => 0x15c0ca6d => 200
	i32 367780167, ; 56: System.IO.Pipes => 0x15ebe147 => 55
	i32 371306672, ; 57: Grpc.Core.Api.dll => 0x1621b0b0 => 198
	i32 374914964, ; 58: System.Transactions.Local => 0x1658bf94 => 149
	i32 375677976, ; 59: System.Net.ServicePoint.dll => 0x16646418 => 74
	i32 379916513, ; 60: System.Threading.Thread.dll => 0x16a510e1 => 145
	i32 382771021, ; 61: Microsoft.Bcl.Memory.dll => 0x16d09f4d => 205
	i32 385762202, ; 62: System.Memory.dll => 0x16fe439a => 62
	i32 391886110, ; 63: Grpc.Net.Client.dll => 0x175bb51e => 199
	i32 392610295, ; 64: System.Threading.ThreadPool.dll => 0x1766c1f7 => 146
	i32 393699800, ; 65: Firebase => 0x177761d8 => 183
	i32 395744057, ; 66: _Microsoft.Android.Resource.Designer => 0x17969339 => 382
	i32 403441872, ; 67: WindowsBase => 0x180c08d0 => 165
	i32 435591531, ; 68: sv/Microsoft.Maui.Controls.resources.dll => 0x19f6996b => 374
	i32 441335492, ; 69: Xamarin.AndroidX.ConstraintLayout.Core => 0x1a4e3ec4 => 263
	i32 442565967, ; 70: System.Collections => 0x1a61054f => 12
	i32 450948140, ; 71: Xamarin.AndroidX.Fragment.dll => 0x1ae0ec2c => 276
	i32 451504562, ; 72: System.Security.Cryptography.X509Certificates => 0x1ae969b2 => 125
	i32 456227837, ; 73: System.Web.HttpUtility.dll => 0x1b317bfd => 152
	i32 459347974, ; 74: System.Runtime.Serialization.Primitives.dll => 0x1b611806 => 113
	i32 465846621, ; 75: mscorlib => 0x1bc4415d => 166
	i32 469710990, ; 76: System.dll => 0x1bff388e => 164
	i32 476646585, ; 77: Xamarin.AndroidX.Interpolator.dll => 0x1c690cb9 => 278
	i32 485140951, ; 78: Xamarin.Google.Android.DataTransport.TransportRuntime => 0x1ceaa9d7 => 329
	i32 485463106, ; 79: Microsoft.IdentityModel.Abstractions => 0x1cef9442 => 215
	i32 486930444, ; 80: Xamarin.AndroidX.LocalBroadcastManager.dll => 0x1d05f80c => 291
	i32 495452658, ; 81: Xamarin.Google.Android.DataTransport.TransportRuntime.dll => 0x1d8801f2 => 329
	i32 498788369, ; 82: System.ObjectModel => 0x1dbae811 => 84
	i32 500358224, ; 83: id/Microsoft.Maui.Controls.resources.dll => 0x1dd2dc50 => 361
	i32 503918385, ; 84: fi/Microsoft.Maui.Controls.resources.dll => 0x1e092f31 => 355
	i32 507148113, ; 85: Xamarin.Google.Android.DataTransport.TransportApi.dll => 0x1e3a7751 => 327
	i32 513247710, ; 86: Microsoft.Extensions.Primitives.dll => 0x1e9789de => 214
	i32 525008092, ; 87: SkiaSharp.dll => 0x1f4afcdc => 232
	i32 526420162, ; 88: System.Transactions.dll => 0x1f6088c2 => 150
	i32 527452488, ; 89: Xamarin.Kotlin.StdLib.Jdk7 => 0x1f704948 => 344
	i32 530272170, ; 90: System.Linq.Queryable => 0x1f9b4faa => 60
	i32 539058512, ; 91: Microsoft.Extensions.Logging => 0x20216150 => 210
	i32 540030774, ; 92: System.IO.FileSystem.dll => 0x20303736 => 51
	i32 542030372, ; 93: Xamarin.GooglePlayServices.Stats => 0x204eba24 => 338
	i32 545304856, ; 94: System.Runtime.Extensions => 0x2080b118 => 103
	i32 546455878, ; 95: System.Runtime.Serialization.Xml => 0x20924146 => 114
	i32 548916678, ; 96: Microsoft.Bcl.AsyncInterfaces => 0x20b7cdc6 => 204
	i32 549171840, ; 97: System.Globalization.Calendars => 0x20bbb280 => 40
	i32 557405415, ; 98: Jsr305Binding => 0x213954e7 => 331
	i32 569601784, ; 99: Xamarin.AndroidX.Window.Extensions.Core.Core => 0x21f36ef8 => 314
	i32 577335427, ; 100: System.Security.Cryptography.Cng => 0x22697083 => 120
	i32 592146354, ; 101: pt-BR/Microsoft.Maui.Controls.resources.dll => 0x234b6fb2 => 369
	i32 597488923, ; 102: CommunityToolkit.Maui => 0x239cf51b => 175
	i32 601371474, ; 103: System.IO.IsolatedStorage.dll => 0x23d83352 => 52
	i32 605376203, ; 104: System.IO.Compression.FileSystem => 0x24154ecb => 44
	i32 610194910, ; 105: System.Reactive.dll => 0x245ed5de => 242
	i32 613668793, ; 106: System.Security.Cryptography.Algorithms => 0x2493d7b9 => 119
	i32 627609679, ; 107: Xamarin.AndroidX.CustomView => 0x2568904f => 268
	i32 627931235, ; 108: nl\Microsoft.Maui.Controls.resources => 0x256d7863 => 367
	i32 639843206, ; 109: Xamarin.AndroidX.Emoji2.ViewsHelper.dll => 0x26233b86 => 274
	i32 643868501, ; 110: System.Net => 0x2660a755 => 81
	i32 646990296, ; 111: Google.Cloud.Firestore.V1.dll => 0x269049d8 => 192
	i32 662205335, ; 112: System.Text.Encodings.Web.dll => 0x27787397 => 136
	i32 663517072, ; 113: Xamarin.AndroidX.VersionedParcelable => 0x278c7790 => 310
	i32 666292255, ; 114: Xamarin.AndroidX.Arch.Core.Common.dll => 0x27b6d01f => 255
	i32 672442732, ; 115: System.Collections.Concurrent => 0x2814a96c => 8
	i32 683518922, ; 116: System.Net.Security => 0x28bdabca => 73
	i32 688181140, ; 117: ca/Microsoft.Maui.Controls.resources.dll => 0x2904cf94 => 349
	i32 690569205, ; 118: System.Xml.Linq.dll => 0x29293ff5 => 155
	i32 691348768, ; 119: Xamarin.KotlinX.Coroutines.Android.dll => 0x29352520 => 346
	i32 693804605, ; 120: System.Windows => 0x295a9e3d => 154
	i32 699345723, ; 121: System.Reflection.Emit => 0x29af2b3b => 92
	i32 700284507, ; 122: Xamarin.Jetbrains.Annotations => 0x29bd7e5b => 341
	i32 700358131, ; 123: System.IO.Compression.ZipFile => 0x29be9df3 => 45
	i32 706645707, ; 124: ko/Microsoft.Maui.Controls.resources.dll => 0x2a1e8ecb => 364
	i32 709557578, ; 125: de/Microsoft.Maui.Controls.resources.dll => 0x2a4afd4a => 352
	i32 720511267, ; 126: Xamarin.Kotlin.StdLib.Jdk8 => 0x2af22123 => 345
	i32 722857257, ; 127: System.Runtime.Loader.dll => 0x2b15ed29 => 109
	i32 735137430, ; 128: System.Security.SecureString.dll => 0x2bd14e96 => 129
	i32 752232764, ; 129: System.Diagnostics.Contracts.dll => 0x2cd6293c => 25
	i32 755313932, ; 130: Xamarin.Android.Glide.Annotations.dll => 0x2d052d0c => 245
	i32 759454413, ; 131: System.Net.Requests => 0x2d445acd => 72
	i32 762598435, ; 132: System.IO.Pipes.dll => 0x2d745423 => 55
	i32 775507847, ; 133: System.IO.Compression => 0x2e394f87 => 46
	i32 777317022, ; 134: sk\Microsoft.Maui.Controls.resources => 0x2e54ea9e => 373
	i32 789151979, ; 135: Microsoft.Extensions.Options => 0x2f0980eb => 213
	i32 790371945, ; 136: Xamarin.AndroidX.CustomView.PoolingContainer.dll => 0x2f1c1e69 => 269
	i32 804715423, ; 137: System.Data.Common => 0x2ff6fb9f => 22
	i32 807930345, ; 138: Xamarin.AndroidX.Lifecycle.LiveData.Core.Ktx.dll => 0x302809e9 => 283
	i32 823281589, ; 139: System.Private.Uri.dll => 0x311247b5 => 86
	i32 830298997, ; 140: System.IO.Compression.Brotli => 0x317d5b75 => 43
	i32 832635846, ; 141: System.Xml.XPath.dll => 0x31a103c6 => 160
	i32 834051424, ; 142: System.Net.Quic => 0x31b69d60 => 71
	i32 843511501, ; 143: Xamarin.AndroidX.Print => 0x3246f6cd => 296
	i32 846667644, ; 144: Xamarin.Firebase.Installations.dll => 0x32771f7c => 323
	i32 856800933, ; 145: Plugin.Firebase.CloudMessaging.dll => 0x3311bea5 => 226
	i32 873119928, ; 146: Microsoft.VisualBasic => 0x340ac0b8 => 3
	i32 877678880, ; 147: System.Globalization.dll => 0x34505120 => 42
	i32 878954865, ; 148: System.Net.Http.Json => 0x3463c971 => 63
	i32 882434999, ; 149: Xamarin.Firebase.Installations.InterOp.dll => 0x3498e3b7 => 324
	i32 904024072, ; 150: System.ComponentModel.Primitives.dll => 0x35e25008 => 16
	i32 911108515, ; 151: System.IO.MemoryMappedFiles.dll => 0x364e69a3 => 53
	i32 926902833, ; 152: tr/Microsoft.Maui.Controls.resources.dll => 0x373f6a31 => 376
	i32 928116545, ; 153: Xamarin.Google.Guava.ListenableFuture => 0x3751ef41 => 334
	i32 952186615, ; 154: System.Runtime.InteropServices.JavaScript.dll => 0x38c136f7 => 105
	i32 955402788, ; 155: Newtonsoft.Json => 0x38f24a24 => 225
	i32 956575887, ; 156: Xamarin.Kotlin.StdLib.Jdk8.dll => 0x3904308f => 345
	i32 965247473, ; 157: Plugin.Firebase.Core => 0x398881f1 => 227
	i32 966729478, ; 158: Xamarin.Google.Crypto.Tink.Android => 0x399f1f06 => 332
	i32 967690846, ; 159: Xamarin.AndroidX.Lifecycle.Common.dll => 0x39adca5e => 280
	i32 975236339, ; 160: System.Diagnostics.Tracing => 0x3a20ecf3 => 34
	i32 975874589, ; 161: System.Xml.XDocument => 0x3a2aaa1d => 158
	i32 986514023, ; 162: System.Private.DataContractSerialization.dll => 0x3acd0267 => 85
	i32 987214855, ; 163: System.Diagnostics.Tools => 0x3ad7b407 => 32
	i32 992768348, ; 164: System.Collections.dll => 0x3b2c715c => 12
	i32 994442037, ; 165: System.IO.FileSystem => 0x3b45fb35 => 51
	i32 996733531, ; 166: Xamarin.Google.Android.DataTransport.TransportBackendCct => 0x3b68f25b => 328
	i32 1001831731, ; 167: System.IO.UnmanagedMemoryStream.dll => 0x3bb6bd33 => 56
	i32 1012816738, ; 168: Xamarin.AndroidX.SavedState.dll => 0x3c5e5b62 => 300
	i32 1019214401, ; 169: System.Drawing => 0x3cbffa41 => 36
	i32 1028951442, ; 170: Microsoft.Extensions.DependencyInjection.Abstractions => 0x3d548d92 => 209
	i32 1029334545, ; 171: da/Microsoft.Maui.Controls.resources.dll => 0x3d5a6611 => 351
	i32 1031528504, ; 172: Xamarin.Google.ErrorProne.Annotations.dll => 0x3d7be038 => 333
	i32 1035644815, ; 173: Xamarin.AndroidX.AppCompat => 0x3dbaaf8f => 253
	i32 1036359102, ; 174: Xamarin.GooglePlayServices.CloudMessaging.dll => 0x3dc595be => 337
	i32 1036536393, ; 175: System.Drawing.Primitives.dll => 0x3dc84a49 => 35
	i32 1044663988, ; 176: System.Linq.Expressions.dll => 0x3e444eb4 => 58
	i32 1049751285, ; 177: Google.Api.CommonProtos.dll => 0x3e91eef5 => 184
	i32 1052210849, ; 178: Xamarin.AndroidX.Lifecycle.ViewModel.dll => 0x3eb776a1 => 287
	i32 1067306892, ; 179: GoogleGson => 0x3f9dcf8c => 196
	i32 1082857460, ; 180: System.ComponentModel.TypeConverter => 0x408b17f4 => 17
	i32 1083751839, ; 181: System.IO.Packaging => 0x4098bd9f => 239
	i32 1084122840, ; 182: Xamarin.Kotlin.StdLib => 0x409e66d8 => 342
	i32 1098259244, ; 183: System => 0x41761b2c => 164
	i32 1118262833, ; 184: ko\Microsoft.Maui.Controls.resources => 0x42a75631 => 364
	i32 1121599056, ; 185: Xamarin.AndroidX.Lifecycle.Runtime.Ktx.dll => 0x42da3e50 => 286
	i32 1127624469, ; 186: Microsoft.Extensions.Logging.Debug => 0x43362f15 => 212
	i32 1141947663, ; 187: Xamarin.Firebase.Measurement.Connector.dll => 0x4410bd0f => 325
	i32 1145085672, ; 188: System.Linq.Async.dll => 0x44409ee8 => 240
	i32 1149092582, ; 189: Xamarin.AndroidX.Window => 0x447dc2e6 => 313
	i32 1162065116, ; 190: Microsoft.Bcl.Memory => 0x4543b4dc => 205
	i32 1168523401, ; 191: pt\Microsoft.Maui.Controls.resources => 0x45a64089 => 370
	i32 1170634674, ; 192: System.Web.dll => 0x45c677b2 => 153
	i32 1175144683, ; 193: Xamarin.AndroidX.VectorDrawable.Animated => 0x460b48eb => 309
	i32 1178241025, ; 194: Xamarin.AndroidX.Navigation.Runtime.dll => 0x463a8801 => 294
	i32 1201029973, ; 195: StarkbankEcdsa => 0x47964355 => 236
	i32 1203173028, ; 196: Grpc.Net.Client => 0x47b6f6a4 => 199
	i32 1203215381, ; 197: pl/Microsoft.Maui.Controls.resources.dll => 0x47b79c15 => 368
	i32 1204270330, ; 198: Xamarin.AndroidX.Arch.Core.Common => 0x47c7b4fa => 255
	i32 1208641965, ; 199: System.Diagnostics.Process => 0x480a69ad => 29
	i32 1214827643, ; 200: CommunityToolkit.Mvvm => 0x4868cc7b => 177
	i32 1219128291, ; 201: System.IO.IsolatedStorage => 0x48aa6be3 => 52
	i32 1234928153, ; 202: nb/Microsoft.Maui.Controls.resources.dll => 0x499b8219 => 366
	i32 1243150071, ; 203: Xamarin.AndroidX.Window.Extensions.Core.Core.dll => 0x4a18f6f7 => 314
	i32 1253011324, ; 204: Microsoft.Win32.Registry => 0x4aaf6f7c => 5
	i32 1260983243, ; 205: cs\Microsoft.Maui.Controls.resources => 0x4b2913cb => 350
	i32 1264511973, ; 206: Xamarin.AndroidX.Startup.StartupRuntime.dll => 0x4b5eebe5 => 304
	i32 1267360935, ; 207: Xamarin.AndroidX.VectorDrawable => 0x4b8a64a7 => 308
	i32 1273260888, ; 208: Xamarin.AndroidX.Collection.Ktx => 0x4be46b58 => 260
	i32 1275534314, ; 209: Xamarin.KotlinX.Coroutines.Android => 0x4c071bea => 346
	i32 1278448581, ; 210: Xamarin.AndroidX.Annotation.Jvm => 0x4c3393c5 => 252
	i32 1292843635, ; 211: DocumentFormat.OpenXml.Framework => 0x4d0f3a73 => 179
	i32 1293217323, ; 212: Xamarin.AndroidX.DrawerLayout.dll => 0x4d14ee2b => 271
	i32 1309188875, ; 213: System.Private.DataContractSerialization => 0x4e08a30b => 85
	i32 1309284514, ; 214: Plugin.FirebasePushNotification => 0x4e0a18a2 => 228
	i32 1322716291, ; 215: Xamarin.AndroidX.Window.dll => 0x4ed70c83 => 313
	i32 1324164729, ; 216: System.Linq => 0x4eed2679 => 61
	i32 1333047053, ; 217: Xamarin.Firebase.Common => 0x4f74af0d => 316
	i32 1335329327, ; 218: System.Runtime.Serialization.Json.dll => 0x4f97822f => 112
	i32 1338318188, ; 219: ExcelNumberFormat.dll => 0x4fc51d6c => 180
	i32 1338781641, ; 220: DocumentFormat.OpenXml.dll => 0x4fcc2fc9 => 178
	i32 1364015309, ; 221: System.IO => 0x514d38cd => 57
	i32 1373134921, ; 222: zh-Hans\Microsoft.Maui.Controls.resources => 0x51d86049 => 380
	i32 1376866003, ; 223: Xamarin.AndroidX.SavedState => 0x52114ed3 => 300
	i32 1379779777, ; 224: System.Resources.ResourceManager => 0x523dc4c1 => 99
	i32 1379897097, ; 225: Xamarin.JavaX.Inject => 0x523f8f09 => 340
	i32 1390396154, ; 226: ClosedXML.Parser.dll => 0x52dfc2fa => 174
	i32 1402170036, ; 227: System.Configuration.dll => 0x53936ab4 => 19
	i32 1406073936, ; 228: Xamarin.AndroidX.CoordinatorLayout => 0x53cefc50 => 264
	i32 1408764838, ; 229: System.Runtime.Serialization.Formatters.dll => 0x53f80ba6 => 111
	i32 1411638395, ; 230: System.Runtime.CompilerServices.Unsafe => 0x5423e47b => 101
	i32 1422545099, ; 231: System.Runtime.CompilerServices.VisualC => 0x54ca50cb => 102
	i32 1430672901, ; 232: ar\Microsoft.Maui.Controls.resources => 0x55465605 => 348
	i32 1433687999, ; 233: SendGrid.dll => 0x557457bf => 230
	i32 1434145427, ; 234: System.Runtime.Handles => 0x557b5293 => 104
	i32 1435222561, ; 235: Xamarin.Google.Crypto.Tink.Android.dll => 0x558bc221 => 332
	i32 1437713837, ; 236: Grpc.Auth => 0x55b1c5ad => 197
	i32 1439761251, ; 237: System.Net.Quic.dll => 0x55d10363 => 71
	i32 1452070440, ; 238: System.Formats.Asn1.dll => 0x568cd628 => 38
	i32 1453312822, ; 239: System.Diagnostics.Tools.dll => 0x569fcb36 => 32
	i32 1455549312, ; 240: LiveCharts => 0x56c1eb80 => 202
	i32 1457743152, ; 241: System.Runtime.Extensions.dll => 0x56e36530 => 103
	i32 1458022317, ; 242: System.Net.Security.dll => 0x56e7a7ad => 73
	i32 1460893475, ; 243: System.IdentityModel.Tokens.Jwt => 0x57137723 => 238
	i32 1461004990, ; 244: es\Microsoft.Maui.Controls.resources => 0x57152abe => 354
	i32 1461234159, ; 245: System.Collections.Immutable.dll => 0x5718a9ef => 9
	i32 1461719063, ; 246: System.Security.Cryptography.OpenSsl => 0x57201017 => 123
	i32 1462112819, ; 247: System.IO.Compression.dll => 0x57261233 => 46
	i32 1469204771, ; 248: Xamarin.AndroidX.AppCompat.AppCompatResources => 0x57924923 => 254
	i32 1470490898, ; 249: Microsoft.Extensions.Primitives => 0x57a5e912 => 214
	i32 1479771757, ; 250: System.Collections.Immutable => 0x5833866d => 9
	i32 1480492111, ; 251: System.IO.Compression.Brotli.dll => 0x583e844f => 43
	i32 1487239319, ; 252: Microsoft.Win32.Primitives => 0x58a57897 => 4
	i32 1490025113, ; 253: Xamarin.AndroidX.SavedState.SavedState.Ktx.dll => 0x58cffa99 => 301
	i32 1493001747, ; 254: hi/Microsoft.Maui.Controls.resources.dll => 0x58fd6613 => 358
	i32 1498168481, ; 255: Microsoft.IdentityModel.JsonWebTokens.dll => 0x594c3ca1 => 216
	i32 1514721132, ; 256: el/Microsoft.Maui.Controls.resources.dll => 0x5a48cf6c => 353
	i32 1531040989, ; 257: Xamarin.Firebase.Iid.Interop.dll => 0x5b41d4dd => 322
	i32 1536373174, ; 258: System.Diagnostics.TextWriterTraceListener => 0x5b9331b6 => 31
	i32 1536837071, ; 259: Twilio.dll => 0x5b9a45cf => 243
	i32 1543031311, ; 260: System.Text.RegularExpressions.dll => 0x5bf8ca0f => 138
	i32 1543355203, ; 261: System.Reflection.Emit.dll => 0x5bfdbb43 => 92
	i32 1550322496, ; 262: System.Reflection.Extensions.dll => 0x5c680b40 => 93
	i32 1551623176, ; 263: sk/Microsoft.Maui.Controls.resources.dll => 0x5c7be408 => 373
	i32 1565862583, ; 264: System.IO.FileSystem.Primitives => 0x5d552ab7 => 49
	i32 1566207040, ; 265: System.Threading.Tasks.Dataflow.dll => 0x5d5a6c40 => 141
	i32 1573704789, ; 266: System.Runtime.Serialization.Json => 0x5dccd455 => 112
	i32 1580037396, ; 267: System.Threading.Overlapped => 0x5e2d7514 => 140
	i32 1582372066, ; 268: Xamarin.AndroidX.DocumentFile.dll => 0x5e5114e2 => 270
	i32 1592978981, ; 269: System.Runtime.Serialization.dll => 0x5ef2ee25 => 115
	i32 1597949149, ; 270: Xamarin.Google.ErrorProne.Annotations => 0x5f3ec4dd => 333
	i32 1601112923, ; 271: System.Xml.Serialization => 0x5f6f0b5b => 157
	i32 1604827217, ; 272: System.Net.WebClient => 0x5fa7b851 => 76
	i32 1618516317, ; 273: System.Net.WebSockets.Client.dll => 0x6078995d => 79
	i32 1622152042, ; 274: Xamarin.AndroidX.Loader.dll => 0x60b0136a => 290
	i32 1622358360, ; 275: System.Dynamic.Runtime => 0x60b33958 => 37
	i32 1623212457, ; 276: SkiaSharp.Views.Maui.Controls => 0x60c041a9 => 234
	i32 1624863272, ; 277: Xamarin.AndroidX.ViewPager2 => 0x60d97228 => 312
	i32 1634654947, ; 278: CommunityToolkit.Maui.Core.dll => 0x616edae3 => 176
	i32 1635184631, ; 279: Xamarin.AndroidX.Emoji2.ViewsHelper => 0x6176eff7 => 274
	i32 1636350590, ; 280: Xamarin.AndroidX.CursorAdapter => 0x6188ba7e => 267
	i32 1639515021, ; 281: System.Net.Http.dll => 0x61b9038d => 64
	i32 1639986890, ; 282: System.Text.RegularExpressions => 0x61c036ca => 138
	i32 1641389582, ; 283: System.ComponentModel.EventBasedAsync.dll => 0x61d59e0e => 15
	i32 1657153582, ; 284: System.Runtime => 0x62c6282e => 116
	i32 1658241508, ; 285: Xamarin.AndroidX.Tracing.Tracing.dll => 0x62d6c1e4 => 306
	i32 1658251792, ; 286: Xamarin.Google.Android.Material.dll => 0x62d6ea10 => 330
	i32 1670060433, ; 287: Xamarin.AndroidX.ConstraintLayout => 0x638b1991 => 262
	i32 1675553242, ; 288: System.IO.FileSystem.DriveInfo.dll => 0x63dee9da => 48
	i32 1677501392, ; 289: System.Net.Primitives.dll => 0x63fca3d0 => 70
	i32 1678508291, ; 290: System.Net.WebSockets => 0x640c0103 => 80
	i32 1679769178, ; 291: System.Security.Cryptography => 0x641f3e5a => 126
	i32 1691477237, ; 292: System.Reflection.Metadata => 0x64d1e4f5 => 94
	i32 1696967625, ; 293: System.Security.Cryptography.Csp => 0x6525abc9 => 121
	i32 1698840827, ; 294: Xamarin.Kotlin.StdLib.Common => 0x654240fb => 343
	i32 1701541528, ; 295: System.Diagnostics.Debug.dll => 0x656b7698 => 26
	i32 1720223769, ; 296: Xamarin.AndroidX.Lifecycle.LiveData.Core.Ktx => 0x66888819 => 283
	i32 1726116996, ; 297: System.Reflection.dll => 0x66e27484 => 97
	i32 1728033016, ; 298: System.Diagnostics.FileVersionInfo.dll => 0x66ffb0f8 => 28
	i32 1729485958, ; 299: Xamarin.AndroidX.CardView.dll => 0x6715dc86 => 258
	i32 1736233607, ; 300: ro/Microsoft.Maui.Controls.resources.dll => 0x677cd287 => 371
	i32 1743415430, ; 301: ca\Microsoft.Maui.Controls.resources => 0x67ea6886 => 349
	i32 1744735666, ; 302: System.Transactions.Local.dll => 0x67fe8db2 => 149
	i32 1746316138, ; 303: Mono.Android.Export => 0x6816ab6a => 169
	i32 1750313021, ; 304: Microsoft.Win32.Primitives.dll => 0x6853a83d => 4
	i32 1758240030, ; 305: System.Resources.Reader.dll => 0x68cc9d1e => 98
	i32 1763938596, ; 306: System.Diagnostics.TraceSource.dll => 0x69239124 => 33
	i32 1765942094, ; 307: System.Reflection.Extensions => 0x6942234e => 93
	i32 1766324549, ; 308: Xamarin.AndroidX.SwipeRefreshLayout => 0x6947f945 => 305
	i32 1770582343, ; 309: Microsoft.Extensions.Logging.dll => 0x6988f147 => 210
	i32 1776026572, ; 310: System.Core.dll => 0x69dc03cc => 21
	i32 1777075843, ; 311: System.Globalization.Extensions.dll => 0x69ec0683 => 41
	i32 1780572499, ; 312: Mono.Android.Runtime.dll => 0x6a216153 => 170
	i32 1782161461, ; 313: Grpc.Core.Api => 0x6a39a035 => 198
	i32 1782862114, ; 314: ms\Microsoft.Maui.Controls.resources => 0x6a445122 => 365
	i32 1788241197, ; 315: Xamarin.AndroidX.Fragment => 0x6a96652d => 276
	i32 1793755602, ; 316: he\Microsoft.Maui.Controls.resources => 0x6aea89d2 => 357
	i32 1796167890, ; 317: Microsoft.Bcl.AsyncInterfaces.dll => 0x6b0f58d2 => 204
	i32 1808609942, ; 318: Xamarin.AndroidX.Loader => 0x6bcd3296 => 290
	i32 1813058853, ; 319: Xamarin.Kotlin.StdLib.dll => 0x6c111525 => 342
	i32 1813201214, ; 320: Xamarin.Google.Android.Material => 0x6c13413e => 330
	i32 1818569960, ; 321: Xamarin.AndroidX.Navigation.UI.dll => 0x6c652ce8 => 295
	i32 1818787751, ; 322: Microsoft.VisualBasic.Core => 0x6c687fa7 => 2
	i32 1824175904, ; 323: System.Text.Encoding.Extensions => 0x6cbab720 => 134
	i32 1824722060, ; 324: System.Runtime.Serialization.Formatters => 0x6cc30c8c => 111
	i32 1828688058, ; 325: Microsoft.Extensions.Logging.Abstractions.dll => 0x6cff90ba => 211
	i32 1842015223, ; 326: uk/Microsoft.Maui.Controls.resources.dll => 0x6dcaebf7 => 377
	i32 1847515442, ; 327: Xamarin.Android.Glide.Annotations => 0x6e1ed932 => 245
	i32 1853025655, ; 328: sv\Microsoft.Maui.Controls.resources => 0x6e72ed77 => 374
	i32 1858542181, ; 329: System.Linq.Expressions => 0x6ec71a65 => 58
	i32 1866604563, ; 330: RBush.dll => 0x6f422013 => 229
	i32 1870277092, ; 331: System.Reflection.Primitives => 0x6f7a29e4 => 95
	i32 1875935024, ; 332: fr\Microsoft.Maui.Controls.resources => 0x6fd07f30 => 356
	i32 1876173635, ; 333: Xamarin.Firebase.Encoders.Proto => 0x6fd42343 => 321
	i32 1879696579, ; 334: System.Formats.Tar.dll => 0x7009e4c3 => 39
	i32 1885316902, ; 335: Xamarin.AndroidX.Arch.Core.Runtime.dll => 0x705fa726 => 256
	i32 1888955245, ; 336: System.Diagnostics.Contracts => 0x70972b6d => 25
	i32 1889954781, ; 337: System.Reflection.Metadata.dll => 0x70a66bdd => 94
	i32 1898237753, ; 338: System.Reflection.DispatchProxy => 0x7124cf39 => 89
	i32 1900519031, ; 339: Grpc.Auth.dll => 0x71479e77 => 197
	i32 1900610850, ; 340: System.Resources.ResourceManager.dll => 0x71490522 => 99
	i32 1908813208, ; 341: Xamarin.GooglePlayServices.Basement => 0x71c62d98 => 336
	i32 1910275211, ; 342: System.Collections.NonGeneric.dll => 0x71dc7c8b => 10
	i32 1927897671, ; 343: System.CodeDom.dll => 0x72e96247 => 237
	i32 1933215285, ; 344: Xamarin.Firebase.Messaging.dll => 0x733a8635 => 326
	i32 1939592360, ; 345: System.Private.Xml.Linq => 0x739bd4a8 => 87
	i32 1956758971, ; 346: System.Resources.Writer => 0x74a1c5bb => 100
	i32 1961813231, ; 347: Xamarin.AndroidX.Security.SecurityCrypto.dll => 0x74eee4ef => 302
	i32 1968388702, ; 348: Microsoft.Extensions.Configuration.dll => 0x75533a5e => 206
	i32 1983156543, ; 349: Xamarin.Kotlin.StdLib.Common.dll => 0x7634913f => 343
	i32 1985761444, ; 350: Xamarin.Android.Glide.GifDecoder => 0x765c50a4 => 247
	i32 1986222447, ; 351: Microsoft.IdentityModel.Tokens.dll => 0x7663596f => 218
	i32 2003115576, ; 352: el\Microsoft.Maui.Controls.resources => 0x77651e38 => 353
	i32 2011961780, ; 353: System.Buffers.dll => 0x77ec19b4 => 7
	i32 2019465201, ; 354: Xamarin.AndroidX.Lifecycle.ViewModel => 0x785e97f1 => 287
	i32 2025202353, ; 355: ar/Microsoft.Maui.Controls.resources.dll => 0x78b622b1 => 348
	i32 2031763787, ; 356: Xamarin.Android.Glide => 0x791a414b => 244
	i32 2045470958, ; 357: System.Private.Xml => 0x79eb68ee => 88
	i32 2055257422, ; 358: Xamarin.AndroidX.Lifecycle.LiveData.Core.dll => 0x7a80bd4e => 282
	i32 2060060697, ; 359: System.Windows.dll => 0x7aca0819 => 154
	i32 2066184531, ; 360: de\Microsoft.Maui.Controls.resources => 0x7b277953 => 352
	i32 2070888862, ; 361: System.Diagnostics.TraceSource => 0x7b6f419e => 33
	i32 2079903147, ; 362: System.Runtime.dll => 0x7bf8cdab => 116
	i32 2090596640, ; 363: System.Numerics.Vectors => 0x7c9bf920 => 82
	i32 2124230737, ; 364: Xamarin.Google.Android.DataTransport.TransportBackendCct.dll => 0x7e9d3051 => 328
	i32 2127167465, ; 365: System.Console => 0x7ec9ffe9 => 20
	i32 2129483829, ; 366: Xamarin.GooglePlayServices.Base.dll => 0x7eed5835 => 335
	i32 2142473426, ; 367: System.Collections.Specialized => 0x7fb38cd2 => 11
	i32 2143790110, ; 368: System.Xml.XmlSerializer.dll => 0x7fc7a41e => 162
	i32 2146852085, ; 369: Microsoft.VisualBasic.dll => 0x7ff65cf5 => 3
	i32 2159891885, ; 370: Microsoft.Maui => 0x80bd55ad => 222
	i32 2166698602, ; 371: ClosedXML => 0x8125326a => 173
	i32 2169148018, ; 372: hu\Microsoft.Maui.Controls.resources => 0x814a9272 => 360
	i32 2174878672, ; 373: Xamarin.Firebase.Annotations => 0x81a203d0 => 315
	i32 2178612968, ; 374: System.CodeDom => 0x81dafee8 => 237
	i32 2181898931, ; 375: Microsoft.Extensions.Options.dll => 0x820d22b3 => 213
	i32 2188602587, ; 376: Microcharts.Maui => 0x82736cdb => 203
	i32 2192057212, ; 377: Microsoft.Extensions.Logging.Abstractions => 0x82a8237c => 211
	i32 2193016926, ; 378: System.ObjectModel.dll => 0x82b6c85e => 84
	i32 2201107256, ; 379: Xamarin.KotlinX.Coroutines.Core.Jvm.dll => 0x83323b38 => 347
	i32 2201231467, ; 380: System.Net.Http => 0x8334206b => 64
	i32 2207618523, ; 381: it\Microsoft.Maui.Controls.resources => 0x839595db => 362
	i32 2210798277, ; 382: SendGrid => 0x83c61ac5 => 230
	i32 2216717168, ; 383: Firebase.Auth.dll => 0x84206b70 => 182
	i32 2217644978, ; 384: Xamarin.AndroidX.VectorDrawable.Animated.dll => 0x842e93b2 => 309
	i32 2222056684, ; 385: System.Threading.Tasks.Parallel => 0x8471e4ec => 143
	i32 2225974570, ; 386: Twilio => 0x84adad2a => 243
	i32 2244775296, ; 387: Xamarin.AndroidX.LocalBroadcastManager => 0x85cc8d80 => 291
	i32 2252106437, ; 388: System.Xml.Serialization.dll => 0x863c6ac5 => 157
	i32 2256313426, ; 389: System.Globalization.Extensions => 0x867c9c52 => 41
	i32 2265110946, ; 390: System.Security.AccessControl.dll => 0x8702d9a2 => 117
	i32 2266799131, ; 391: Microsoft.Extensions.Configuration.Abstractions => 0x871c9c1b => 207
	i32 2267999099, ; 392: Xamarin.Android.Glide.DiskLruCache.dll => 0x872eeb7b => 246
	i32 2270573516, ; 393: fr/Microsoft.Maui.Controls.resources.dll => 0x875633cc => 356
	i32 2279755925, ; 394: Xamarin.AndroidX.RecyclerView.dll => 0x87e25095 => 298
	i32 2293034957, ; 395: System.ServiceModel.Web.dll => 0x88acefcd => 131
	i32 2295906218, ; 396: System.Net.Sockets => 0x88d8bfaa => 75
	i32 2298471582, ; 397: System.Net.Mail => 0x88ffe49e => 66
	i32 2303942373, ; 398: nb\Microsoft.Maui.Controls.resources => 0x89535ee5 => 366
	i32 2305521784, ; 399: System.Private.CoreLib.dll => 0x896b7878 => 172
	i32 2315684594, ; 400: Xamarin.AndroidX.Annotation.dll => 0x8a068af2 => 250
	i32 2320631194, ; 401: System.Threading.Tasks.Parallel.dll => 0x8a52059a => 143
	i32 2340441535, ; 402: System.Runtime.InteropServices.RuntimeInformation.dll => 0x8b804dbf => 106
	i32 2344264397, ; 403: System.ValueTuple => 0x8bbaa2cd => 151
	i32 2353062107, ; 404: System.Net.Primitives => 0x8c40e0db => 70
	i32 2364201794, ; 405: SkiaSharp.Views.Maui.Core => 0x8ceadb42 => 235
	i32 2368005991, ; 406: System.Xml.ReaderWriter.dll => 0x8d24e767 => 156
	i32 2369706906, ; 407: Microsoft.IdentityModel.Logging => 0x8d3edb9a => 217
	i32 2371007202, ; 408: Microsoft.Extensions.Configuration => 0x8d52b2e2 => 206
	i32 2378619854, ; 409: System.Security.Cryptography.Csp.dll => 0x8dc6dbce => 121
	i32 2383496789, ; 410: System.Security.Principal.Windows.dll => 0x8e114655 => 127
	i32 2395872292, ; 411: id\Microsoft.Maui.Controls.resources => 0x8ece1c24 => 361
	i32 2397347608, ; 412: Google.LongRunning.dll => 0x8ee49f18 => 194
	i32 2401565422, ; 413: System.Web.HttpUtility => 0x8f24faee => 152
	i32 2403452196, ; 414: Xamarin.AndroidX.Emoji2.dll => 0x8f41c524 => 273
	i32 2421380589, ; 415: System.Threading.Tasks.Dataflow => 0x905355ed => 141
	i32 2423080555, ; 416: Xamarin.AndroidX.Collection.Ktx.dll => 0x906d466b => 260
	i32 2427813419, ; 417: hi\Microsoft.Maui.Controls.resources => 0x90b57e2b => 358
	i32 2435356389, ; 418: System.Console.dll => 0x912896e5 => 20
	i32 2435904999, ; 419: System.ComponentModel.DataAnnotations.dll => 0x9130f5e7 => 14
	i32 2441199521, ; 420: Google.Cloud.Firestore => 0x9181bfa1 => 191
	i32 2454642406, ; 421: System.Text.Encoding.dll => 0x924edee6 => 135
	i32 2458678730, ; 422: System.Net.Sockets.dll => 0x928c75ca => 75
	i32 2459001652, ; 423: System.Linq.Parallel.dll => 0x92916334 => 59
	i32 2465532216, ; 424: Xamarin.AndroidX.ConstraintLayout.Core.dll => 0x92f50938 => 263
	i32 2471841756, ; 425: netstandard.dll => 0x93554fdc => 167
	i32 2475788418, ; 426: Java.Interop.dll => 0x93918882 => 168
	i32 2480646305, ; 427: Microsoft.Maui.Controls => 0x93dba8a1 => 220
	i32 2483661569, ; 428: Xamarin.Firebase.Measurement.Connector => 0x9409ab01 => 325
	i32 2483742551, ; 429: Xamarin.Firebase.Messaging => 0x940ae757 => 326
	i32 2483903535, ; 430: System.ComponentModel.EventBasedAsync => 0x940d5c2f => 15
	i32 2484371297, ; 431: System.Net.ServicePoint => 0x94147f61 => 74
	i32 2486410006, ; 432: Xamarin.GooglePlayServices.CloudMessaging => 0x94339b16 => 337
	i32 2486847491, ; 433: Google.Api.Gax => 0x943a4803 => 185
	i32 2490993605, ; 434: System.AppContext.dll => 0x94798bc5 => 6
	i32 2501346920, ; 435: System.Data.DataSetExtensions => 0x95178668 => 23
	i32 2505896520, ; 436: Xamarin.AndroidX.Lifecycle.Runtime.dll => 0x955cf248 => 285
	i32 2522472828, ; 437: Xamarin.Android.Glide.dll => 0x9659e17c => 244
	i32 2538310050, ; 438: System.Reflection.Emit.Lightweight.dll => 0x974b89a2 => 91
	i32 2550873716, ; 439: hr\Microsoft.Maui.Controls.resources => 0x980b3e74 => 359
	i32 2562349572, ; 440: Microsoft.CSharp => 0x98ba5a04 => 1
	i32 2570120770, ; 441: System.Text.Encodings.Web => 0x9930ee42 => 136
	i32 2581783588, ; 442: Xamarin.AndroidX.Lifecycle.Runtime.Ktx => 0x99e2e424 => 286
	i32 2581819634, ; 443: Xamarin.AndroidX.VectorDrawable.dll => 0x99e370f2 => 308
	i32 2585220780, ; 444: System.Text.Encoding.Extensions.dll => 0x9a1756ac => 134
	i32 2585805581, ; 445: System.Net.Ping => 0x9a20430d => 69
	i32 2589602615, ; 446: System.Threading.ThreadPool => 0x9a5a3337 => 146
	i32 2593496499, ; 447: pl\Microsoft.Maui.Controls.resources => 0x9a959db3 => 368
	i32 2595928349, ; 448: FirebaseAdmin => 0x9abab91d => 181
	i32 2605712449, ; 449: Xamarin.KotlinX.Coroutines.Core.Jvm => 0x9b500441 => 347
	i32 2615233544, ; 450: Xamarin.AndroidX.Fragment.Ktx => 0x9be14c08 => 277
	i32 2616218305, ; 451: Microsoft.Extensions.Logging.Debug.dll => 0x9bf052c1 => 212
	i32 2617129537, ; 452: System.Private.Xml.dll => 0x9bfe3a41 => 88
	i32 2618712057, ; 453: System.Reflection.TypeExtensions.dll => 0x9c165ff9 => 96
	i32 2620111890, ; 454: Xamarin.Firebase.Encoders.dll => 0x9c2bbc12 => 319
	i32 2620871830, ; 455: Xamarin.AndroidX.CursorAdapter.dll => 0x9c375496 => 267
	i32 2623491480, ; 456: Xamarin.Firebase.Installations.InterOp => 0x9c5f4d98 => 324
	i32 2624644809, ; 457: Xamarin.AndroidX.DynamicAnimation => 0x9c70e6c9 => 272
	i32 2625339995, ; 458: SkiaSharp.Views.Maui.Core.dll => 0x9c7b825b => 235
	i32 2626831493, ; 459: ja\Microsoft.Maui.Controls.resources => 0x9c924485 => 363
	i32 2627185994, ; 460: System.Diagnostics.TextWriterTraceListener.dll => 0x9c97ad4a => 31
	i32 2629053246, ; 461: Google.Api.Gax.Rest => 0x9cb42b3e => 187
	i32 2629843544, ; 462: System.IO.Compression.ZipFile.dll => 0x9cc03a58 => 45
	i32 2633051222, ; 463: Xamarin.AndroidX.Lifecycle.LiveData => 0x9cf12c56 => 281
	i32 2635732976, ; 464: Google.Cloud.Firestore.dll => 0x9d1a17f0 => 191
	i32 2639764100, ; 465: Xamarin.Firebase.Encoders => 0x9d579a84 => 319
	i32 2640290731, ; 466: Microsoft.IdentityModel.Logging.dll => 0x9d5fa3ab => 217
	i32 2663391936, ; 467: Xamarin.Android.Glide.DiskLruCache => 0x9ec022c0 => 246
	i32 2663698177, ; 468: System.Runtime.Loader => 0x9ec4cf01 => 109
	i32 2664396074, ; 469: System.Xml.XDocument.dll => 0x9ecf752a => 158
	i32 2665622720, ; 470: System.Drawing.Primitives => 0x9ee22cc0 => 35
	i32 2673807045, ; 471: RBush => 0x9f5f0ec5 => 229
	i32 2676780864, ; 472: System.Data.Common.dll => 0x9f8c6f40 => 22
	i32 2686887180, ; 473: System.Runtime.Serialization.Xml.dll => 0xa026a50c => 114
	i32 2693849962, ; 474: System.IO.dll => 0xa090e36a => 57
	i32 2701096212, ; 475: Xamarin.AndroidX.Tracing.Tracing => 0xa0ff7514 => 306
	i32 2715334215, ; 476: System.Threading.Tasks.dll => 0xa1d8b647 => 144
	i32 2717744543, ; 477: System.Security.Claims => 0xa1fd7d9f => 118
	i32 2719963679, ; 478: System.Security.Cryptography.Cng.dll => 0xa21f5a1f => 120
	i32 2724373263, ; 479: System.Runtime.Numerics.dll => 0xa262a30f => 110
	i32 2732626843, ; 480: Xamarin.AndroidX.Activity => 0xa2e0939b => 248
	i32 2735172069, ; 481: System.Threading.Channels => 0xa30769e5 => 139
	i32 2737747696, ; 482: Xamarin.AndroidX.AppCompat.AppCompatResources.dll => 0xa32eb6f0 => 254
	i32 2740948882, ; 483: System.IO.Pipes.AccessControl => 0xa35f8f92 => 54
	i32 2744327253, ; 484: Google.Api.Gax.Grpc.dll => 0xa3931c55 => 186
	i32 2748088231, ; 485: System.Runtime.InteropServices.JavaScript => 0xa3cc7fa7 => 105
	i32 2752995522, ; 486: pt-BR\Microsoft.Maui.Controls.resources => 0xa41760c2 => 369
	i32 2757554483, ; 487: Google.Api.Gax.Grpc => 0xa45cf133 => 186
	i32 2758225723, ; 488: Microsoft.Maui.Controls.Xaml => 0xa4672f3b => 221
	i32 2764765095, ; 489: Microsoft.Maui.dll => 0xa4caf7a7 => 222
	i32 2765824710, ; 490: System.Text.Encoding.CodePages.dll => 0xa4db22c6 => 133
	i32 2770495804, ; 491: Xamarin.Jetbrains.Annotations.dll => 0xa522693c => 341
	i32 2778768386, ; 492: Xamarin.AndroidX.ViewPager.dll => 0xa5a0a402 => 311
	i32 2779977773, ; 493: Xamarin.AndroidX.ResourceInspection.Annotation.dll => 0xa5b3182d => 299
	i32 2785988530, ; 494: th\Microsoft.Maui.Controls.resources => 0xa60ecfb2 => 375
	i32 2788224221, ; 495: Xamarin.AndroidX.Fragment.Ktx.dll => 0xa630ecdd => 277
	i32 2795602088, ; 496: SkiaSharp.Views.Android.dll => 0xa6a180a8 => 233
	i32 2801831435, ; 497: Microsoft.Maui.Graphics => 0xa7008e0b => 224
	i32 2803228030, ; 498: System.Xml.XPath.XDocument.dll => 0xa715dd7e => 159
	i32 2804607052, ; 499: Xamarin.Firebase.Components.dll => 0xa72ae84c => 317
	i32 2806116107, ; 500: es/Microsoft.Maui.Controls.resources.dll => 0xa741ef0b => 354
	i32 2810250172, ; 501: Xamarin.AndroidX.CoordinatorLayout.dll => 0xa78103bc => 264
	i32 2818335264, ; 502: System.Linq.Async => 0xa7fc6220 => 240
	i32 2819470561, ; 503: System.Xml.dll => 0xa80db4e1 => 163
	i32 2821205001, ; 504: System.ServiceProcess.dll => 0xa8282c09 => 132
	i32 2821294376, ; 505: Xamarin.AndroidX.ResourceInspection.Annotation => 0xa8298928 => 299
	i32 2824502124, ; 506: System.Xml.XmlDocument => 0xa85a7b6c => 161
	i32 2831556043, ; 507: nl/Microsoft.Maui.Controls.resources.dll => 0xa8c61dcb => 367
	i32 2838993487, ; 508: Xamarin.AndroidX.Lifecycle.ViewModel.Ktx.dll => 0xa9379a4f => 288
	i32 2839679515, ; 509: Google.LongRunning => 0xa942121b => 194
	i32 2847418871, ; 510: Xamarin.GooglePlayServices.Base => 0xa9b829f7 => 335
	i32 2849599387, ; 511: System.Threading.Overlapped.dll => 0xa9d96f9b => 140
	i32 2853208004, ; 512: Xamarin.AndroidX.ViewPager => 0xaa107fc4 => 311
	i32 2855708567, ; 513: Xamarin.AndroidX.Transition => 0xaa36a797 => 307
	i32 2861098320, ; 514: Mono.Android.Export.dll => 0xaa88e550 => 169
	i32 2861189240, ; 515: Microsoft.Maui.Essentials => 0xaa8a4878 => 223
	i32 2868488919, ; 516: CommunityToolkit.Maui.Core => 0xaaf9aad7 => 176
	i32 2870099610, ; 517: Xamarin.AndroidX.Activity.Ktx.dll => 0xab123e9a => 249
	i32 2875164099, ; 518: Jsr305Binding.dll => 0xab5f85c3 => 331
	i32 2875220617, ; 519: System.Globalization.Calendars.dll => 0xab606289 => 40
	i32 2877542466, ; 520: ClosedXML.dll => 0xab83d042 => 173
	i32 2883826422, ; 521: Xamarin.Firebase.Installations => 0xabe3b2f6 => 323
	i32 2884993177, ; 522: Xamarin.AndroidX.ExifInterface => 0xabf58099 => 275
	i32 2887636118, ; 523: System.Net.dll => 0xac1dd496 => 81
	i32 2893550578, ; 524: Google.Apis.Core => 0xac7813f2 => 190
	i32 2898407901, ; 525: System.Management => 0xacc231dd => 241
	i32 2899753641, ; 526: System.IO.UnmanagedMemoryStream => 0xacd6baa9 => 56
	i32 2900621748, ; 527: System.Dynamic.Runtime.dll => 0xace3f9b4 => 37
	i32 2901442782, ; 528: System.Reflection => 0xacf080de => 97
	i32 2905242038, ; 529: mscorlib.dll => 0xad2a79b6 => 166
	i32 2909740682, ; 530: System.Private.CoreLib => 0xad6f1e8a => 172
	i32 2912489636, ; 531: SkiaSharp.Views.Android => 0xad9910a4 => 233
	i32 2912646636, ; 532: Google.Api.CommonProtos => 0xad9b75ec => 184
	i32 2914202368, ; 533: Xamarin.Firebase.Iid.Interop => 0xadb33300 => 322
	i32 2916838712, ; 534: Xamarin.AndroidX.ViewPager2.dll => 0xaddb6d38 => 312
	i32 2919462931, ; 535: System.Numerics.Vectors.dll => 0xae037813 => 82
	i32 2921128767, ; 536: Xamarin.AndroidX.Annotation.Experimental.dll => 0xae1ce33f => 251
	i32 2936416060, ; 537: System.Resources.Reader => 0xaf06273c => 98
	i32 2936686614, ; 538: SIMRAdmin.dll => 0xaf0a4816 => 0
	i32 2940926066, ; 539: System.Diagnostics.StackTrace.dll => 0xaf4af872 => 30
	i32 2942453041, ; 540: System.Xml.XPath.XDocument => 0xaf624531 => 159
	i32 2959614098, ; 541: System.ComponentModel.dll => 0xb0682092 => 18
	i32 2968338931, ; 542: System.Security.Principal.Windows => 0xb0ed41f3 => 127
	i32 2972252294, ; 543: System.Security.Cryptography.Algorithms.dll => 0xb128f886 => 119
	i32 2978675010, ; 544: Xamarin.AndroidX.DrawerLayout => 0xb18af942 => 271
	i32 2987532451, ; 545: Xamarin.AndroidX.Security.SecurityCrypto => 0xb21220a3 => 302
	i32 2990604888, ; 546: Google.Apis => 0xb2410258 => 188
	i32 2996846495, ; 547: Xamarin.AndroidX.Lifecycle.Process.dll => 0xb2a03f9f => 284
	i32 3016983068, ; 548: Xamarin.AndroidX.Startup.StartupRuntime => 0xb3d3821c => 304
	i32 3023353419, ; 549: WindowsBase.dll => 0xb434b64b => 165
	i32 3024354802, ; 550: Xamarin.AndroidX.Legacy.Support.Core.Utils => 0xb443fdf2 => 279
	i32 3038032645, ; 551: _Microsoft.Android.Resource.Designer.dll => 0xb514b305 => 382
	i32 3056245963, ; 552: Xamarin.AndroidX.SavedState.SavedState.Ktx => 0xb62a9ccb => 301
	i32 3057625584, ; 553: Xamarin.AndroidX.Navigation.Common => 0xb63fa9f0 => 292
	i32 3058099980, ; 554: Xamarin.GooglePlayServices.Tasks => 0xb646e70c => 339
	i32 3059408633, ; 555: Mono.Android.Runtime => 0xb65adef9 => 170
	i32 3059793426, ; 556: System.ComponentModel.Primitives => 0xb660be12 => 16
	i32 3071899978, ; 557: Xamarin.Firebase.Common.dll => 0xb719794a => 316
	i32 3075834255, ; 558: System.Threading.Tasks => 0xb755818f => 144
	i32 3077302341, ; 559: hu/Microsoft.Maui.Controls.resources.dll => 0xb76be845 => 360
	i32 3084678329, ; 560: Microsoft.IdentityModel.Tokens => 0xb7dc74b9 => 218
	i32 3090735792, ; 561: System.Security.Cryptography.X509Certificates.dll => 0xb838e2b0 => 125
	i32 3099732863, ; 562: System.Security.Claims.dll => 0xb8c22b7f => 118
	i32 3103600923, ; 563: System.Formats.Asn1 => 0xb8fd311b => 38
	i32 3106263381, ; 564: Grpc.Net.Common.dll => 0xb925d155 => 200
	i32 3106737866, ; 565: Xamarin.Firebase.Datatransport.dll => 0xb92d0eca => 318
	i32 3111772706, ; 566: System.Runtime.Serialization => 0xb979e222 => 115
	i32 3118851116, ; 567: ExcelNumberFormat => 0xb9e5e42c => 180
	i32 3121463068, ; 568: System.IO.FileSystem.AccessControl.dll => 0xba0dbf1c => 47
	i32 3124832203, ; 569: System.Threading.Tasks.Extensions => 0xba4127cb => 142
	i32 3132293585, ; 570: System.Security.AccessControl => 0xbab301d1 => 117
	i32 3147165239, ; 571: System.Diagnostics.Tracing.dll => 0xbb95ee37 => 34
	i32 3148237826, ; 572: GoogleGson.dll => 0xbba64c02 => 196
	i32 3155362983, ; 573: Xamarin.Google.Android.DataTransport.TransportApi => 0xbc1304a7 => 327
	i32 3159123045, ; 574: System.Reflection.Primitives.dll => 0xbc4c6465 => 95
	i32 3160747431, ; 575: System.IO.MemoryMappedFiles => 0xbc652da7 => 53
	i32 3178803400, ; 576: Xamarin.AndroidX.Navigation.Fragment.dll => 0xbd78b0c8 => 293
	i32 3178908327, ; 577: SixLabors.Fonts.dll => 0xbd7a4aa7 => 231
	i32 3192346100, ; 578: System.Security.SecureString => 0xbe4755f4 => 129
	i32 3193515020, ; 579: System.Web => 0xbe592c0c => 153
	i32 3203277885, ; 580: Google.Api.Gax.dll => 0xbeee243d => 185
	i32 3204380047, ; 581: System.Data.dll => 0xbefef58f => 24
	i32 3209718065, ; 582: System.Xml.XmlDocument.dll => 0xbf506931 => 161
	i32 3211777861, ; 583: Xamarin.AndroidX.DocumentFile => 0xbf6fd745 => 270
	i32 3220365878, ; 584: System.Threading => 0xbff2e236 => 148
	i32 3226221578, ; 585: System.Runtime.Handles.dll => 0xc04c3c0a => 104
	i32 3230466174, ; 586: Xamarin.GooglePlayServices.Basement.dll => 0xc08d007e => 336
	i32 3240169105, ; 587: LiveCharts.dll => 0xc1210e91 => 202
	i32 3251039220, ; 588: System.Reflection.DispatchProxy.dll => 0xc1c6ebf4 => 89
	i32 3258312781, ; 589: Xamarin.AndroidX.CardView => 0xc235e84d => 258
	i32 3265493905, ; 590: System.Linq.Queryable.dll => 0xc2a37b91 => 60
	i32 3265893370, ; 591: System.Threading.Tasks.Extensions.dll => 0xc2a993fa => 142
	i32 3271840132, ; 592: StarkbankEcdsa.dll => 0xc3045184 => 236
	i32 3277815716, ; 593: System.Resources.Writer.dll => 0xc35f7fa4 => 100
	i32 3279906254, ; 594: Microsoft.Win32.Registry.dll => 0xc37f65ce => 5
	i32 3280506390, ; 595: System.ComponentModel.Annotations.dll => 0xc3888e16 => 13
	i32 3290767353, ; 596: System.Security.Cryptography.Encoding => 0xc4251ff9 => 122
	i32 3299363146, ; 597: System.Text.Encoding => 0xc4a8494a => 135
	i32 3303498502, ; 598: System.Diagnostics.FileVersionInfo => 0xc4e76306 => 28
	i32 3305363605, ; 599: fi\Microsoft.Maui.Controls.resources => 0xc503d895 => 355
	i32 3312457198, ; 600: Microsoft.IdentityModel.JsonWebTokens => 0xc57015ee => 216
	i32 3316684772, ; 601: System.Net.Requests.dll => 0xc5b097e4 => 72
	i32 3317135071, ; 602: Xamarin.AndroidX.CustomView.dll => 0xc5b776df => 268
	i32 3317144872, ; 603: System.Data => 0xc5b79d28 => 24
	i32 3322403133, ; 604: Firebase.dll => 0xc607d93d => 183
	i32 3331531814, ; 605: Xamarin.GooglePlayServices.Stats.dll => 0xc6932426 => 338
	i32 3340387945, ; 606: SkiaSharp => 0xc71a4669 => 232
	i32 3340431453, ; 607: Xamarin.AndroidX.Arch.Core.Runtime => 0xc71af05d => 256
	i32 3345895724, ; 608: Xamarin.AndroidX.ProfileInstaller.ProfileInstaller.dll => 0xc76e512c => 297
	i32 3346324047, ; 609: Xamarin.AndroidX.Navigation.Runtime => 0xc774da4f => 294
	i32 3357674450, ; 610: ru\Microsoft.Maui.Controls.resources => 0xc8220bd2 => 372
	i32 3358260929, ; 611: System.Text.Json => 0xc82afec1 => 137
	i32 3362336904, ; 612: Xamarin.AndroidX.Activity.Ktx => 0xc8693088 => 249
	i32 3362522851, ; 613: Xamarin.AndroidX.Core => 0xc86c06e3 => 265
	i32 3366347497, ; 614: Java.Interop => 0xc8a662e9 => 168
	i32 3371992681, ; 615: Xamarin.Firebase.Encoders.Proto.dll => 0xc8fc8669 => 321
	i32 3374999561, ; 616: Xamarin.AndroidX.RecyclerView => 0xc92a6809 => 298
	i32 3381016424, ; 617: da\Microsoft.Maui.Controls.resources => 0xc9863768 => 351
	i32 3383578424, ; 618: Xamarin.Firebase.Encoders.JSON => 0xc9ad4f38 => 320
	i32 3395150330, ; 619: System.Runtime.CompilerServices.Unsafe.dll => 0xca5de1fa => 101
	i32 3401559547, ; 620: Plugin.FirebasePushNotification.dll => 0xcabfadfb => 228
	i32 3403906625, ; 621: System.Security.Cryptography.OpenSsl.dll => 0xcae37e41 => 123
	i32 3405233483, ; 622: Xamarin.AndroidX.CustomView.PoolingContainer => 0xcaf7bd4b => 269
	i32 3428513518, ; 623: Microsoft.Extensions.DependencyInjection.dll => 0xcc5af6ee => 208
	i32 3429136800, ; 624: System.Xml => 0xcc6479a0 => 163
	i32 3430777524, ; 625: netstandard => 0xcc7d82b4 => 167
	i32 3441283291, ; 626: Xamarin.AndroidX.DynamicAnimation.dll => 0xcd1dd0db => 272
	i32 3445260447, ; 627: System.Formats.Tar => 0xcd5a809f => 39
	i32 3452344032, ; 628: Microsoft.Maui.Controls.Compatibility.dll => 0xcdc696e0 => 219
	i32 3453592554, ; 629: Google.Apis.Core.dll => 0xcdd9a3ea => 190
	i32 3463511458, ; 630: hr/Microsoft.Maui.Controls.resources.dll => 0xce70fda2 => 359
	i32 3471940407, ; 631: System.ComponentModel.TypeConverter.dll => 0xcef19b37 => 17
	i32 3473156932, ; 632: SkiaSharp.Views.Maui.Controls.dll => 0xcf042b44 => 234
	i32 3476120550, ; 633: Mono.Android => 0xcf3163e6 => 171
	i32 3479583265, ; 634: ru/Microsoft.Maui.Controls.resources.dll => 0xcf663a21 => 372
	i32 3484440000, ; 635: ro\Microsoft.Maui.Controls.resources => 0xcfb055c0 => 371
	i32 3485117614, ; 636: System.Text.Json.dll => 0xcfbaacae => 137
	i32 3486566296, ; 637: System.Transactions => 0xcfd0c798 => 150
	i32 3493954962, ; 638: Xamarin.AndroidX.Concurrent.Futures.dll => 0xd0418592 => 261
	i32 3499097210, ; 639: Google.Protobuf.dll => 0xd08ffc7a => 195
	i32 3509114376, ; 640: System.Xml.Linq => 0xd128d608 => 155
	i32 3515174580, ; 641: System.Security.dll => 0xd1854eb4 => 130
	i32 3530912306, ; 642: System.Configuration => 0xd2757232 => 19
	i32 3539954161, ; 643: System.Net.HttpListener => 0xd2ff69f1 => 65
	i32 3560100363, ; 644: System.Threading.Timer => 0xd432d20b => 147
	i32 3570554715, ; 645: System.IO.FileSystem.AccessControl => 0xd4d2575b => 47
	i32 3580758918, ; 646: zh-HK\Microsoft.Maui.Controls.resources => 0xd56e0b86 => 379
	i32 3581231576, ; 647: ClosedXML.Parser => 0xd57541d8 => 174
	i32 3596207933, ; 648: LiteDB.dll => 0xd659c73d => 201
	i32 3597029428, ; 649: Xamarin.Android.Glide.GifDecoder.dll => 0xd6665034 => 247
	i32 3598063517, ; 650: Google.Cloud.Firestore.V1 => 0xd676179d => 192
	i32 3598340787, ; 651: System.Net.WebSockets.Client => 0xd67a52b3 => 79
	i32 3608519521, ; 652: System.Linq.dll => 0xd715a361 => 61
	i32 3612435020, ; 653: System.Management.dll => 0xd751624c => 241
	i32 3621458322, ; 654: Google.Api.Gax.Rest.dll => 0xd7db1192 => 187
	i32 3624195450, ; 655: System.Runtime.InteropServices.RuntimeInformation => 0xd804d57a => 106
	i32 3627220390, ; 656: Xamarin.AndroidX.Print.dll => 0xd832fda6 => 296
	i32 3629588173, ; 657: LiteDB => 0xd8571ecd => 201
	i32 3633644679, ; 658: Xamarin.AndroidX.Annotation.Experimental => 0xd8950487 => 251
	i32 3638274909, ; 659: System.IO.FileSystem.Primitives.dll => 0xd8dbab5d => 49
	i32 3641597786, ; 660: Xamarin.AndroidX.Lifecycle.LiveData.Core => 0xd90e5f5a => 282
	i32 3643446276, ; 661: tr\Microsoft.Maui.Controls.resources => 0xd92a9404 => 376
	i32 3643854240, ; 662: Xamarin.AndroidX.Navigation.Fragment => 0xd930cda0 => 293
	i32 3645089577, ; 663: System.ComponentModel.DataAnnotations => 0xd943a729 => 14
	i32 3645630983, ; 664: Google.Protobuf => 0xd94bea07 => 195
	i32 3657292374, ; 665: Microsoft.Extensions.Configuration.Abstractions.dll => 0xd9fdda56 => 207
	i32 3660523487, ; 666: System.Net.NetworkInformation => 0xda2f27df => 68
	i32 3672681054, ; 667: Mono.Android.dll => 0xdae8aa5e => 171
	i32 3682565725, ; 668: Xamarin.AndroidX.Browser => 0xdb7f7e5d => 257
	i32 3684561358, ; 669: Xamarin.AndroidX.Concurrent.Futures => 0xdb9df1ce => 261
	i32 3697841164, ; 670: zh-Hant/Microsoft.Maui.Controls.resources.dll => 0xdc68940c => 381
	i32 3700591436, ; 671: Microsoft.IdentityModel.Abstractions.dll => 0xdc928b4c => 215
	i32 3700866549, ; 672: System.Net.WebProxy.dll => 0xdc96bdf5 => 78
	i32 3706696989, ; 673: Xamarin.AndroidX.Core.Core.Ktx.dll => 0xdcefb51d => 266
	i32 3716563718, ; 674: System.Runtime.Intrinsics => 0xdd864306 => 108
	i32 3718780102, ; 675: Xamarin.AndroidX.Annotation => 0xdda814c6 => 250
	i32 3724971120, ; 676: Xamarin.AndroidX.Navigation.Common.dll => 0xde068c70 => 292
	i32 3731644420, ; 677: System.Reactive => 0xde6c6004 => 242
	i32 3732100267, ; 678: System.Net.NameResolution => 0xde7354ab => 67
	i32 3737834244, ; 679: System.Net.Http.Json.dll => 0xdecad304 => 63
	i32 3748608112, ; 680: System.Diagnostics.DiagnosticSource => 0xdf6f3870 => 27
	i32 3751444290, ; 681: System.Xml.XPath => 0xdf9a7f42 => 160
	i32 3757995660, ; 682: Google.Cloud.Location.dll => 0xdffe768c => 193
	i32 3786282454, ; 683: Xamarin.AndroidX.Collection => 0xe1ae15d6 => 259
	i32 3792276235, ; 684: System.Collections.NonGeneric => 0xe2098b0b => 10
	i32 3793997468, ; 685: Google.Apis.Auth.dll => 0xe223ce9c => 189
	i32 3800979733, ; 686: Microsoft.Maui.Controls.Compatibility => 0xe28e5915 => 219
	i32 3802395368, ; 687: System.Collections.Specialized.dll => 0xe2a3f2e8 => 11
	i32 3817368567, ; 688: CommunityToolkit.Maui.dll => 0xe3886bf7 => 175
	i32 3819260425, ; 689: System.Net.WebProxy => 0xe3a54a09 => 78
	i32 3822443793, ; 690: DocumentFormat.OpenXml => 0xe3d5dd11 => 178
	i32 3823082795, ; 691: System.Security.Cryptography.dll => 0xe3df9d2b => 126
	i32 3829621856, ; 692: System.Numerics.dll => 0xe4436460 => 83
	i32 3841636137, ; 693: Microsoft.Extensions.DependencyInjection.Abstractions.dll => 0xe4fab729 => 209
	i32 3844307129, ; 694: System.Net.Mail.dll => 0xe52378b9 => 66
	i32 3849253459, ; 695: System.Runtime.InteropServices.dll => 0xe56ef253 => 107
	i32 3870376305, ; 696: System.Net.HttpListener.dll => 0xe6b14171 => 65
	i32 3873536506, ; 697: System.Security.Principal => 0xe6e179fa => 128
	i32 3875112723, ; 698: System.Security.Cryptography.Encoding.dll => 0xe6f98713 => 122
	i32 3885497537, ; 699: System.Net.WebHeaderCollection.dll => 0xe797fcc1 => 77
	i32 3885922214, ; 700: Xamarin.AndroidX.Transition.dll => 0xe79e77a6 => 307
	i32 3888767677, ; 701: Xamarin.AndroidX.ProfileInstaller.ProfileInstaller => 0xe7c9e2bd => 297
	i32 3889960447, ; 702: zh-Hans/Microsoft.Maui.Controls.resources.dll => 0xe7dc15ff => 380
	i32 3896106733, ; 703: System.Collections.Concurrent.dll => 0xe839deed => 8
	i32 3896760992, ; 704: Xamarin.AndroidX.Core.dll => 0xe843daa0 => 265
	i32 3901907137, ; 705: Microsoft.VisualBasic.Core.dll => 0xe89260c1 => 2
	i32 3920810846, ; 706: System.IO.Compression.FileSystem.dll => 0xe9b2d35e => 44
	i32 3921031405, ; 707: Xamarin.AndroidX.VersionedParcelable.dll => 0xe9b630ed => 310
	i32 3928044579, ; 708: System.Xml.ReaderWriter => 0xea213423 => 156
	i32 3930554604, ; 709: System.Security.Principal.dll => 0xea4780ec => 128
	i32 3931092270, ; 710: Xamarin.AndroidX.Navigation.UI => 0xea4fb52e => 295
	i32 3934056515, ; 711: Xamarin.JavaX.Inject.dll => 0xea7cf043 => 340
	i32 3945713374, ; 712: System.Data.DataSetExtensions.dll => 0xeb2ecede => 23
	i32 3952357212, ; 713: System.IO.Packaging.dll => 0xeb942f5c => 239
	i32 3953953790, ; 714: System.Text.Encoding.CodePages => 0xebac8bfe => 133
	i32 3955647286, ; 715: Xamarin.AndroidX.AppCompat.dll => 0xebc66336 => 253
	i32 3959773229, ; 716: Xamarin.AndroidX.Lifecycle.Process => 0xec05582d => 284
	i32 3970018735, ; 717: Xamarin.GooglePlayServices.Tasks.dll => 0xeca1adaf => 339
	i32 3979528423, ; 718: Plugin.Firebase.CloudMessaging => 0xed32c8e7 => 226
	i32 3980434154, ; 719: th/Microsoft.Maui.Controls.resources.dll => 0xed409aea => 375
	i32 3987592930, ; 720: he/Microsoft.Maui.Controls.resources.dll => 0xedadd6e2 => 357
	i32 4003436829, ; 721: System.Diagnostics.Process.dll => 0xee9f991d => 29
	i32 4015948917, ; 722: Xamarin.AndroidX.Annotation.Jvm.dll => 0xef5e8475 => 252
	i32 4024013275, ; 723: Firebase.Auth => 0xefd991db => 182
	i32 4025784931, ; 724: System.Memory => 0xeff49a63 => 62
	i32 4046471985, ; 725: Microsoft.Maui.Controls.Xaml.dll => 0xf1304331 => 221
	i32 4054681211, ; 726: System.Reflection.Emit.ILGeneration => 0xf1ad867b => 90
	i32 4056144661, ; 727: Google.Cloud.Location => 0xf1c3db15 => 193
	i32 4059682726, ; 728: Google.Apis.dll => 0xf1f9d7a6 => 188
	i32 4068434129, ; 729: System.Private.Xml.Linq.dll => 0xf27f60d1 => 87
	i32 4073602200, ; 730: System.Threading.dll => 0xf2ce3c98 => 148
	i32 4082882467, ; 731: Google.Apis.Auth => 0xf35bd7a3 => 189
	i32 4094352644, ; 732: Microsoft.Maui.Essentials.dll => 0xf40add04 => 223
	i32 4099507663, ; 733: System.Drawing.dll => 0xf45985cf => 36
	i32 4100113165, ; 734: System.Private.Uri => 0xf462c30d => 86
	i32 4101593132, ; 735: Xamarin.AndroidX.Emoji2 => 0xf479582c => 273
	i32 4102112229, ; 736: pt/Microsoft.Maui.Controls.resources.dll => 0xf48143e5 => 370
	i32 4125707920, ; 737: ms/Microsoft.Maui.Controls.resources.dll => 0xf5e94e90 => 365
	i32 4126470640, ; 738: Microsoft.Extensions.DependencyInjection => 0xf5f4f1f0 => 208
	i32 4127667938, ; 739: System.IO.FileSystem.Watcher => 0xf60736e2 => 50
	i32 4130442656, ; 740: System.AppContext => 0xf6318da0 => 6
	i32 4147896353, ; 741: System.Reflection.Emit.ILGeneration.dll => 0xf73be021 => 90
	i32 4150914736, ; 742: uk\Microsoft.Maui.Controls.resources => 0xf769eeb0 => 377
	i32 4151237749, ; 743: System.Core => 0xf76edc75 => 21
	i32 4159265925, ; 744: System.Xml.XmlSerializer => 0xf7e95c85 => 162
	i32 4161255271, ; 745: System.Reflection.TypeExtensions => 0xf807b767 => 96
	i32 4164802419, ; 746: System.IO.FileSystem.Watcher.dll => 0xf83dd773 => 50
	i32 4177102269, ; 747: FirebaseAdmin.dll => 0xf8f985bd => 181
	i32 4181436372, ; 748: System.Runtime.Serialization.Primitives => 0xf93ba7d4 => 113
	i32 4182413190, ; 749: Xamarin.AndroidX.Lifecycle.ViewModelSavedState.dll => 0xf94a8f86 => 289
	i32 4185676441, ; 750: System.Security => 0xf97c5a99 => 130
	i32 4189085287, ; 751: Microcharts.Maui.dll => 0xf9b05e67 => 203
	i32 4192648326, ; 752: Xamarin.Firebase.Encoders.JSON.dll => 0xf9e6bc86 => 320
	i32 4196529839, ; 753: System.Net.WebClient.dll => 0xfa21f6af => 76
	i32 4213026141, ; 754: System.Diagnostics.DiagnosticSource.dll => 0xfb1dad5d => 27
	i32 4256097574, ; 755: Xamarin.AndroidX.Core.Core.Ktx => 0xfdaee526 => 266
	i32 4258378803, ; 756: Xamarin.AndroidX.Lifecycle.ViewModel.Ktx => 0xfdd1b433 => 288
	i32 4260525087, ; 757: System.Buffers => 0xfdf2741f => 7
	i32 4263231520, ; 758: System.IdentityModel.Tokens.Jwt.dll => 0xfe1bc020 => 238
	i32 4269159614, ; 759: Xamarin.Firebase.Datatransport => 0xfe7634be => 318
	i32 4271975918, ; 760: Microsoft.Maui.Controls.dll => 0xfea12dee => 220
	i32 4274623895, ; 761: CommunityToolkit.Mvvm.dll => 0xfec99597 => 177
	i32 4274976490, ; 762: System.Runtime.Numerics => 0xfecef6ea => 110
	i32 4284549794, ; 763: Xamarin.Firebase.Components => 0xff610aa2 => 317
	i32 4292120959, ; 764: Xamarin.AndroidX.Lifecycle.ViewModelSavedState => 0xffd4917f => 289
	i32 4294763496 ; 765: Xamarin.AndroidX.ExifInterface.dll => 0xfffce3e8 => 275
], align 4

@assembly_image_cache_indices = dso_local local_unnamed_addr constant [766 x i32] [
	i32 68, ; 0
	i32 67, ; 1
	i32 108, ; 2
	i32 285, ; 3
	i32 334, ; 4
	i32 48, ; 5
	i32 225, ; 6
	i32 80, ; 7
	i32 145, ; 8
	i32 30, ; 9
	i32 381, ; 10
	i32 124, ; 11
	i32 224, ; 12
	i32 102, ; 13
	i32 0, ; 14
	i32 303, ; 15
	i32 315, ; 16
	i32 107, ; 17
	i32 303, ; 18
	i32 139, ; 19
	i32 344, ; 20
	i32 77, ; 21
	i32 227, ; 22
	i32 124, ; 23
	i32 13, ; 24
	i32 259, ; 25
	i32 132, ; 26
	i32 305, ; 27
	i32 151, ; 28
	i32 378, ; 29
	i32 379, ; 30
	i32 18, ; 31
	i32 257, ; 32
	i32 26, ; 33
	i32 279, ; 34
	i32 1, ; 35
	i32 59, ; 36
	i32 42, ; 37
	i32 91, ; 38
	i32 262, ; 39
	i32 179, ; 40
	i32 147, ; 41
	i32 281, ; 42
	i32 278, ; 43
	i32 350, ; 44
	i32 54, ; 45
	i32 69, ; 46
	i32 378, ; 47
	i32 248, ; 48
	i32 83, ; 49
	i32 231, ; 50
	i32 363, ; 51
	i32 280, ; 52
	i32 362, ; 53
	i32 131, ; 54
	i32 200, ; 55
	i32 55, ; 56
	i32 198, ; 57
	i32 149, ; 58
	i32 74, ; 59
	i32 145, ; 60
	i32 205, ; 61
	i32 62, ; 62
	i32 199, ; 63
	i32 146, ; 64
	i32 183, ; 65
	i32 382, ; 66
	i32 165, ; 67
	i32 374, ; 68
	i32 263, ; 69
	i32 12, ; 70
	i32 276, ; 71
	i32 125, ; 72
	i32 152, ; 73
	i32 113, ; 74
	i32 166, ; 75
	i32 164, ; 76
	i32 278, ; 77
	i32 329, ; 78
	i32 215, ; 79
	i32 291, ; 80
	i32 329, ; 81
	i32 84, ; 82
	i32 361, ; 83
	i32 355, ; 84
	i32 327, ; 85
	i32 214, ; 86
	i32 232, ; 87
	i32 150, ; 88
	i32 344, ; 89
	i32 60, ; 90
	i32 210, ; 91
	i32 51, ; 92
	i32 338, ; 93
	i32 103, ; 94
	i32 114, ; 95
	i32 204, ; 96
	i32 40, ; 97
	i32 331, ; 98
	i32 314, ; 99
	i32 120, ; 100
	i32 369, ; 101
	i32 175, ; 102
	i32 52, ; 103
	i32 44, ; 104
	i32 242, ; 105
	i32 119, ; 106
	i32 268, ; 107
	i32 367, ; 108
	i32 274, ; 109
	i32 81, ; 110
	i32 192, ; 111
	i32 136, ; 112
	i32 310, ; 113
	i32 255, ; 114
	i32 8, ; 115
	i32 73, ; 116
	i32 349, ; 117
	i32 155, ; 118
	i32 346, ; 119
	i32 154, ; 120
	i32 92, ; 121
	i32 341, ; 122
	i32 45, ; 123
	i32 364, ; 124
	i32 352, ; 125
	i32 345, ; 126
	i32 109, ; 127
	i32 129, ; 128
	i32 25, ; 129
	i32 245, ; 130
	i32 72, ; 131
	i32 55, ; 132
	i32 46, ; 133
	i32 373, ; 134
	i32 213, ; 135
	i32 269, ; 136
	i32 22, ; 137
	i32 283, ; 138
	i32 86, ; 139
	i32 43, ; 140
	i32 160, ; 141
	i32 71, ; 142
	i32 296, ; 143
	i32 323, ; 144
	i32 226, ; 145
	i32 3, ; 146
	i32 42, ; 147
	i32 63, ; 148
	i32 324, ; 149
	i32 16, ; 150
	i32 53, ; 151
	i32 376, ; 152
	i32 334, ; 153
	i32 105, ; 154
	i32 225, ; 155
	i32 345, ; 156
	i32 227, ; 157
	i32 332, ; 158
	i32 280, ; 159
	i32 34, ; 160
	i32 158, ; 161
	i32 85, ; 162
	i32 32, ; 163
	i32 12, ; 164
	i32 51, ; 165
	i32 328, ; 166
	i32 56, ; 167
	i32 300, ; 168
	i32 36, ; 169
	i32 209, ; 170
	i32 351, ; 171
	i32 333, ; 172
	i32 253, ; 173
	i32 337, ; 174
	i32 35, ; 175
	i32 58, ; 176
	i32 184, ; 177
	i32 287, ; 178
	i32 196, ; 179
	i32 17, ; 180
	i32 239, ; 181
	i32 342, ; 182
	i32 164, ; 183
	i32 364, ; 184
	i32 286, ; 185
	i32 212, ; 186
	i32 325, ; 187
	i32 240, ; 188
	i32 313, ; 189
	i32 205, ; 190
	i32 370, ; 191
	i32 153, ; 192
	i32 309, ; 193
	i32 294, ; 194
	i32 236, ; 195
	i32 199, ; 196
	i32 368, ; 197
	i32 255, ; 198
	i32 29, ; 199
	i32 177, ; 200
	i32 52, ; 201
	i32 366, ; 202
	i32 314, ; 203
	i32 5, ; 204
	i32 350, ; 205
	i32 304, ; 206
	i32 308, ; 207
	i32 260, ; 208
	i32 346, ; 209
	i32 252, ; 210
	i32 179, ; 211
	i32 271, ; 212
	i32 85, ; 213
	i32 228, ; 214
	i32 313, ; 215
	i32 61, ; 216
	i32 316, ; 217
	i32 112, ; 218
	i32 180, ; 219
	i32 178, ; 220
	i32 57, ; 221
	i32 380, ; 222
	i32 300, ; 223
	i32 99, ; 224
	i32 340, ; 225
	i32 174, ; 226
	i32 19, ; 227
	i32 264, ; 228
	i32 111, ; 229
	i32 101, ; 230
	i32 102, ; 231
	i32 348, ; 232
	i32 230, ; 233
	i32 104, ; 234
	i32 332, ; 235
	i32 197, ; 236
	i32 71, ; 237
	i32 38, ; 238
	i32 32, ; 239
	i32 202, ; 240
	i32 103, ; 241
	i32 73, ; 242
	i32 238, ; 243
	i32 354, ; 244
	i32 9, ; 245
	i32 123, ; 246
	i32 46, ; 247
	i32 254, ; 248
	i32 214, ; 249
	i32 9, ; 250
	i32 43, ; 251
	i32 4, ; 252
	i32 301, ; 253
	i32 358, ; 254
	i32 216, ; 255
	i32 353, ; 256
	i32 322, ; 257
	i32 31, ; 258
	i32 243, ; 259
	i32 138, ; 260
	i32 92, ; 261
	i32 93, ; 262
	i32 373, ; 263
	i32 49, ; 264
	i32 141, ; 265
	i32 112, ; 266
	i32 140, ; 267
	i32 270, ; 268
	i32 115, ; 269
	i32 333, ; 270
	i32 157, ; 271
	i32 76, ; 272
	i32 79, ; 273
	i32 290, ; 274
	i32 37, ; 275
	i32 234, ; 276
	i32 312, ; 277
	i32 176, ; 278
	i32 274, ; 279
	i32 267, ; 280
	i32 64, ; 281
	i32 138, ; 282
	i32 15, ; 283
	i32 116, ; 284
	i32 306, ; 285
	i32 330, ; 286
	i32 262, ; 287
	i32 48, ; 288
	i32 70, ; 289
	i32 80, ; 290
	i32 126, ; 291
	i32 94, ; 292
	i32 121, ; 293
	i32 343, ; 294
	i32 26, ; 295
	i32 283, ; 296
	i32 97, ; 297
	i32 28, ; 298
	i32 258, ; 299
	i32 371, ; 300
	i32 349, ; 301
	i32 149, ; 302
	i32 169, ; 303
	i32 4, ; 304
	i32 98, ; 305
	i32 33, ; 306
	i32 93, ; 307
	i32 305, ; 308
	i32 210, ; 309
	i32 21, ; 310
	i32 41, ; 311
	i32 170, ; 312
	i32 198, ; 313
	i32 365, ; 314
	i32 276, ; 315
	i32 357, ; 316
	i32 204, ; 317
	i32 290, ; 318
	i32 342, ; 319
	i32 330, ; 320
	i32 295, ; 321
	i32 2, ; 322
	i32 134, ; 323
	i32 111, ; 324
	i32 211, ; 325
	i32 377, ; 326
	i32 245, ; 327
	i32 374, ; 328
	i32 58, ; 329
	i32 229, ; 330
	i32 95, ; 331
	i32 356, ; 332
	i32 321, ; 333
	i32 39, ; 334
	i32 256, ; 335
	i32 25, ; 336
	i32 94, ; 337
	i32 89, ; 338
	i32 197, ; 339
	i32 99, ; 340
	i32 336, ; 341
	i32 10, ; 342
	i32 237, ; 343
	i32 326, ; 344
	i32 87, ; 345
	i32 100, ; 346
	i32 302, ; 347
	i32 206, ; 348
	i32 343, ; 349
	i32 247, ; 350
	i32 218, ; 351
	i32 353, ; 352
	i32 7, ; 353
	i32 287, ; 354
	i32 348, ; 355
	i32 244, ; 356
	i32 88, ; 357
	i32 282, ; 358
	i32 154, ; 359
	i32 352, ; 360
	i32 33, ; 361
	i32 116, ; 362
	i32 82, ; 363
	i32 328, ; 364
	i32 20, ; 365
	i32 335, ; 366
	i32 11, ; 367
	i32 162, ; 368
	i32 3, ; 369
	i32 222, ; 370
	i32 173, ; 371
	i32 360, ; 372
	i32 315, ; 373
	i32 237, ; 374
	i32 213, ; 375
	i32 203, ; 376
	i32 211, ; 377
	i32 84, ; 378
	i32 347, ; 379
	i32 64, ; 380
	i32 362, ; 381
	i32 230, ; 382
	i32 182, ; 383
	i32 309, ; 384
	i32 143, ; 385
	i32 243, ; 386
	i32 291, ; 387
	i32 157, ; 388
	i32 41, ; 389
	i32 117, ; 390
	i32 207, ; 391
	i32 246, ; 392
	i32 356, ; 393
	i32 298, ; 394
	i32 131, ; 395
	i32 75, ; 396
	i32 66, ; 397
	i32 366, ; 398
	i32 172, ; 399
	i32 250, ; 400
	i32 143, ; 401
	i32 106, ; 402
	i32 151, ; 403
	i32 70, ; 404
	i32 235, ; 405
	i32 156, ; 406
	i32 217, ; 407
	i32 206, ; 408
	i32 121, ; 409
	i32 127, ; 410
	i32 361, ; 411
	i32 194, ; 412
	i32 152, ; 413
	i32 273, ; 414
	i32 141, ; 415
	i32 260, ; 416
	i32 358, ; 417
	i32 20, ; 418
	i32 14, ; 419
	i32 191, ; 420
	i32 135, ; 421
	i32 75, ; 422
	i32 59, ; 423
	i32 263, ; 424
	i32 167, ; 425
	i32 168, ; 426
	i32 220, ; 427
	i32 325, ; 428
	i32 326, ; 429
	i32 15, ; 430
	i32 74, ; 431
	i32 337, ; 432
	i32 185, ; 433
	i32 6, ; 434
	i32 23, ; 435
	i32 285, ; 436
	i32 244, ; 437
	i32 91, ; 438
	i32 359, ; 439
	i32 1, ; 440
	i32 136, ; 441
	i32 286, ; 442
	i32 308, ; 443
	i32 134, ; 444
	i32 69, ; 445
	i32 146, ; 446
	i32 368, ; 447
	i32 181, ; 448
	i32 347, ; 449
	i32 277, ; 450
	i32 212, ; 451
	i32 88, ; 452
	i32 96, ; 453
	i32 319, ; 454
	i32 267, ; 455
	i32 324, ; 456
	i32 272, ; 457
	i32 235, ; 458
	i32 363, ; 459
	i32 31, ; 460
	i32 187, ; 461
	i32 45, ; 462
	i32 281, ; 463
	i32 191, ; 464
	i32 319, ; 465
	i32 217, ; 466
	i32 246, ; 467
	i32 109, ; 468
	i32 158, ; 469
	i32 35, ; 470
	i32 229, ; 471
	i32 22, ; 472
	i32 114, ; 473
	i32 57, ; 474
	i32 306, ; 475
	i32 144, ; 476
	i32 118, ; 477
	i32 120, ; 478
	i32 110, ; 479
	i32 248, ; 480
	i32 139, ; 481
	i32 254, ; 482
	i32 54, ; 483
	i32 186, ; 484
	i32 105, ; 485
	i32 369, ; 486
	i32 186, ; 487
	i32 221, ; 488
	i32 222, ; 489
	i32 133, ; 490
	i32 341, ; 491
	i32 311, ; 492
	i32 299, ; 493
	i32 375, ; 494
	i32 277, ; 495
	i32 233, ; 496
	i32 224, ; 497
	i32 159, ; 498
	i32 317, ; 499
	i32 354, ; 500
	i32 264, ; 501
	i32 240, ; 502
	i32 163, ; 503
	i32 132, ; 504
	i32 299, ; 505
	i32 161, ; 506
	i32 367, ; 507
	i32 288, ; 508
	i32 194, ; 509
	i32 335, ; 510
	i32 140, ; 511
	i32 311, ; 512
	i32 307, ; 513
	i32 169, ; 514
	i32 223, ; 515
	i32 176, ; 516
	i32 249, ; 517
	i32 331, ; 518
	i32 40, ; 519
	i32 173, ; 520
	i32 323, ; 521
	i32 275, ; 522
	i32 81, ; 523
	i32 190, ; 524
	i32 241, ; 525
	i32 56, ; 526
	i32 37, ; 527
	i32 97, ; 528
	i32 166, ; 529
	i32 172, ; 530
	i32 233, ; 531
	i32 184, ; 532
	i32 322, ; 533
	i32 312, ; 534
	i32 82, ; 535
	i32 251, ; 536
	i32 98, ; 537
	i32 0, ; 538
	i32 30, ; 539
	i32 159, ; 540
	i32 18, ; 541
	i32 127, ; 542
	i32 119, ; 543
	i32 271, ; 544
	i32 302, ; 545
	i32 188, ; 546
	i32 284, ; 547
	i32 304, ; 548
	i32 165, ; 549
	i32 279, ; 550
	i32 382, ; 551
	i32 301, ; 552
	i32 292, ; 553
	i32 339, ; 554
	i32 170, ; 555
	i32 16, ; 556
	i32 316, ; 557
	i32 144, ; 558
	i32 360, ; 559
	i32 218, ; 560
	i32 125, ; 561
	i32 118, ; 562
	i32 38, ; 563
	i32 200, ; 564
	i32 318, ; 565
	i32 115, ; 566
	i32 180, ; 567
	i32 47, ; 568
	i32 142, ; 569
	i32 117, ; 570
	i32 34, ; 571
	i32 196, ; 572
	i32 327, ; 573
	i32 95, ; 574
	i32 53, ; 575
	i32 293, ; 576
	i32 231, ; 577
	i32 129, ; 578
	i32 153, ; 579
	i32 185, ; 580
	i32 24, ; 581
	i32 161, ; 582
	i32 270, ; 583
	i32 148, ; 584
	i32 104, ; 585
	i32 336, ; 586
	i32 202, ; 587
	i32 89, ; 588
	i32 258, ; 589
	i32 60, ; 590
	i32 142, ; 591
	i32 236, ; 592
	i32 100, ; 593
	i32 5, ; 594
	i32 13, ; 595
	i32 122, ; 596
	i32 135, ; 597
	i32 28, ; 598
	i32 355, ; 599
	i32 216, ; 600
	i32 72, ; 601
	i32 268, ; 602
	i32 24, ; 603
	i32 183, ; 604
	i32 338, ; 605
	i32 232, ; 606
	i32 256, ; 607
	i32 297, ; 608
	i32 294, ; 609
	i32 372, ; 610
	i32 137, ; 611
	i32 249, ; 612
	i32 265, ; 613
	i32 168, ; 614
	i32 321, ; 615
	i32 298, ; 616
	i32 351, ; 617
	i32 320, ; 618
	i32 101, ; 619
	i32 228, ; 620
	i32 123, ; 621
	i32 269, ; 622
	i32 208, ; 623
	i32 163, ; 624
	i32 167, ; 625
	i32 272, ; 626
	i32 39, ; 627
	i32 219, ; 628
	i32 190, ; 629
	i32 359, ; 630
	i32 17, ; 631
	i32 234, ; 632
	i32 171, ; 633
	i32 372, ; 634
	i32 371, ; 635
	i32 137, ; 636
	i32 150, ; 637
	i32 261, ; 638
	i32 195, ; 639
	i32 155, ; 640
	i32 130, ; 641
	i32 19, ; 642
	i32 65, ; 643
	i32 147, ; 644
	i32 47, ; 645
	i32 379, ; 646
	i32 174, ; 647
	i32 201, ; 648
	i32 247, ; 649
	i32 192, ; 650
	i32 79, ; 651
	i32 61, ; 652
	i32 241, ; 653
	i32 187, ; 654
	i32 106, ; 655
	i32 296, ; 656
	i32 201, ; 657
	i32 251, ; 658
	i32 49, ; 659
	i32 282, ; 660
	i32 376, ; 661
	i32 293, ; 662
	i32 14, ; 663
	i32 195, ; 664
	i32 207, ; 665
	i32 68, ; 666
	i32 171, ; 667
	i32 257, ; 668
	i32 261, ; 669
	i32 381, ; 670
	i32 215, ; 671
	i32 78, ; 672
	i32 266, ; 673
	i32 108, ; 674
	i32 250, ; 675
	i32 292, ; 676
	i32 242, ; 677
	i32 67, ; 678
	i32 63, ; 679
	i32 27, ; 680
	i32 160, ; 681
	i32 193, ; 682
	i32 259, ; 683
	i32 10, ; 684
	i32 189, ; 685
	i32 219, ; 686
	i32 11, ; 687
	i32 175, ; 688
	i32 78, ; 689
	i32 178, ; 690
	i32 126, ; 691
	i32 83, ; 692
	i32 209, ; 693
	i32 66, ; 694
	i32 107, ; 695
	i32 65, ; 696
	i32 128, ; 697
	i32 122, ; 698
	i32 77, ; 699
	i32 307, ; 700
	i32 297, ; 701
	i32 380, ; 702
	i32 8, ; 703
	i32 265, ; 704
	i32 2, ; 705
	i32 44, ; 706
	i32 310, ; 707
	i32 156, ; 708
	i32 128, ; 709
	i32 295, ; 710
	i32 340, ; 711
	i32 23, ; 712
	i32 239, ; 713
	i32 133, ; 714
	i32 253, ; 715
	i32 284, ; 716
	i32 339, ; 717
	i32 226, ; 718
	i32 375, ; 719
	i32 357, ; 720
	i32 29, ; 721
	i32 252, ; 722
	i32 182, ; 723
	i32 62, ; 724
	i32 221, ; 725
	i32 90, ; 726
	i32 193, ; 727
	i32 188, ; 728
	i32 87, ; 729
	i32 148, ; 730
	i32 189, ; 731
	i32 223, ; 732
	i32 36, ; 733
	i32 86, ; 734
	i32 273, ; 735
	i32 370, ; 736
	i32 365, ; 737
	i32 208, ; 738
	i32 50, ; 739
	i32 6, ; 740
	i32 90, ; 741
	i32 377, ; 742
	i32 21, ; 743
	i32 162, ; 744
	i32 96, ; 745
	i32 50, ; 746
	i32 181, ; 747
	i32 113, ; 748
	i32 289, ; 749
	i32 130, ; 750
	i32 203, ; 751
	i32 320, ; 752
	i32 76, ; 753
	i32 27, ; 754
	i32 266, ; 755
	i32 288, ; 756
	i32 7, ; 757
	i32 238, ; 758
	i32 318, ; 759
	i32 220, ; 760
	i32 177, ; 761
	i32 110, ; 762
	i32 317, ; 763
	i32 289, ; 764
	i32 275 ; 765
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
