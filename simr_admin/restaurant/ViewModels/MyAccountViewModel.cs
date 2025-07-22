using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Controls;
using Microsoft.Maui.Storage;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;

namespace restaurant.ViewModels
{
    public class MyAccountViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        FirebaseClient firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");

        public ObservableCollection<string> Timezones { get; }
        public ObservableCollection<string> DriveThruOptions { get; }
        public ObservableCollection<string> Currencies { get; }
        public ObservableCollection<string> TemperatureUnits { get; }

        public Command UpdateAccountCommand { get; }

        public int SelectedTimezoneIndex
        {
            get => _selectedTimezoneIndex;
            set { if (_selectedTimezoneIndex != value) { _selectedTimezoneIndex = value; OnPropertyChanged(nameof(SelectedTimezoneIndex)); } }
        }
        int _selectedTimezoneIndex;

        public int SelectedTemperatureUnitIndex
        {
            get => _selectedTemperatureUnitIndex;
            set { if (_selectedTemperatureUnitIndex != value) { _selectedTemperatureUnitIndex = value; OnPropertyChanged(nameof(SelectedTemperatureUnitIndex)); } }
        }
        int _selectedTemperatureUnitIndex;

        public MyAccountViewModel()
        {
            Timezones = new ObservableCollection<string>();
            DriveThruOptions = new ObservableCollection<string>();
            Currencies = new ObservableCollection<string>();
            TemperatureUnits = new ObservableCollection<string>();
            UpdateAccountCommand = new Command(OnUpdateAccount);
            Email = Preferences.Get("SavedUsername", string.Empty);
            _ = InitializeAsync();
        }

        async Task InitializeAsync()
        {
            PopulateCollections();
            await LoadDataAsync();
        }

