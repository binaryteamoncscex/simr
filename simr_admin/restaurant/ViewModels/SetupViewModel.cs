using Firebase.Auth.Providers;
using Firebase.Auth;
using Firebase.Database;
using Firebase.Database.Query;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace restaurant.ViewModels
{
    public class SetupViewModel : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        private readonly string webApiKey = "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k";
        private readonly FirebaseClient firebaseClient = new FirebaseClient("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");

        public SetupViewModel()
        {
            var cityZones = TimeZoneInfo
                .GetSystemTimeZones()
                .Where(tz =>
                    tz.Id.Count(c => c == '/') == 1
                    && !tz.Id.StartsWith("Etc/", StringComparison.OrdinalIgnoreCase)
                    && Regex.IsMatch(tz.Id, @"^[A-Za-z]+/[A-Za-z_]+$")
                )
                .Select(tz => tz.Id)
                .OrderBy(id => id.Split('/')[0], StringComparer.OrdinalIgnoreCase)
                .ThenBy(id => id.Split('/')[1], StringComparer.OrdinalIgnoreCase);

            Timezones = new ObservableCollection<string>(cityZones);
            DriveThruOptions = new ObservableCollection<string> { "Yes", "No" };
            FinishSetup = new Command(OnFinishSetup);
            Currencies = new ObservableCollection<string>(GetIsoCurrencies());
            TemperatureUnits = new ObservableCollection<string> { "Celsius", "Fahrenheit", "Kelvin" };
        }
        private List<string> GetIsoCurrencies()
        {
            return new List<string>
            {
"AFN - Afghan Afghani",
"ALL - Albanian Lek",
"AMD - Armenian Dram",
"ANG - Netherlands Antillean Guilder",
"AOA - Angolan Kwanza",
"ARS - Argentine Peso",
"AUD - Australian Dollar",
"AWG - Aruban Florin",
"AZN - Azerbaijani Manat",
"BAM - Bosnia-Herzegovina Convertible Mark",
"BBD - Barbadian Dollar",
"BDT - Bangladeshi Taka",
"BGN - Bulgarian Lev",
"BHD - Bahraini Dinar",
"BIF - Burundian Franc",
"BMD - Bermudian Dollar",
"BND - Brunei Dollar",
"BOB - Bolivian Boliviano",
"BRL - Brazilian Real",
"BSD - Bahamian Dollar",
"BTN - Bhutanese Ngultrum",
"BWP - Botswanan Pula",
"BYN - Belarusian Ruble",
"BZD - Belize Dollar",
"CAD - Canadian Dollar",
"CDF - Congolese Franc",
"CHF - Swiss Franc",
"CLP - Chilean Peso",
"CNY - Chinese Yuan",
"COP - Colombian Peso",
"CRC - Costa Rican Colón",
"CUP - Cuban Peso",
"CVE - Cape Verdean Escudo",
"CZK - Czech Koruna",
"DJF - Djiboutian Franc",
"DKK - Danish Krone",
"DOP - Dominican Peso",
"DZD - Algerian Dinar",
"EGP - Egyptian Pound",
"ERN - Eritrean Nakfa",
"ETB - Ethiopian Birr",
"EUR - Euro",
"FJD - Fijian Dollar",
"FKP - Falkland Islands Pound",
"GBP - British Pound",
"GEL - Georgian Lari",
"GHS - Ghanaian Cedi",
"GIP - Gibraltar Pound",
"GMD - Gambian Dalasi",
"GNF - Guinean Franc",
"GTQ - Guatemalan Quetzal",
"GYD - Guyanaese Dollar",
"HKD - Hong Kong Dollar",
"HNL - Honduran Lempira",
"HRK - Croatian Kuna",
"HTG - Haitian Gourde",
"HUF - Hungarian Forint",
"IDR - Indonesian Rupiah",
"ILS - Israeli New Shekel",
"INR - Indian Rupee",
"IQD - Iraqi Dinar",
"IRR - Iranian Rial",
"ISK - Icelandic Króna",
"JMD - Jamaican Dollar",
"JOD - Jordanian Dinar",
"JPY - Japanese Yen",
"KES - Kenyan Shilling",
"KGS - Kyrgyzstani Som",
"KHR - Cambodian Riel",
"KMF - Comorian Franc",
"KPW - North Korean Won",
"KRW - South Korean Won",
"KWD - Kuwaiti Dinar",
"KYD - Cayman Islands Dollar",
"KZT - Kazakhstani Tenge",
"LAK - Lao Kip",
"LBP - Lebanese Pound",
"LKR - Sri Lankan Rupee",
"LRD - Liberian Dollar",
"LSL - Lesotho Loti",
"LYD - Libyan Dinar",
"MAD - Moroccan Dirham",
"MDL - Moldovan Leu",
"MGA - Malagasy Ariary",
"MKD - Macedonian Denar",
"MMK - Myanmar Kyat",
"MNT - Mongolian Tugrik",
"MOP - Macanese Pataca",
"MRU - Mauritanian Ouguiya",
"MUR - Mauritian Rupee",
"MVR - Maldivian Rufiyaa",
"MWK - Malawian Kwacha",
"MXN - Mexican Peso",
"MYR - Malaysian Ringgit",
"MZN - Mozambican Metical",
"NAD - Namibian Dollar",
"NGN - Nigerian Naira",
"NIO - Nicaraguan Córdoba",
"NOK - Norwegian Krone",
"NPR - Nepalese Rupee",
"NZD - New Zealand Dollar",
"OMR - Omani Rial",
"PAB - Panamanian Balboa",
"PEN - Peruvian Sol",
"PGK - Papua New Guinean Kina",
"PHP - Philippine Peso",
"PKR - Pakistani Rupee",
"PLN - Polish Zloty",
"PYG - Paraguayan Guarani",
"QAR - Qatari Riyal",
"RON - Romanian Leu",
"RSD - Serbian Dinar",
"RUB - Russian Ruble",
"RWF - Rwandan Franc",
"SAR - Saudi Riyal",
"SBD - Solomon Islands Dollar",
"SCR - Seychellois Rupee",
"SDG - Sudanese Pound",
"SEK - Swedish Krona",
"SGD - Singapore Dollar",
"SLL - Sierra Leonean Leone",
"SOS - Somali Shilling",
"SRD - Surinamese Dollar",
"SSP - South Sudanese Pound",
"STN - São Tomé and Príncipe Dobra",
"SVC - Salvadoran Colón",
"SYP - Syrian Pound",
"SZL - Swazi Lilangeni",
"THB - Thai Baht",
"TJS - Tajikistani Somoni",
"TMT - Turkmenistani Manat",
"TND - Tunisian Dinar",
"TOP - Tongan Paʻanga",
"TRY - Turkish Lira",
"TTD - Trinidad and Tobago Dollar",
"TWD - New Taiwan Dollar",
"TZS - Tanzanian Shilling",
"UAH - Ukrainian Hryvnia",
"UGX - Ugandan Shilling",
"USD - United States Dollar",
"UYU - Uruguayan Peso",
"UZS - Uzbekistan Sum",
"VES - Venezuelan Bolívar Soberano",
"VND - Vietnamese Dong",
"VUV - Vanuatu Vatu",
"WST - Samoan Tala",
"XAF - CFA Franc BEAC",
"XCD - East Caribbean Dollar",
"XOF - CFA Franc BCEAO",
"XPF - CFP Franc",
"YER - Yemeni Rial",
"ZAR - South African Rand",
"ZMW - Zambian Kwacha",
"ZWL - Zimbabwean Dollar"
            };
        }
        private async void OnFinishSetup(object obj)
        {
            try
            {
                var authConfig = new FirebaseAuthConfig
                {
                    ApiKey = webApiKey,
                    AuthDomain = "restaurant-3e115.firebaseapp.com",
                    Providers = new FirebaseAuthProvider[]
                    {
                        new EmailProvider()
                    }
                };
                var authProvider = new FirebaseAuthClient(authConfig);

                string uid = Preferences.Get("uid", string.Empty);
                string currencyCode = SelectedCurrency?.Split(' ')[0];
                string temperatureUnitCode = SelectedTemperatureUnit switch
                {
                    "Celsius" => "C",
                    "Fahrenheit" => "F",
                    "Kelvin" => "K",
                    _ => null
                };
                var updates = new Dictionary<string, object>
                {
                    ["timezone"] = SelectedTimezone,
                    ["drive_thru"] = SelectedDriveThru,
                    ["Name"] = this.Name,
                    ["updateHour"] = UpdateHour,
                    ["temp_min"] = TempMin,
                    ["temp_max"] = TempMax,
                    ["umd_min"] = UmdMin,
                    ["umd_max"] = UmdMax,
                    ["currency"] = currencyCode,
                    ["tu"] = temperatureUnitCode,
                    ["setup"] = true
                };
                await firebaseClient
                    .Child("users")
                    .Child(uid)
                    .PatchAsync(updates);
                await App.Current.MainPage.DisplayAlert("Alert",
                    "Restaurant setup completed successfully!", "OK");
                Application.Current.MainPage = new NavigationPage(new Dashboard());
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Alert", ex.Message, "OK");
                throw;
            }
        }
        private class SetupData
        {
            public string Name { get; set; }
            public string timezone { get; set; }
            public string drive_thru { get; set; }
            public string updateHour { get; set; }
            public string temp_min { get; set; }
            public string temp_max { get; set; }
            public string umd_min { get; set; }
            public string umd_max { get; set; }
            public string currency { get; set; }
            public string temperatureUnit { get; set; }
        }

        public ObservableCollection<string> Timezones { get; }
        public ObservableCollection<string> DriveThruOptions { get; }
        public ObservableCollection<string> Currencies { get; } 
        public ObservableCollection<string> TemperatureUnits { get; }

        public Command FinishSetup { get; }

        private string _name;
        public string Name
        {
            get => _name;
            set
            {
                if (_name == value) return;
                _name = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Name)));
            }
        }

        private string _updateHour;
        public string UpdateHour
        {
            get => _updateHour;
            set
            {
                if (_updateHour == value) return;
                _updateHour = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(UpdateHour)));
            }
        }

        private string _selectedTimezone;
        public string SelectedTimezone
        {
            get => _selectedTimezone;
            set
            {
                if (_selectedTimezone == value) return;
                _selectedTimezone = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(SelectedTimezone)));
            }
        }

        private string _selectedDriveThru;
        public string SelectedDriveThru
        {
            get => _selectedDriveThru;
            set
            {
                if (_selectedDriveThru == value) return;
                _selectedDriveThru = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(SelectedDriveThru)));
            }
        }

        private string _selectedCurrency;
        public string SelectedCurrency
        {
            get => _selectedCurrency;
            set
            {
                if (_selectedCurrency == value) return;
                _selectedCurrency = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(SelectedCurrency)));
            }
        }

        private string _selectedTemperatureUnit;
        public string SelectedTemperatureUnit
        {
            get => _selectedTemperatureUnit;
            set
            {
                if (_selectedTemperatureUnit == value) return;
                _selectedTemperatureUnit = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(SelectedTemperatureUnit)));
            }
        }

        private string _tempMin;
        public string TempMin
        {
            get => _tempMin;
            set
            {
                if (_tempMin == value) return;
                _tempMin = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(TempMin)));
            }
        }

        private string _tempMax;
        public string TempMax
        {
            get => _tempMax;
            set
            {
                if (_tempMax == value) return;
                _tempMax = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(TempMax)));
            }
        }

        private string _umdMin;
        public string UmdMin
        {
            get => _umdMin;
            set
            {
                if (_umdMin == value) return;
                _umdMin = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(UmdMin)));
            }
        }

        private string _umdMax;
        public string UmdMax
        {
            get => _umdMax;
            set
            {
                if (_umdMax == value) return;
                _umdMax = value;
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(UmdMax)));
            }
        }
    }
}