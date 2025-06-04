; ModuleID = 'marshal_methods.arm64-v8a.ll'
source_filename = "marshal_methods.arm64-v8a.ll"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-android21"

%struct.MarshalMethodName = type {
	i64, ; uint64_t id
	ptr ; char* name
}

%struct.MarshalMethodsManagedClass = type {
	i32, ; uint32_t token
	ptr ; MonoClass klass
}

@assembly_image_cache = dso_local local_unnamed_addr global [192 x ptr] zeroinitializer, align 8

; Each entry maps hash of an assembly name to an index into the `assembly_image_cache` array
@assembly_image_cache_hashes = dso_local local_unnamed_addr constant [576 x i64] [
	i64 u0x0010bf7088f76c5f, ; 0: Google.Cloud.Firestore.V1 => 49
	i64 u0x0071cf2d27b7d61e, ; 1: lib_Xamarin.AndroidX.SwipeRefreshLayout.dll.so => 113
	i64 u0x020f428300334897, ; 2: Grpc.Net.Client.dll => 55
	i64 u0x02123411c4e01926, ; 3: lib_Xamarin.AndroidX.Navigation.Runtime.dll.so => 109
	i64 u0x022e81ea9c46e03a, ; 4: lib_CommunityToolkit.Maui.Core.dll.so => 36
	i64 u0x02abedc11addc1ed, ; 5: lib_Mono.Android.Runtime.dll.so => 190
	i64 u0x032267b2a94db371, ; 6: lib_Xamarin.AndroidX.AppCompat.dll.so => 92
	i64 u0x03bb23be2292d02c, ; 7: StarkbankEcdsa => 84
	i64 u0x043032f1d071fae0, ; 8: ru/Microsoft.Maui.Controls.resources => 24
	i64 u0x044440a55165631e, ; 9: lib-cs-Microsoft.Maui.Controls.resources.dll.so => 2
	i64 u0x046eb1581a80c6b0, ; 10: vi/Microsoft.Maui.Controls.resources => 30
	i64 u0x0470607fd33c32db, ; 11: Microsoft.IdentityModel.Abstractions.dll => 69
	i64 u0x0517ef04e06e9f76, ; 12: System.Net.Primitives => 149
	i64 u0x0565d18c6da3de38, ; 13: Xamarin.AndroidX.RecyclerView => 111
	i64 u0x0581db89237110e9, ; 14: lib_System.Collections.dll.so => 126
	i64 u0x05989cb940b225a9, ; 15: Microsoft.Maui.dll => 75
	i64 u0x06076b5d2b581f08, ; 16: zh-HK/Microsoft.Maui.Controls.resources => 31
	i64 u0x06388ffe9f6c161a, ; 17: System.Xml.Linq.dll => 183
	i64 u0x0680a433c781bb3d, ; 18: Xamarin.AndroidX.Collection.Jvm => 95
	i64 u0x07c57877c7ba78ad, ; 19: ru/Microsoft.Maui.Controls.resources.dll => 24
	i64 u0x07d3c4001b324a05, ; 20: lib_Twilio.dll.so => 90
	i64 u0x07dcdc7460a0c5e4, ; 21: System.Collections.NonGeneric => 124
	i64 u0x08a7c865576bbde7, ; 22: System.Reflection.Primitives => 161
	i64 u0x08f3c9788ee2153c, ; 23: Xamarin.AndroidX.DrawerLayout => 100
	i64 u0x0919c28b89381a0b, ; 24: lib_Microsoft.Extensions.Options.dll.so => 67
	i64 u0x092266563089ae3e, ; 25: lib_System.Collections.NonGeneric.dll.so => 124
	i64 u0x09d144a7e214d457, ; 26: System.Security.Cryptography => 173
	i64 u0x0a066c5968b04c8d, ; 27: lib_Firebase.dll.so => 40
	i64 u0x0abb3e2b271edc45, ; 28: System.Threading.Channels.dll => 178
	i64 u0x0b3b632c3bbee20c, ; 29: sk/Microsoft.Maui.Controls.resources => 25
	i64 u0x0b6aff547b84fbe9, ; 30: Xamarin.KotlinX.Serialization.Core.Jvm => 119
	i64 u0x0be2e1f8ce4064ed, ; 31: Xamarin.AndroidX.ViewPager => 114
	i64 u0x0c279376b1ae96ae, ; 32: lib_System.CodeDom.dll.so => 85
	i64 u0x0c3ca6cc978e2aae, ; 33: pt-BR/Microsoft.Maui.Controls.resources => 21
	i64 u0x0c59ad9fbbd43abe, ; 34: Mono.Android => 191
	i64 u0x0c7790f60165fc06, ; 35: lib_Microsoft.Maui.Essentials.dll.so => 76
	i64 u0x0d3b5ab8b2766190, ; 36: lib_Microsoft.Bcl.AsyncInterfaces.dll.so => 60
	i64 u0x0d565cb22b8879da, ; 37: lib_Grpc.Core.Api.dll.so => 54
	i64 u0x0e14e73a54dda68e, ; 38: lib_System.Net.NameResolution.dll.so => 147
	i64 u0x0ec01b05613190b9, ; 39: SkiaSharp.Views.Android.dll => 81
	i64 u0x0f5e7abaa7cf470a, ; 40: System.Net.HttpListener => 146
	i64 u0x102861e4055f511a, ; 41: Microsoft.Bcl.AsyncInterfaces.dll => 60
	i64 u0x102a31b45304b1da, ; 42: Xamarin.AndroidX.CustomView => 99
	i64 u0x10f6cfcbcf801616, ; 43: System.IO.Compression.Brotli => 138
	i64 u0x114443cdcf2091f1, ; 44: System.Security.Cryptography.Primitives => 171
	i64 u0x123639456fb056da, ; 45: System.Reflection.Emit.Lightweight.dll => 160
	i64 u0x124b1cd9ce23ae6f, ; 46: Google.Api.Gax.Rest => 44
	i64 u0x125b7f94acb989db, ; 47: Xamarin.AndroidX.RecyclerView.dll => 111
	i64 u0x12f23aabd624cf79, ; 48: lib_Google.Cloud.Firestore.V1.dll.so => 49
	i64 u0x13a01de0cbc3f06c, ; 49: lib-fr-Microsoft.Maui.Controls.resources.dll.so => 8
	i64 u0x13f1e5e209e91af4, ; 50: lib_Java.Interop.dll.so => 189
	i64 u0x13f1e880c25d96d1, ; 51: he/Microsoft.Maui.Controls.resources => 9
	i64 u0x143d8ea60a6a4011, ; 52: Microsoft.Extensions.DependencyInjection.Abstractions => 64
	i64 u0x16bf2a22df043a09, ; 53: System.IO.Pipes.dll => 141
	i64 u0x16ea2b318ad2d830, ; 54: System.Security.Cryptography.Algorithms => 170
	i64 u0x17125c9a85b4929f, ; 55: lib_netstandard.dll.so => 187
	i64 u0x1720be632265b2ab, ; 56: restaurant.dll => 120
	i64 u0x17b56e25558a5d36, ; 57: lib-hu-Microsoft.Maui.Controls.resources.dll.so => 12
	i64 u0x17f9358913beb16a, ; 58: System.Text.Encodings.Web => 175
	i64 u0x18402a709e357f3b, ; 59: lib_Xamarin.KotlinX.Serialization.Core.Jvm.dll.so => 119
	i64 u0x18f0ce884e87d89a, ; 60: nb/Microsoft.Maui.Controls.resources.dll => 18
	i64 u0x19a4c090f14ebb66, ; 61: System.Security.Claims => 169
	i64 u0x1a539258f88190d6, ; 62: lib_System.Linq.Async.dll.so => 87
	i64 u0x1a91866a319e9259, ; 63: lib_System.Collections.Concurrent.dll.so => 122
	i64 u0x1aac34d1917ba5d3, ; 64: lib_System.dll.so => 186
	i64 u0x1aad60783ffa3e5b, ; 65: lib-th-Microsoft.Maui.Controls.resources.dll.so => 27
	i64 u0x1c753b5ff15bce1b, ; 66: Mono.Android.Runtime.dll => 190
	i64 u0x1cb6a0ededc839e2, ; 67: lib_Google.Apis.Auth.dll.so => 46
	i64 u0x1dba6509cc55b56f, ; 68: lib_Google.Protobuf.dll.so => 52
	i64 u0x1e3d87657e9659bc, ; 69: Xamarin.AndroidX.Navigation.UI => 110
	i64 u0x1e71143913d56c10, ; 70: lib-ko-Microsoft.Maui.Controls.resources.dll.so => 16
	i64 u0x1ed8fcce5e9b50a0, ; 71: Microsoft.Extensions.Options.dll => 67
	i64 u0x209375905fcc1bad, ; 72: lib_System.IO.Compression.Brotli.dll.so => 138
	i64 u0x20d9b03355e48538, ; 73: lib_FirebaseAdmin.dll.so => 38
	i64 u0x20e085517023eec8, ; 74: lib_Google.Api.Gax.dll.so => 42
	i64 u0x20fab3cf2dfbc8df, ; 75: lib_System.Diagnostics.Process.dll.so => 133
	i64 u0x2174319c0d835bc9, ; 76: System.Runtime => 168
	i64 u0x21846dffb992e05b, ; 77: lib_Microcharts.Maui.dll.so => 59
	i64 u0x21cc7e445dcd5469, ; 78: System.Reflection.Emit.ILGeneration => 159
	i64 u0x220fd4f2e7c48170, ; 79: th/Microsoft.Maui.Controls.resources => 27
	i64 u0x224538d85ed15a82, ; 80: System.IO.Pipes => 141
	i64 u0x237be844f1f812c7, ; 81: System.Threading.Thread.dll => 180
	i64 u0x23b0dd507a933aa9, ; 82: Google.Api.Gax => 42
	i64 u0x2407aef2bbe8fadf, ; 83: System.Console => 130
	i64 u0x240abe014b27e7d3, ; 84: Xamarin.AndroidX.Core.dll => 97
	i64 u0x247619fe4413f8bf, ; 85: System.Runtime.Serialization.Primitives.dll => 167
	i64 u0x24b95d581a70fbee, ; 86: Grpc.Auth.dll => 53
	i64 u0x24d4238047d7310f, ; 87: Google.Apis.Auth => 46
	i64 u0x252073cc3caa62c2, ; 88: fr/Microsoft.Maui.Controls.resources.dll => 8
	i64 u0x2662c629b96b0b30, ; 89: lib_Xamarin.Kotlin.StdLib.dll.so => 117
	i64 u0x268c1439f13bcc29, ; 90: lib_Microsoft.Extensions.Primitives.dll.so => 68
	i64 u0x270a44600c921861, ; 91: System.IdentityModel.Tokens.Jwt => 86
	i64 u0x273f3515de5faf0d, ; 92: id/Microsoft.Maui.Controls.resources.dll => 13
	i64 u0x2742545f9094896d, ; 93: hr/Microsoft.Maui.Controls.resources => 11
	i64 u0x27b410442fad6cf1, ; 94: Java.Interop.dll => 189
	i64 u0x2801845a2c71fbfb, ; 95: System.Net.Primitives.dll => 149
	i64 u0x2927d345f3daec35, ; 96: SkiaSharp.dll => 80
	i64 u0x2a128783efe70ba0, ; 97: uk/Microsoft.Maui.Controls.resources.dll => 29
	i64 u0x2a3b095612184159, ; 98: lib_System.Net.NetworkInformation.dll.so => 148
	i64 u0x2a6507a5ffabdf28, ; 99: System.Diagnostics.TraceSource.dll => 134
	i64 u0x2ad156c8e1354139, ; 100: fi/Microsoft.Maui.Controls.resources => 7
	i64 u0x2af298f63581d886, ; 101: System.Text.RegularExpressions.dll => 177
	i64 u0x2af615542f04da50, ; 102: System.IdentityModel.Tokens.Jwt.dll => 86
	i64 u0x2afc1c4f898552ee, ; 103: lib_System.Formats.Asn1.dll.so => 137
	i64 u0x2b148910ed40fbf9, ; 104: zh-Hant/Microsoft.Maui.Controls.resources.dll => 33
	i64 u0x2c8bd14bb93a7d82, ; 105: lib-pl-Microsoft.Maui.Controls.resources.dll.so => 20
	i64 u0x2cc9e1fed6257257, ; 106: lib_System.Reflection.Emit.Lightweight.dll.so => 160
	i64 u0x2cd723e9fe623c7c, ; 107: lib_System.Private.Xml.Linq.dll.so => 157
	i64 u0x2d169d318a968379, ; 108: System.Threading.dll => 181
	i64 u0x2d47774b7d993f59, ; 109: sv/Microsoft.Maui.Controls.resources.dll => 26
	i64 u0x2db915caf23548d2, ; 110: System.Text.Json.dll => 176
	i64 u0x2e6f1f226821322a, ; 111: el/Microsoft.Maui.Controls.resources.dll => 5
	i64 u0x2f02f94df3200fe5, ; 112: System.Diagnostics.Process => 133
	i64 u0x2f2e98e1c89b1aff, ; 113: System.Xml.ReaderWriter => 184
	i64 u0x309ee9eeec09a71e, ; 114: lib_Xamarin.AndroidX.Fragment.dll.so => 101
	i64 u0x309f2bedefa9a318, ; 115: Microsoft.IdentityModel.Abstractions => 69
	i64 u0x30ff0edf3d280bcd, ; 116: Firebase.Auth => 39
	i64 u0x31195fef5d8fb552, ; 117: _Microsoft.Android.Resource.Designer.dll => 34
	i64 u0x32243413e774362a, ; 118: Xamarin.AndroidX.CardView.dll => 94
	i64 u0x3235427f8d12dae1, ; 119: lib_System.Drawing.Primitives.dll.so => 135
	i64 u0x326256f7722d4fe5, ; 120: SkiaSharp.Views.Maui.Controls.dll => 82
	i64 u0x329753a17a517811, ; 121: fr/Microsoft.Maui.Controls.resources => 8
	i64 u0x32aa989ff07a84ff, ; 122: lib_System.Xml.ReaderWriter.dll.so => 184
	i64 u0x33829542f112d59b, ; 123: System.Collections.Immutable => 123
	i64 u0x33a31443733849fe, ; 124: lib-es-Microsoft.Maui.Controls.resources.dll.so => 6
	i64 u0x33ec63a7e226adfb, ; 125: Google.Cloud.Location.dll => 50
	i64 u0x341abc357fbb4ebf, ; 126: lib_System.Net.Sockets.dll.so => 152
	i64 u0x34dfd74fe2afcf37, ; 127: Microsoft.Maui => 75
	i64 u0x34e292762d9615df, ; 128: cs/Microsoft.Maui.Controls.resources.dll => 2
	i64 u0x3508234247f48404, ; 129: Microsoft.Maui.Controls => 73
	i64 u0x3549870798b4cd30, ; 130: lib_Xamarin.AndroidX.ViewPager2.dll.so => 115
	i64 u0x355282fc1c909694, ; 131: Microsoft.Extensions.Configuration => 61
	i64 u0x36b2b50fdf589ae2, ; 132: System.Reflection.Emit.Lightweight => 160
	i64 u0x374ef46b06791af6, ; 133: System.Reflection.Primitives.dll => 161
	i64 u0x379e6c338e5508ad, ; 134: lib_Google.Api.Gax.Grpc.dll.so => 43
	i64 u0x380134e03b1e160a, ; 135: System.Collections.Immutable.dll => 123
	i64 u0x385c17636bb6fe6e, ; 136: Xamarin.AndroidX.CustomView.dll => 99
	i64 u0x38869c811d74050e, ; 137: System.Net.NameResolution.dll => 147
	i64 u0x393c226616977fdb, ; 138: lib_Xamarin.AndroidX.ViewPager.dll.so => 114
	i64 u0x395b3053dde89e41, ; 139: lib_System.Reactive.dll.so => 89
	i64 u0x395e37c3334cf82a, ; 140: lib-ca-Microsoft.Maui.Controls.resources.dll.so => 1
	i64 u0x39a87563fdb248a0, ; 141: System.Reactive.dll => 89
	i64 u0x39aa39fda111d9d3, ; 142: Newtonsoft.Json => 78
	i64 u0x3ab5859054645f72, ; 143: System.Security.Cryptography.Primitives.dll => 171
	i64 u0x3b860f9932505633, ; 144: lib_System.Text.Encoding.Extensions.dll.so => 174
	i64 u0x3bea9ebe8c027c01, ; 145: lib_Microsoft.IdentityModel.Tokens.dll.so => 72
	i64 u0x3c3aafb6b3a00bf6, ; 146: lib_System.Security.Cryptography.X509Certificates.dll.so => 172
	i64 u0x3c51334447dec9e7, ; 147: Google.LongRunning => 51
	i64 u0x3c7c495f58ac5ee9, ; 148: Xamarin.Kotlin.StdLib => 117
	i64 u0x3d46f0b995082740, ; 149: System.Xml.Linq => 183
	i64 u0x3d9c2a242b040a50, ; 150: lib_Xamarin.AndroidX.Core.dll.so => 97
	i64 u0x3daa14724d8f58e8, ; 151: Google.Protobuf.dll => 52
	i64 u0x3e027e6e728d7f1c, ; 152: Google.LongRunning.dll => 51
	i64 u0x3f2839b8d63653b8, ; 153: lib_LiteDB.dll.so => 57
	i64 u0x3f510adf788828dd, ; 154: System.Threading.Tasks.Extensions => 179
	i64 u0x407a10bb4bf95829, ; 155: lib_Xamarin.AndroidX.Navigation.Common.dll.so => 107
	i64 u0x40c6d9cbfdb8b9f7, ; 156: SkiaSharp.Views.Maui.Core.dll => 83
	i64 u0x41406d6f37320d99, ; 157: Google.Api.Gax.Grpc.dll => 43
	i64 u0x41cab042be111c34, ; 158: lib_Xamarin.AndroidX.AppCompat.AppCompatResources.dll.so => 93
	i64 u0x42418aba44539ffd, ; 159: Google.Cloud.Firestore => 48
	i64 u0x4266c67fd9a4ee79, ; 160: Google.Api.CommonProtos => 41
	i64 u0x42d3cd7add035099, ; 161: System.Management.dll => 88
	i64 u0x43375950ec7c1b6a, ; 162: netstandard.dll => 187
	i64 u0x434c4e1d9284cdae, ; 163: Mono.Android.dll => 191
	i64 u0x43950f84de7cc79a, ; 164: pl/Microsoft.Maui.Controls.resources.dll => 20
	i64 u0x448bd33429269b19, ; 165: Microsoft.CSharp => 121
	i64 u0x4499fa3c8e494654, ; 166: lib_System.Runtime.Serialization.Primitives.dll.so => 167
	i64 u0x4515080865a951a5, ; 167: Xamarin.Kotlin.StdLib.dll => 117
	i64 u0x458d2df79ac57c1d, ; 168: lib_System.IdentityModel.Tokens.Jwt.dll.so => 86
	i64 u0x45b31d67ff6f2b8a, ; 169: lib_Google.Apis.dll.so => 45
	i64 u0x45c40276a42e283e, ; 170: System.Diagnostics.TraceSource => 134
	i64 u0x46a4213bc97fe5ae, ; 171: lib-ru-Microsoft.Maui.Controls.resources.dll.so => 24
	i64 u0x47358bd471172e1d, ; 172: lib_System.Xml.Linq.dll.so => 183
	i64 u0x4747e19ad6a1d4bb, ; 173: Grpc.Net.Common => 56
	i64 u0x47daf4e1afbada10, ; 174: pt/Microsoft.Maui.Controls.resources => 22
	i64 u0x49e952f19a4e2022, ; 175: System.ObjectModel => 155
	i64 u0x4a5667b2462a664b, ; 176: lib_Xamarin.AndroidX.Navigation.UI.dll.so => 110
	i64 u0x4b7b6532ded934b7, ; 177: System.Text.Json => 176
	i64 u0x4bf547f87e5016a8, ; 178: lib_SkiaSharp.Views.Android.dll.so => 81
	i64 u0x4cc5f15266470798, ; 179: lib_Xamarin.AndroidX.Loader.dll.so => 106
	i64 u0x4cf6f67dc77aacd2, ; 180: System.Net.NetworkInformation.dll => 148
	i64 u0x4d3711d4edd16f99, ; 181: Google.Api.Gax.Rest.dll => 44
	i64 u0x4d479f968a05e504, ; 182: System.Linq.Expressions.dll => 142
	i64 u0x4d55a010ffc4faff, ; 183: System.Private.Xml => 158
	i64 u0x4d95fccc1f67c7ca, ; 184: System.Runtime.Loader.dll => 164
	i64 u0x4dcf44c3c9b076a2, ; 185: it/Microsoft.Maui.Controls.resources.dll => 14
	i64 u0x4dd9247f1d2c3235, ; 186: Xamarin.AndroidX.Loader.dll => 106
	i64 u0x4e32f00cb0937401, ; 187: Mono.Android.Runtime => 190
	i64 u0x4ebd0c4b82c5eefc, ; 188: lib_System.Threading.Channels.dll.so => 178
	i64 u0x4f21ee6ef9eb527e, ; 189: ca/Microsoft.Maui.Controls.resources => 1
	i64 u0x4ffd65baff757598, ; 190: Microsoft.IdentityModel.Tokens => 72
	i64 u0x5037f0be3c28c7a3, ; 191: lib_Microsoft.Maui.Controls.dll.so => 73
	i64 u0x508c1fa6b57728d9, ; 192: Grpc.Net.Common.dll => 56
	i64 u0x50cfaa297b1f7ede, ; 193: FirebaseAdmin.dll => 38
	i64 u0x5112ed116d87baf8, ; 194: CommunityToolkit.Mvvm => 37
	i64 u0x5131bbe80989093f, ; 195: Xamarin.AndroidX.Lifecycle.ViewModel.Android.dll => 104
	i64 u0x51bb8a2afe774e32, ; 196: System.Drawing => 136
	i64 u0x526ce79eb8e90527, ; 197: lib_System.Net.Primitives.dll.so => 149
	i64 u0x5277169428c6ebf6, ; 198: lib_Grpc.Net.Common.dll.so => 56
	i64 u0x52829f00b4467c38, ; 199: lib_System.Data.Common.dll.so => 131
	i64 u0x529ffe06f39ab8db, ; 200: Xamarin.AndroidX.Core => 97
	i64 u0x52ff996554dbf352, ; 201: Microsoft.Maui.Graphics => 77
	i64 u0x535f7e40e8fef8af, ; 202: lib-sk-Microsoft.Maui.Controls.resources.dll.so => 25
	i64 u0x53a96d5c86c9e194, ; 203: System.Net.NetworkInformation => 148
	i64 u0x53be1038a61e8d44, ; 204: System.Runtime.InteropServices.RuntimeInformation.dll => 162
	i64 u0x53c3014b9437e684, ; 205: lib-zh-HK-Microsoft.Maui.Controls.resources.dll.so => 31
	i64 u0x5435e6f049e9bc37, ; 206: System.Security.Claims.dll => 169
	i64 u0x54795225dd1587af, ; 207: lib_System.Runtime.dll.so => 168
	i64 u0x54b42cc2b8e65a84, ; 208: Google.Apis.Core.dll => 47
	i64 u0x556e8b63b660ab8b, ; 209: Xamarin.AndroidX.Lifecycle.Common.Jvm.dll => 102
	i64 u0x5588627c9a108ec9, ; 210: System.Collections.Specialized => 125
	i64 u0x561449e1215a61e4, ; 211: lib_SkiaSharp.Views.Maui.Core.dll.so => 83
	i64 u0x571c5cfbec5ae8e2, ; 212: System.Private.Uri => 156
	i64 u0x579a06fed6eec900, ; 213: System.Private.CoreLib.dll => 188
	i64 u0x57c542c14049b66d, ; 214: System.Diagnostics.DiagnosticSource => 132
	i64 u0x58601b2dda4a27b9, ; 215: lib-ja-Microsoft.Maui.Controls.resources.dll.so => 15
	i64 u0x58688d9af496b168, ; 216: Microsoft.Extensions.DependencyInjection.dll => 63
	i64 u0x595a356d23e8da9a, ; 217: lib_Microsoft.CSharp.dll.so => 121
	i64 u0x59a935a032dbc08c, ; 218: lib_Grpc.Auth.dll.so => 53
	i64 u0x59b8a0a114cd1cb5, ; 219: StarkbankEcdsa.dll => 84
	i64 u0x5a89a886ae30258d, ; 220: lib_Xamarin.AndroidX.CoordinatorLayout.dll.so => 96
	i64 u0x5a8f6699f4a1caa9, ; 221: lib_System.Threading.dll.so => 181
	i64 u0x5ae9cd33b15841bf, ; 222: System.ComponentModel => 129
	i64 u0x5b5ba1327561f926, ; 223: lib_SkiaSharp.Views.Maui.Controls.dll.so => 82
	i64 u0x5b5f0e240a06a2a2, ; 224: da/Microsoft.Maui.Controls.resources.dll => 3
	i64 u0x5c393624b8176517, ; 225: lib_Microsoft.Extensions.Logging.dll.so => 65
	i64 u0x5d0a4a29b02d9d3c, ; 226: System.Net.WebHeaderCollection.dll => 153
	i64 u0x5db0cbbd1028510e, ; 227: lib_System.Runtime.InteropServices.dll.so => 163
	i64 u0x5db30905d3e5013b, ; 228: Xamarin.AndroidX.Collection.Jvm.dll => 95
	i64 u0x5e467bc8f09ad026, ; 229: System.Collections.Specialized.dll => 125
	i64 u0x5ea92fdb19ec8c4c, ; 230: System.Text.Encodings.Web.dll => 175
	i64 u0x5eb8046dd40e9ac3, ; 231: System.ComponentModel.Primitives => 127
	i64 u0x5eee1376d94c7f5e, ; 232: System.Net.HttpListener.dll => 146
	i64 u0x5f36ccf5c6a57e24, ; 233: System.Xml.ReaderWriter.dll => 184
	i64 u0x5f4294b9b63cb842, ; 234: System.Data.Common => 131
	i64 u0x5f9a2d823f664957, ; 235: lib-el-Microsoft.Maui.Controls.resources.dll.so => 5
	i64 u0x609f4b7b63d802d4, ; 236: lib_Microsoft.Extensions.DependencyInjection.dll.so => 63
	i64 u0x60cd4e33d7e60134, ; 237: Xamarin.KotlinX.Coroutines.Core.Jvm => 118
	i64 u0x60f62d786afcf130, ; 238: System.Memory => 144
	i64 u0x61be8d1299194243, ; 239: Microsoft.Maui.Controls.Xaml => 74
	i64 u0x61d2cba29557038f, ; 240: de/Microsoft.Maui.Controls.resources => 4
	i64 u0x61d88f399afb2f45, ; 241: lib_System.Runtime.Loader.dll.so => 164
	i64 u0x622eef6f9e59068d, ; 242: System.Private.CoreLib => 188
	i64 u0x63f1f6883c1e23c2, ; 243: lib_System.Collections.Immutable.dll.so => 123
	i64 u0x6400f68068c1e9f1, ; 244: Xamarin.Google.Android.Material.dll => 116
	i64 u0x640e3b14dbd325c2, ; 245: System.Security.Cryptography.Algorithms.dll => 170
	i64 u0x6533c154f14eefe0, ; 246: lib_Google.Api.Gax.Rest.dll.so => 44
	i64 u0x658f524e4aba7dad, ; 247: CommunityToolkit.Maui.dll => 35
	i64 u0x65ca90e07a453071, ; 248: Microcharts.Maui.dll => 59
	i64 u0x65ecac39144dd3cc, ; 249: Microsoft.Maui.Controls.dll => 73
	i64 u0x65ece51227bfa724, ; 250: lib_System.Runtime.Numerics.dll.so => 165
	i64 u0x6692e924eade1b29, ; 251: lib_System.Console.dll.so => 130
	i64 u0x66a4e5c6a3fb0bae, ; 252: lib_Xamarin.AndroidX.Lifecycle.ViewModel.Android.dll.so => 104
	i64 u0x66d13304ce1a3efa, ; 253: Xamarin.AndroidX.CursorAdapter => 98
	i64 u0x68558ec653afa616, ; 254: lib-da-Microsoft.Maui.Controls.resources.dll.so => 3
	i64 u0x6872ec7a2e36b1ac, ; 255: System.Drawing.Primitives.dll => 135
	i64 u0x68fbbbe2eb455198, ; 256: System.Formats.Asn1 => 137
	i64 u0x69063fc0ba8e6bdd, ; 257: he/Microsoft.Maui.Controls.resources.dll => 9
	i64 u0x6a4d7577b2317255, ; 258: System.Runtime.InteropServices.dll => 163
	i64 u0x6ab05716e0ac384b, ; 259: LiteDB.dll => 57
	i64 u0x6abfd1917e8d3355, ; 260: SendGrid.dll => 79
	i64 u0x6ace3b74b15ee4a4, ; 261: nb/Microsoft.Maui.Controls.resources => 18
	i64 u0x6bc822f45373a1d6, ; 262: Google.Apis.dll => 45
	i64 u0x6c07f7c8a4a1e99d, ; 263: LiteDB => 57
	i64 u0x6d12bfaa99c72b1f, ; 264: lib_Microsoft.Maui.Graphics.dll.so => 77
	i64 u0x6d79993361e10ef2, ; 265: Microsoft.Extensions.Primitives => 68
	i64 u0x6d86d56b84c8eb71, ; 266: lib_Xamarin.AndroidX.CursorAdapter.dll.so => 98
	i64 u0x6d9bea6b3e895cf7, ; 267: Microsoft.Extensions.Primitives.dll => 68
	i64 u0x6e25a02c3833319a, ; 268: lib_Xamarin.AndroidX.Navigation.Fragment.dll.so => 108
	i64 u0x6fd2265da78b93a4, ; 269: lib_Microsoft.Maui.dll.so => 75
	i64 u0x6fdfc7de82c33008, ; 270: cs/Microsoft.Maui.Controls.resources => 2
	i64 u0x70e99f48c05cb921, ; 271: tr/Microsoft.Maui.Controls.resources.dll => 28
	i64 u0x70fd3deda22442d2, ; 272: lib-nb-Microsoft.Maui.Controls.resources.dll.so => 18
	i64 u0x71a495ea3761dde8, ; 273: lib-it-Microsoft.Maui.Controls.resources.dll.so => 14
	i64 u0x71ad672adbe48f35, ; 274: System.ComponentModel.Primitives.dll => 127
	i64 u0x72b1fb4109e08d7b, ; 275: lib-hr-Microsoft.Maui.Controls.resources.dll.so => 11
	i64 u0x73e4ce94e2eb6ffc, ; 276: lib_System.Memory.dll.so => 144
	i64 u0x755a91767330b3d4, ; 277: lib_Microsoft.Extensions.Configuration.dll.so => 61
	i64 u0x76012e7334db86e5, ; 278: lib_Xamarin.AndroidX.SavedState.dll.so => 112
	i64 u0x76ca07b878f44da0, ; 279: System.Runtime.Numerics.dll => 165
	i64 u0x780bc73597a503a9, ; 280: lib-ms-Microsoft.Maui.Controls.resources.dll.so => 17
	i64 u0x781876fefbd32de8, ; 281: LiveCharts => 58
	i64 u0x783606d1e53e7a1a, ; 282: th/Microsoft.Maui.Controls.resources.dll => 27
	i64 u0x78a45e51311409b6, ; 283: Xamarin.AndroidX.Fragment.dll => 101
	i64 u0x7adb8da2ac89b647, ; 284: fi/Microsoft.Maui.Controls.resources.dll => 7
	i64 u0x7b4927e421291c41, ; 285: Microsoft.IdentityModel.JsonWebTokens.dll => 70
	i64 u0x7bef86a4335c4870, ; 286: System.ComponentModel.TypeConverter => 128
	i64 u0x7c0820144cd34d6a, ; 287: sk/Microsoft.Maui.Controls.resources.dll => 25
	i64 u0x7c2a0bd1e0f988fc, ; 288: lib-de-Microsoft.Maui.Controls.resources.dll.so => 4
	i64 u0x7cc637f941f716d0, ; 289: CommunityToolkit.Maui.Core => 36
	i64 u0x7d649b75d580bb42, ; 290: ms/Microsoft.Maui.Controls.resources.dll => 17
	i64 u0x7d8ee2bdc8e3aad1, ; 291: System.Numerics.Vectors => 154
	i64 u0x7dfc3d6d9d8d7b70, ; 292: System.Collections => 126
	i64 u0x7e302e110e1e1346, ; 293: lib_System.Security.Claims.dll.so => 169
	i64 u0x7e946809d6008ef2, ; 294: lib_System.ObjectModel.dll.so => 155
	i64 u0x7ecc13347c8fd849, ; 295: lib_System.ComponentModel.dll.so => 129
	i64 u0x7f00ddd9b9ca5a13, ; 296: Xamarin.AndroidX.ViewPager.dll => 114
	i64 u0x7f9351cd44b1273f, ; 297: Microsoft.Extensions.Configuration.Abstractions => 62
	i64 u0x7fbd557c99b3ce6f, ; 298: lib_Xamarin.AndroidX.Lifecycle.LiveData.Core.dll.so => 103
	i64 u0x812c069d5cdecc17, ; 299: System.dll => 186
	i64 u0x8145faf772692484, ; 300: Google.Cloud.Firestore.V1.dll => 49
	i64 u0x81ab745f6c0f5ce6, ; 301: zh-Hant/Microsoft.Maui.Controls.resources => 33
	i64 u0x8277f2be6b5ce05f, ; 302: Xamarin.AndroidX.AppCompat => 92
	i64 u0x828f06563b30bc50, ; 303: lib_Xamarin.AndroidX.CardView.dll.so => 94
	i64 u0x82df8f5532a10c59, ; 304: lib_System.Drawing.dll.so => 136
	i64 u0x82f6403342e12049, ; 305: uk/Microsoft.Maui.Controls.resources => 29
	i64 u0x83a7afd2c49adc86, ; 306: lib_Microsoft.IdentityModel.Abstractions.dll.so => 69
	i64 u0x83c14ba66c8e2b8c, ; 307: zh-Hans/Microsoft.Maui.Controls.resources => 32
	i64 u0x8492dec79fe3ffda, ; 308: LiveCharts.dll => 58
	i64 u0x84ae73148a4557d2, ; 309: lib_System.IO.Pipes.dll.so => 141
	i64 u0x84f9060cc4a93c8f, ; 310: lib_SkiaSharp.dll.so => 80
	i64 u0x86a909228dc7657b, ; 311: lib-zh-Hant-Microsoft.Maui.Controls.resources.dll.so => 33
	i64 u0x86b3e00c36b84509, ; 312: Microsoft.Extensions.Configuration.dll => 61
	i64 u0x87c69b87d9283884, ; 313: lib_System.Threading.Thread.dll.so => 180
	i64 u0x87f6569b25707834, ; 314: System.IO.Compression.Brotli.dll => 138
	i64 u0x87fef727071b7fe5, ; 315: Grpc.Net.Client => 55
	i64 u0x8842b3a5d2d3fb36, ; 316: Microsoft.Maui.Essentials => 76
	i64 u0x88bda98e0cffb7a9, ; 317: lib_Xamarin.KotlinX.Coroutines.Core.Jvm.dll.so => 118
	i64 u0x8930322c7bd8f768, ; 318: netstandard => 187
	i64 u0x897a606c9e39c75f, ; 319: lib_System.ComponentModel.Primitives.dll.so => 127
	i64 u0x89c5188089ec2cd5, ; 320: lib_System.Runtime.InteropServices.RuntimeInformation.dll.so => 162
	i64 u0x8a90bab2026e5b88, ; 321: Google.Cloud.Firestore.dll => 48
	i64 u0x8ad229ea26432ee2, ; 322: Xamarin.AndroidX.Loader => 106
	i64 u0x8b4ff5d0fdd5faa1, ; 323: lib_System.Diagnostics.DiagnosticSource.dll.so => 132
	i64 u0x8b8d01333a96d0b5, ; 324: System.Diagnostics.Process.dll => 133
	i64 u0x8b9ceca7acae3451, ; 325: lib-he-Microsoft.Maui.Controls.resources.dll.so => 9
	i64 u0x8d0f420977c2c1c7, ; 326: Xamarin.AndroidX.CursorAdapter.dll => 98
	i64 u0x8d7b8ab4b3310ead, ; 327: System.Threading => 181
	i64 u0x8da188285aadfe8e, ; 328: System.Collections.Concurrent => 122
	i64 u0x8dfc1cfbf8858f95, ; 329: Grpc.Core.Api.dll => 54
	i64 u0x8ec6e06a61c1baeb, ; 330: lib_Newtonsoft.Json.dll.so => 78
	i64 u0x8ed807bfe9858dfc, ; 331: Xamarin.AndroidX.Navigation.Common => 107
	i64 u0x8ee08b8194a30f48, ; 332: lib-hi-Microsoft.Maui.Controls.resources.dll.so => 10
	i64 u0x8ef7601039857a44, ; 333: lib-ro-Microsoft.Maui.Controls.resources.dll.so => 23
	i64 u0x8f32c6f611f6ffab, ; 334: pt/Microsoft.Maui.Controls.resources.dll => 22
	i64 u0x8f8829d21c8985a4, ; 335: lib-pt-BR-Microsoft.Maui.Controls.resources.dll.so => 21
	i64 u0x90263f8448b8f572, ; 336: lib_System.Diagnostics.TraceSource.dll.so => 134
	i64 u0x903101b46fb73a04, ; 337: _Microsoft.Android.Resource.Designer => 34
	i64 u0x90393bd4865292f3, ; 338: lib_System.IO.Compression.dll.so => 139
	i64 u0x905e2b8e7ae91ae6, ; 339: System.Threading.Tasks.Extensions.dll => 179
	i64 u0x90634f86c5ebe2b5, ; 340: Xamarin.AndroidX.Lifecycle.ViewModel.Android => 104
	i64 u0x907b636704ad79ef, ; 341: lib_Microsoft.Maui.Controls.Xaml.dll.so => 74
	i64 u0x91418dc638b29e68, ; 342: lib_Xamarin.AndroidX.CustomView.dll.so => 99
	i64 u0x9157bd523cd7ed36, ; 343: lib_System.Text.Json.dll.so => 176
	i64 u0x91a74f07b30d37e2, ; 344: System.Linq.dll => 143
	i64 u0x91fa41a87223399f, ; 345: ca/Microsoft.Maui.Controls.resources.dll => 1
	i64 u0x93cfa73ab28d6e35, ; 346: ms/Microsoft.Maui.Controls.resources => 17
	i64 u0x944077d8ca3c6580, ; 347: System.IO.Compression.dll => 139
	i64 u0x948d746a7702861f, ; 348: Microsoft.IdentityModel.Logging.dll => 71
	i64 u0x9564283c37ed59a9, ; 349: lib_Microsoft.IdentityModel.Logging.dll.so => 71
	i64 u0x967fc325e09bfa8c, ; 350: es/Microsoft.Maui.Controls.resources => 6
	i64 u0x9729c8c4c069c478, ; 351: Google.Apis.Core => 47
	i64 u0x9732d8dbddea3d9a, ; 352: id/Microsoft.Maui.Controls.resources => 13
	i64 u0x978be80e5210d31b, ; 353: Microsoft.Maui.Graphics.dll => 77
	i64 u0x97a7d96b96967bc2, ; 354: lib_Firebase.Auth.dll.so => 39
	i64 u0x97b8c771ea3e4220, ; 355: System.ComponentModel.dll => 129
	i64 u0x97e144c9d3c6976e, ; 356: System.Collections.Concurrent.dll => 122
	i64 u0x991d510397f92d9d, ; 357: System.Linq.Expressions => 142
	i64 u0x999cb19e1a04ffd3, ; 358: CommunityToolkit.Mvvm.dll => 37
	i64 u0x99a00ca5270c6878, ; 359: Xamarin.AndroidX.Navigation.Runtime => 109
	i64 u0x99cdc6d1f2d3a72f, ; 360: ko/Microsoft.Maui.Controls.resources.dll => 16
	i64 u0x9c244ac7cda32d26, ; 361: System.Security.Cryptography.X509Certificates.dll => 172
	i64 u0x9d5dbcf5a48583fe, ; 362: lib_Xamarin.AndroidX.Activity.dll.so => 91
	i64 u0x9d74dee1a7725f34, ; 363: Microsoft.Extensions.Configuration.Abstractions.dll => 62
	i64 u0x9e4534b6adaf6e84, ; 364: nl/Microsoft.Maui.Controls.resources => 19
	i64 u0x9eaf1efdf6f7267e, ; 365: Xamarin.AndroidX.Navigation.Common.dll => 107
	i64 u0x9ef542cf1f78c506, ; 366: Xamarin.AndroidX.Lifecycle.LiveData.Core => 103
	i64 u0xa088c6d6689b264d, ; 367: Firebase.Auth.dll => 39
	i64 u0xa0d8259f4cc284ec, ; 368: lib_System.Security.Cryptography.dll.so => 173
	i64 u0xa0eac92f5016e3c7, ; 369: lib_StarkbankEcdsa.dll.so => 84
	i64 u0xa1440773ee9d341e, ; 370: Xamarin.Google.Android.Material => 116
	i64 u0xa1a184e02d8fa4f2, ; 371: Firebase.dll => 40
	i64 u0xa1b9d7c27f47219f, ; 372: Xamarin.AndroidX.Navigation.UI.dll => 110
	i64 u0xa2572680829d2c7c, ; 373: System.IO.Pipelines.dll => 140
	i64 u0xa2beee74530fc01c, ; 374: SkiaSharp.Views.Android => 81
	i64 u0xa46aa1eaa214539b, ; 375: ko/Microsoft.Maui.Controls.resources => 16
	i64 u0xa4d20d2ff0563d26, ; 376: lib_CommunityToolkit.Mvvm.dll.so => 37
	i64 u0xa4edc8f2ceae241a, ; 377: System.Data.Common.dll => 131
	i64 u0xa5494f40f128ce6a, ; 378: System.Runtime.Serialization.Formatters.dll => 166
	i64 u0xa5e599d1e0524750, ; 379: System.Numerics.Vectors.dll => 154
	i64 u0xa5f1ba49b85dd355, ; 380: System.Security.Cryptography.dll => 173
	i64 u0xa5f1e826b58a6998, ; 381: System.Linq.Async.dll => 87
	i64 u0xa67dbee13e1df9ca, ; 382: Xamarin.AndroidX.SavedState.dll => 112
	i64 u0xa68a420042bb9b1f, ; 383: Xamarin.AndroidX.DrawerLayout.dll => 100
	i64 u0xa78ce3745383236a, ; 384: Xamarin.AndroidX.Lifecycle.Common.Jvm => 102
	i64 u0xa7c31b56b4dc7b33, ; 385: hu/Microsoft.Maui.Controls.resources => 12
	i64 u0xa7efa4327dda185f, ; 386: SendGrid => 79
	i64 u0xa8e6320dd07580ef, ; 387: lib_Microsoft.IdentityModel.JsonWebTokens.dll.so => 70
	i64 u0xa952cc4a0d808a59, ; 388: lib_Google.Api.CommonProtos.dll.so => 41
	i64 u0xa964304b5631e28a, ; 389: CommunityToolkit.Maui.Core.dll => 36
	i64 u0xaa2219c8e3449ff5, ; 390: Microsoft.Extensions.Logging.Abstractions => 66
	i64 u0xaa443ac34067eeef, ; 391: System.Private.Xml.dll => 158
	i64 u0xaa52de307ef5d1dd, ; 392: System.Net.Http => 145
	i64 u0xaaaf86367285a918, ; 393: Microsoft.Extensions.DependencyInjection.Abstractions.dll => 64
	i64 u0xaaf84bb3f052a265, ; 394: el/Microsoft.Maui.Controls.resources => 5
	i64 u0xab375658f5084c9f, ; 395: lib_Google.Cloud.Firestore.dll.so => 48
	i64 u0xab5de6f30214c6fc, ; 396: Twilio.dll => 90
	i64 u0xab9c1b2687d86b0b, ; 397: lib_System.Linq.Expressions.dll.so => 142
	i64 u0xac2af3fa195a15ce, ; 398: System.Runtime.Numerics => 165
	i64 u0xac5376a2a538dc10, ; 399: Xamarin.AndroidX.Lifecycle.LiveData.Core.dll => 103
	i64 u0xac65e40f62b6b90e, ; 400: Google.Protobuf => 52
	i64 u0xac98d31068e24591, ; 401: System.Xml.XDocument => 185
	i64 u0xacd46e002c3ccb97, ; 402: ro/Microsoft.Maui.Controls.resources => 23
	i64 u0xacf42eea7ef9cd12, ; 403: System.Threading.Channels => 178
	i64 u0xad89c07347f1bad6, ; 404: nl/Microsoft.Maui.Controls.resources.dll => 19
	i64 u0xadbb53caf78a79d2, ; 405: System.Web.HttpUtility => 182
	i64 u0xadc90ab061a9e6e4, ; 406: System.ComponentModel.TypeConverter.dll => 128
	i64 u0xadf511667bef3595, ; 407: System.Net.Security => 151
	i64 u0xae282bcd03739de7, ; 408: Java.Interop => 189
	i64 u0xae53579c90db1107, ; 409: System.ObjectModel.dll => 155
	i64 u0xafe29f45095518e7, ; 410: lib_Xamarin.AndroidX.Lifecycle.ViewModelSavedState.dll.so => 105
	i64 u0xb05cc42cd94c6d9d, ; 411: lib-sv-Microsoft.Maui.Controls.resources.dll.so => 26
	i64 u0xb220631954820169, ; 412: System.Text.RegularExpressions => 177
	i64 u0xb2a3f67f3bf29fce, ; 413: da/Microsoft.Maui.Controls.resources => 3
	i64 u0xb39eed1decc0cd95, ; 414: Google.Api.Gax.dll => 42
	i64 u0xb3f0a0fcda8d3ebc, ; 415: Xamarin.AndroidX.CardView => 94
	i64 u0xb4512edf6d2b372b, ; 416: Google.Cloud.Location => 50
	i64 u0xb46be1aa6d4fff93, ; 417: hi/Microsoft.Maui.Controls.resources => 10
	i64 u0xb477491be13109d8, ; 418: ar/Microsoft.Maui.Controls.resources => 0
	i64 u0xb4bd7015ecee9d86, ; 419: System.IO.Pipelines => 140
	i64 u0xb5c7fcdafbc67ee4, ; 420: Microsoft.Extensions.Logging.Abstractions.dll => 66
	i64 u0xb7212c4683a94afe, ; 421: System.Drawing.Primitives => 135
	i64 u0xb7b7753d1f319409, ; 422: sv/Microsoft.Maui.Controls.resources => 26
	i64 u0xb814bab5805188b7, ; 423: restaurant => 120
	i64 u0xb81a2c6e0aee50fe, ; 424: lib_System.Private.CoreLib.dll.so => 188
	i64 u0xb898d1802c1a108c, ; 425: lib_System.Management.dll.so => 88
	i64 u0xb90ff82c284e9af9, ; 426: Grpc.Core.Api => 54
	i64 u0xb9185c33a1643eed, ; 427: Microsoft.CSharp.dll => 121
	i64 u0xb9f64d3b230def68, ; 428: lib-pt-Microsoft.Maui.Controls.resources.dll.so => 22
	i64 u0xb9fc3c8a556e3691, ; 429: ja/Microsoft.Maui.Controls.resources => 15
	i64 u0xba4670aa94a2b3c6, ; 430: lib_System.Xml.XDocument.dll.so => 185
	i64 u0xba48785529705af9, ; 431: System.Collections.dll => 126
	i64 u0xbb32554b4c20e01b, ; 432: lib_LiveCharts.dll.so => 58
	i64 u0xbb6026d73f757bcf, ; 433: Google.Api.Gax.Grpc => 43
	i64 u0xbb65706fde942ce3, ; 434: System.Net.Sockets => 152
	i64 u0xbbd180354b67271a, ; 435: System.Runtime.Serialization.Formatters => 166
	i64 u0xbd0e2c0d55246576, ; 436: System.Net.Http.dll => 145
	i64 u0xbd3fbd85b9e1cb29, ; 437: lib_System.Net.HttpListener.dll.so => 146
	i64 u0xbd437a2cdb333d0d, ; 438: Xamarin.AndroidX.ViewPager2 => 115
	i64 u0xbee38d4a88835966, ; 439: Xamarin.AndroidX.AppCompat.AppCompatResources => 93
	i64 u0xc040a4ab55817f58, ; 440: ar/Microsoft.Maui.Controls.resources.dll => 0
	i64 u0xc0d928351ab5ca77, ; 441: System.Console.dll => 130
	i64 u0xc0ecf0f97d38640d, ; 442: lib_restaurant.dll.so => 120
	i64 u0xc12b8b3afa48329c, ; 443: lib_System.Linq.dll.so => 143
	i64 u0xc1649f545b2f76aa, ; 444: Grpc.Auth => 53
	i64 u0xc1ff9ae3cdb6e1e6, ; 445: Xamarin.AndroidX.Activity.dll => 91
	i64 u0xc278de356ad8a9e3, ; 446: Microsoft.IdentityModel.Logging => 71
	i64 u0xc2850fbba221599d, ; 447: lib_Google.Apis.Core.dll.so => 47
	i64 u0xc28c50f32f81cc73, ; 448: ja/Microsoft.Maui.Controls.resources.dll => 15
	i64 u0xc2bcfec99f69365e, ; 449: Xamarin.AndroidX.ViewPager2.dll => 115
	i64 u0xc4d3858ed4d08512, ; 450: Xamarin.AndroidX.Lifecycle.ViewModelSavedState.dll => 105
	i64 u0xc50fded0ded1418c, ; 451: lib_System.ComponentModel.TypeConverter.dll.so => 128
	i64 u0xc519125d6bc8fb11, ; 452: lib_System.Net.Requests.dll.so => 150
	i64 u0xc5293b19e4dc230e, ; 453: Xamarin.AndroidX.Navigation.Fragment => 108
	i64 u0xc5325b2fcb37446f, ; 454: lib_System.Private.Xml.dll.so => 158
	i64 u0xc5a0f4b95a699af7, ; 455: lib_System.Private.Uri.dll.so => 156
	i64 u0xc5cdcd5b6277579e, ; 456: lib_System.Security.Cryptography.Algorithms.dll.so => 170
	i64 u0xc5d608afb58abba2, ; 457: Google.Apis.Auth.dll => 46
	i64 u0xc6c2d0367d74968d, ; 458: Microcharts.Maui => 59
	i64 u0xc7c01e7d7c93a110, ; 459: System.Text.Encoding.Extensions.dll => 174
	i64 u0xc7ce851898a4548e, ; 460: lib_System.Web.HttpUtility.dll.so => 182
	i64 u0xc858a28d9ee5a6c5, ; 461: lib_System.Collections.Specialized.dll.so => 125
	i64 u0xc9e54b32fc19baf3, ; 462: lib_CommunityToolkit.Maui.dll.so => 35
	i64 u0xca3a723e7342c5b6, ; 463: lib-tr-Microsoft.Maui.Controls.resources.dll.so => 28
	i64 u0xcab3493c70141c2d, ; 464: pl/Microsoft.Maui.Controls.resources => 20
	i64 u0xcacfddc9f7c6de76, ; 465: ro/Microsoft.Maui.Controls.resources.dll => 23
	i64 u0xcb00e67f1362d5a9, ; 466: lib_SendGrid.dll.so => 79
	i64 u0xcb76efab0f56f81a, ; 467: System.Reactive => 89
	i64 u0xcbd4fdd9cef4a294, ; 468: lib__Microsoft.Android.Resource.Designer.dll.so => 34
	i64 u0xcc182c3afdc374d6, ; 469: Microsoft.Bcl.AsyncInterfaces => 60
	i64 u0xcc2876b32ef2794c, ; 470: lib_System.Text.RegularExpressions.dll.so => 177
	i64 u0xcc5c3bb714c4561e, ; 471: Xamarin.KotlinX.Coroutines.Core.Jvm.dll => 118
	i64 u0xcc76886e09b88260, ; 472: Xamarin.KotlinX.Serialization.Core.Jvm.dll => 119
	i64 u0xccf25c4b634ccd3a, ; 473: zh-Hans/Microsoft.Maui.Controls.resources.dll => 32
	i64 u0xcd10a42808629144, ; 474: System.Net.Requests => 150
	i64 u0xcd79e8a518d2be04, ; 475: Twilio => 90
	i64 u0xcdd0c48b6937b21c, ; 476: Xamarin.AndroidX.SwipeRefreshLayout => 113
	i64 u0xcf23d8093f3ceadf, ; 477: System.Diagnostics.DiagnosticSource.dll => 132
	i64 u0xcf8fc898f98b0d34, ; 478: System.Private.Xml.Linq => 157
	i64 u0xd1194e1d8a8de83c, ; 479: lib_Xamarin.AndroidX.Lifecycle.Common.Jvm.dll.so => 102
	i64 u0xd333d0af9e423810, ; 480: System.Runtime.InteropServices => 163
	i64 u0xd3426d966bb704f5, ; 481: Xamarin.AndroidX.AppCompat.AppCompatResources.dll => 93
	i64 u0xd3651b6fc3125825, ; 482: System.Private.Uri.dll => 156
	i64 u0xd373685349b1fe8b, ; 483: Microsoft.Extensions.Logging.dll => 65
	i64 u0xd3e4c8d6a2d5d470, ; 484: it/Microsoft.Maui.Controls.resources => 14
	i64 u0xd4645626dffec99d, ; 485: lib_Microsoft.Extensions.DependencyInjection.Abstractions.dll.so => 64
	i64 u0xd5507e11a2b2839f, ; 486: Xamarin.AndroidX.Lifecycle.ViewModelSavedState => 105
	i64 u0xd64f50eb4ba264b3, ; 487: lib_Google.LongRunning.dll.so => 51
	i64 u0xd6694f8359737e4e, ; 488: Xamarin.AndroidX.SavedState => 112
	i64 u0xd6d21782156bc35b, ; 489: Xamarin.AndroidX.SwipeRefreshLayout.dll => 113
	i64 u0xd72329819cbbbc44, ; 490: lib_Microsoft.Extensions.Configuration.Abstractions.dll.so => 62
	i64 u0xd7b3764ada9d341d, ; 491: lib_Microsoft.Extensions.Logging.Abstractions.dll.so => 66
	i64 u0xd8113d9a7e8ad136, ; 492: System.CodeDom => 85
	i64 u0xda1dfa4c534a9251, ; 493: Microsoft.Extensions.DependencyInjection => 63
	i64 u0xdad05a11827959a3, ; 494: System.Collections.NonGeneric.dll => 124
	i64 u0xdb5383ab5865c007, ; 495: lib-vi-Microsoft.Maui.Controls.resources.dll.so => 30
	i64 u0xdb58816721c02a59, ; 496: lib_System.Reflection.Emit.ILGeneration.dll.so => 159
	i64 u0xdb8f858873e2186b, ; 497: SkiaSharp.Views.Maui.Controls => 82
	i64 u0xdbc296dc8fc262d3, ; 498: FirebaseAdmin => 38
	i64 u0xdbeda89f832aa805, ; 499: vi/Microsoft.Maui.Controls.resources.dll => 30
	i64 u0xdbf9607a441b4505, ; 500: System.Linq => 143
	i64 u0xdcbd21904ff0f297, ; 501: Google.Apis => 45
	i64 u0xdce2c53525640bf3, ; 502: Microsoft.Extensions.Logging => 65
	i64 u0xdd2b722d78ef5f43, ; 503: System.Runtime.dll => 168
	i64 u0xdd67031857c72f96, ; 504: lib_System.Text.Encodings.Web.dll.so => 175
	i64 u0xdde30e6b77aa6f6c, ; 505: lib-zh-Hans-Microsoft.Maui.Controls.resources.dll.so => 32
	i64 u0xde110ae80fa7c2e2, ; 506: System.Xml.XDocument.dll => 185
	i64 u0xde572c2b2fb32f93, ; 507: lib_System.Threading.Tasks.Extensions.dll.so => 179
	i64 u0xde8769ebda7d8647, ; 508: hr/Microsoft.Maui.Controls.resources.dll => 11
	i64 u0xe0142572c095a480, ; 509: Xamarin.AndroidX.AppCompat.dll => 92
	i64 u0xe02f89350ec78051, ; 510: Xamarin.AndroidX.CoordinatorLayout.dll => 96
	i64 u0xe10b760bb1462e7a, ; 511: lib_System.Security.Cryptography.Primitives.dll.so => 171
	i64 u0xe192a588d4410686, ; 512: lib_System.IO.Pipelines.dll.so => 140
	i64 u0xe1a08bd3fa539e0d, ; 513: System.Runtime.Loader => 164
	i64 u0xe1b52f9f816c70ef, ; 514: System.Private.Xml.Linq.dll => 157
	i64 u0xe1ecfdb7fff86067, ; 515: System.Net.Security.dll => 151
	i64 u0xe2420585aeceb728, ; 516: System.Net.Requests.dll => 150
	i64 u0xe29b73bc11392966, ; 517: lib-id-Microsoft.Maui.Controls.resources.dll.so => 13
	i64 u0xe3811d68d4fe8463, ; 518: pt-BR/Microsoft.Maui.Controls.resources.dll => 21
	i64 u0xe494f7ced4ecd10a, ; 519: hu/Microsoft.Maui.Controls.resources.dll => 12
	i64 u0xe49a982a2533a332, ; 520: lib_Google.Cloud.Location.dll.so => 50
	i64 u0xe4a9b1e40d1e8917, ; 521: lib-fi-Microsoft.Maui.Controls.resources.dll.so => 7
	i64 u0xe4f74a0b5bf9703f, ; 522: System.Runtime.Serialization.Primitives => 167
	i64 u0xe5434e8a119ceb69, ; 523: lib_Mono.Android.dll.so => 191
	i64 u0xe6e77c648688b75b, ; 524: Google.Api.CommonProtos.dll => 41
	i64 u0xe7b0691bcbb5a85d, ; 525: System.Linq.Async => 87
	i64 u0xe89a2a9ef110899b, ; 526: System.Drawing.dll => 136
	i64 u0xe98b0e4b4d44e931, ; 527: lib_Grpc.Net.Client.dll.so => 55
	i64 u0xeaf8e9970fc2fe69, ; 528: System.Management => 88
	i64 u0xedc4817167106c23, ; 529: System.Net.Sockets.dll => 152
	i64 u0xedc632067fb20ff3, ; 530: System.Memory.dll => 144
	i64 u0xedc8e4ca71a02a8b, ; 531: Xamarin.AndroidX.Navigation.Runtime.dll => 109
	i64 u0xeeb7ebb80150501b, ; 532: lib_Xamarin.AndroidX.Collection.Jvm.dll.so => 95
	i64 u0xef72742e1bcca27a, ; 533: Microsoft.Maui.Essentials.dll => 76
	i64 u0xefec0b7fdc57ec42, ; 534: Xamarin.AndroidX.Activity => 91
	i64 u0xf008bcd238ede2c8, ; 535: System.CodeDom.dll => 85
	i64 u0xf00c29406ea45e19, ; 536: es/Microsoft.Maui.Controls.resources.dll => 6
	i64 u0xf09e47b6ae914f6e, ; 537: System.Net.NameResolution => 147
	i64 u0xf0de2537ee19c6ca, ; 538: lib_System.Net.WebHeaderCollection.dll.so => 153
	i64 u0xf11b621fc87b983f, ; 539: Microsoft.Maui.Controls.Xaml.dll => 74
	i64 u0xf1c4b4005493d871, ; 540: System.Formats.Asn1.dll => 137
	i64 u0xf238bd79489d3a96, ; 541: lib-nl-Microsoft.Maui.Controls.resources.dll.so => 19
	i64 u0xf37221fda4ef8830, ; 542: lib_Xamarin.Google.Android.Material.dll.so => 116
	i64 u0xf3ddfe05336abf29, ; 543: System => 186
	i64 u0xf408654b2a135055, ; 544: System.Reflection.Emit.ILGeneration.dll => 159
	i64 u0xf4727d423e5d26f3, ; 545: SkiaSharp => 80
	i64 u0xf4c1dd70a5496a17, ; 546: System.IO.Compression => 139
	i64 u0xf5fc7602fe27b333, ; 547: System.Net.WebHeaderCollection => 153
	i64 u0xf6077741019d7428, ; 548: Xamarin.AndroidX.CoordinatorLayout => 96
	i64 u0xf61ade9836ad4692, ; 549: Microsoft.IdentityModel.Tokens.dll => 72
	i64 u0xf6c0e7d55a7a4e4f, ; 550: Microsoft.IdentityModel.JsonWebTokens => 70
	i64 u0xf77b20923f07c667, ; 551: de/Microsoft.Maui.Controls.resources.dll => 4
	i64 u0xf7e2cac4c45067b3, ; 552: lib_System.Numerics.Vectors.dll.so => 154
	i64 u0xf7e74930e0e3d214, ; 553: zh-HK/Microsoft.Maui.Controls.resources.dll => 31
	i64 u0xf7fa0bf77fe677cc, ; 554: Newtonsoft.Json.dll => 78
	i64 u0xf84773b5c81e3cef, ; 555: lib-uk-Microsoft.Maui.Controls.resources.dll.so => 29
	i64 u0xf84bc13af9296b71, ; 556: Firebase => 40
	i64 u0xf8b77539b362d3ba, ; 557: lib_System.Reflection.Primitives.dll.so => 161
	i64 u0xf8e045dc345b2ea3, ; 558: lib_Xamarin.AndroidX.RecyclerView.dll.so => 111
	i64 u0xf915dc29808193a1, ; 559: System.Web.HttpUtility.dll => 182
	i64 u0xf96c777a2a0686f4, ; 560: hi/Microsoft.Maui.Controls.resources.dll => 10
	i64 u0xf9eec5bb3a6aedc6, ; 561: Microsoft.Extensions.Options => 67
	i64 u0xfa3f278f288b0e84, ; 562: lib_System.Net.Security.dll.so => 151
	i64 u0xfa5ed7226d978949, ; 563: lib-ar-Microsoft.Maui.Controls.resources.dll.so => 0
	i64 u0xfa645d91e9fc4cba, ; 564: System.Threading.Thread => 180
	i64 u0xfa99d44ebf9bea5b, ; 565: SkiaSharp.Views.Maui.Core => 83
	i64 u0xfbad3e4ce4b98145, ; 566: System.Security.Cryptography.X509Certificates => 172
	i64 u0xfbf0a31c9fc34bc4, ; 567: lib_System.Net.Http.dll.so => 145
	i64 u0xfc6b7527cc280b3f, ; 568: lib_System.Runtime.Serialization.Formatters.dll.so => 166
	i64 u0xfc719aec26adf9d9, ; 569: Xamarin.AndroidX.Navigation.Fragment.dll => 108
	i64 u0xfd22f00870e40ae0, ; 570: lib_Xamarin.AndroidX.DrawerLayout.dll.so => 100
	i64 u0xfd49b3c1a76e2748, ; 571: System.Runtime.InteropServices.RuntimeInformation => 162
	i64 u0xfd536c702f64dc47, ; 572: System.Text.Encoding.Extensions => 174
	i64 u0xfd583f7657b6a1cb, ; 573: Xamarin.AndroidX.Fragment => 101
	i64 u0xfdbe4710aa9beeff, ; 574: CommunityToolkit.Maui => 35
	i64 u0xfeae9952cf03b8cb ; 575: tr/Microsoft.Maui.Controls.resources => 28
], align 8