        void PopulateCollections()
        {
            Timezones.Clear();
            var timezones = new List<string>
            {
                "Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", "Africa/Algiers", "Africa/Asmara",
                "Africa/Bamako", "Africa/Bangui", "Africa/Banjul", "Africa/Bissau", "Africa/Blantyre",
                "Africa/Brazzaville", "Africa/Bujumbura", "Africa/Cairo", "Africa/Casablanca", "Africa/Ceuta",
                "Africa/Conakry", "Africa/Dakar", "Africa/Dar_es_Salaam", "Africa/Djibouti", "Africa/Douala",
                "Africa/El_Aaiun", "Africa/Freetown", "Africa/Gaborone", "Africa/Harare", "Africa/Johannesburg",
                "Africa/Juba", "Africa/Kampala", "Africa/Khartoum", "Africa/Kigali", "Africa/Kinshasa",
                "Africa/Lagos", "Africa/Libreville", "Africa/Lome", "Africa/Luanda", "Africa/Lubumbashi",
                "Africa/Lusaka", "Africa/Malabo", "Africa/Maputo", "Africa/Maseru", "Africa/Mbabane",
                "Africa/Mogadishu", "Africa/Monrovia", "Africa/Nairobi", "Africa/Ndjamena", "Africa/Niamey",
                "Africa/Nouakchott", "Africa/Ouagadougou", "Africa/Porto-Novo", "Africa/Sao_Tome", "Africa/Tripoli",
                "Africa/Tunis", "Africa/Windhoek", "America/Adak", "America/Anchorage", "America/Anguilla",
                "America/Antigua", "America/Araguaina", "America/Argentina/Buenos_Aires", "America/Argentina/Catamarca",
                "America/Argentina/Cordoba", "America/Argentina/Jujuy", "America/Argentina/La_Rioja", "America/Argentina/Mendoza",
                "America/Argentina/Rio_Gallegos", "America/Argentina/Salta", "America/Argentina/San_Juan", "America/Argentina/San_Luis",
                "America/Argentina/Tucuman", "America/Argentina/Ushuaia", "America/Aruba", "America/Asuncion", "America/Atikokan",
                "America/Bahia", "America/Bahia_Banderas", "America/Barbados", "America/Belem", "America/Belize",
                "America/Blanc-Sablon", "America/Boa_Vista", "America/Bogota", "America/Boise", "America/Cambridge_Bay",
                "America/Campo_Grande", "America/Cancun", "America/Caracas", "America/Cayenne", "America/Cayman",
                "America/Chicago", "America/Chihuahua", "America/Costa_Rica", "America/Creston", "America/Cuiaba",
                "America/Curacao", "America/Danmarkshavn", "America/Dawson", "America/Dawson_Creek", "America/Denver",
                "America/Detroit", "America/Dominica", "America/Edmonton", "America/Eirunepe", "America/El_Salvador",
                "America/Fort_Nelson", "America/Fortaleza", "America/Glace_Bay", "America/Godthab", "America/Goose_Bay",
                "America/Grand_Turk", "America/Grenada", "America/Guadeloupe", "America/Guatemala", "America/Guayaquil",
                "America/Guyana", "America/Halifax", "America/Havana", "America/Hermosillo", "America/Indiana/Indianapolis",
                "America/Indiana/Knox", "America/Indiana/Marengo", "America/Indiana/Petersburg", "America/Indiana/Tell_City",
                "America/Indiana/Vevay", "America/Indiana/Vincennes", "America/Indiana/Winamac", "America/Inuvik", "America/Iqaluit",
                "America/Jamaica", "America/Juneau", "America/Kentucky/Louisville", "America/Kentucky/Monticello", "America/La_Paz",
                "America/Lima", "America/Los_Angeles", "America/Maceio", "America/Managua", "America/Manaus",
                "America/Martinique", "America/Matamoros", "America/Mazatlan", "America/Menominee", "America/Merida",
                "America/Mexico_City", "America/Miquelon", "America/Moncton", "America/Monterrey", "America/Montevideo",
                "America/Montserrat", "America/Nassau", "America/New_York", "America/Nipigon", "America/Nome",
                "America/Noronha", "America/North_Dakota/Beulah", "America/North_Dakota/Center", "America/North_Dakota/New_Salem",
                "America/Nuuk", "America/Ojinaga", "America/Panama", "America/Pangnirtung", "America/Paramaribo",
                "America/Phoenix", "America/Port-au-Prince", "America/Port_of_Spain", "America/Porto_Velho", "America/Puerto_Rico",
                "America/Punta_Arenas", "America/Rainy_River", "America/Rankin_Inlet", "America/Recife", "America/Regina",
                "America/Resolute", "America/Rio_Branco", "America/Santarem", "America/Santiago", "America/Santo_Domingo",
                "America/Sao_Paulo", "America/Scoresbysund", "America/Sitka", "America/St_Johns", "America/St_Kitts",
                "America/St_Lucia", "America/St_Thomas", "America/St_Vincent", "America/Swift_Current", "America/Tegucigalpa",
                "America/Thule", "America/Thunder_Bay", "America/Tijuana", "America/Toronto", "America/Tortola",
                "America/Vancouver", "America/Whitehorse", "America/Winnipeg", "America/Yakutat", "America/Yellowknife",
                "Asia/Almaty", "Asia/Amman", "Asia/Baghdad", "Asia/Baku", "Asia/Bangkok", "Asia/Beirut", "Asia/Bishkek",
                "Asia/Colombo", "Asia/Damascus", "Asia/Dhaka", "Asia/Dili", "Asia/Dubai", "Asia/Dushanbe", "Asia/Gaza",
                "Asia/Hebron", "Asia/Ho_Chi_Minh", "Asia/Hong_Kong", "Asia/Irkutsk", "Asia/Jakarta", "Asia/Jayapura", "Asia/Jerusalem",
                "Asia/Kabul", "Asia/Kamchatka", "Asia/Karachi", "Asia/Kathmandu", "Asia/Kolkata", "Asia/Krasnoyarsk",
                "Asia/Kuala_Lumpur", "Asia/Kuching", "Asia/Kuwait", "Asia/Macau", "Asia/Magadan", "Asia/Makassar", "Asia/Manila",
                "Asia/Muscat", "Asia/Nicosia", "Asia/Novokuznetsk", "Asia/Novosibirsk", "Asia/Omsk", "Asia/Phnom_Penh", "Asia/Pontianak",
                "Asia/Qatar", "Asia/Qyzylorda", "Asia/Riyadh", "Asia/Sakhalin", "Asia/Samarkand", "Asia/Seoul", "Asia/Shanghai",
                "Asia/Singapore", "Asia/Srednekolymsk", "Asia/Taipei", "Asia/Tashkent", "Asia/Tbilisi", "Asia/Tehran", "Asia/Thimphu",
                "Asia/Tokyo", "Asia/Tomsk", "Asia/Ulaanbaatar", "Asia/Urumqi", "Asia/Vientiane", "Asia/Vladivostok", "Asia/Yakutsk",
                "Asia/Yekaterinburg", "Asia/Yerevan", "Atlantic/Azores", "Atlantic/Bermuda", "Atlantic/Canary", "Atlantic/Cape_Verde",
                "Atlantic/Faroe", "Atlantic/Madeira", "Atlantic/Reykjavik", "Atlantic/South_Georgia", "Atlantic/St_Helena",
                "Atlantic/Stanley", "Australia/Adelaide", "Australia/Brisbane", "Australia/Broken_Hill", "Australia/Darwin",
                "Australia/Eucla", "Australia/Hobart", "Australia/Lindeman", "Australia/Lord_Howe", "Australia/Melbourne",
                "Australia/Perth", "Australia/Sydney", "Europe/Amsterdam", "Europe/Andorra", "Europe/Astrakhan", "Europe/Athens",
                "Europe/Belgrade", "Europe/Berlin", "Europe/Bratislava", "Europe/Brussels", "Europe/Bucharest", "Europe/Budapest",
                "Europe/Chisinau", "Europe/Copenhagen", "Europe/Dublin", "Europe/Gibraltar", "Europe/Guernsey", "Europe/Helsinki",
                "Europe/Isle_of_Man", "Europe/Istanbul", "Europe/Jersey", "Europe/Kaliningrad", "Europe/Kiev", "Europe/Kirov",
                "Europe/Lisbon", "Europe/Ljubljana", "Europe/London", "Europe/Luxembourg", "Europe/Madrid", "Europe/Malta",
                "Europe/Mariehamn", "Europe/Minsk", "Europe/Monaco", "Europe/Moscow", "Europe/Oslo", "Europe/Paris", "Europe/Podgorica",
                "Europe/Prague", "Europe/Riga", "Europe/Rome", "Europe/Samara", "Europe/San_Marino", "Europe/Sarajevo", "Europe/Skopje",
                "Europe/Sofia", "Europe/Stockholm", "Europe/Tallinn", "Europe/Tirane", "Europe/Uzhgorod", "Europe/Vaduz", "Europe/Vatican",
                "Europe/Vienna", "Europe/Vilnius", "Europe/Volgograd", "Europe/Warsaw", "Europe/Zagreb", "Europe/Zaporozhye", "Europe/Zurich",
                "Pacific/Apia", "Pacific/Auckland", "Pacific/Bougainville", "Pacific/Chatham", "Pacific/Chuuk", "Pacific/Easter", "Pacific/Efate",
                "Pacific/Fakaofo", "Pacific/Fiji", "Pacific/Funafuti", "Pacific/Galapagos", "Pacific/Gambier", "Pacific/Guadalcanal",
                "Pacific/Guam", "Pacific/Honolulu", "Pacific/Kiritimati", "Pacific/Kosrae", "Pacific/Kwajalein", "Pacific/Majuro",
                "Pacific/Marquesas", "Pacific/Midway", "Pacific/Nauru", "Pacific/Niue", "Pacific/Norfolk", "Pacific/Noumea",
                "Pacific/Pago_Pago", "Pacific/Palau", "Pacific/Pitcairn", "Pacific/Pohnpei", "Pacific/Port_Moresby", "Pacific/Rarotonga",
                "Pacific/Saipan", "Pacific/Tahiti", "Pacific/Tarawa", "Pacific/Tongatapu", "Pacific/Wake", "Pacific/Wallis"
            };
            foreach (var tz in timezones)
                Timezones.Add(tz);

            DriveThruOptions.Clear();
            DriveThruOptions.Add("Yes");
            DriveThruOptions.Add("No");

            Currencies.Clear();
            foreach (var currency in GetIsoCurrencies())
                Currencies.Add(currency);

            TemperatureUnits.Clear();
            TemperatureUnits.Add("Celsius");
            TemperatureUnits.Add("Fahrenheit");
            TemperatureUnits.Add("Kelvin");
        }

