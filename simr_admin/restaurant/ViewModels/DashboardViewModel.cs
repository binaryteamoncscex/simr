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

    public partial class DashboardViewModel : ObservableObject
    {
        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private readonly FirebaseClient _firebaseClient;
        private string _kitchenUid => Preferences.Get("uid", string.Empty);
        private string _statistics = string.Empty;

        [ObservableProperty] private Chart mostOrderedIngredientsChart;
        [ObservableProperty] private Chart mostOrderedDishesChart;
        [ObservableProperty] private bool isRefreshing;
        [ObservableProperty] private string restaurantName;

        public ObservableCollection<LegendItem> IngredientLegend { get; } = new();
        public ObservableCollection<LegendItem> DishLegend { get; } = new();

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
            var (ingredientsSummary, dishesSummary) = GenerateStatisticsSummaries();
            _statistics = $"{ingredientsSummary}\n\n{dishesSummary}";
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

                    if (list == null || !list.Any())
                    {
                        MostOrderedIngredientsChart = new PieChart
                        {
                            Entries = new[] { new Entry(1) { Label = "No Data", Color = SKColors.Gray } },
                            LabelTextSize = 0,
                            LabelMode = LabelMode.None
                        };
                        return;
                    }

                    foreach (var item in list.Where(i => i != null && i["name"] != null && i["used"] != null))
                    {
                        var name = item["name"].ToString();
                        var used = item["used"].ToObject<double>();
                        var color = SKColor.Parse(GetRandomColor());
                        var percent = $"{Math.Round((used / totalUsed) * 100, 1)}%";
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

                    MostOrderedIngredientsChart = new PieChart
                    {
                        Entries = entries.OrderByDescending(e => e.Value),
                        LabelTextSize = 0,
                        LabelMode = LabelMode.None
                    };
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading ingredient statistics: {ex}");
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

                    if (list == null || !list.Any())
                    {
                        MostOrderedDishesChart = new PieChart
                        {
                            Entries = new[] { new Entry(1) { Label = "No Data", Color = SKColors.Gray } },
                            LabelTextSize = 0,
                            LabelMode = LabelMode.None
                        };
                        return;
                    }

                    foreach (var item in list.Where(i => i != null && i["name"] != null && i["count"] != null))
                    {
                        var name = item["name"].ToString();
                        var count = item["count"].ToObject<int>();
                        var color = SKColor.Parse(GetRandomColor());
                        var percent = $"{Math.Round(((double)count / total) * 100, 1)}%";
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

                    MostOrderedDishesChart = new PieChart
                    {
                        Entries = entries.OrderByDescending(e => e.Value),
                        LabelTextSize = 0,
                        LabelMode = LabelMode.None
                    };
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading dish statistics: {ex}");
            }
        }

        private async Task SignOut(INavigation navigation)
        {
            try
            {
                Preferences.Remove("SavedUsername");
                Preferences.Remove("SavedPassword");
                Preferences.Remove("uid");
                Preferences.Remove("RememberMe");
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
                var ingredientsData = new List<(string Name, string Percent)>();
                var dishesData = new List<(string Name, string Percent)>();

                var lines = _statistics.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
                bool isIngredientSection = false;
                bool isDishSection = false;

                foreach (var line in lines)
                {
                    if (line.Contains("The most ordered ingredients:"))
                    {
                        isIngredientSection = true;
                        isDishSection = false;
                        continue;
                    }
                    if (line.Contains("The most ordered dishes:"))
                    {
                        isIngredientSection = false;
                        isDishSection = true;
                        continue;
                    }

                    if ((isIngredientSection || isDishSection) && line.Contains(":"))
                    {
                        var parts = line.Split(':');
                        var name = parts[0].Trim();
                        var percent = parts[1].Trim();

                        if (isIngredientSection)
                            ingredientsData.Add((name, percent));
                        else if (isDishSection)
                            dishesData.Add((name, percent));
                    }
                }

                using var workbook = new ClosedXML.Excel.XLWorkbook();

                var ingredientsSheet = workbook.Worksheets.Add("Ingredients");
                ingredientsSheet.Cell(1, 1).Value = "Ingredient";
                ingredientsSheet.Cell(1, 2).Value = "Percentage";
                for (int i = 0; i < ingredientsData.Count; i++)
                {
                    ingredientsSheet.Cell(i + 2, 1).Value = ingredientsData[i].Name;
                    ingredientsSheet.Cell(i + 2, 2).Value = ingredientsData[i].Percent;
                }

                var dishesSheet = workbook.Worksheets.Add("Dishes");
                dishesSheet.Cell(1, 1).Value = "Dish";
                dishesSheet.Cell(1, 2).Value = "Percentage";
                for (int i = 0; i < dishesData.Count; i++)
                {
                    dishesSheet.Cell(i + 2, 1).Value = dishesData[i].Name;
                    dishesSheet.Cell(i + 2, 2).Value = dishesData[i].Percent;
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

        public (string ingredientsSummary, string dishesSummary) GenerateStatisticsSummaries()
        {
            string ingredientsSummary = "The most ordered ingredients:\n";
            string dishesSummary = "The most ordered dishes:\n";

            if (MostOrderedIngredientsChart is PieChart ingredientPieChart && ingredientPieChart.Entries?.Any() == true)
            {
                foreach (var entry in ingredientPieChart.Entries)
                {
                    if (!string.IsNullOrEmpty(entry.Label) && !string.IsNullOrEmpty(entry.ValueLabel))
                        ingredientsSummary += $"- {entry.Label}: {entry.ValueLabel}\n";
                }
            }
            else
            {
                ingredientsSummary += "- No data available.\n";
            }

            if (MostOrderedDishesChart is PieChart dishPieChart && dishPieChart.Entries?.Any() == true)
            {
                foreach (var entry in dishPieChart.Entries)
                {
                    if (!string.IsNullOrEmpty(entry.Label) && !string.IsNullOrEmpty(entry.ValueLabel))
                        dishesSummary += $"- {entry.Label}: {entry.ValueLabel}\n";
                }
            }
            else
            {
                dishesSummary += "- No data available.\n";
            }

            return (ingredientsSummary.TrimEnd(), dishesSummary.TrimEnd());
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