@assembly_image_cache_indices = dso_local local_unnamed_addr constant [576 x i32] [
	i32 49, i32 113, i32 55, i32 109, i32 36, i32 190, i32 92, i32 84,
	i32 24, i32 2, i32 30, i32 69, i32 149, i32 111, i32 126, i32 75,
	i32 31, i32 183, i32 95, i32 24, i32 90, i32 124, i32 161, i32 100,
	i32 67, i32 124, i32 173, i32 40, i32 178, i32 25, i32 119, i32 114,
	i32 85, i32 21, i32 191, i32 76, i32 60, i32 54, i32 147, i32 81,
	i32 146, i32 60, i32 99, i32 138, i32 171, i32 160, i32 44, i32 111,
	i32 49, i32 8, i32 189, i32 9, i32 64, i32 141, i32 170, i32 187,
	i32 120, i32 12, i32 175, i32 119, i32 18, i32 169, i32 87, i32 122,
	i32 186, i32 27, i32 190, i32 46, i32 52, i32 110, i32 16, i32 67,
	i32 138, i32 38, i32 42, i32 133, i32 168, i32 59, i32 159, i32 27,
	i32 141, i32 180, i32 42, i32 130, i32 97, i32 167, i32 53, i32 46,
	i32 8, i32 117, i32 68, i32 86, i32 13, i32 11, i32 189, i32 149,
	i32 80, i32 29, i32 148, i32 134, i32 7, i32 177, i32 86, i32 137,
	i32 33, i32 20, i32 160, i32 157, i32 181, i32 26, i32 176, i32 5,
	i32 133, i32 184, i32 101, i32 69, i32 39, i32 34, i32 94, i32 135,
	i32 82, i32 8, i32 184, i32 123, i32 6, i32 50, i32 152, i32 75,
	i32 2, i32 73, i32 115, i32 61, i32 160, i32 161, i32 43, i32 123,
	i32 99, i32 147, i32 114, i32 89, i32 1, i32 89, i32 78, i32 171,
	i32 174, i32 72, i32 172, i32 51, i32 117, i32 183, i32 97, i32 52,
	i32 51, i32 57, i32 179, i32 107, i32 83, i32 43, i32 93, i32 48,
	i32 41, i32 88, i32 187, i32 191, i32 20, i32 121, i32 167, i32 117,
	i32 86, i32 45, i32 134, i32 24, i32 183, i32 56, i32 22, i32 155,
	i32 110, i32 176, i32 81, i32 106, i32 148, i32 44, i32 142, i32 158,
	i32 164, i32 14, i32 106, i32 190, i32 178, i32 1, i32 72, i32 73,
	i32 56, i32 38, i32 37, i32 104, i32 136, i32 149, i32 56, i32 131,
	i32 97, i32 77, i32 25, i32 148, i32 162, i32 31, i32 169, i32 168,
	i32 47, i32 102, i32 125, i32 83, i32 156, i32 188, i32 132, i32 15,
	i32 63, i32 121, i32 53, i32 84, i32 96, i32 181, i32 129, i32 82,
	i32 3, i32 65, i32 153, i32 163, i32 95, i32 125, i32 175, i32 127,
	i32 146, i32 184, i32 131, i32 5, i32 63, i32 118, i32 144, i32 74,
	i32 4, i32 164, i32 188, i32 123, i32 116, i32 170, i32 44, i32 35,
	i32 59, i32 73, i32 165, i32 130, i32 104, i32 98, i32 3, i32 135,
	i32 137, i32 9, i32 163, i32 57, i32 79, i32 18, i32 45, i32 57,
	i32 77, i32 68, i32 98, i32 68, i32 108, i32 75, i32 2, i32 28,
	i32 18, i32 14, i32 127, i32 11, i32 144, i32 61, i32 112, i32 165,
	i32 17, i32 58, i32 27, i32 101, i32 7, i32 70, i32 128, i32 25,
	i32 4, i32 36, i32 17, i32 154, i32 126, i32 169, i32 155, i32 129,
	i32 114, i32 62, i32 103, i32 186, i32 49, i32 33, i32 92, i32 94,
	i32 136, i32 29, i32 69, i32 32, i32 58, i32 141, i32 80, i32 33,
	i32 61, i32 180, i32 138, i32 55, i32 76, i32 118, i32 187, i32 127,
	i32 162, i32 48, i32 106, i32 132, i32 133, i32 9, i32 98, i32 181,
	i32 122, i32 54, i32 78, i32 107, i32 10, i32 23, i32 22, i32 21,
	i32 134, i32 34, i32 139, i32 179, i32 104, i32 74, i32 99, i32 176,
	i32 143, i32 1, i32 17, i32 139, i32 71, i32 71, i32 6, i32 47,
	i32 13, i32 77, i32 39, i32 129, i32 122, i32 142, i32 37, i32 109,
	i32 16, i32 172, i32 91, i32 62, i32 19, i32 107, i32 103, i32 39,
	i32 173, i32 84, i32 116, i32 40, i32 110, i32 140, i32 81, i32 16,
	i32 37, i32 131, i32 166, i32 154, i32 173, i32 87, i32 112, i32 100,
	i32 102, i32 12, i32 79, i32 70, i32 41, i32 36, i32 66, i32 158,
	i32 145, i32 64, i32 5, i32 48, i32 90, i32 142, i32 165, i32 103,
	i32 52, i32 185, i32 23, i32 178, i32 19, i32 182, i32 128, i32 151,
	i32 189, i32 155, i32 105, i32 26, i32 177, i32 3, i32 42, i32 94,
	i32 50, i32 10, i32 0, i32 140, i32 66, i32 135, i32 26, i32 120,
	i32 188, i32 88, i32 54, i32 121, i32 22, i32 15, i32 185, i32 126,
	i32 58, i32 43, i32 152, i32 166, i32 145, i32 146, i32 115, i32 93,
	i32 0, i32 130, i32 120, i32 143, i32 53, i32 91, i32 71, i32 47,
	i32 15, i32 115, i32 105, i32 128, i32 150, i32 108, i32 158, i32 156,
	i32 170, i32 46, i32 59, i32 174, i32 182, i32 125, i32 35, i32 28,
	i32 20, i32 23, i32 79, i32 89, i32 34, i32 60, i32 177, i32 118,
	i32 119, i32 32, i32 150, i32 90, i32 113, i32 132, i32 157, i32 102,
	i32 163, i32 93, i32 156, i32 65, i32 14, i32 64, i32 105, i32 51,
	i32 112, i32 113, i32 62, i32 66, i32 85, i32 63, i32 124, i32 30,
	i32 159, i32 82, i32 38, i32 30, i32 143, i32 45, i32 65, i32 168,
	i32 175, i32 32, i32 185, i32 179, i32 11, i32 92, i32 96, i32 171,
	i32 140, i32 164, i32 157, i32 151, i32 150, i32 13, i32 21, i32 12,
	i32 50, i32 7, i32 167, i32 191, i32 41, i32 87, i32 136, i32 55,
	i32 88, i32 152, i32 144, i32 109, i32 95, i32 76, i32 91, i32 85,
	i32 6, i32 147, i32 153, i32 74, i32 137, i32 19, i32 116, i32 186,
	i32 159, i32 80, i32 139, i32 153, i32 96, i32 72, i32 70, i32 4,
	i32 154, i32 31, i32 78, i32 29, i32 40, i32 161, i32 111, i32 182,
	i32 10, i32 67, i32 151, i32 0, i32 180, i32 83, i32 172, i32 145,
	i32 166, i32 108, i32 100, i32 162, i32 174, i32 101, i32 35, i32 28
], align 4