        async Task LoadDataAsync()
        {
            try
            {
                string uid = Preferences.Get("uid", string.Empty);
                if (string.IsNullOrEmpty(uid)) return;
                bool setup = await firebaseClient.Child("users").Child(uid).Child("setup").OnceSingleAsync<bool>();
                if (!setup) return;
                var data = await firebaseClient.Child("users").Child(uid).OnceSingleAsync<SetupData>();

                Name = data.Name;
                UpdateHour = data.updateHour;
                YourName = data.Your_Name;
                PayDay = data.payday;
                PayHour = data.payhour;
                SelectedTimezoneIndex = Timezones.IndexOf(data.timezone) switch { var i when i >= 0 => i, _ => 0 };
                SelectedDriveThru = data.drive_thru;
                SelectedCurrency = Currencies.FirstOrDefault(c => c.StartsWith(data.currency + " -"));

                string fullTu = data.temperatureUnit switch
                {
                    "C" => "Celsius",
                    "F" => "Fahrenheit",
                    "K" => "Kelvin",
                    _ => null
                };
                SelectedTemperatureUnitIndex = TemperatureUnits.IndexOf(fullTu) switch { var i when i >= 0 => i, _ => 0 };
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error loading account data", ex.Message, "OK");
            }
        }

        async void OnUpdateAccount()
        {
            try
            {
                string uid = Preferences.Get("uid", string.Empty);
                var currencyCode = SelectedCurrency?.Split(' ')[0];
                var tuCode = SelectedTemperatureUnitIndex switch
                {
                    0 => "C",
                    1 => "F",
                    2 => "K",
                    _ => null
                };

                var updates = new Dictionary<string, object>
                {
                    ["Name"] = Name,
                    ["updateHour"] = UpdateHour,
                    ["timezone"] = Timezones[SelectedTimezoneIndex],
                    ["drive_thru"] = SelectedDriveThru,
                    ["currency"] = currencyCode,
                    ["tu"] = tuCode,
                    ["Your_Name"] = YourName,
                    ["payday"] = PayDay,
                    ["payhour"] = PayHour
                };

                await firebaseClient.Child("users").Child(uid).PatchAsync(updates);
                await Application.Current.MainPage.DisplayAlert("Success", "Account updated successfully!", "OK");
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error updating account", ex.Message, "OK");
            }
        }

