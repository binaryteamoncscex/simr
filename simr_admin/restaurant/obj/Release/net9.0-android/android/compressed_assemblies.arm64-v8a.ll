; ModuleID = 'compressed_assemblies.arm64-v8a.ll'
source_filename = "compressed_assemblies.arm64-v8a.ll"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-android21"

%struct.CompressedAssemblies = type {
	i32, ; uint32_t count
	ptr ; CompressedAssemblyDescriptor descriptors
}

%struct.CompressedAssemblyDescriptor = type {
	i32, ; uint32_t uncompressed_file_size
	i1, ; bool loaded
	ptr ; uint8_t data
}

@compressed_assemblies = dso_local local_unnamed_addr global %struct.CompressedAssemblies {
	i32 192, ; uint32_t count
	ptr @compressed_assembly_descriptors; CompressedAssemblyDescriptor* descriptors
}, align 8

@compressed_assembly_descriptors = internal dso_local global [192 x %struct.CompressedAssemblyDescriptor] [
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_0; uint8_t* data
	}, ; 0: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_1; uint8_t* data
	}, ; 1: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15384, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_2; uint8_t* data
	}, ; 2: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_3; uint8_t* data
	}, ; 3: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_4; uint8_t* data
	}, ; 4: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_5; uint8_t* data
	}, ; 5: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_6; uint8_t* data
	}, ; 6: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_7; uint8_t* data
	}, ; 7: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_8; uint8_t* data
	}, ; 8: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_9; uint8_t* data
	}, ; 9: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_10; uint8_t* data
	}, ; 10: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_11; uint8_t* data
	}, ; 11: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_12; uint8_t* data
	}, ; 12: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_13; uint8_t* data
	}, ; 13: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_14; uint8_t* data
	}, ; 14: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_15; uint8_t* data
	}, ; 15: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_16; uint8_t* data
	}, ; 16: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15384, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_17; uint8_t* data
	}, ; 17: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15384, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_18; uint8_t* data
	}, ; 18: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_19; uint8_t* data
	}, ; 19: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_20; uint8_t* data
	}, ; 20: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_21; uint8_t* data
	}, ; 21: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_22; uint8_t* data
	}, ; 22: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_23; uint8_t* data
	}, ; 23: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_24; uint8_t* data
	}, ; 24: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_25; uint8_t* data
	}, ; 25: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_26; uint8_t* data
	}, ; 26: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_27; uint8_t* data
	}, ; 27: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_28; uint8_t* data
	}, ; 28: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_29; uint8_t* data
	}, ; 29: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_30; uint8_t* data
	}, ; 30: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_31; uint8_t* data
	}, ; 31: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15384, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_32; uint8_t* data
	}, ; 32: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 15392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_33; uint8_t* data
	}, ; 33: Microsoft.Maui.Controls.resources
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_34; uint8_t* data
	}, ; 34: _Microsoft.Android.Resource.Designer
	%struct.CompressedAssemblyDescriptor {
		i32 34304, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_35; uint8_t* data
	}, ; 35: CommunityToolkit.Maui
	%struct.CompressedAssemblyDescriptor {
		i32 47616, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_36; uint8_t* data
	}, ; 36: CommunityToolkit.Maui.Core
	%struct.CompressedAssemblyDescriptor {
		i32 19456, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_37; uint8_t* data
	}, ; 37: CommunityToolkit.Mvvm
	%struct.CompressedAssemblyDescriptor {
		i32 295936, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_38; uint8_t* data
	}, ; 38: FirebaseAdmin
	%struct.CompressedAssemblyDescriptor {
		i32 80896, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_39; uint8_t* data
	}, ; 39: Firebase.Auth
	%struct.CompressedAssemblyDescriptor {
		i32 91648, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_40; uint8_t* data
	}, ; 40: Firebase
	%struct.CompressedAssemblyDescriptor {
		i32 437760, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_41; uint8_t* data
	}, ; 41: Google.Api.CommonProtos
	%struct.CompressedAssemblyDescriptor {
		i32 79360, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_42; uint8_t* data
	}, ; 42: Google.Api.Gax
	%struct.CompressedAssemblyDescriptor {
		i32 203264, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_43; uint8_t* data
	}, ; 43: Google.Api.Gax.Grpc
	%struct.CompressedAssemblyDescriptor {
		i32 26624, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_44; uint8_t* data
	}, ; 44: Google.Api.Gax.Rest
	%struct.CompressedAssemblyDescriptor {
		i32 83456, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_45; uint8_t* data
	}, ; 45: Google.Apis
	%struct.CompressedAssemblyDescriptor {
		i32 233472, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_46; uint8_t* data
	}, ; 46: Google.Apis.Auth
	%struct.CompressedAssemblyDescriptor {
		i32 85504, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_47; uint8_t* data
	}, ; 47: Google.Apis.Core
	%struct.CompressedAssemblyDescriptor {
		i32 180224, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_48; uint8_t* data
	}, ; 48: Google.Cloud.Firestore
	%struct.CompressedAssemblyDescriptor {
		i32 308224, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_49; uint8_t* data
	}, ; 49: Google.Cloud.Firestore.V1
	%struct.CompressedAssemblyDescriptor {
		i32 35328, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_50; uint8_t* data
	}, ; 50: Google.Cloud.Location
	%struct.CompressedAssemblyDescriptor {
		i32 62976, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_51; uint8_t* data
	}, ; 51: Google.LongRunning
	%struct.CompressedAssemblyDescriptor {
		i32 388608, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_52; uint8_t* data
	}, ; 52: Google.Protobuf
	%struct.CompressedAssemblyDescriptor {
		i32 21608, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_53; uint8_t* data
	}, ; 53: Grpc.Auth
	%struct.CompressedAssemblyDescriptor {
		i32 70248, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_54; uint8_t* data
	}, ; 54: Grpc.Core.Api
	%struct.CompressedAssemblyDescriptor {
		i32 260608, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_55; uint8_t* data
	}, ; 55: Grpc.Net.Client
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_56; uint8_t* data
	}, ; 56: Grpc.Net.Common
	%struct.CompressedAssemblyDescriptor {
		i32 488960, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_57; uint8_t* data
	}, ; 57: LiteDB
	%struct.CompressedAssemblyDescriptor {
		i32 146432, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_58; uint8_t* data
	}, ; 58: LiveCharts
	%struct.CompressedAssemblyDescriptor {
		i32 89600, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_59; uint8_t* data
	}, ; 59: Microcharts.Maui
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_60; uint8_t* data
	}, ; 60: Microsoft.Bcl.AsyncInterfaces
	%struct.CompressedAssemblyDescriptor {
		i32 14848, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_61; uint8_t* data
	}, ; 61: Microsoft.Extensions.Configuration
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_62; uint8_t* data
	}, ; 62: Microsoft.Extensions.Configuration.Abstractions
	%struct.CompressedAssemblyDescriptor {
		i32 46080, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_63; uint8_t* data
	}, ; 63: Microsoft.Extensions.DependencyInjection
	%struct.CompressedAssemblyDescriptor {
		i32 26112, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_64; uint8_t* data
	}, ; 64: Microsoft.Extensions.DependencyInjection.Abstractions
	%struct.CompressedAssemblyDescriptor {
		i32 19456, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_65; uint8_t* data
	}, ; 65: Microsoft.Extensions.Logging
	%struct.CompressedAssemblyDescriptor {
		i32 32256, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_66; uint8_t* data
	}, ; 66: Microsoft.Extensions.Logging.Abstractions
	%struct.CompressedAssemblyDescriptor {
		i32 17408, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_67; uint8_t* data
	}, ; 67: Microsoft.Extensions.Options
	%struct.CompressedAssemblyDescriptor {
		i32 9216, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_68; uint8_t* data
	}, ; 68: Microsoft.Extensions.Primitives
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_69; uint8_t* data
	}, ; 69: Microsoft.IdentityModel.Abstractions
	%struct.CompressedAssemblyDescriptor {
		i32 32768, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_70; uint8_t* data
	}, ; 70: Microsoft.IdentityModel.JsonWebTokens
	%struct.CompressedAssemblyDescriptor {
		i32 14848, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_71; uint8_t* data
	}, ; 71: Microsoft.IdentityModel.Logging
	%struct.CompressedAssemblyDescriptor {
		i32 116224, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_72; uint8_t* data
	}, ; 72: Microsoft.IdentityModel.Tokens
	%struct.CompressedAssemblyDescriptor {
		i32 1868320, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_73; uint8_t* data
	}, ; 73: Microsoft.Maui.Controls
	%struct.CompressedAssemblyDescriptor {
		i32 128032, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_74; uint8_t* data
	}, ; 74: Microsoft.Maui.Controls.Xaml
	%struct.CompressedAssemblyDescriptor {
		i32 792096, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_75; uint8_t* data
	}, ; 75: Microsoft.Maui
	%struct.CompressedAssemblyDescriptor {
		i32 53248, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_76; uint8_t* data
	}, ; 76: Microsoft.Maui.Essentials
	%struct.CompressedAssemblyDescriptor {
		i32 207392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_77; uint8_t* data
	}, ; 77: Microsoft.Maui.Graphics
	%struct.CompressedAssemblyDescriptor {
		i32 712464, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_78; uint8_t* data
	}, ; 78: Newtonsoft.Json
	%struct.CompressedAssemblyDescriptor {
		i32 79872, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_79; uint8_t* data
	}, ; 79: SendGrid
	%struct.CompressedAssemblyDescriptor {
		i32 76800, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_80; uint8_t* data
	}, ; 80: SkiaSharp
	%struct.CompressedAssemblyDescriptor {
		i32 50224, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_81; uint8_t* data
	}, ; 81: SkiaSharp.Views.Android
	%struct.CompressedAssemblyDescriptor {
		i32 26152, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_82; uint8_t* data
	}, ; 82: SkiaSharp.Views.Maui.Controls
	%struct.CompressedAssemblyDescriptor {
		i32 33864, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_83; uint8_t* data
	}, ; 83: SkiaSharp.Views.Maui.Core
	%struct.CompressedAssemblyDescriptor {
		i32 26112, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_84; uint8_t* data
	}, ; 84: StarkbankEcdsa
	%struct.CompressedAssemblyDescriptor {
		i32 186496, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_85; uint8_t* data
	}, ; 85: System.CodeDom
	%struct.CompressedAssemblyDescriptor {
		i32 30208, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_86; uint8_t* data
	}, ; 86: System.IdentityModel.Tokens.Jwt
	%struct.CompressedAssemblyDescriptor {
		i32 1112720, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_87; uint8_t* data
	}, ; 87: System.Linq.Async
	%struct.CompressedAssemblyDescriptor {
		i32 8192, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_88; uint8_t* data
	}, ; 88: System.Management
	%struct.CompressedAssemblyDescriptor {
		i32 98304, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_89; uint8_t* data
	}, ; 89: System.Reactive
	%struct.CompressedAssemblyDescriptor {
		i32 5748736, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_90; uint8_t* data
	}, ; 90: Twilio
	%struct.CompressedAssemblyDescriptor {
		i32 59392, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_91; uint8_t* data
	}, ; 91: Xamarin.AndroidX.Activity
	%struct.CompressedAssemblyDescriptor {
		i32 515584, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_92; uint8_t* data
	}, ; 92: Xamarin.AndroidX.AppCompat
	%struct.CompressedAssemblyDescriptor {
		i32 15872, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_93; uint8_t* data
	}, ; 93: Xamarin.AndroidX.AppCompat.AppCompatResources
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_94; uint8_t* data
	}, ; 94: Xamarin.AndroidX.CardView
	%struct.CompressedAssemblyDescriptor {
		i32 19456, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_95; uint8_t* data
	}, ; 95: Xamarin.AndroidX.Collection.Jvm
	%struct.CompressedAssemblyDescriptor {
		i32 71680, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_96; uint8_t* data
	}, ; 96: Xamarin.AndroidX.CoordinatorLayout
	%struct.CompressedAssemblyDescriptor {
		i32 542208, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_97; uint8_t* data
	}, ; 97: Xamarin.AndroidX.Core
	%struct.CompressedAssemblyDescriptor {
		i32 24576, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_98; uint8_t* data
	}, ; 98: Xamarin.AndroidX.CursorAdapter
	%struct.CompressedAssemblyDescriptor {
		i32 9728, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_99; uint8_t* data
	}, ; 99: Xamarin.AndroidX.CustomView
	%struct.CompressedAssemblyDescriptor {
		i32 42496, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_100; uint8_t* data
	}, ; 100: Xamarin.AndroidX.DrawerLayout
	%struct.CompressedAssemblyDescriptor {
		i32 209920, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_101; uint8_t* data
	}, ; 101: Xamarin.AndroidX.Fragment
	%struct.CompressedAssemblyDescriptor {
		i32 21504, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_102; uint8_t* data
	}, ; 102: Xamarin.AndroidX.Lifecycle.Common.Jvm
	%struct.CompressedAssemblyDescriptor {
		i32 17408, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_103; uint8_t* data
	}, ; 103: Xamarin.AndroidX.Lifecycle.LiveData.Core
	%struct.CompressedAssemblyDescriptor {
		i32 32256, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_104; uint8_t* data
	}, ; 104: Xamarin.AndroidX.Lifecycle.ViewModel.Android
	%struct.CompressedAssemblyDescriptor {
		i32 12800, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_105; uint8_t* data
	}, ; 105: Xamarin.AndroidX.Lifecycle.ViewModelSavedState
	%struct.CompressedAssemblyDescriptor {
		i32 36352, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_106; uint8_t* data
	}, ; 106: Xamarin.AndroidX.Loader
	%struct.CompressedAssemblyDescriptor {
		i32 89600, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_107; uint8_t* data
	}, ; 107: Xamarin.AndroidX.Navigation.Common
	%struct.CompressedAssemblyDescriptor {
		i32 18432, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_108; uint8_t* data
	}, ; 108: Xamarin.AndroidX.Navigation.Fragment
	%struct.CompressedAssemblyDescriptor {
		i32 58368, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_109; uint8_t* data
	}, ; 109: Xamarin.AndroidX.Navigation.Runtime
	%struct.CompressedAssemblyDescriptor {
		i32 28160, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_110; uint8_t* data
	}, ; 110: Xamarin.AndroidX.Navigation.UI
	%struct.CompressedAssemblyDescriptor {
		i32 405504, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_111; uint8_t* data
	}, ; 111: Xamarin.AndroidX.RecyclerView
	%struct.CompressedAssemblyDescriptor {
		i32 11264, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_112; uint8_t* data
	}, ; 112: Xamarin.AndroidX.SavedState
	%struct.CompressedAssemblyDescriptor {
		i32 37888, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_113; uint8_t* data
	}, ; 113: Xamarin.AndroidX.SwipeRefreshLayout
	%struct.CompressedAssemblyDescriptor {
		i32 57344, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_114; uint8_t* data
	}, ; 114: Xamarin.AndroidX.ViewPager
	%struct.CompressedAssemblyDescriptor {
		i32 38400, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_115; uint8_t* data
	}, ; 115: Xamarin.AndroidX.ViewPager2
	%struct.CompressedAssemblyDescriptor {
		i32 583168, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_116; uint8_t* data
	}, ; 116: Xamarin.Google.Android.Material
	%struct.CompressedAssemblyDescriptor {
		i32 86016, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_117; uint8_t* data
	}, ; 117: Xamarin.Kotlin.StdLib
	%struct.CompressedAssemblyDescriptor {
		i32 18432, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_118; uint8_t* data
	}, ; 118: Xamarin.KotlinX.Coroutines.Core.Jvm
	%struct.CompressedAssemblyDescriptor {
		i32 89600, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_119; uint8_t* data
	}, ; 119: Xamarin.KotlinX.Serialization.Core.Jvm
	%struct.CompressedAssemblyDescriptor {
		i32 756224, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_120; uint8_t* data
	}, ; 120: restaurant
	%struct.CompressedAssemblyDescriptor {
		i32 254464, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_121; uint8_t* data
	}, ; 121: Microsoft.CSharp
	%struct.CompressedAssemblyDescriptor {
		i32 35328, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_122; uint8_t* data
	}, ; 122: System.Collections.Concurrent
	%struct.CompressedAssemblyDescriptor {
		i32 71168, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_123; uint8_t* data
	}, ; 123: System.Collections.Immutable
	%struct.CompressedAssemblyDescriptor {
		i32 19456, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_124; uint8_t* data
	}, ; 124: System.Collections.NonGeneric
	%struct.CompressedAssemblyDescriptor {
		i32 22528, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_125; uint8_t* data
	}, ; 125: System.Collections.Specialized
	%struct.CompressedAssemblyDescriptor {
		i32 70144, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_126; uint8_t* data
	}, ; 126: System.Collections
	%struct.CompressedAssemblyDescriptor {
		i32 18432, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_127; uint8_t* data
	}, ; 127: System.ComponentModel.Primitives
	%struct.CompressedAssemblyDescriptor {
		i32 160256, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_128; uint8_t* data
	}, ; 128: System.ComponentModel.TypeConverter
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_129; uint8_t* data
	}, ; 129: System.ComponentModel
	%struct.CompressedAssemblyDescriptor {
		i32 12288, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_130; uint8_t* data
	}, ; 130: System.Console
	%struct.CompressedAssemblyDescriptor {
		i32 529408, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_131; uint8_t* data
	}, ; 131: System.Data.Common
	%struct.CompressedAssemblyDescriptor {
		i32 47104, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_132; uint8_t* data
	}, ; 132: System.Diagnostics.DiagnosticSource
	%struct.CompressedAssemblyDescriptor {
		i32 60416, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_133; uint8_t* data
	}, ; 133: System.Diagnostics.Process
	%struct.CompressedAssemblyDescriptor {
		i32 20480, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_134; uint8_t* data
	}, ; 134: System.Diagnostics.TraceSource
	%struct.CompressedAssemblyDescriptor {
		i32 40960, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_135; uint8_t* data
	}, ; 135: System.Drawing.Primitives
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_136; uint8_t* data
	}, ; 136: System.Drawing
	%struct.CompressedAssemblyDescriptor {
		i32 61952, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_137; uint8_t* data
	}, ; 137: System.Formats.Asn1
	%struct.CompressedAssemblyDescriptor {
		i32 22016, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_138; uint8_t* data
	}, ; 138: System.IO.Compression.Brotli
	%struct.CompressedAssemblyDescriptor {
		i32 33792, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_139; uint8_t* data
	}, ; 139: System.IO.Compression
	%struct.CompressedAssemblyDescriptor {
		i32 27136, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_140; uint8_t* data
	}, ; 140: System.IO.Pipelines
	%struct.CompressedAssemblyDescriptor {
		i32 22528, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_141; uint8_t* data
	}, ; 141: System.IO.Pipes
	%struct.CompressedAssemblyDescriptor {
		i32 434176, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_142; uint8_t* data
	}, ; 142: System.Linq.Expressions
	%struct.CompressedAssemblyDescriptor {
		i32 64000, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_143; uint8_t* data
	}, ; 143: System.Linq
	%struct.CompressedAssemblyDescriptor {
		i32 18432, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_144; uint8_t* data
	}, ; 144: System.Memory
	%struct.CompressedAssemblyDescriptor {
		i32 396288, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_145; uint8_t* data
	}, ; 145: System.Net.Http
	%struct.CompressedAssemblyDescriptor {
		i32 66560, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_146; uint8_t* data
	}, ; 146: System.Net.HttpListener
	%struct.CompressedAssemblyDescriptor {
		i32 27648, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_147; uint8_t* data
	}, ; 147: System.Net.NameResolution
	%struct.CompressedAssemblyDescriptor {
		i32 25600, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_148; uint8_t* data
	}, ; 148: System.Net.NetworkInformation
	%struct.CompressedAssemblyDescriptor {
		i32 68608, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_149; uint8_t* data
	}, ; 149: System.Net.Primitives
	%struct.CompressedAssemblyDescriptor {
		i32 9216, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_150; uint8_t* data
	}, ; 150: System.Net.Requests
	%struct.CompressedAssemblyDescriptor {
		i32 148992, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_151; uint8_t* data
	}, ; 151: System.Net.Security
	%struct.CompressedAssemblyDescriptor {
		i32 114176, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_152; uint8_t* data
	}, ; 152: System.Net.Sockets
	%struct.CompressedAssemblyDescriptor {
		i32 16896, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_153; uint8_t* data
	}, ; 153: System.Net.WebHeaderCollection
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_154; uint8_t* data
	}, ; 154: System.Numerics.Vectors
	%struct.CompressedAssemblyDescriptor {
		i32 20992, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_155; uint8_t* data
	}, ; 155: System.ObjectModel
	%struct.CompressedAssemblyDescriptor {
		i32 74752, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_156; uint8_t* data
	}, ; 156: System.Private.Uri
	%struct.CompressedAssemblyDescriptor {
		i32 46080, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_157; uint8_t* data
	}, ; 157: System.Private.Xml.Linq
	%struct.CompressedAssemblyDescriptor {
		i32 1346560, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_158; uint8_t* data
	}, ; 158: System.Private.Xml
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_159; uint8_t* data
	}, ; 159: System.Reflection.Emit.ILGeneration
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_160; uint8_t* data
	}, ; 160: System.Reflection.Emit.Lightweight
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_161; uint8_t* data
	}, ; 161: System.Reflection.Primitives
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_162; uint8_t* data
	}, ; 162: System.Runtime.InteropServices.RuntimeInformation
	%struct.CompressedAssemblyDescriptor {
		i32 9728, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_163; uint8_t* data
	}, ; 163: System.Runtime.InteropServices
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_164; uint8_t* data
	}, ; 164: System.Runtime.Loader
	%struct.CompressedAssemblyDescriptor {
		i32 107008, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_165; uint8_t* data
	}, ; 165: System.Runtime.Numerics
	%struct.CompressedAssemblyDescriptor {
		i32 8192, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_166; uint8_t* data
	}, ; 166: System.Runtime.Serialization.Formatters
	%struct.CompressedAssemblyDescriptor {
		i32 6144, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_167; uint8_t* data
	}, ; 167: System.Runtime.Serialization.Primitives
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_168; uint8_t* data
	}, ; 168: System.Runtime
	%struct.CompressedAssemblyDescriptor {
		i32 12288, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_169; uint8_t* data
	}, ; 169: System.Security.Claims
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_170; uint8_t* data
	}, ; 170: System.Security.Cryptography.Algorithms
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_171; uint8_t* data
	}, ; 171: System.Security.Cryptography.Primitives
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_172; uint8_t* data
	}, ; 172: System.Security.Cryptography.X509Certificates
	%struct.CompressedAssemblyDescriptor {
		i32 277504, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_173; uint8_t* data
	}, ; 173: System.Security.Cryptography
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_174; uint8_t* data
	}, ; 174: System.Text.Encoding.Extensions
	%struct.CompressedAssemblyDescriptor {
		i32 33280, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_175; uint8_t* data
	}, ; 175: System.Text.Encodings.Web
	%struct.CompressedAssemblyDescriptor {
		i32 372736, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_176; uint8_t* data
	}, ; 176: System.Text.Json
	%struct.CompressedAssemblyDescriptor {
		i32 322048, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_177; uint8_t* data
	}, ; 177: System.Text.RegularExpressions
	%struct.CompressedAssemblyDescriptor {
		i32 20992, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_178; uint8_t* data
	}, ; 178: System.Threading.Channels
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_179; uint8_t* data
	}, ; 179: System.Threading.Tasks.Extensions
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_180; uint8_t* data
	}, ; 180: System.Threading.Thread
	%struct.CompressedAssemblyDescriptor {
		i32 12288, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_181; uint8_t* data
	}, ; 181: System.Threading
	%struct.CompressedAssemblyDescriptor {
		i32 11264, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_182; uint8_t* data
	}, ; 182: System.Web.HttpUtility
	%struct.CompressedAssemblyDescriptor {
		i32 4608, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_183; uint8_t* data
	}, ; 183: System.Xml.Linq
	%struct.CompressedAssemblyDescriptor {
		i32 5632, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_184; uint8_t* data
	}, ; 184: System.Xml.ReaderWriter
	%struct.CompressedAssemblyDescriptor {
		i32 5120, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_185; uint8_t* data
	}, ; 185: System.Xml.XDocument
	%struct.CompressedAssemblyDescriptor {
		i32 4608, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_186; uint8_t* data
	}, ; 186: System
	%struct.CompressedAssemblyDescriptor {
		i32 16384, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_187; uint8_t* data
	}, ; 187: netstandard
	%struct.CompressedAssemblyDescriptor {
		i32 2459136, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_188; uint8_t* data
	}, ; 188: System.Private.CoreLib
	%struct.CompressedAssemblyDescriptor {
		i32 166912, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_189; uint8_t* data
	}, ; 189: Java.Interop
	%struct.CompressedAssemblyDescriptor {
		i32 19000, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_190; uint8_t* data
	}, ; 190: Mono.Android.Runtime
	%struct.CompressedAssemblyDescriptor {
		i32 2020864, ; uint32_t uncompressed_file_size
		i1 false, ; bool loaded
		ptr @__compressedAssemblyData_191; uint8_t* data
	} ; 191: Mono.Android
], align 8