@marshal_methods_number_of_classes = dso_local local_unnamed_addr constant i32 0, align 4

@marshal_methods_class_cache = dso_local local_unnamed_addr global [0 x %struct.MarshalMethodsManagedClass] zeroinitializer, align 8

; Names of classes in which marshal methods reside
@mm_class_names = dso_local local_unnamed_addr constant [0 x ptr] zeroinitializer, align 8

@mm_method_names = dso_local local_unnamed_addr constant [1 x %struct.MarshalMethodName] [
	%struct.MarshalMethodName {
		i64 u0x0000000000000000, ; name: 
		ptr @.MarshalMethodName.0_name; char* name
	} ; 0
], align 8

; get_function_pointer (uint32_t mono_image_index, uint32_t class_index, uint32_t method_token, void*& target_ptr)
@get_function_pointer = internal dso_local unnamed_addr global ptr null, align 8

; Functions

; Function attributes: memory(write, argmem: none, inaccessiblemem: none) "min-legal-vector-width"="0" mustprogress "no-trapping-math"="true" nofree norecurse nosync nounwind "stack-protector-buffer-size"="8" uwtable willreturn
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
@.str.0 = private unnamed_addr constant [40 x i8] c"get_function_pointer MUST be specified\0A\00", align 1

;MarshalMethodName
@.MarshalMethodName.0_name = private unnamed_addr constant [1 x i8] c"\00", align 1

