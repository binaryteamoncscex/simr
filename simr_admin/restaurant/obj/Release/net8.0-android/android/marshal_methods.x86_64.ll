; ModuleID = 'marshal_methods.x86_64.ll'
source_filename = "marshal_methods.x86_64.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-android21"

%struct.MarshalMethodName = type {
	i64, ; uint64_t id
	ptr ; char* name
}

%struct.MarshalMethodsManagedClass = type {
	i32, ; uint32_t token
	ptr ; MonoClass klass
}

@assembly_image_cache = dso_local local_unnamed_addr global [222 x ptr] zeroinitializer, align 16

; Each entry maps hash of an assembly name to an index into the `assembly_image_cache` array
@assembly_image_cache_hashes = dso_local local_unnamed_addr constant [444 x i64] [
	i64 96808603140984794, ; 0: Google.Cloud.Location.dll => 0x157eee9616b8fda => 55
	i64 98382396393917666, ; 1: Microsoft.Extensions.Primitives.dll => 0x15d8644ad360ce2 => 74
	i64 120698629574877762, ; 2: Mono.Android => 0x1accec39cafe242 => 221
	i64 131669012237370309, ; 3: Microsoft.Maui.Essentials.dll => 0x1d3c844de55c3c5 => 83
	i64 196720943101637631, ; 4: System.Linq.Expressions.dll => 0x2bae4a7cd73f3ff => 165
	i64 210515253464952879, ; 5: Xamarin.AndroidX.Collection.dll => 0x2ebe681f694702f => 108
	i64 225432268808147330, ; 6: Microcharts.Maui => 0x320e5743f385182 => 64
	i64 232391251801502327, ; 7: Xamarin.AndroidX.SavedState.dll => 0x3399e9cbc897277 => 125
	i64 286416576930729751, ; 8: Twilio => 0x3f98e5bf5bd4f17 => 103
	i64 464346026994987652, ; 9: System.Reactive.dll => 0x671b04057e67284 => 102
	i64 502670939551102150, ; 10: System.Management.dll => 0x6f9d88e66daf4c6 => 101
	i64 545109961164950392, ; 11: fi/Microsoft.Maui.Controls.resources.dll => 0x7909e9f1ec38b78 => 7
	i64 560278790331054453, ; 12: System.Reflection.Primitives => 0x7c6829760de3975 => 187
	i64 687654259221141486, ; 13: Xamarin.GooglePlayServices.Base => 0x98b09e7c92917ee => 134
	i64 710500338161506772, ; 14: SixLabors.Fonts.dll => 0x9dc344b0ce959d4 => 91
	i64 718159679911342543, ; 15: FirebaseAdmin.dll => 0x9f76a6c851fb1cf => 43
	i64 750875890346172408, ; 16: System.Threading.Thread => 0xa6ba5a4da7d1ff8 => 209
	i64 799765834175365804, ; 17: System.ComponentModel.dll => 0xb1956c9f18442ac => 149
	i64 849051935479314978, ; 18: hi/Microsoft.Maui.Controls.resources.dll => 0xbc8703ca21a3a22 => 10
	i64 872800313462103108, ; 19: Xamarin.AndroidX.DrawerLayout => 0xc1ccf42c3c21c44 => 113
	i64 1010599046655515943, ; 20: System.Reflection.Primitives.dll => 0xe065e7a82401d27 => 187
	i64 1120440138749646132, ; 21: Xamarin.Google.Android.Material.dll => 0xf8c9a5eae431534 => 133
	i64 1121665720830085036, ; 22: nb/Microsoft.Maui.Controls.resources.dll => 0xf90f507becf47ac => 18
	i64 1268860745194512059, ; 23: System.Drawing.dll => 0x119be62002c19ebb => 159
	i64 1369545283391376210, ; 24: Xamarin.AndroidX.Navigation.Fragment.dll => 0x13019a2dd85acb52 => 121
	i64 1476839205573959279, ; 25: System.Net.Primitives.dll => 0x147ec96ece9b1e6f => 174
	i64 1486715745332614827, ; 26: Microsoft.Maui.Controls.dll => 0x14a1e017ea87d6ab => 80
	i64 1492954217099365037, ; 27: System.Net.HttpListener => 0x14b809f350210aad => 170
	i64 1513467482682125403, ; 28: Mono.Android.Runtime => 0x1500eaa8245f6c5b => 220
	i64 1537168428375924959, ; 29: System.Threading.Thread.dll => 0x15551e8a954ae0df => 209
	i64 1556147632182429976, ; 30: ko/Microsoft.Maui.Controls.resources.dll => 0x15988c06d24c8918 => 16
	i64 1624659445732251991, ; 31: Xamarin.AndroidX.AppCompat.AppCompatResources.dll => 0x168bf32877da9957 => 106
	i64 1628611045998245443, ; 32: Xamarin.AndroidX.Lifecycle.ViewModelSavedState.dll => 0x1699fd1e1a00b643 => 118
	i64 1731380447121279447, ; 33: Newtonsoft.Json => 0x18071957e9b889d7 => 85
	i64 1735388228521408345, ; 34: System.Net.Mail.dll => 0x181556663c69b759 => 171
	i64 1743969030606105336, ; 35: System.Memory.dll => 0x1833d297e88f2af8 => 168
	i64 1767386781656293639, ; 36: System.Private.Uri.dll => 0x188704e9f5582107 => 182
	i64 1769105627832031750, ; 37: Google.Protobuf => 0x188d203205129a06 => 57
	i64 1795316252682057001, ; 38: Xamarin.AndroidX.AppCompat.dll => 0x18ea3e9eac997529 => 105
	i64 1825687700144851180, ; 39: System.Runtime.InteropServices.RuntimeInformation.dll => 0x1956254a55ef08ec => 191
	i64 1835311033149317475, ; 40: es\Microsoft.Maui.Controls.resources => 0x197855a927386163 => 6
	i64 1836611346387731153, ; 41: Xamarin.AndroidX.SavedState => 0x197cf449ebe482d1 => 125
	i64 1847446322536158010, ; 42: DocumentFormat.OpenXml.Framework.dll => 0x19a372a4645e933a => 41
	i64 1865037103900624886, ; 43: Microsoft.Bcl.AsyncInterfaces => 0x19e1f15d56eb87f6 => 65
	i64 1875417405349196092, ; 44: System.Drawing.Primitives => 0x1a06d2319b6c713c => 158
	i64 1881198190668717030, ; 45: tr\Microsoft.Maui.Controls.resources => 0x1a1b5bc992ea9be6 => 28
	i64 1920760634179481754, ; 46: Microsoft.Maui.Controls.Xaml => 0x1aa7e99ec2d2709a => 81
	i64 1930726298510463061, ; 47: CommunityToolkit.Mvvm.dll => 0x1acb5156cd389055 => 39
	i64 1959996714666907089, ; 48: tr/Microsoft.Maui.Controls.resources.dll => 0x1b334ea0a2a755d1 => 28
	i64 1972385128188460614, ; 49: System.Security.Cryptography.Algorithms => 0x1b5f51d2edefbe46 => 199
	i64 1981742497975770890, ; 50: Xamarin.AndroidX.Lifecycle.ViewModel.dll => 0x1b80904d5c241f0a => 117
	i64 1983698669889758782, ; 51: cs/Microsoft.Maui.Controls.resources.dll => 0x1b87836e2031a63e => 2
	i64 2019660174692588140, ; 52: pl/Microsoft.Maui.Controls.resources.dll => 0x1c07463a6f8e1a6c => 20
	i64 2040001226662520565, ; 53: System.Threading.Tasks.Extensions.dll => 0x1c4f8a4ea894a6f5 => 208
	i64 2102659300918482391, ; 54: System.Drawing.Primitives.dll => 0x1d2e257e6aead5d7 => 158
	i64 2133195048986300728, ; 55: Newtonsoft.Json.dll => 0x1d9aa1984b735138 => 85
	i64 2207662933261301575, ; 56: DocumentFormat.OpenXml => 0x1ea331bdb8d63747 => 40
	i64 2262844636196693701, ; 57: Xamarin.AndroidX.DrawerLayout.dll => 0x1f673d352266e6c5 => 113
	i64 2287834202362508563, ; 58: System.Collections.Concurrent => 0x1fc00515e8ce7513 => 142
	i64 2302323944321350744, ; 59: ru/Microsoft.Maui.Controls.resources.dll => 0x1ff37f6ddb267c58 => 24
	i64 2315304989185124968, ; 60: System.IO.FileSystem.dll => 0x20219d9ee311aa68 => 163
	i64 2329709569556905518, ; 61: Xamarin.AndroidX.Lifecycle.LiveData.Core.dll => 0x2054ca829b447e2e => 116
	i64 2335503487726329082, ; 62: System.Text.Encodings.Web => 0x2069600c4d9d1cfa => 204
	i64 2337758774805907496, ; 63: System.Runtime.CompilerServices.Unsafe => 0x207163383edbc828 => 189
	i64 2445261912722553526, ; 64: Google.Cloud.Firestore.dll => 0x21ef50c10a9ebab6 => 53
	i64 2470498323731680442, ; 65: Xamarin.AndroidX.CoordinatorLayout => 0x2248f922dc398cba => 109
	i64 2497223385847772520, ; 66: System.Runtime => 0x22a7eb7046413568 => 197
	i64 2547086958574651984, ; 67: Xamarin.AndroidX.Activity.dll => 0x2359121801df4a50 => 104
	i64 2602673633151553063, ; 68: th\Microsoft.Maui.Controls.resources => 0x241e8de13a460e27 => 27
	i64 2612152650457191105, ; 69: Microsoft.IdentityModel.Tokens.dll => 0x24403afeed9892c1 => 78
	i64 2624866290265602282, ; 70: mscorlib.dll => 0x246d65fbde2db8ea => 216
	i64 2632269733008246987, ; 71: System.Net.NameResolution => 0x2487b36034f808cb => 172
	i64 2656907746661064104, ; 72: Microsoft.Extensions.DependencyInjection => 0x24df3b84c8b75da8 => 69
	i64 2662981627730767622, ; 73: cs\Microsoft.Maui.Controls.resources => 0x24f4cfae6c48af06 => 2
	i64 2783046991838674048, ; 74: System.Runtime.CompilerServices.Unsafe.dll => 0x269f5e7e6dc37c80 => 189
	i64 2789714023057451704, ; 75: Microsoft.IdentityModel.JsonWebTokens.dll => 0x26b70e1f9943eab8 => 76
	i64 2812926542227278819, ; 76: Google.Apis.Core.dll => 0x270985c960b98be3 => 52
	i64 2895129759130297543, ; 77: fi\Microsoft.Maui.Controls.resources => 0x282d912d479fa4c7 => 7
	i64 3017704767998173186, ; 78: Xamarin.Google.Android.Material => 0x29e10a7f7d88a002 => 133
	i64 3289520064315143713, ; 79: Xamarin.AndroidX.Lifecycle.Common => 0x2da6b911e3063621 => 115
	i64 3311221304742556517, ; 80: System.Numerics.Vectors.dll => 0x2df3d23ba9e2b365 => 180
	i64 3325875462027654285, ; 81: System.Runtime.Numerics => 0x2e27e21c8958b48d => 194
	i64 3328853167529574890, ; 82: System.Net.Sockets.dll => 0x2e327651a008c1ea => 178
	i64 3344514922410554693, ; 83: Xamarin.KotlinX.Coroutines.Core.Jvm => 0x2e6a1a9a18463545 => 138
	i64 3364695309916733813, ; 84: Xamarin.Firebase.Common => 0x2eb1cc8eb5028175 => 130
	i64 3402534845034375023, ; 85: System.IdentityModel.Tokens.Jwt.dll => 0x2f383b6a0629a76f => 98
	i64 3411255996856937470, ; 86: Xamarin.GooglePlayServices.Basement => 0x2f5737416a942bfe => 135
	i64 3414639567687375782, ; 87: SkiaSharp.Views.Maui.Controls => 0x2f633c9863ffdba6 => 94
	i64 3429672777697402584, ; 88: Microsoft.Maui.Essentials => 0x2f98a5385a7b1ed8 => 83
	i64 3430216265859992823, ; 89: Grpc.Auth.dll => 0x2f9a93850d5a0cf7 => 58
	i64 3494946837667399002, ; 90: Microsoft.Extensions.Configuration => 0x30808ba1c00a455a => 67
	i64 3522470458906976663, ; 91: Xamarin.AndroidX.SwipeRefreshLayout => 0x30e2543832f52197 => 126
	i64 3551103847008531295, ; 92: System.Private.CoreLib.dll => 0x31480e226177735f => 218
	i64 3567343442040498961, ; 93: pt\Microsoft.Maui.Controls.resources => 0x3181bff5bea4ab11 => 22
	i64 3571415421602489686, ; 94: System.Runtime.dll => 0x319037675df7e556 => 197
	i64 3610052191230710096, ; 95: StarkbankEcdsa => 0x32197b574eed5150 => 96
	i64 3638003163729360188, ; 96: Microsoft.Extensions.Configuration.Abstractions => 0x327cc89a39d5f53c => 68
	i64 3647754201059316852, ; 97: System.Xml.ReaderWriter => 0x329f6d1e86145474 => 213
	i64 3655542548057982301, ; 98: Microsoft.Extensions.Configuration.dll => 0x32bb18945e52855d => 67
	i64 3716579019761409177, ; 99: netstandard.dll => 0x3393f0ed5c8c5c99 => 217
	i64 3727469159507183293, ; 100: Xamarin.AndroidX.RecyclerView => 0x33baa1739ba646bd => 124
	i64 3869221888984012293, ; 101: Microsoft.Extensions.Logging.dll => 0x35b23cceda0ed605 => 71
	i64 3869649043256705283, ; 102: System.Diagnostics.Tools => 0x35b3c14d74bf0103 => 156
	i64 3890352374528606784, ; 103: Microsoft.Maui.Controls.Xaml.dll => 0x35fd4edf66e00240 => 81
	i64 3893087497687830326, ; 104: Google.Cloud.Firestore.V1.dll => 0x36070673e3328f36 => 54
	i64 3921656159949438693, ; 105: Twilio.dll => 0x366c857fe9023ee5 => 103
	i64 3933965368022646939, ; 106: System.Net.Requests => 0x369840a8bfadc09b => 175
	i64 3966267475168208030, ; 107: System.Memory => 0x370b03412596249e => 168
	i64 4009997192427317104, ; 108: System.Runtime.Serialization.Primitives => 0x37a65f335cf1a770 => 196
	i64 4056584864658557221, ; 109: Google.Apis.Auth => 0x384be27113330925 => 51
	i64 4073500526318903918, ; 110: System.Private.Xml.dll => 0x3887fb25779ae26e => 184
	i64 4073631083018132676, ; 111: Microsoft.Maui.Controls.Compatibility.dll => 0x388871e311491cc4 => 79
	i64 4120493066591692148, ; 112: zh-Hant\Microsoft.Maui.Controls.resources => 0x392eee9cdda86574 => 33
	i64 4154383907710350974, ; 113: System.ComponentModel => 0x39a7562737acb67e => 149
	i64 4168469861834746866, ; 114: System.Security.Claims.dll => 0x39d96140fb94ebf2 => 198
	i64 4187479170553454871, ; 115: System.Linq.Expressions => 0x3a1cea1e912fa117 => 165
	i64 4205801962323029395, ; 116: System.ComponentModel.TypeConverter => 0x3a5e0299f7e7ad93 => 148
	i64 4247996603072512073, ; 117: Xamarin.GooglePlayServices.Tasks => 0x3af3ea6755340049 => 136
	i64 4356591372459378815, ; 118: vi/Microsoft.Maui.Controls.resources.dll => 0x3c75b8c562f9087f => 30
	i64 4373617458794931033, ; 119: System.IO.Pipes.dll => 0x3cb235e806eb2359 => 164
	i64 4376937205476565312, ; 120: ExcelNumberFormat.dll => 0x3cbe0132c89f2140 => 42
	i64 4477672992252076438, ; 121: System.Web.HttpUtility.dll => 0x3e23e3dcdb8ba196 => 211
	i64 4482826947393284255, ; 122: Microsoft.Bcl.Memory.dll => 0x3e36335b8cece89f => 66
	i64 4636684751163556186, ; 123: Xamarin.AndroidX.VersionedParcelable.dll => 0x4058d0370893015a => 127
	i64 4679594760078841447, ; 124: ar/Microsoft.Maui.Controls.resources.dll => 0x40f142a407475667 => 0
	i64 4794310189461587505, ; 125: Xamarin.AndroidX.Activity => 0x4288cfb749e4c631 => 104
	i64 4795410492532947900, ; 126: Xamarin.AndroidX.SwipeRefreshLayout.dll => 0x428cb86f8f9b7bbc => 126
	i64 4809057822547766521, ; 127: System.Drawing => 0x42bd349c3145ecf9 => 159
	i64 4814660307502931973, ; 128: System.Net.NameResolution.dll => 0x42d11c0a5ee2a005 => 172
	i64 4853321196694829351, ; 129: System.Runtime.Loader.dll => 0x435a75ea15de7927 => 193
	i64 5081566143765835342, ; 130: System.Resources.ResourceManager.dll => 0x4685597c05d06e4e => 188
	i64 5098983611934048327, ; 131: Google.Cloud.Location => 0x46c33a9458de0047 => 55
	i64 5099468265966638712, ; 132: System.Resources.ResourceManager => 0x46c4f35ea8519678 => 188
	i64 5103417709280584325, ; 133: System.Collections.Specialized => 0x46d2fb5e161b6285 => 145
	i64 5182934613077526976, ; 134: System.Collections.Specialized.dll => 0x47ed7b91fa9009c0 => 145
	i64 5290786973231294105, ; 135: System.Runtime.Loader => 0x496ca6b869b72699 => 193
	i64 5423376490970181369, ; 136: System.Runtime.InteropServices.RuntimeInformation => 0x4b43b42f2b7b6ef9 => 191
	i64 5426193594926737925, ; 137: Plugin.Firebase.Core => 0x4b4db6534c1baa05 => 87
	i64 5446034149219586269, ; 138: System.Diagnostics.Debug => 0x4b94333452e150dd => 153
	i64 5471532531798518949, ; 139: sv\Microsoft.Maui.Controls.resources => 0x4beec9d926d82ca5 => 26
	i64 5507995362134886206, ; 140: System.Core.dll => 0x4c705499688c873e => 151
	i64 5522859530602327440, ; 141: uk\Microsoft.Maui.Controls.resources => 0x4ca5237b51eead90 => 29
	i64 5570799893513421663, ; 142: System.IO.Compression.Brotli => 0x4d4f74fcdfa6c35f => 161
	i64 5573260873512690141, ; 143: System.Security.Cryptography.dll => 0x4d58333c6e4ea1dd => 202
	i64 5591791169662171124, ; 144: System.Linq.Parallel => 0x4d9a087135e137f4 => 166
	i64 5650097808083101034, ; 145: System.Security.Cryptography.Algorithms.dll => 0x4e692e055d01a56a => 199
	i64 5665389054145784248, ; 146: Google.Apis.Core => 0x4e9f815406bee9b8 => 52
	i64 5692067934154308417, ; 147: Xamarin.AndroidX.ViewPager2.dll => 0x4efe49a0d4a8bb41 => 129
	i64 5796442605724717762, ; 148: ExcelNumberFormat => 0x507119d6cb2952c2 => 42
	i64 5979151488806146654, ; 149: System.Formats.Asn1 => 0x52fa3699a489d25e => 160
	i64 5984759512290286505, ; 150: System.Security.Cryptography.Primitives => 0x530e23115c33dba9 => 200
	i64 6068057819846744445, ; 151: ro/Microsoft.Maui.Controls.resources.dll => 0x5436126fec7f197d => 23
	i64 6200764641006662125, ; 152: ro\Microsoft.Maui.Controls.resources => 0x560d8a96830131ed => 23
	i64 6218967553231149354, ; 153: Firebase.Auth.dll => 0x564e360a4805d92a => 44
	i64 6222399776351216807, ; 154: System.Text.Json.dll => 0x565a67a0ffe264a7 => 205
	i64 6284145129771520194, ; 155: System.Reflection.Emit.ILGeneration => 0x5735c4b3610850c2 => 185
	i64 6357457916754632952, ; 156: _Microsoft.Android.Resource.Designer => 0x583a3a4ac2a7a0f8 => 34
	i64 6401687960814735282, ; 157: Xamarin.AndroidX.Lifecycle.LiveData.Core => 0x58d75d486341cfb2 => 116
	i64 6478287442656530074, ; 158: hr\Microsoft.Maui.Controls.resources => 0x59e7801b0c6a8e9a => 11
	i64 6548213210057960872, ; 159: Xamarin.AndroidX.CustomView.dll => 0x5adfed387b066da8 => 112
	i64 6560151584539558821, ; 160: Microsoft.Extensions.Options => 0x5b0a571be53243a5 => 73
	i64 6594803674001204912, ; 161: Plugin.Firebase.CloudMessaging => 0x5b857300304866b0 => 86
	i64 6671798237668743565, ; 162: SkiaSharp => 0x5c96fd260152998d => 92
	i64 6743165466166707109, ; 163: nl\Microsoft.Maui.Controls.resources => 0x5d948943c08c43a5 => 19
	i64 6777482997383978746, ; 164: pt/Microsoft.Maui.Controls.resources.dll => 0x5e0e74e0a2525efa => 22
	i64 6786606130239981554, ; 165: System.Diagnostics.TraceSource => 0x5e2ede51877147f2 => 157
	i64 6802026988460721845, ; 166: ClosedXML.Parser => 0x5e65a781dfd246b5 => 36
	i64 6814185388980153342, ; 167: System.Xml.XDocument.dll => 0x5e90d98217d1abfe => 214
	i64 6876862101832370452, ; 168: System.Xml.Linq => 0x5f6f85a57d108914 => 212
	i64 6894844156784520562, ; 169: System.Numerics.Vectors => 0x5faf683aead1ad72 => 180
	i64 6934772601320367100, ; 170: Google.Api.Gax.Rest => 0x603d42f05bcfe3fc => 49
	i64 6987056692196838363, ; 171: System.Management => 0x60f7030ae3e88bdb => 101
	i64 7083547580668757502, ; 172: System.Private.Xml.Linq.dll => 0x624dd0fe8f56c5fe => 183
	i64 7098131676344687625, ; 173: LiveCharts => 0x6281a126f1791c09 => 63
	i64 7112547816752919026, ; 174: System.IO.FileSystem => 0x62b4d88e3189b1f2 => 163
	i64 7220009545223068405, ; 175: sv/Microsoft.Maui.Controls.resources.dll => 0x6432a06d99f35af5 => 26
	i64 7270811800166795866, ; 176: System.Linq => 0x64e71ccf51a90a5a => 167
	i64 7314237870106916923, ; 177: SkiaSharp.Views.Maui.Core.dll => 0x65816497226eb83b => 95
	i64 7377312882064240630, ; 178: System.ComponentModel.TypeConverter.dll => 0x66617afac45a2ff6 => 148
	i64 7488575175965059935, ; 179: System.Xml.Linq.dll => 0x67ecc3724534ab5f => 212
	i64 7489048572193775167, ; 180: System.ObjectModel => 0x67ee71ff6b419e3f => 181
	i64 7496222613193209122, ; 181: System.IdentityModel.Tokens.Jwt => 0x6807eec000a1b522 => 98
	i64 7592577537120840276, ; 182: System.Diagnostics.Process => 0x695e410af5b2aa54 => 155
	i64 7602111570124318452, ; 183: System.Reactive => 0x698020320025a6f4 => 102
	i64 7621211152690795761, ; 184: Google.LongRunning.dll => 0x69c3fb2a1a6154f1 => 56
	i64 7654504624184590948, ; 185: System.Net.Http => 0x6a3a4366801b8264 => 169
	i64 7694700312542370399, ; 186: System.Net.Mail => 0x6ac9112a7e2cda5f => 171
	i64 7708790323521193081, ; 187: ms/Microsoft.Maui.Controls.resources.dll => 0x6afb1ff4d1730479 => 17
	i64 7714652370974252055, ; 188: System.Private.CoreLib => 0x6b0ff375198b9c17 => 218
	i64 7723873813026311384, ; 189: SkiaSharp.Views.Maui.Controls.dll => 0x6b30b64f63600cd8 => 94
	i64 7735176074855944702, ; 190: Microsoft.CSharp => 0x6b58dda848e391fe => 140
	i64 7735352534559001595, ; 191: Xamarin.Kotlin.StdLib.dll => 0x6b597e2582ce8bfb => 137
	i64 7740912860115050295, ; 192: Google.Api.CommonProtos => 0x6b6d3f3bb0691f37 => 46
	i64 7836164640616011524, ; 193: Xamarin.AndroidX.AppCompat.AppCompatResources => 0x6cbfa6390d64d704 => 106
	i64 7843473411302439824, ; 194: Google.LongRunning => 0x6cd99d82d5e73b90 => 56
	i64 7927939710195668715, ; 195: SkiaSharp.Views.Android.dll => 0x6e05b32992ed16eb => 93
	i64 8012566953210257060, ; 196: ClosedXML.dll => 0x6f325b3109219ea4 => 35
	i64 8064050204834738623, ; 197: System.Collections.dll => 0x6fe942efa61731bf => 146
	i64 8083354569033831015, ; 198: Xamarin.AndroidX.Lifecycle.Common.dll => 0x702dd82730cad267 => 115
	i64 8087206902342787202, ; 199: System.Diagnostics.DiagnosticSource => 0x703b87d46f3aa082 => 154
	i64 8167236081217502503, ; 200: Java.Interop.dll => 0x7157d9f1a9b8fd27 => 219
	i64 8185542183669246576, ; 201: System.Collections => 0x7198e33f4794aa70 => 146
	i64 8246048515196606205, ; 202: Microsoft.Maui.Graphics.dll => 0x726fd96f64ee56fd => 84
	i64 8264926008854159966, ; 203: System.Diagnostics.Process.dll => 0x72b2ea6a64a3a25e => 155
	i64 8290740647658429042, ; 204: System.Runtime.Extensions => 0x730ea0b15c929a72 => 190
	i64 8293702073711834350, ; 205: System.Linq.Async => 0x731926181883b4ee => 100
	i64 8368701292315763008, ; 206: System.Security.Cryptography => 0x7423997c6fd56140 => 202
	i64 8400357532724379117, ; 207: Xamarin.AndroidX.Navigation.UI.dll => 0x749410ab44503ded => 123
	i64 8410671156615598628, ; 208: System.Reflection.Emit.Lightweight.dll => 0x74b8b4daf4b25224 => 186
	i64 8465511506719290632, ; 209: Xamarin.Firebase.Messaging.dll => 0x757b89dcf7fc3508 => 131
	i64 8518412311883997971, ; 210: System.Collections.Immutable => 0x76377add7c28e313 => 143
	i64 8563666267364444763, ; 211: System.Private.Uri => 0x76d841191140ca5b => 182
	i64 8565268909422235801, ; 212: RBush => 0x76ddf2b13fcf5099 => 89
	i64 8599632406834268464, ; 213: CommunityToolkit.Maui => 0x7758081c784b4930 => 37
	i64 8614108721271900878, ; 214: pt-BR/Microsoft.Maui.Controls.resources.dll => 0x778b763e14018ace => 21
	i64 8626175481042262068, ; 215: Java.Interop => 0x77b654e585b55834 => 219
	i64 8638972117149407195, ; 216: Microsoft.CSharp.dll => 0x77e3cb5e8b31d7db => 140
	i64 8639588376636138208, ; 217: Xamarin.AndroidX.Navigation.Runtime => 0x77e5fbdaa2fda2e0 => 122
	i64 8677882282824630478, ; 218: pt-BR\Microsoft.Maui.Controls.resources => 0x786e07f5766b00ce => 21
	i64 8685687024490312494, ; 219: Google.Api.Gax.Grpc => 0x7889c2547cf6f32e => 48
	i64 8702320156596882678, ; 220: Firebase.dll => 0x78c4da1357adccf6 => 45
	i64 8725526185868997716, ; 221: System.Diagnostics.DiagnosticSource.dll => 0x79174bd613173454 => 154
	i64 8823529091010338516, ; 222: Microsoft.Bcl.Memory => 0x7a7378f58eff1ed4 => 66
	i64 8844506025403580595, ; 223: Plugin.FirebasePushNotification => 0x7abdff5eb1fb80b3 => 88
	i64 8941376889969657626, ; 224: System.Xml.XDocument => 0x7c1626e87187471a => 214
	i64 9045785047181495996, ; 225: zh-HK\Microsoft.Maui.Controls.resources => 0x7d891592e3cb0ebc => 31
	i64 9057635389615298436, ; 226: LiteDB => 0x7db32f65bf06d784 => 62
	i64 9153910511549984549, ; 227: SendGrid.dll => 0x7f09391c5aa6af25 => 90
	i64 9285318971778582014, ; 228: Plugin.Firebase.Core.dll => 0x80dc1468bb0ec5fe => 87
	i64 9296667808972889535, ; 229: LiteDB.dll => 0x8104661dcca35dbf => 62
	i64 9312692141327339315, ; 230: Xamarin.AndroidX.ViewPager2 => 0x813d54296a634f33 => 129
	i64 9324707631942237306, ; 231: Xamarin.AndroidX.AppCompat => 0x8168042fd44a7c7a => 105
	i64 9404599086328396064, ; 232: Grpc.Net.Client.dll => 0x8283d90a93913920 => 60
	i64 9427266486299436557, ; 233: Microsoft.IdentityModel.Logging.dll => 0x82d460ebe6d2a60d => 77
	i64 9659729154652888475, ; 234: System.Text.RegularExpressions => 0x860e407c9991dd9b => 206
	i64 9678050649315576968, ; 235: Xamarin.AndroidX.CoordinatorLayout.dll => 0x864f57c9feb18c88 => 109
	i64 9702891218465930390, ; 236: System.Collections.NonGeneric.dll => 0x86a79827b2eb3c96 => 144
	i64 9704315356731487263, ; 237: Plugin.FirebasePushNotification.dll => 0x86aca766ba59341f => 88
	i64 9808709177481450983, ; 238: Mono.Android.dll => 0x881f890734e555e7 => 221
	i64 9875200773399460291, ; 239: Xamarin.GooglePlayServices.Base.dll => 0x890bc2c8482339c3 => 134
	i64 9956195530459977388, ; 240: Microsoft.Maui => 0x8a2b8315b36616ac => 82
	i64 9959489431142554298, ; 241: System.CodeDom => 0x8a3736deb7825aba => 97
	i64 9991543690424095600, ; 242: es/Microsoft.Maui.Controls.resources.dll => 0x8aa9180c89861370 => 6
	i64 10038780035334861115, ; 243: System.Net.Http.dll => 0x8b50e941206af13b => 169
	i64 10051358222726253779, ; 244: System.Private.Xml => 0x8b7d990c97ccccd3 => 184
	i64 10051920404523413229, ; 245: Grpc.Net.Common => 0x8b7f9859be1e6eed => 61
	i64 10092835686693276772, ; 246: Microsoft.Maui.Controls => 0x8c10f49539bd0c64 => 80
	i64 10143853363526200146, ; 247: da\Microsoft.Maui.Controls.resources => 0x8cc634e3c2a16b52 => 3
	i64 10144742755892837524, ; 248: Firebase => 0x8cc95dc98eb5bc94 => 45
	i64 10220684565739810458, ; 249: FirebaseAdmin => 0x8dd72a76063d2e9a => 43
	i64 10229024438826829339, ; 250: Xamarin.AndroidX.CustomView => 0x8df4cb880b10061b => 112
	i64 10236703004850800690, ; 251: System.Net.ServicePoint.dll => 0x8e101325834e4832 => 177
	i64 10245369515835430794, ; 252: System.Reflection.Emit.Lightweight => 0x8e2edd4ad7fc978a => 186
	i64 10282208442277544177, ; 253: Google.Cloud.Firestore.V1 => 0x8eb1be19cc79c0f1 => 54
	i64 10364469296367737616, ; 254: System.Reflection.Emit.ILGeneration.dll => 0x8fd5fde967711b10 => 185
	i64 10406448008575299332, ; 255: Xamarin.KotlinX.Coroutines.Core.Jvm.dll => 0x906b2153fcb3af04 => 138
	i64 10430153318873392755, ; 256: Xamarin.AndroidX.Core => 0x90bf592ea44f6673 => 110
	i64 10447083246144586668, ; 257: Microsoft.Bcl.AsyncInterfaces.dll => 0x90fb7edc816203ac => 65
	i64 10506226065143327199, ; 258: ca\Microsoft.Maui.Controls.resources => 0x91cd9cf11ed169df => 1
	i64 10650478070646097812, ; 259: System.IO.Packaging => 0x93ce196068f2c794 => 99
	i64 10714184849103829812, ; 260: System.Runtime.Extensions.dll => 0x94b06e5aa4b4bb34 => 190
	i64 10785150219063592792, ; 261: System.Net.Primitives => 0x95ac8cfb68830758 => 174
	i64 10823124638835005028, ; 262: Google.Api.Gax.dll => 0x963376840189d664 => 47
	i64 10854473764158213966, ; 263: Grpc.Core.Api.dll => 0x96a2d66108728f4e => 59
	i64 10880838204485145808, ; 264: CommunityToolkit.Maui.dll => 0x970080b2a4d614d0 => 37
	i64 10953751836886437922, ; 265: System.Linq.Async.dll => 0x98038b429b661022 => 100
	i64 11002576679268595294, ; 266: Microsoft.Extensions.Logging.Abstractions => 0x98b1013215cd365e => 72
	i64 11009005086950030778, ; 267: Microsoft.Maui.dll => 0x98c7d7cc621ffdba => 82
	i64 11023048688141570732, ; 268: System.Core => 0x98f9bc61168392ac => 151
	i64 11103970607964515343, ; 269: hu\Microsoft.Maui.Controls.resources => 0x9a193a6fc41a6c0f => 12
	i64 11162124722117608902, ; 270: Xamarin.AndroidX.ViewPager => 0x9ae7d54b986d05c6 => 128
	i64 11220793807500858938, ; 271: ja\Microsoft.Maui.Controls.resources => 0x9bb8448481fdd63a => 15
	i64 11226290749488709958, ; 272: Microsoft.Extensions.Options.dll => 0x9bcbcbf50c874146 => 73
	i64 11326322297822330275, ; 273: Google.Cloud.Firestore => 0x9d2f2e1ed5493da3 => 53
	i64 11340910727871153756, ; 274: Xamarin.AndroidX.CursorAdapter => 0x9d630238642d465c => 111
	i64 11435314654401632883, ; 275: Grpc.Core.Api => 0x9eb266175e6d9a73 => 59
	i64 11441445377436144712, ; 276: Grpc.Net.Common.dll => 0x9ec82df38f1dd448 => 61
	i64 11481869442598199266, ; 277: Microcharts.Maui.dll => 0x9f57cb6cab7a5fe2 => 64
	i64 11485890710487134646, ; 278: System.Runtime.InteropServices => 0x9f6614bf0f8b71b6 => 192
	i64 11517440453979132662, ; 279: Microsoft.IdentityModel.Abstractions.dll => 0x9fd62b122523d2f6 => 75
	i64 11518296021396496455, ; 280: id\Microsoft.Maui.Controls.resources => 0x9fd9353475222047 => 13
	i64 11529969570048099689, ; 281: Xamarin.AndroidX.ViewPager.dll => 0xa002ae3c4dc7c569 => 128
	i64 11530571088791430846, ; 282: Microsoft.Extensions.Logging => 0xa004d1504ccd66be => 71
	i64 11543207250219725293, ; 283: Grpc.Net.Client => 0xa031b5d5e60f71ed => 60
	i64 11597940890313164233, ; 284: netstandard => 0xa0f429ca8d1805c9 => 217
	i64 11705530742807338875, ; 285: he/Microsoft.Maui.Controls.resources.dll => 0xa272663128721f7b => 9
	i64 11707554492040141440, ; 286: System.Linq.Parallel.dll => 0xa27996c7fe94da80 => 166
	i64 11806871145320508000, ; 287: StarkbankEcdsa.dll => 0xa3da6ec04da36a60 => 96
	i64 12010362171126083089, ; 288: Plugin.Firebase.CloudMessaging.dll => 0xa6ad60c2d1c26e11 => 86
	i64 12040886584167504988, ; 289: System.Net.ServicePoint => 0xa719d28d8e121c5c => 177
	i64 12102847907131387746, ; 290: System.Buffers => 0xa7f5f40c43256f62 => 141
	i64 12145679461940342714, ; 291: System.Text.Json => 0xa88e1f1ebcb62fba => 205
	i64 12201331334810686224, ; 292: System.Runtime.Serialization.Primitives.dll => 0xa953d6341e3bd310 => 196
	i64 12269460666702402136, ; 293: System.Collections.Immutable.dll => 0xaa45e178506c9258 => 143
	i64 12341818387765915815, ; 294: CommunityToolkit.Maui.Core.dll => 0xab46f26f152bf0a7 => 38
	i64 12437742355241350664, ; 295: Google.Apis.dll => 0xac9bbcc62bfdb608 => 50
	i64 12439275739440478309, ; 296: Microsoft.IdentityModel.JsonWebTokens => 0xaca12f61007bf865 => 76
	i64 12451044538927396471, ; 297: Xamarin.AndroidX.Fragment.dll => 0xaccaff0a2955b677 => 114
	i64 12466513435562512481, ; 298: Xamarin.AndroidX.Loader.dll => 0xad01f3eb52569061 => 119
	i64 12475113361194491050, ; 299: _Microsoft.Android.Resource.Designer.dll => 0xad2081818aba1caa => 34
	i64 12517810545449516888, ; 300: System.Diagnostics.TraceSource.dll => 0xadb8325e6f283f58 => 157
	i64 12528155905152483962, ; 301: Firebase.Auth => 0xaddcf36b3153827a => 44
	i64 12538491095302438457, ; 302: Xamarin.AndroidX.CardView.dll => 0xae01ab382ae67e39 => 107
	i64 12550732019250633519, ; 303: System.IO.Compression => 0xae2d28465e8e1b2f => 162
	i64 12681088699309157496, ; 304: it/Microsoft.Maui.Controls.resources.dll => 0xaffc46fc178aec78 => 14
	i64 12700543734426720211, ; 305: Xamarin.AndroidX.Collection => 0xb041653c70d157d3 => 108
	i64 12708922737231849740, ; 306: System.Text.Encoding.Extensions => 0xb05f29e50e96e90c => 203
	i64 12722065664929968482, ; 307: Google.Api.Gax.Rest.dll => 0xb08ddb515f583162 => 49
	i64 12823819093633476069, ; 308: th/Microsoft.Maui.Controls.resources.dll => 0xb1f75b85abe525e5 => 27
	i64 12835242264250840079, ; 309: System.IO.Pipes => 0xb21ff0d5d6c0740f => 164
	i64 12843321153144804894, ; 310: Microsoft.Extensions.Primitives => 0xb23ca48abd74d61e => 74
	i64 12859557719246324186, ; 311: System.Net.WebHeaderCollection.dll => 0xb276539ce04f41da => 179
	i64 12958614573187252691, ; 312: Google.Apis => 0xb3d63f4bf006c1d3 => 50
	i64 13068258254871114833, ; 313: System.Runtime.Serialization.Formatters.dll => 0xb55bc7a4eaa8b451 => 195
	i64 13109727801987935684, ; 314: SixLabors.Fonts => 0xb5ef1bfa438dadc4 => 91
	i64 13221551921002590604, ; 315: ca/Microsoft.Maui.Controls.resources.dll => 0xb77c636bdebe318c => 1
	i64 13222659110913276082, ; 316: ja/Microsoft.Maui.Controls.resources.dll => 0xb78052679c1178b2 => 15
	i64 13343850469010654401, ; 317: Mono.Android.Runtime.dll => 0xb92ee14d854f44c1 => 220
	i64 13381594904270902445, ; 318: he\Microsoft.Maui.Controls.resources => 0xb9b4f9aaad3e94ad => 9
	i64 13465488254036897740, ; 319: Xamarin.Kotlin.StdLib => 0xbadf06394d106fcc => 137
	i64 13467053111158216594, ; 320: uk/Microsoft.Maui.Controls.resources.dll => 0xbae49573fde79792 => 29
	i64 13540124433173649601, ; 321: vi\Microsoft.Maui.Controls.resources => 0xbbe82f6eede718c1 => 30
	i64 13545416393490209236, ; 322: id/Microsoft.Maui.Controls.resources.dll => 0xbbfafc7174bc99d4 => 13
	i64 13572454107664307259, ; 323: Xamarin.AndroidX.RecyclerView.dll => 0xbc5b0b19d99f543b => 124
	i64 13595456055014782591, ; 324: SendGrid => 0xbcacc3400e96f67f => 90
	i64 13702626353344114072, ; 325: System.Diagnostics.Tools.dll => 0xbe29821198fb6d98 => 156
	i64 13717397318615465333, ; 326: System.ComponentModel.Primitives.dll => 0xbe5dfc2ef2f87d75 => 147
	i64 13755568601956062840, ; 327: fr/Microsoft.Maui.Controls.resources.dll => 0xbee598c36b1b9678 => 8
	i64 13782512541859110153, ; 328: Google.Apis.Auth.dll => 0xbf45522249e0dd09 => 51
	i64 13814445057219246765, ; 329: hr/Microsoft.Maui.Controls.resources.dll => 0xbfb6c49664b43aad => 11
	i64 13881769479078963060, ; 330: System.Console.dll => 0xc0a5f3cade5c6774 => 150
	i64 13959074834287824816, ; 331: Xamarin.AndroidX.Fragment => 0xc1b8989a7ad20fb0 => 114
	i64 14065717908940967541, ; 332: RBush.dll => 0xc33377ea3146ce75 => 89
	i64 14100563506285742564, ; 333: da/Microsoft.Maui.Controls.resources.dll => 0xc3af43cd0cff89e4 => 3
	i64 14124974489674258913, ; 334: Xamarin.AndroidX.CardView => 0xc405fd76067d19e1 => 107
	i64 14125464355221830302, ; 335: System.Threading.dll => 0xc407bafdbc707a9e => 210
	i64 14148919944076435199, ; 336: DocumentFormat.OpenXml.dll => 0xc45b0fb9961d9eff => 40
	i64 14254574811015963973, ; 337: System.Text.Encoding.Extensions.dll => 0xc5d26c4442d66545 => 203
	i64 14327709162229390963, ; 338: System.Security.Cryptography.X509Certificates => 0xc6d63f9253cade73 => 201
	i64 14461014870687870182, ; 339: System.Net.Requests.dll => 0xc8afd8683afdece6 => 175
	i64 14464374589798375073, ; 340: ru\Microsoft.Maui.Controls.resources => 0xc8bbc80dcb1e5ea1 => 24
	i64 14522721392235705434, ; 341: el/Microsoft.Maui.Controls.resources.dll => 0xc98b12295c2cf45a => 5
	i64 14551742072151931844, ; 342: System.Text.Encodings.Web.dll => 0xc9f22c50f1b8fbc4 => 204
	i64 14552901170081803662, ; 343: SkiaSharp.Views.Maui.Core => 0xc9f64a827617ad8e => 95
	i64 14556034074661724008, ; 344: CommunityToolkit.Maui.Core => 0xca016bdea6b19f68 => 38
	i64 14561513370130550166, ; 345: System.Security.Cryptography.Primitives.dll => 0xca14e3428abb8d96 => 200
	i64 14622043554576106986, ; 346: System.Runtime.Serialization.Formatters => 0xcaebef2458cc85ea => 195
	i64 14650706219563630045, ; 347: Grpc.Auth => 0xcb51c3af15b23ddd => 58
	i64 14669215534098758659, ; 348: Microsoft.Extensions.DependencyInjection.dll => 0xcb9385ceb3993c03 => 69
	i64 14690985099581930927, ; 349: System.Web.HttpUtility => 0xcbe0dd1ca5233daf => 211
	i64 14705122255218365489, ; 350: ko\Microsoft.Maui.Controls.resources => 0xcc1316c7b0fb5431 => 16
	i64 14744092281598614090, ; 351: zh-Hans\Microsoft.Maui.Controls.resources => 0xcc9d89d004439a4a => 32
	i64 14789919016435397935, ; 352: Xamarin.Firebase.Common.dll => 0xcd4058fc2f6d352f => 130
	i64 14832630590065248058, ; 353: System.Security.Claims => 0xcdd816ef5d6e873a => 198
	i64 14852515768018889994, ; 354: Xamarin.AndroidX.CursorAdapter.dll => 0xce1ebc6625a76d0a => 111
	i64 14892012299694389861, ; 355: zh-Hant/Microsoft.Maui.Controls.resources.dll => 0xceab0e490a083a65 => 33
	i64 14904040806490515477, ; 356: ar\Microsoft.Maui.Controls.resources => 0xced5ca2604cb2815 => 0
	i64 14954917835170835695, ; 357: Microsoft.Extensions.DependencyInjection.Abstractions.dll => 0xcf8a8a895a82ecef => 70
	i64 14984936317414011727, ; 358: System.Net.WebHeaderCollection => 0xcff5302fe54ff34f => 179
	i64 14987728460634540364, ; 359: System.IO.Compression.dll => 0xcfff1ba06622494c => 162
	i64 15015154896917945444, ; 360: System.Net.Security.dll => 0xd0608bd33642dc64 => 176
	i64 15076659072870671916, ; 361: System.ObjectModel.dll => 0xd13b0d8c1620662c => 181
	i64 15097078878581906526, ; 362: Google.Api.Gax.Grpc.dll => 0xd183994097ed5c5e => 48
	i64 15111608613780139878, ; 363: ms\Microsoft.Maui.Controls.resources => 0xd1b737f831192f66 => 17
	i64 15115185479366240210, ; 364: System.IO.Compression.Brotli.dll => 0xd1c3ed1c1bc467d2 => 161
	i64 15133485256822086103, ; 365: System.Linq.dll => 0xd204f0a9127dd9d7 => 167
	i64 15138356091203993725, ; 366: Microsoft.IdentityModel.Abstractions => 0xd2163ea89395c07d => 75
	i64 15227001540531775957, ; 367: Microsoft.Extensions.Configuration.Abstractions.dll => 0xd3512d3999b8e9d5 => 68
	i64 15370334346939861994, ; 368: Xamarin.AndroidX.Core.dll => 0xd54e65a72c560bea => 110
	i64 15391712275433856905, ; 369: Microsoft.Extensions.DependencyInjection.Abstractions => 0xd59a58c406411f89 => 70
	i64 15527772828719725935, ; 370: System.Console => 0xd77dbb1e38cd3d6f => 150
	i64 15530465045505749832, ; 371: System.Net.HttpListener.dll => 0xd7874bacc9fdb348 => 170
	i64 15536481058354060254, ; 372: de\Microsoft.Maui.Controls.resources => 0xd79cab34eec75bde => 4
	i64 15541854775306130054, ; 373: System.Security.Cryptography.X509Certificates.dll => 0xd7afc292e8d49286 => 201
	i64 15557562860424774966, ; 374: System.Net.Sockets => 0xd7e790fe7a6dc536 => 178
	i64 15582737692548360875, ; 375: Xamarin.AndroidX.Lifecycle.ViewModelSavedState => 0xd841015ed86f6aab => 118
	i64 15609085926864131306, ; 376: System.dll => 0xd89e9cf3334914ea => 215
	i64 15661133872274321916, ; 377: System.Xml.ReaderWriter.dll => 0xd9578647d4bfb1fc => 213
	i64 15664356999916475676, ; 378: de/Microsoft.Maui.Controls.resources.dll => 0xd962f9b2b6ecd51c => 4
	i64 15690212772238353659, ; 379: ClosedXML.Parser.dll => 0xd9bed562d39064fb => 36
	i64 15743187114543869802, ; 380: hu/Microsoft.Maui.Controls.resources.dll => 0xda7b09450ae4ef6a => 12
	i64 15783653065526199428, ; 381: el\Microsoft.Maui.Controls.resources => 0xdb0accd674b1c484 => 5
	i64 15847085070278954535, ; 382: System.Threading.Channels.dll => 0xdbec27e8f35f8e27 => 207
	i64 15886777458096683662, ; 383: SIMRAdmin => 0xdc792bed27893a8e => 139
	i64 15928521404965645318, ; 384: Microsoft.Maui.Controls.Compatibility => 0xdd0d79d32c2eec06 => 79
	i64 15930129725311349754, ; 385: Xamarin.GooglePlayServices.Tasks.dll => 0xdd1330956f12f3fa => 136
	i64 15963349826457351533, ; 386: System.Threading.Tasks.Extensions => 0xdd893616f748b56d => 208
	i64 16018552496348375205, ; 387: System.Net.NetworkInformation.dll => 0xde4d54a020caa8a5 => 173
	i64 16134727167002609129, ; 388: SIMRAdmin.dll => 0xdfea10df790905e9 => 139
	i64 16154507427712707110, ; 389: System => 0xe03056ea4e39aa26 => 215
	i64 16219561732052121626, ; 390: System.Net.Security => 0xe1177575db7c781a => 176
	i64 16288847719894691167, ; 391: nb\Microsoft.Maui.Controls.resources => 0xe20d9cb300c12d5f => 18
	i64 16321164108206115771, ; 392: Microsoft.Extensions.Logging.Abstractions.dll => 0xe2806c487e7b0bbb => 72
	i64 16324796876805858114, ; 393: SkiaSharp.dll => 0xe28d5444586b6342 => 92
	i64 16454459195343277943, ; 394: System.Net.NetworkInformation => 0xe459fb756d988f77 => 173
	i64 16467346005009053642, ; 395: Xamarin.Google.Android.DataTransport.TransportApi => 0xe487c3f19e0337ca => 132
	i64 16648892297579399389, ; 396: CommunityToolkit.Mvvm => 0xe70cbf55c4f508dd => 39
	i64 16649148416072044166, ; 397: Microsoft.Maui.Graphics => 0xe70da84600bb4e86 => 84
	i64 16677317093839702854, ; 398: Xamarin.AndroidX.Navigation.UI => 0xe771bb8960dd8b46 => 123
	i64 16833383113903931215, ; 399: mscorlib => 0xe99c30c1484d7f4f => 216
	i64 16856067890322379635, ; 400: System.Data.Common.dll => 0xe9ecc87060889373 => 152
	i64 16890310621557459193, ; 401: System.Text.RegularExpressions.dll => 0xea66700587f088f9 => 206
	i64 16942731696432749159, ; 402: sk\Microsoft.Maui.Controls.resources => 0xeb20acb622a01a67 => 25
	i64 16955525858597485057, ; 403: Google.Api.Gax => 0xeb4e20ef25a73a01 => 47
	i64 16991533501433402966, ; 404: Google.Api.CommonProtos.dll => 0xebce0db1ce165656 => 46
	i64 16998075588627545693, ; 405: Xamarin.AndroidX.Navigation.Fragment => 0xebe54bb02d623e5d => 121
	i64 17008137082415910100, ; 406: System.Collections.NonGeneric => 0xec090a90408c8cd4 => 144
	i64 17031351772568316411, ; 407: Xamarin.AndroidX.Navigation.Common.dll => 0xec5b843380a769fb => 120
	i64 17062143951396181894, ; 408: System.ComponentModel.Primitives => 0xecc8e986518c9786 => 147
	i64 17089008752050867324, ; 409: zh-Hans/Microsoft.Maui.Controls.resources.dll => 0xed285aeb25888c7c => 32
	i64 17118171214553292978, ; 410: System.Threading.Channels => 0xed8ff6060fc420b2 => 207
	i64 17137864900836977098, ; 411: Microsoft.IdentityModel.Tokens => 0xedd5ed53b705e9ca => 78
	i64 17230721278011714856, ; 412: System.Private.Xml.Linq => 0xef1fd1b5c7a72d28 => 183
	i64 17260702271250283638, ; 413: System.Data.Common => 0xef8a5543bba6bc76 => 152
	i64 17272529741349494537, ; 414: ClosedXML => 0xefb45a4935819f09 => 35
	i64 17342750010158924305, ; 415: hi\Microsoft.Maui.Controls.resources => 0xf0add33f97ecc211 => 10
	i64 17438153253682247751, ; 416: sk/Microsoft.Maui.Controls.resources.dll => 0xf200c3fe308d7847 => 25
	i64 17514990004910432069, ; 417: fr\Microsoft.Maui.Controls.resources => 0xf311be9c6f341f45 => 8
	i64 17553799493972570483, ; 418: Google.Protobuf.dll => 0xf39b9fa2c0aab173 => 57
	i64 17623389608345532001, ; 419: pl\Microsoft.Maui.Controls.resources => 0xf492db79dfbef661 => 20
	i64 17671790519499593115, ; 420: SkiaSharp.Views.Android => 0xf53ecfd92be3959b => 93
	i64 17685921127322830888, ; 421: System.Diagnostics.Debug.dll => 0xf571038fafa74828 => 153
	i64 17702523067201099846, ; 422: zh-HK/Microsoft.Maui.Controls.resources.dll => 0xf5abfef008ae1846 => 31
	i64 17704177640604968747, ; 423: Xamarin.AndroidX.Loader => 0xf5b1dfc36cac272b => 119
	i64 17710060891934109755, ; 424: Xamarin.AndroidX.Lifecycle.ViewModel => 0xf5c6c68c9e45303b => 117
	i64 17712670374920797664, ; 425: System.Runtime.InteropServices.dll => 0xf5d00bdc38bd3de0 => 192
	i64 17743407583038752114, ; 426: System.CodeDom.dll => 0xf63d3f302bff4572 => 97
	i64 17777860260071588075, ; 427: System.Runtime.Numerics.dll => 0xf6b7a5b72419c0eb => 194
	i64 17790600151040787804, ; 428: Microsoft.IdentityModel.Logging => 0xf6e4e89427cc055c => 77
	i64 17838668724098252521, ; 429: System.Buffers.dll => 0xf78faeb0f5bf3ee9 => 141
	i64 17875729375684862191, ; 430: LiveCharts.dll => 0xf813592852b620ef => 63
	i64 17945795017270165205, ; 431: Xamarin.Google.Android.DataTransport.TransportApi.dll => 0xf90c457cc05cfed5 => 132
	i64 17986907704309214542, ; 432: Xamarin.GooglePlayServices.Basement.dll => 0xf99e554223166d4e => 135
	i64 18025913125965088385, ; 433: System.Threading => 0xfa28e87b91334681 => 210
	i64 18099568558057551825, ; 434: nl/Microsoft.Maui.Controls.resources.dll => 0xfb2e95b53ad977d1 => 19
	i64 18121036031235206392, ; 435: Xamarin.AndroidX.Navigation.Common => 0xfb7ada42d3d42cf8 => 120
	i64 18146411883821974900, ; 436: System.Formats.Asn1.dll => 0xfbd50176eb22c574 => 160
	i64 18245806341561545090, ; 437: System.Collections.Concurrent.dll => 0xfd3620327d587182 => 142
	i64 18284618658670613420, ; 438: System.IO.Packaging.dll => 0xfdc003cb438a93ac => 99
	i64 18305135509493619199, ; 439: Xamarin.AndroidX.Navigation.Runtime.dll => 0xfe08e7c2d8c199ff => 122
	i64 18324163916253801303, ; 440: it\Microsoft.Maui.Controls.resources => 0xfe4c81ff0a56ab57 => 14
	i64 18337470502355292274, ; 441: Xamarin.Firebase.Messaging => 0xfe7bc8440c175072 => 131
	i64 18341799084585866416, ; 442: DocumentFormat.OpenXml.Framework => 0xfe8b2916a25354b0 => 41
	i64 18380184030268848184 ; 443: Xamarin.AndroidX.VersionedParcelable => 0xff1387fe3e7b7838 => 127
], align 16

