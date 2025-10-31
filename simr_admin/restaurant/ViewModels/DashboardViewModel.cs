using CommunityToolkit.Maui.Storage;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Firebase.Database;
using Firebase.Database.Query;
using Microcharts;
using Newtonsoft.Json.Linq;
using SkiaSharp;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;
using Entry = Microcharts.ChartEntry;

namespace restaurant.ViewModels
{
    public class LegendItem
    {
        public string Label { get; set; }
        public string Percentage { get; set; }
        public Color Color { get; set; }
    }

    public class AccountingRecord
    {
        public string Month { get; set; }
        public string Profit { get; set; }
        public string Expenses { get; set; }
        public string TotalRevenue { get; set; }
    }

    public partial class DashboardViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient;
        private string _kitchenUid => Preferences.Get("uid", string.Empty);
        private string _statistics = string.Empty;

        [ObservableProperty] private Chart mostOrderedIngredientsChart;
        [ObservableProperty] private Chart mostOrderedDishesChart;
        [ObservableProperty] private Chart monthlyProfitChart;
        [ObservableProperty] private Chart monthlyExpensesChart;
        [ObservableProperty] private bool isRefreshing;
        [ObservableProperty] private string restaurantName;
        [ObservableProperty] private bool isIngredientsChartAvailable;
        [ObservableProperty] private bool isDishesChartAvailable;
        [ObservableProperty] private bool isProfitChartAvailable;
        [ObservableProperty] private bool isExpensesChartAvailable;
        [ObservableProperty] private bool isAccountingTableAvailable;

        public ObservableCollection<LegendItem> IngredientLegend { get; } = new();
        public ObservableCollection<LegendItem> DishLegend { get; } = new();
        public ObservableCollection<AccountingRecord> AccountingTable { get; } = new();

        public ICommand RefreshCommand { get; }
        public ICommand ManageEmployBtn { get; }
        public ICommand ManageIngrProvBtn { get; }
        public ICommand AskAICommand { get; }
        public ICommand ManageTablesBtn { get; }
        public ICommand CheckInvenBtn { get; }
        public ICommand SignOutBtn { get; }
        public ICommand MyAccountBtn { get; }
        public ICommand ManageMenuItemBtn { get; }
        public ICommand ManageMenuIngrBtn { get; }
        public ICommand IngrCommands { get; }
        public ICommand ManageMenuCatBtn { get; }
        public ICommand DownloadExcelCommand { get; }
        public ICommand ManageDiscountsBtn { get; }
        public ICommand BugCamera { get; }

        public DashboardViewModel(INavigation navigation)
        {
            _firebaseClient = new FirebaseClient(FirebaseUrl);
            RefreshCommand = new AsyncRelayCommand(ExecuteRefreshCommand);
            AskAICommand = new AsyncRelayCommand(async () => await navigation.PushAsync(new AskAI(_statistics)));
            ManageTablesBtn = new Command(async () => await navigation.PushAsync(new ManageTables()));
            CheckInvenBtn = new Command(async () => await navigation.PushAsync(new CheckInven()));
            SignOutBtn = new Command(async () => await SignOut(navigation));
            MyAccountBtn = new Command(async () => await navigation.PushAsync(new MyAccount()));
            ManageMenuItemBtn = new Command(async () => await navigation.PushAsync(new DelMenuItem()));
            ManageMenuIngrBtn = new Command(async () => await navigation.PushAsync(new DelMenuIngr()));
            IngrCommands = new Command(async () => await navigation.PushAsync(new IngrCommands()));
            ManageMenuCatBtn = new Command(async () => await navigation.PushAsync(new DelCategories()));
            ManageEmployBtn = new Command(async () => await navigation.PushAsync(new ManageEmployees()));
            ManageIngrProvBtn = new Command(async () => await navigation.PushAsync(new DelIngrProv()));
            ManageDiscountsBtn = new Command(async () => await navigation.PushAsync(new ManageDiscounts()));
            BugCamera = new Command(async () => await navigation.PushAsync(new CameraGandaci()));
            DownloadExcelCommand = new Command(DownloadExcelCommandAsync);

            LoadRestaurantName();
            LoadStatistics();
        }

        private async Task ExecuteRefreshCommand()
        {
            IsRefreshing = true;
            try
            {
                await LoadStatistics();
            }
            finally
            {
                IsRefreshing = false;
            }
        }