; External functions

; Function attributes: "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8"
declare void @abort() local_unnamed_addr #2

; Function attributes: nofree nounwind
declare noundef i32 @puts(ptr noundef) local_unnamed_addr #1
attributes #0 = { memory(write, argmem: none, inaccessiblemem: none) "min-legal-vector-width"="0" mustprogress "no-trapping-math"="true" nofree norecurse nosync nounwind "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fix-cortex-a53-835769,+neon,+outline-atomics,+v8a" uwtable willreturn }
attributes #1 = { nofree nounwind }
attributes #2 = { "no-trapping-math"="true" noreturn nounwind "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fix-cortex-a53-835769,+neon,+outline-atomics,+v8a" }

; Metadata
!llvm.module.flags = !{!0, !1, !7, !8, !9, !10}
!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!llvm.ident = !{!2}
!2 = !{!".NET for Android remotes/origin/release/9.0.1xx @ 1719a35b8a0348a4a8dd0061cfc4dd7fe6612a3c"}
!3 = !{!4, !4, i64 0}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{i32 1, !"branch-target-enforcement", i32 0}
!8 = !{i32 1, !"sign-return-address", i32 0}
!9 = !{i32 1, !"sign-return-address-all", i32 0}
!10 = !{i32 1, !"sign-return-address-with-bkey", i32 0}