        List<string> GetIsoCurrencies() => new()
        {
            "AFN - Afghan Afghani","ALL - Albanian Lek","AMD - Armenian Dram","ANG - Netherlands Antillean Guilder",
            "AOA - Angolan Kwanza","ARS - Argentine Peso","AUD - Australian Dollar","AWG - Aruban Florin",
            "AZN - Azerbaijani Manat","BAM - Bosnia-Herzegovina Convertible Mark","BBD - Barbadian Dollar",
            "BDT - Bangladeshi Taka","BGN - Bulgarian Lev","BHD - Bahraini Dinar","BIF - Burundian Franc",
            "BMD - Bermudian Dollar","BND - Brunei Dollar","BOB - Bolivian Boliviano","BRL - Brazilian Real",
            "BSD - Bahamian Dollar","BTN - Bhutanese Ngultrum","BWP - Botswanan Pula","BYN - Belarusian Ruble",
            "BZD - Belize Dollar","CAD - Canadian Dollar","CDF - Congolese Franc","CHF - Swiss Franc",
            "CLP - Chilean Peso","CNY - Chinese Yuan","COP - Colombian Peso","CRC - Costa Rican Colón",
            "CUP - Cuban Peso","CVE - Cape Verdean Escudo","CZK - Czech Koruna","DJF - Djiboutian Franc",
            "DKK - Danish Krone","DOP - Dominican Peso","DZD - Algerian Dinar","EGP - Egyptian Pound",
            "ERN - Eritrean Nakfa","ETB - Ethiopian Birr","EUR - Euro","FJD - Fijian Dollar","FKP - Falkland Islands Pound",
            "GBP - British Pound","GEL - Georgian Lari","GHS - Ghanaian Cedi","GIP - Gibraltar Pound",
            "GMD - Gambian Dalasi","GNF - Guinean Franc","GTQ - Guatemalan Quetzal","GYD - Guyanaese Dollar",
            "HKD - Hong Kong Dollar","HNL - Honduran Lempira","HRK - Croatian Kuna","HTG - Haitian Gourde",
            "HUF - Hungarian Forint","IDR - Indonesian Rupiah","ILS - Israeli New Shekel","INR - Indian Rupee",
            "IQD - Iraqi Dinar","IRR - Iranian Rial","ISK - Icelandic Króna","JMD - Jamaican Dollar",
            "JOD - Jordanian Dinar","JPY - Japanese Yen","KES - Kenyan Shilling","KGS - Kyrgyzstani Som",
            "KHR - Cambodian Riel","KMF - Comorian Franc","KPW - North Korean Won","KRW - South Korean Won",
            "KWD - Kuwaiti Dinar","KYD - Cayman Islands Dollar","KZT - Kazakhstani Tenge","LAK - Lao Kip",
            "LBP - Lebanese Pound","LKR - Sri Lankan Rupee","LRD - Liberian Dollar","LSL - Lesotho Loti",
            "LYD - Libyan Dinar","MAD - Moroccan Dirham","MDL - Moldovan Leu","MGA - Malagasy Ariary",
            "MKD - Macedonian Denar","MMK - Myanmar Kyat","MNT - Mongolian Tugrik","MOP - Macanese Pataca",
            "MRU - Mauritanian Ouguiya","MUR - Mauritian Rupee","MVR - Maldivian Rufiyaa","MWK - Malawian Kwacha",
            "MXN - Mexican Peso","MYR - Malaysian Ringgit","MZN - Mozambican Metical","NAD - Namibian Dollar",
            "NGN - Nigerian Naira","NIO - Nicaraguan Córdoba","NOK - Norwegian Krone","NPR - Nepalese Rupee",
            "NZD - New Zealand Dollar","OMR - Omani Rial","PAB - Panamanian Balboa","PEN - Peruvian Sol",
            "PGK - Papua New Guinean Kina","PHP - Philippine Peso","PKR - Pakistani Rupee","PLN - Polish Zloty",
            "PYG - Paraguayan Guarani","QAR - Qatari Riyal","RON - Romanian Leu","RSD - Serbian Dinar",
            "RUB - Russian Ruble","RWF - Rwandan Franc","SAR - Saudi Riyal","SBD - Solomon Islands Dollar",
            "SCR - Seychellois Rupee","SDG - Sudanese Pound","SEK - Swedish Krona","SGD - Singapore Dollar",
            "SLL - Sierra Leonean Leone","SOS - Somali Shilling","SRD - Surinamese Dollar","SSP - South Sudanese Pound",
            "STN - São Tomé and Príncipe Dobra","SVC - Salvadoran Colón","SYP - Syrian Pound","SZL - Swazi Lilangeni",
            "THB - Thai Baht","TJS - Tajikistani Somoni","TMT - Turkmenistani Manat","TND - Tunisian Dinar",
            "TOP - Tongan Paʻanga","TRY - Turkish Lira","TTD - Trinidad and Tobago Dollar","TWD - New Taiwan Dollar",
            "TZS - Tanzanian Shilling","UAH - Ukrainian Hryvnia","UGX - Ugandan Shilling","USD - United States Dollar",
            "UYU - Uruguayan Peso","UZS - Uzbekistan Sum","VES - Venezuelan Bolívar Soberano","VND - Vietnamese Dong",
            "VUV - Vanuatu Vatu","WST - Samoan Tala","XAF - CFA Franc BEAC","XCD - East Caribbean Dollar",
            "XOF - CFA Franc BCEAO","XPF - CFP Franc","YER - Yemeni Rial","ZAR - South African Rand",
            "ZMW - Zambian Kwacha","ZWL - Zimbabwean Dollar"
        };