@assembly_image_cache_indices = dso_local local_unnamed_addr constant [444 x i32] [
	i32 55, ; 0
	i32 74, ; 1
	i32 221, ; 2
	i32 83, ; 3
	i32 165, ; 4
	i32 108, ; 5
	i32 64, ; 6
	i32 125, ; 7
	i32 103, ; 8
	i32 102, ; 9
	i32 101, ; 10
	i32 7, ; 11
	i32 187, ; 12
	i32 134, ; 13
	i32 91, ; 14
	i32 43, ; 15
	i32 209, ; 16
	i32 149, ; 17
	i32 10, ; 18
	i32 113, ; 19
	i32 187, ; 20
	i32 133, ; 21
	i32 18, ; 22
	i32 159, ; 23
	i32 121, ; 24
	i32 174, ; 25
	i32 80, ; 26
	i32 170, ; 27
	i32 220, ; 28
	i32 209, ; 29
	i32 16, ; 30
	i32 106, ; 31
	i32 118, ; 32
	i32 85, ; 33
	i32 171, ; 34
	i32 168, ; 35
	i32 182, ; 36
	i32 57, ; 37
	i32 105, ; 38
	i32 191, ; 39
	i32 6, ; 40
	i32 125, ; 41
	i32 41, ; 42
	i32 65, ; 43
	i32 158, ; 44
	i32 28, ; 45
	i32 81, ; 46
	i32 39, ; 47
	i32 28, ; 48
	i32 199, ; 49
	i32 117, ; 50
	i32 2, ; 51
	i32 20, ; 52
	i32 208, ; 53
	i32 158, ; 54
	i32 85, ; 55
	i32 40, ; 56
	i32 113, ; 57
	i32 142, ; 58
	i32 24, ; 59
	i32 163, ; 60
	i32 116, ; 61
	i32 204, ; 62
	i32 189, ; 63
	i32 53, ; 64
	i32 109, ; 65
	i32 197, ; 66
	i32 104, ; 67
	i32 27, ; 68
	i32 78, ; 69
	i32 216, ; 70
	i32 172, ; 71
	i32 69, ; 72
	i32 2, ; 73
	i32 189, ; 74
	i32 76, ; 75
	i32 52, ; 76
	i32 7, ; 77
	i32 133, ; 78
	i32 115, ; 79
	i32 180, ; 80
	i32 194, ; 81
	i32 178, ; 82
	i32 138, ; 83
	i32 130, ; 84
	i32 98, ; 85
	i32 135, ; 86
	i32 94, ; 87
	i32 83, ; 88
	i32 58, ; 89
	i32 67, ; 90
	i32 126, ; 91
	i32 218, ; 92
	i32 22, ; 93
	i32 197, ; 94
	i32 96, ; 95
	i32 68, ; 96
	i32 213, ; 97
	i32 67, ; 98
	i32 217, ; 99
	i32 124, ; 100
	i32 71, ; 101
	i32 156, ; 102
	i32 81, ; 103
	i32 54, ; 104
	i32 103, ; 105
	i32 175, ; 106
	i32 168, ; 107
	i32 196, ; 108
	i32 51, ; 109
	i32 184, ; 110
	i32 79, ; 111
	i32 33, ; 112
	i32 149, ; 113
	i32 198, ; 114
	i32 165, ; 115
	i32 148, ; 116
	i32 136, ; 117
	i32 30, ; 118
	i32 164, ; 119
	i32 42, ; 120
	i32 211, ; 121
	i32 66, ; 122
	i32 127, ; 123
	i32 0, ; 124
	i32 104, ; 125
	i32 126, ; 126
	i32 159, ; 127
	i32 172, ; 128
	i32 193, ; 129
	i32 188, ; 130
	i32 55, ; 131
	i32 188, ; 132
	i32 145, ; 133
	i32 145, ; 134
	i32 193, ; 135
	i32 191, ; 136
	i32 87, ; 137
	i32 153, ; 138
	i32 26, ; 139
	i32 151, ; 140
	i32 29, ; 141
	i32 161, ; 142
	i32 202, ; 143
	i32 166, ; 144
	i32 199, ; 145
	i32 52, ; 146
	i32 129, ; 147
	i32 42, ; 148
	i32 160, ; 149
	i32 200, ; 150
	i32 23, ; 151
	i32 23, ; 152
	i32 44, ; 153
	i32 205, ; 154
	i32 185, ; 155
	i32 34, ; 156
	i32 116, ; 157
	i32 11, ; 158
	i32 112, ; 159
	i32 73, ; 160
	i32 86, ; 161
	i32 92, ; 162
	i32 19, ; 163
	i32 22, ; 164
	i32 157, ; 165
	i32 36, ; 166
	i32 214, ; 167
	i32 212, ; 168
	i32 180, ; 169
	i32 49, ; 170
	i32 101, ; 171
	i32 183, ; 172
	i32 63, ; 173
	i32 163, ; 174
	i32 26, ; 175
	i32 167, ; 176
	i32 95, ; 177
	i32 148, ; 178
	i32 212, ; 179
	i32 181, ; 180
	i32 98, ; 181
	i32 155, ; 182
	i32 102, ; 183
	i32 56, ; 184
	i32 169, ; 185
	i32 171, ; 186
	i32 17, ; 187
	i32 218, ; 188
	i32 94, ; 189
	i32 140, ; 190
	i32 137, ; 191
	i32 46, ; 192
	i32 106, ; 193
	i32 56, ; 194
	i32 93, ; 195
	i32 35, ; 196
	i32 146, ; 197
	i32 115, ; 198
	i32 154, ; 199
	i32 219, ; 200
	i32 146, ; 201
	i32 84, ; 202
	i32 155, ; 203
	i32 190, ; 204
	i32 100, ; 205
	i32 202, ; 206
	i32 123, ; 207
	i32 186, ; 208
	i32 131, ; 209
	i32 143, ; 210
	i32 182, ; 211
	i32 89, ; 212
	i32 37, ; 213
	i32 21, ; 214
	i32 219, ; 215
	i32 140, ; 216
	i32 122, ; 217
	i32 21, ; 218
	i32 48, ; 219
	i32 45, ; 220
	i32 154, ; 221
	i32 66, ; 222
	i32 88, ; 223
	i32 214, ; 224
	i32 31, ; 225
	i32 62, ; 226
	i32 90, ; 227
	i32 87, ; 228
	i32 62, ; 229
	i32 129, ; 230
	i32 105, ; 231
	i32 60, ; 232
	i32 77, ; 233
	i32 206, ; 234
	i32 109, ; 235
	i32 144, ; 236
	i32 88, ; 237
	i32 221, ; 238
	i32 134, ; 239
	i32 82, ; 240
	i32 97, ; 241
	i32 6, ; 242
	i32 169, ; 243
	i32 184, ; 244
	i32 61, ; 245
	i32 80, ; 246
	i32 3, ; 247
	i32 45, ; 248
	i32 43, ; 249
	i32 112, ; 250
	i32 177, ; 251
	i32 186, ; 252
	i32 54, ; 253
	i32 185, ; 254
	i32 138, ; 255
	i32 110, ; 256
	i32 65, ; 257
	i32 1, ; 258
	i32 99, ; 259
	i32 190, ; 260
	i32 174, ; 261
	i32 47, ; 262
	i32 59, ; 263
	i32 37, ; 264
	i32 100, ; 265
	i32 72, ; 266
	i32 82, ; 267
	i32 151, ; 268
	i32 12, ; 269
	i32 128, ; 270
	i32 15, ; 271
	i32 73, ; 272
	i32 53, ; 273
	i32 111, ; 274
	i32 59, ; 275
	i32 61, ; 276
	i32 64, ; 277
	i32 192, ; 278
	i32 75, ; 279
	i32 13, ; 280
	i32 128, ; 281
	i32 71, ; 282
	i32 60, ; 283
	i32 217, ; 284
	i32 9, ; 285
	i32 166, ; 286
	i32 96, ; 287
	i32 86, ; 288
	i32 177, ; 289
	i32 141, ; 290
	i32 205, ; 291
	i32 196, ; 292
	i32 143, ; 293
	i32 38, ; 294
	i32 50, ; 295
	i32 76, ; 296
	i32 114, ; 297
	i32 119, ; 298
	i32 34, ; 299
	i32 157, ; 300
	i32 44, ; 301
	i32 107, ; 302
	i32 162, ; 303
	i32 14, ; 304
	i32 108, ; 305
	i32 203, ; 306
	i32 49, ; 307
	i32 27, ; 308
	i32 164, ; 309
	i32 74, ; 310
	i32 179, ; 311
	i32 50, ; 312
	i32 195, ; 313
	i32 91, ; 314
	i32 1, ; 315
	i32 15, ; 316
	i32 220, ; 317
	i32 9, ; 318
	i32 137, ; 319
	i32 29, ; 320
	i32 30, ; 321
	i32 13, ; 322
	i32 124, ; 323
	i32 90, ; 324
	i32 156, ; 325
	i32 147, ; 326
	i32 8, ; 327
	i32 51, ; 328
	i32 11, ; 329
	i32 150, ; 330
	i32 114, ; 331
	i32 89, ; 332
	i32 3, ; 333
	i32 107, ; 334
	i32 210, ; 335
	i32 40, ; 336
	i32 203, ; 337
	i32 201, ; 338
	i32 175, ; 339
	i32 24, ; 340
	i32 5, ; 341
	i32 204, ; 342
	i32 95, ; 343
	i32 38, ; 344
	i32 200, ; 345
	i32 195, ; 346
	i32 58, ; 347
	i32 69, ; 348
	i32 211, ; 349
	i32 16, ; 350
	i32 32, ; 351
	i32 130, ; 352
	i32 198, ; 353
	i32 111, ; 354
	i32 33, ; 355
	i32 0, ; 356
	i32 70, ; 357
	i32 179, ; 358
	i32 162, ; 359
	i32 176, ; 360
	i32 181, ; 361
	i32 48, ; 362
	i32 17, ; 363
	i32 161, ; 364
	i32 167, ; 365
	i32 75, ; 366
	i32 68, ; 367
	i32 110, ; 368
	i32 70, ; 369
	i32 150, ; 370
	i32 170, ; 371
	i32 4, ; 372
	i32 201, ; 373
	i32 178, ; 374
	i32 118, ; 375
	i32 215, ; 376
	i32 213, ; 377
	i32 4, ; 378
	i32 36, ; 379
	i32 12, ; 380
	i32 5, ; 381
	i32 207, ; 382
	i32 139, ; 383
	i32 79, ; 384
	i32 136, ; 385
	i32 208, ; 386
	i32 173, ; 387
	i32 139, ; 388
	i32 215, ; 389
	i32 176, ; 390
	i32 18, ; 391
	i32 72, ; 392
	i32 92, ; 393
	i32 173, ; 394
	i32 132, ; 395
	i32 39, ; 396
	i32 84, ; 397
	i32 123, ; 398
	i32 216, ; 399
	i32 152, ; 400
	i32 206, ; 401
	i32 25, ; 402
	i32 47, ; 403
	i32 46, ; 404
	i32 121, ; 405
	i32 144, ; 406
	i32 120, ; 407
	i32 147, ; 408
	i32 32, ; 409
	i32 207, ; 410
	i32 78, ; 411
	i32 183, ; 412
	i32 152, ; 413
	i32 35, ; 414
	i32 10, ; 415
	i32 25, ; 416
	i32 8, ; 417
	i32 57, ; 418
	i32 20, ; 419
	i32 93, ; 420
	i32 153, ; 421
	i32 31, ; 422
	i32 119, ; 423
	i32 117, ; 424
	i32 192, ; 425
	i32 97, ; 426
	i32 194, ; 427
	i32 77, ; 428
	i32 141, ; 429
	i32 63, ; 430
	i32 132, ; 431
	i32 135, ; 432
	i32 210, ; 433
	i32 19, ; 434
	i32 120, ; 435
	i32 160, ; 436
	i32 142, ; 437
	i32 99, ; 438
	i32 122, ; 439
	i32 14, ; 440
	i32 131, ; 441
	i32 41, ; 442
	i32 127 ; 443
], align 16