        public async Task LoadStatistics()
        {
            await LoadMostOrderedIngredients();
            await LoadMostOrderedDishes();
            await LoadFinancialData();
            var (ingredientsSummary, dishesSummary, financialSummary) = GenerateStatisticsSummaries();
            _statistics = $"{ingredientsSummary}\n\n{dishesSummary}\n\n{financialSummary}";
        }

        private async Task LoadMostOrderedIngredients()
        {
            try
            {
                var response = await _firebaseClient
                    .Child($"kitchen/{_kitchenUid}/ingredients")
                    .OnceAsJsonAsync();

                if (!string.IsNullOrEmpty(response))
                {
                    var json = JObject.Parse(response);
                    var list = json["list"]?.ToObject<List<JObject>>();
                    var totalUsed = json["used"]?.ToObject<double>() ?? 0;
                    var entries = new List<Entry>();
                    IngredientLegend.Clear();

                    if (list == null || !list.Any() || totalUsed <= 0)
                    {
                        IsIngredientsChartAvailable = false;
                        return;
                    }

                    foreach (var item in list.Where(i => i != null && i["name"] != null && i["used"] != null))
                    {
                        var name = item["name"].ToString();
                        var used = item["used"].ToObject<double>();
                        if (used <= 0 || totalUsed <= 0) continue;
                        var percentValue = (used / totalUsed) * 100;
                        if (double.IsNaN(percentValue) || double.IsInfinity(percentValue))
                        {
                            IsIngredientsChartAvailable = false;
                            return;
                        }
                        var color = SKColor.Parse(GetRandomColor());
                        var percent = $"{Math.Round(percentValue, 1)}%";
                        entries.Add(new Entry((float)used)
                        {
                            Label = name,
                            ValueLabel = percent,
                            Color = color
                        });
                        IngredientLegend.Add(new LegendItem
                        {
                            Label = name,
                            Percentage = percent,
                            Color = new Color(color.Red / 255f, color.Green / 255f, color.Blue / 255f, color.Alpha / 255f)
                        });
                    }

                    if (entries.Count == 0)
                    {
                        IsIngredientsChartAvailable = false;
                        return;
                    }

                    MostOrderedIngredientsChart = new PieChart
                    {
                        Entries = entries.OrderByDescending(e => e.Value),
                        LabelTextSize = 0,
                        LabelMode = LabelMode.None
                    };
                    IsIngredientsChartAvailable = true;
                }
                else
                {
                    IsIngredientsChartAvailable = false;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading ingredient statistics: {ex}");
                IsIngredientsChartAvailable = false;
            }
        }

        private async Task LoadMostOrderedDishes()
        {
            try
            {
                var response = await _firebaseClient
                    .Child($"kitchen/{_kitchenUid}/menu")
                    .OnceAsJsonAsync();

                if (!string.IsNullOrEmpty(response))
                {
                    var json = JObject.Parse(response);
                    var list = json["list"]?.ToObject<List<JObject>>();
                    var total = json["orders"]?["count"]?.ToObject<int>() ?? 0;
                    var entries = new List<Entry>();
                    DishLegend.Clear();
                    if (list == null || !list.Any() || total <= 0)
                    {
                        IsDishesChartAvailable = false;
                        return;
                    }
                    foreach (var item in list.Where(i => i != null && i["name"] != null && i["count"] != null))
                    {
                        var name = item["name"].ToString();
                        var count = item["count"].ToObject<int>();
                        if (count <= 0 || total <= 0) continue;
                        var percentValue = ((double)count / total) * 100;
                        if (double.IsNaN(percentValue) || double.IsInfinity(percentValue))
                        {
                            IsDishesChartAvailable = false;
                            return;
                        }
                        var color = SKColor.Parse(GetRandomColor());
                        var percent = $"{Math.Round(percentValue, 1)}%";
                        entries.Add(new Entry(count)
                        {
                            Label = name,
                            ValueLabel = percent,
                            Color = color
                        });
                        DishLegend.Add(new LegendItem
                        {
                            Label = name,
                            Percentage = percent,
                            Color = new Color(color.Red / 255f, color.Green / 255f, color.Blue / 255f, color.Alpha / 255f)
                        });
                    }

                    if (entries.Count == 0)
                    {
                        IsDishesChartAvailable = false;
                        return;
                    }

                    MostOrderedDishesChart = new PieChart
                    {
                        Entries = entries.OrderByDescending(e => e.Value),
                        LabelTextSize = 0,
                        LabelMode = LabelMode.None
                    };
                    IsDishesChartAvailable = true;
                }
                else
                {
                    IsDishesChartAvailable = false;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading dish statistics: {ex}");
                IsDishesChartAvailable = false;
            }
        }

        private async Task LoadFinancialData()
        {
            try
            {
                var userData = await _firebaseClient
                    .Child("users")
                    .Child(_kitchenUid)
                    .OnceSingleAsync<dynamic>();

                if (userData == null)
                {
                    SetFinancialChartsUnavailable();
                    return;
                }

                var profitData = ((JObject)userData.profit)?.ToObject<Dictionary<string, double>>() ?? new Dictionary<string, double>();
                var expensesData = ((JObject)userData.expenses)?.ToObject<Dictionary<string, double>>() ?? new Dictionary<string, double>();

                var lastThreeMonths = GetLastThreeMonths();

                await CreateProfitChart(profitData, lastThreeMonths);
                await CreateExpensesChart(expensesData, lastThreeMonths);
                CreateAccountingTable(profitData, expensesData, lastThreeMonths);
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading financial data: {ex}");
                SetFinancialChartsUnavailable();
            }
        }

        private List<string> GetLastThreeMonths()
        {
            var months = new List<string>();
            var currentDate = DateTime.Now;

            for (int i = 2; i >= 0; i--)
            {
                var date = currentDate.AddMonths(-i);
                months.Add(date.ToString("MM-yyyy"));
            }

            return months;
        }

        private async Task CreateProfitChart(Dictionary<string, double> profitData, List<string> lastThreeMonths)
        {
            var entries = new List<Entry>();
            var profitColor = SKColor.Parse("#4CAF50");

            foreach (var month in lastThreeMonths)
            {
                if (profitData.TryGetValue(month, out double profit))
                {
                    entries.Add(new Entry((float)profit)
                    {
                        Label = month,
                        ValueLabel = profit.ToString("N0"),
                        Color = profitColor
                    });
                }
                else
                {
                    entries.Add(new Entry(0)
                    {
                        Label = month,
                        ValueLabel = "0",
                        Color = profitColor
                    });
                }
            }

            if (entries.Any(e => e.Value > 0))
            {
                MonthlyProfitChart = new LineChart
                {
                    Entries = entries,
                    LabelTextSize = 30,
                    LineMode = LineMode.Straight,
                    PointMode = PointMode.Circle,
                    LineSize = 8,
                    PointSize = 20
                };
                IsProfitChartAvailable = true;
            }
            else
            {
                IsProfitChartAvailable = false;
            }
        }

        private async Task CreateExpensesChart(Dictionary<string, double> expensesData, List<string> lastThreeMonths)
        {
            var entries = new List<Entry>();
            var expensesColor = SKColor.Parse("#F44336");

            foreach (var month in lastThreeMonths)
            {
                if (expensesData.TryGetValue(month, out double expense))
                {
                    entries.Add(new Entry((float)expense)
                    {
                        Label = month,
                        ValueLabel = expense.ToString("N0"),
                        Color = expensesColor
                    });
                }
                else
                {
                    entries.Add(new Entry(0)
                    {
                        Label = month,
                        ValueLabel = "0",
                        Color = expensesColor
                    });
                }
            }

            if (entries.Any(e => e.Value > 0))
            {
                MonthlyExpensesChart = new LineChart
                {
                    Entries = entries,
                    LabelTextSize = 30,
                    LineMode = LineMode.Straight,
                    PointMode = PointMode.Circle,
                    LineSize = 8,
                    PointSize = 20
                };
                IsExpensesChartAvailable = true;
            }
            else
            {
                IsExpensesChartAvailable = false;
            }
        }

        private void CreateAccountingTable(Dictionary<string, double> profitData, Dictionary<string, double> expensesData, List<string> lastThreeMonths)
        {
            AccountingTable.Clear();

            foreach (var month in lastThreeMonths)
            {
                profitData.TryGetValue(month, out double profit);
                expensesData.TryGetValue(month, out double expense);
                var totalRevenue = profit - expense;

                AccountingTable.Add(new AccountingRecord
                {
                    Month = month,
                    Profit = profit.ToString("N0"),
                    Expenses = expense.ToString("N0"),
                    TotalRevenue = totalRevenue.ToString("N0")
                });
            }

            IsAccountingTableAvailable = AccountingTable.Any(r =>
                r.Profit != "0" || r.Expenses != "0" || r.TotalRevenue != "0");
        }

        private void SetFinancialChartsUnavailable()
        {
            IsProfitChartAvailable = false;
            IsExpensesChartAvailable = false;
            IsAccountingTableAvailable = false;
        }

        public async Task SignOut(INavigation navigation)
        {
            try
            {
                var uid = Preferences.Get("uid", null);
                var deviceId = Preferences.Get("DeviceId", null);

                if (!string.IsNullOrEmpty(uid) && !string.IsNullOrEmpty(deviceId))
                {
                    var token = Preferences.Get("FirebaseToken", null);
                    if (!string.IsNullOrEmpty(token))
                    {
                        var firebaseClient = new FirebaseClient(
                            "https://restaurant-ad63f-default-rtdb.europe-west1.firebasedatabase.app/",
                            new FirebaseOptions { AuthTokenAsyncFactory = () => Task.FromResult(token) });

                        await firebaseClient.Child("users").Child(uid).Child("devices").Child(deviceId).DeleteAsync();
                    }
                }

                Preferences.Remove("SavedUsername");
                Preferences.Remove("SavedPassword");
                Preferences.Remove("uid");
                Preferences.Remove("RememberMe");
                Preferences.Remove("FirebaseToken");
                Preferences.Remove("DeviceId");
                Preferences.Remove("FCMToken");

                Application.Current.MainPage = new NavigationPage(new IntroPage(isFirstLaunch: false, rememberMe: false));
            }
            catch (Exception ex)
            {
                await App.Current.MainPage.DisplayAlert("Alert", ex.Message, "OK");
            }
        }

        public async void DownloadExcelCommandAsync()
        {
            try
            {
                using var workbook = new ClosedXML.Excel.XLWorkbook();

                var ingredientsSheet = workbook.Worksheets.Add("Ingredients");
                ingredientsSheet.Cell(1, 1).Value = "Ingredient";
                ingredientsSheet.Cell(1, 2).Value = "Percentage";
                if (!IsIngredientsChartAvailable || !IngredientLegend.Any())
                {
                    ingredientsSheet.Cell(2, 1).Value = "Graph not available";
                }
                else
                {
                    for (int i = 0; i < IngredientLegend.Count; i++)
                    {
                        ingredientsSheet.Cell(i + 2, 1).Value = IngredientLegend[i].Label;
                        ingredientsSheet.Cell(i + 2, 2).Value = IngredientLegend[i].Percentage;
                    }
                }

                var dishesSheet = workbook.Worksheets.Add("Dishes");
                dishesSheet.Cell(1, 1).Value = "Dish";
                dishesSheet.Cell(1, 2).Value = "Percentage";
                if (!IsDishesChartAvailable || !DishLegend.Any())
                {
                    dishesSheet.Cell(2, 1).Value = "Graph not available";
                }
                else
                {
                    for (int i = 0; i < DishLegend.Count; i++)
                    {
                        dishesSheet.Cell(i + 2, 1).Value = DishLegend[i].Label;
                        dishesSheet.Cell(i + 2, 2).Value = DishLegend[i].Percentage;
                    }
                }

                var profitSheet = workbook.Worksheets.Add("Monthly Profit");
                profitSheet.Cell(1, 1).Value = "Month";
                profitSheet.Cell(1, 2).Value = "Profit";
                if (!IsProfitChartAvailable || !AccountingTable.Any())
                {
                    profitSheet.Cell(2, 1).Value = "Graph not available";
                }
                else
                {
                    for (int i = 0; i < AccountingTable.Count; i++)
                    {
                        profitSheet.Cell(i + 2, 1).Value = AccountingTable[i].Month;
                        profitSheet.Cell(i + 2, 2).Value = AccountingTable[i].Profit;
                    }
                }

                var expensesSheet = workbook.Worksheets.Add("Monthly Expenses");
                expensesSheet.Cell(1, 1).Value = "Month";
                expensesSheet.Cell(1, 2).Value = "Expenses";
                if (!IsExpensesChartAvailable || !AccountingTable.Any())
                {
                    expensesSheet.Cell(2, 1).Value = "Graph not available";
                }
                else
                {
                    for (int i = 0; i < AccountingTable.Count; i++)
                    {
                        expensesSheet.Cell(i + 2, 1).Value = AccountingTable[i].Month;
                        expensesSheet.Cell(i + 2, 2).Value = AccountingTable[i].Expenses;
                    }
                }

                var accountingSheet = workbook.Worksheets.Add("Accounting Summary");
                accountingSheet.Cell(1, 1).Value = "Month";
                accountingSheet.Cell(1, 2).Value = "Profit";
                accountingSheet.Cell(1, 3).Value = "Expenses";
                accountingSheet.Cell(1, 4).Value = "Total Revenue";
                if (!IsAccountingTableAvailable || !AccountingTable.Any())
                {
                    accountingSheet.Cell(2, 1).Value = "No data available";
                }
                else
                {
                    for (int i = 0; i < AccountingTable.Count; i++)
                    {
                        accountingSheet.Cell(i + 2, 1).Value = AccountingTable[i].Month;
                        accountingSheet.Cell(i + 2, 2).Value = AccountingTable[i].Profit;
                        accountingSheet.Cell(i + 2, 3).Value = AccountingTable[i].Expenses;
                        accountingSheet.Cell(i + 2, 4).Value = AccountingTable[i].TotalRevenue;
                    }
                }

                using var ms = new MemoryStream();
                workbook.SaveAs(ms);
                ms.Seek(0, SeekOrigin.Begin);

                var fileName = $"Statistics_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx";

                var result = await FileSaver.Default.SaveAsync(
                    fileName,
                    ms,
                    new CancellationToken()
                );

                if (result.IsSuccessful)
                {
                    await Application.Current.MainPage.DisplayAlert("Success", "Excel file saved successfully.", "OK");
                }
                else
                {
                    await Application.Current.MainPage.DisplayAlert("Cancelled", "File save was cancelled.", "OK");
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Failed to generate Excel: {ex.Message}", "OK");
            }
        }

        public (string ingredientsSummary, string dishesSummary, string financialSummary) GenerateStatisticsSummaries()
        {
            string ingredientsSummary = "The most ordered ingredients:\n";
            string dishesSummary = "The most ordered dishes:\n";
            string financialSummary = "Financial Summary (Last 3 Months):\n";

            if (IsIngredientsChartAvailable && MostOrderedIngredientsChart is PieChart ingredientPieChart && ingredientPieChart.Entries?.Any() == true)
            {
                foreach (var entry in ingredientPieChart.Entries)
                {
                    if (!string.IsNullOrEmpty(entry.Label) && !string.IsNullOrEmpty(entry.ValueLabel))
                        ingredientsSummary += $"- {entry.Label}: {entry.ValueLabel}\n";
                }
            }
            else
            {
                ingredientsSummary += "- Graph not available.\n";
            }

            if (IsDishesChartAvailable && MostOrderedDishesChart is PieChart dishPieChart && dishPieChart.Entries?.Any() == true)
            {
                foreach (var entry in dishPieChart.Entries)
                {
                    if (!string.IsNullOrEmpty(entry.Label) && !string.IsNullOrEmpty(entry.ValueLabel))
                        dishesSummary += $"- {entry.Label}: {entry.ValueLabel}\n";
                }
            }
            else
            {
                dishesSummary += "- Graph not available.\n";
            }

            if (IsAccountingTableAvailable && AccountingTable.Any())
            {
                financialSummary += "Month\tProfit\tExpenses\tTotal Revenue\n";
                foreach (var record in AccountingTable)
                {
                    financialSummary += $"{record.Month}\t{record.Profit}\t{record.Expenses}\t{record.TotalRevenue}\n";
                }
            }
            else
            {
                financialSummary += "- No financial data available.\n";
            }

            return (ingredientsSummary.TrimEnd(), dishesSummary.TrimEnd(), financialSummary.TrimEnd());
        }

        private string GetRandomColor()
        {
            Random random = new Random();
            return string.Format("#{0:X2}{1:X2}{2:X2}", random.Next(256), random.Next(256), random.Next(256));
        }

        private async void LoadRestaurantName()
        {
            var user = Preferences.Get("uid", null);
            if (user != null)
            {
                var firebaseClient = new FirebaseClient(FirebaseUrl);
                var restaurantData = await firebaseClient
                    .Child("users")
                    .Child(user)
                    .OnceSingleAsync<dynamic>();
                if (restaurantData.Name != null)
                {
                    RestaurantName = restaurantData.Your_Name + " (" + restaurantData.Name + ")";
                }
                else
                {
                    RestaurantName = "Invalid";
                }
            }
        }
    }
}