        public class SetupData
        {
            public string Name { get; set; }
            public string timezone { get; set; }
            public string drive_thru { get; set; }
            public string updateHour { get; set; }
            public string currency { get; set; }
            public string temperatureUnit { get; set; }
            public string Your_Name { get; set; }
            public int payday { get; set; }
            public int payhour { get; set; }
        }

        string _yourName;
        public string YourName { get => _yourName; set { if (_yourName != value) { _yourName = value; OnPropertyChanged(nameof(YourName)); } } }

        string _email;
        public string Email { get => _email; set { if (_email != value) { _email = value; OnPropertyChanged(nameof(Email)); } } }

        string _name;
        public string Name { get => _name; set { if (_name != value) { _name = value; OnPropertyChanged(nameof(Name)); } } }

        string _updateHour;
        public string UpdateHour { get => _updateHour; set { if (_updateHour != value) { _updateHour = value; OnPropertyChanged(nameof(UpdateHour)); } } }

        string _selectedDriveThru;
        public string SelectedDriveThru { get => _selectedDriveThru; set { if (_selectedDriveThru != value) { _selectedDriveThru = value; OnPropertyChanged(nameof(SelectedDriveThru)); } } }

        string _selectedCurrency;
        public string SelectedCurrency { get => _selectedCurrency; set { if (_selectedCurrency != value) { _selectedCurrency = value; OnPropertyChanged(nameof(SelectedCurrency)); } } }

        int _payDay;
        public int PayDay { get => _payDay; set { if (_payDay != value) { _payDay = value; OnPropertyChanged(nameof(PayDay)); } } }

        int _payHour;
        public int PayHour { get => _payHour; set { if (_payHour != value) { _payHour = value; OnPropertyChanged(nameof(PayHour)); } } }

        protected void OnPropertyChanged(string name) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
    }
}