@marshal_methods_number_of_classes = dso_local local_unnamed_addr constant i32 0, align 4

@marshal_methods_class_cache = dso_local local_unnamed_addr global [0 x %struct.MarshalMethodsManagedClass] zeroinitializer, align 8

; Names of classes in which marshal methods reside
@mm_class_names = dso_local local_unnamed_addr constant [0 x ptr] zeroinitializer, align 8

@mm_method_names = dso_local local_unnamed_addr constant [1 x %struct.MarshalMethodName] [
	%struct.MarshalMethodName {
		i64 0, ; id 0x0; name: 
		ptr @.MarshalMethodName.0_name; char* name
	} ; 0
], align 8

; get_function_pointer (uint32_t mono_image_index, uint32_t class_index, uint32_t method_token, void*& target_ptr)
@get_function_pointer = internal dso_local unnamed_addr global ptr null, align 8

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
	store ptr %fn, ptr @get_function_pointer, align 8, !tbaa !3
	ret void
}

; Strings
@.str.0 = private unnamed_addr constant [40 x i8] c"get_function_pointer MUST be specified\0A\00", align 16

;MarshalMethodName
@.MarshalMethodName.0_name = private unnamed_addr constant [1 x i8] c"\00", align 1

; External functions

; Function attributes: "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8"
declare void @abort() local_unnamed_addr #2

; Function attributes: nofree nounwind
declare noundef i32 @puts(ptr noundef) local_unnamed_addr #1
attributes #0 = { "min-legal-vector-width"="0" mustprogress "no-trapping-math"="true" nofree norecurse nosync nounwind "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+crc32,+cx16,+cx8,+fxsr,+mmx,+popcnt,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87" "tune-cpu"="generic" uwtable willreturn }
attributes #1 = { nofree nounwind }
attributes #2 = { "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+crc32,+cx16,+cx8,+fxsr,+mmx,+popcnt,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87" "tune-cpu"="generic" }

; Metadata
!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!llvm.ident = !{!2}
!2 = !{!"Xamarin.Android remotes/origin/release/8.0.4xx @ 82d8938cf80f6d5fa6c28529ddfbdb753d805ab4"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