@__compressedAssemblyData_0 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_1 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_2 = internal dso_local global [15384 x i8] zeroinitializer, align 1
@__compressedAssemblyData_3 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_4 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_5 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_6 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_7 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_8 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_9 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_10 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_11 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_12 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_13 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_14 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_15 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_16 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_17 = internal dso_local global [15384 x i8] zeroinitializer, align 1
@__compressedAssemblyData_18 = internal dso_local global [15384 x i8] zeroinitializer, align 1
@__compressedAssemblyData_19 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_20 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_21 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_22 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_23 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_24 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_25 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_26 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_27 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_28 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_29 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_30 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_31 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_32 = internal dso_local global [15384 x i8] zeroinitializer, align 1
@__compressedAssemblyData_33 = internal dso_local global [15392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_34 = internal dso_local global [6144 x i8] zeroinitializer, align 1
@__compressedAssemblyData_35 = internal dso_local global [34304 x i8] zeroinitializer, align 1
@__compressedAssemblyData_36 = internal dso_local global [47616 x i8] zeroinitializer, align 1
@__compressedAssemblyData_37 = internal dso_local global [19456 x i8] zeroinitializer, align 1
@__compressedAssemblyData_38 = internal dso_local global [295936 x i8] zeroinitializer, align 1
@__compressedAssemblyData_39 = internal dso_local global [80896 x i8] zeroinitializer, align 1
@__compressedAssemblyData_40 = internal dso_local global [91648 x i8] zeroinitializer, align 1
@__compressedAssemblyData_41 = internal dso_local global [437760 x i8] zeroinitializer, align 1
@__compressedAssemblyData_42 = internal dso_local global [79360 x i8] zeroinitializer, align 1
@__compressedAssemblyData_43 = internal dso_local global [203264 x i8] zeroinitializer, align 1
@__compressedAssemblyData_44 = internal dso_local global [26624 x i8] zeroinitializer, align 1
@__compressedAssemblyData_45 = internal dso_local global [83456 x i8] zeroinitializer, align 1
@__compressedAssemblyData_46 = internal dso_local global [233472 x i8] zeroinitializer, align 1
@__compressedAssemblyData_47 = internal dso_local global [85504 x i8] zeroinitializer, align 1
@__compressedAssemblyData_48 = internal dso_local global [180224 x i8] zeroinitializer, align 1
@__compressedAssemblyData_49 = internal dso_local global [308224 x i8] zeroinitializer, align 1
@__compressedAssemblyData_50 = internal dso_local global [35328 x i8] zeroinitializer, align 1
@__compressedAssemblyData_51 = internal dso_local global [62976 x i8] zeroinitializer, align 1
@__compressedAssemblyData_52 = internal dso_local global [388608 x i8] zeroinitializer, align 1
@__compressedAssemblyData_53 = internal dso_local global [21608 x i8] zeroinitializer, align 1
@__compressedAssemblyData_54 = internal dso_local global [70248 x i8] zeroinitializer, align 1
@__compressedAssemblyData_55 = internal dso_local global [260608 x i8] zeroinitializer, align 1
@__compressedAssemblyData_56 = internal dso_local global [6144 x i8] zeroinitializer, align 1
@__compressedAssemblyData_57 = internal dso_local global [488960 x i8] zeroinitializer, align 1
@__compressedAssemblyData_58 = internal dso_local global [146432 x i8] zeroinitializer, align 1
@__compressedAssemblyData_59 = internal dso_local global [89600 x i8] zeroinitializer, align 1
@__compressedAssemblyData_60 = internal dso_local global [6144 x i8] zeroinitializer, align 1
@__compressedAssemblyData_61 = internal dso_local global [14848 x i8] zeroinitializer, align 1
@__compressedAssemblyData_62 = internal dso_local global [6144 x i8] zeroinitializer, align 1
@__compressedAssemblyData_63 = internal dso_local global [46080 x i8] zeroinitializer, align 1
@__compressedAssemblyData_64 = internal dso_local global [26112 x i8] zeroinitializer, align 1
@__compressedAssemblyData_65 = internal dso_local global [19456 x i8] zeroinitializer, align 1
@__compressedAssemblyData_66 = internal dso_local global [32256 x i8] zeroinitializer, align 1
@__compressedAssemblyData_67 = internal dso_local global [17408 x i8] zeroinitializer, align 1
@__compressedAssemblyData_68 = internal dso_local global [9216 x i8] zeroinitializer, align 1
@__compressedAssemblyData_69 = internal dso_local global [6144 x i8] zeroinitializer, align 1
@__compressedAssemblyData_70 = internal dso_local global [32768 x i8] zeroinitializer, align 1
@__compressedAssemblyData_71 = internal dso_local global [14848 x i8] zeroinitializer, align 1
@__compressedAssemblyData_72 = internal dso_local global [116224 x i8] zeroinitializer, align 1
@__compressedAssemblyData_73 = internal dso_local global [1868320 x i8] zeroinitializer, align 1
@__compressedAssemblyData_74 = internal dso_local global [128032 x i8] zeroinitializer, align 1
@__compressedAssemblyData_75 = internal dso_local global [792096 x i8] zeroinitializer, align 1
@__compressedAssemblyData_76 = internal dso_local global [53248 x i8] zeroinitializer, align 1
@__compressedAssemblyData_77 = internal dso_local global [207392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_78 = internal dso_local global [712464 x i8] zeroinitializer, align 1
@__compressedAssemblyData_79 = internal dso_local global [79872 x i8] zeroinitializer, align 1
@__compressedAssemblyData_80 = internal dso_local global [76800 x i8] zeroinitializer, align 1
@__compressedAssemblyData_81 = internal dso_local global [50224 x i8] zeroinitializer, align 1
@__compressedAssemblyData_82 = internal dso_local global [26152 x i8] zeroinitializer, align 1
@__compressedAssemblyData_83 = internal dso_local global [33864 x i8] zeroinitializer, align 1
@__compressedAssemblyData_84 = internal dso_local global [26112 x i8] zeroinitializer, align 1
@__compressedAssemblyData_85 = internal dso_local global [186496 x i8] zeroinitializer, align 1
@__compressedAssemblyData_86 = internal dso_local global [30208 x i8] zeroinitializer, align 1
@__compressedAssemblyData_87 = internal dso_local global [1112720 x i8] zeroinitializer, align 1
@__compressedAssemblyData_88 = internal dso_local global [8192 x i8] zeroinitializer, align 1
@__compressedAssemblyData_89 = internal dso_local global [98304 x i8] zeroinitializer, align 1
@__compressedAssemblyData_90 = internal dso_local global [5748736 x i8] zeroinitializer, align 1
@__compressedAssemblyData_91 = internal dso_local global [59392 x i8] zeroinitializer, align 1
@__compressedAssemblyData_92 = internal dso_local global [515584 x i8] zeroinitializer, align 1
@__compressedAssemblyData_93 = internal dso_local global [15872 x i8] zeroinitializer, align 1
@__compressedAssemblyData_94 = internal dso_local global [16384 x i8] zeroinitializer, align 1
@__compressedAssemblyData_95 = internal dso_local global [19456 x i8] zeroinitializer, align 1
@__compressedAssemblyData_96 = internal dso_local global [71680 x i8] zeroinitializer, align 1
@__compressedAssemblyData_97 = internal dso_local global [542208 x i8] zeroinitializer, align 1
@__compressedAssemblyData_98 = internal dso_local global [24576 x i8] zeroinitializer, align 1
@__compressedAssemblyData_99 = internal dso_local global [9728 x i8] zeroinitializer, align 1
@__compressedAssemblyData_100 = internal dso_local global [42496 x i8] zeroinitializer, align 1
@__compressedAssemblyData_101 = internal dso_local global [209920 x i8] zeroinitializer, align 1
@__compressedAssemblyData_102 = internal dso_local global [21504 x i8] zeroinitializer, align 1
@__compressedAssemblyData_103 = internal dso_local global [17408 x i8] zeroinitializer, align 1
@__compressedAssemblyData_104 = internal dso_local global [32256 x i8] zeroinitializer, align 1
@__compressedAssemblyData_105 = internal dso_local global [12800 x i8] zeroinitializer, align 1
@__compressedAssemblyData_106 = internal dso_local global [36352 x i8] zeroinitializer, align 1
@__compressedAssemblyData_107 = internal dso_local global [89600 x i8] zeroinitializer, align 1
@__compressedAssemblyData_108 = internal dso_local global [18432 x i8] zeroinitializer, align 1
@__compressedAssemblyData_109 = internal dso_local global [58368 x i8] zeroinitializer, align 1
@__compressedAssemblyData_110 = internal dso_local global [28160 x i8] zeroinitializer, align 1
@__compressedAssemblyData_111 = internal dso_local global [405504 x i8] zeroinitializer, align 1
@__compressedAssemblyData_112 = internal dso_local global [11264 x i8] zeroinitializer, align 1
@__compressedAssemblyData_113 = internal dso_local global [37888 x i8] zeroinitializer, align 1
@__compressedAssemblyData_114 = internal dso_local global [57344 x i8] zeroinitializer, align 1
@__compressedAssemblyData_115 = internal dso_local global [38400 x i8] zeroinitializer, align 1
@__compressedAssemblyData_116 = internal dso_local global [583168 x i8] zeroinitializer, align 1
@__compressedAssemblyData_117 = internal dso_local global [86016 x i8] zeroinitializer, align 1
@__compressedAssemblyData_118 = internal dso_local global [18432 x i8] zeroinitializer, align 1
@__compressedAssemblyData_119 = internal dso_local global [89600 x i8] zeroinitializer, align 1
@__compressedAssemblyData_120 = internal dso_local global [756224 x i8] zeroinitializer, align 1
@__compressedAssemblyData_121 = internal dso_local global [254464 x i8] zeroinitializer, align 1
@__compressedAssemblyData_122 = internal dso_local global [35328 x i8] zeroinitializer, align 1
@__compressedAssemblyData_123 = internal dso_local global [71168 x i8] zeroinitializer, align 1
@__compressedAssemblyData_124 = internal dso_local global [19456 x i8] zeroinitializer, align 1
@__compressedAssemblyData_125 = internal dso_local global [22528 x i8] zeroinitializer, align 1
@__compressedAssemblyData_126 = internal dso_local global [70144 x i8] zeroinitializer, align 1
@__compressedAssemblyData_127 = internal dso_local global [18432 x i8] zeroinitializer, align 1
@__compressedAssemblyData_128 = internal dso_local global [160256 x i8] zeroinitializer, align 1
@__compressedAssemblyData_129 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_130 = internal dso_local global [12288 x i8] zeroinitializer, align 1
@__compressedAssemblyData_131 = internal dso_local global [529408 x i8] zeroinitializer, align 1
@__compressedAssemblyData_132 = internal dso_local global [47104 x i8] zeroinitializer, align 1
@__compressedAssemblyData_133 = internal dso_local global [60416 x i8] zeroinitializer, align 1
@__compressedAssemblyData_134 = internal dso_local global [20480 x i8] zeroinitializer, align 1
@__compressedAssemblyData_135 = internal dso_local global [40960 x i8] zeroinitializer, align 1
@__compressedAssemblyData_136 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_137 = internal dso_local global [61952 x i8] zeroinitializer, align 1
@__compressedAssemblyData_138 = internal dso_local global [22016 x i8] zeroinitializer, align 1
@__compressedAssemblyData_139 = internal dso_local global [33792 x i8] zeroinitializer, align 1
@__compressedAssemblyData_140 = internal dso_local global [27136 x i8] zeroinitializer, align 1
@__compressedAssemblyData_141 = internal dso_local global [22528 x i8] zeroinitializer, align 1
@__compressedAssemblyData_142 = internal dso_local global [434176 x i8] zeroinitializer, align 1
@__compressedAssemblyData_143 = internal dso_local global [64000 x i8] zeroinitializer, align 1
@__compressedAssemblyData_144 = internal dso_local global [18432 x i8] zeroinitializer, align 1
@__compressedAssemblyData_145 = internal dso_local global [396288 x i8] zeroinitializer, align 1
@__compressedAssemblyData_146 = internal dso_local global [66560 x i8] zeroinitializer, align 1
@__compressedAssemblyData_147 = internal dso_local global [27648 x i8] zeroinitializer, align 1
@__compressedAssemblyData_148 = internal dso_local global [25600 x i8] zeroinitializer, align 1
@__compressedAssemblyData_149 = internal dso_local global [68608 x i8] zeroinitializer, align 1
@__compressedAssemblyData_150 = internal dso_local global [9216 x i8] zeroinitializer, align 1
@__compressedAssemblyData_151 = internal dso_local global [148992 x i8] zeroinitializer, align 1
@__compressedAssemblyData_152 = internal dso_local global [114176 x i8] zeroinitializer, align 1
@__compressedAssemblyData_153 = internal dso_local global [16896 x i8] zeroinitializer, align 1
@__compressedAssemblyData_154 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_155 = internal dso_local global [20992 x i8] zeroinitializer, align 1
@__compressedAssemblyData_156 = internal dso_local global [74752 x i8] zeroinitializer, align 1
@__compressedAssemblyData_157 = internal dso_local global [46080 x i8] zeroinitializer, align 1
@__compressedAssemblyData_158 = internal dso_local global [1346560 x i8] zeroinitializer, align 1
@__compressedAssemblyData_159 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_160 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_161 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_162 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_163 = internal dso_local global [9728 x i8] zeroinitializer, align 1
@__compressedAssemblyData_164 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_165 = internal dso_local global [107008 x i8] zeroinitializer, align 1
@__compressedAssemblyData_166 = internal dso_local global [8192 x i8] zeroinitializer, align 1
@__compressedAssemblyData_167 = internal dso_local global [6144 x i8] zeroinitializer, align 1
@__compressedAssemblyData_168 = internal dso_local global [16384 x i8] zeroinitializer, align 1
@__compressedAssemblyData_169 = internal dso_local global [12288 x i8] zeroinitializer, align 1
@__compressedAssemblyData_170 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_171 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_172 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_173 = internal dso_local global [277504 x i8] zeroinitializer, align 1
@__compressedAssemblyData_174 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_175 = internal dso_local global [33280 x i8] zeroinitializer, align 1
@__compressedAssemblyData_176 = internal dso_local global [372736 x i8] zeroinitializer, align 1
@__compressedAssemblyData_177 = internal dso_local global [322048 x i8] zeroinitializer, align 1
@__compressedAssemblyData_178 = internal dso_local global [20992 x i8] zeroinitializer, align 1
@__compressedAssemblyData_179 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_180 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_181 = internal dso_local global [12288 x i8] zeroinitializer, align 1
@__compressedAssemblyData_182 = internal dso_local global [11264 x i8] zeroinitializer, align 1
@__compressedAssemblyData_183 = internal dso_local global [4608 x i8] zeroinitializer, align 1
@__compressedAssemblyData_184 = internal dso_local global [5632 x i8] zeroinitializer, align 1
@__compressedAssemblyData_185 = internal dso_local global [5120 x i8] zeroinitializer, align 1
@__compressedAssemblyData_186 = internal dso_local global [4608 x i8] zeroinitializer, align 1
@__compressedAssemblyData_187 = internal dso_local global [16384 x i8] zeroinitializer, align 1
@__compressedAssemblyData_188 = internal dso_local global [2459136 x i8] zeroinitializer, align 1
@__compressedAssemblyData_189 = internal dso_local global [166912 x i8] zeroinitializer, align 1
@__compressedAssemblyData_190 = internal dso_local global [19000 x i8] zeroinitializer, align 1
@__compressedAssemblyData_191 = internal dso_local global [2020864 x i8] zeroinitializer, align 1

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
