using CommunityToolkit.Mvvm.ComponentModel;
using Microcharts;
using SkiaSharp;
using Firebase.Database;
using Firebase.Database.Query;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Diagnostics;
using Newtonsoft.Json.Linq;
using System.Windows.Input;
using CommunityToolkit.Mvvm.Input;         
using Microsoft.Maui.Storage;   

namespace restaurant.ViewModels
{
    public partial class StatisticsViewModel : ObservableObject
    {
        private readonly FirebaseClient _firebaseClient;
        private const string FirebaseUrl = "https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/";
        private string _kitchenUid => Preferences.Get("uid", string.Empty);

        public string _statistics = string.Empty;

        private Chart _mostOrderedIngredientsChart;
        public Chart MostOrderedIngredientsChart
        {
            get => _mostOrderedIngredientsChart;
            set => SetProperty(ref _mostOrderedIngredientsChart, value);
        }

        private Chart _mostOrderedDishesChart;
        public Chart MostOrderedDishesChart
        {
            get => _mostOrderedDishesChart;
            set => SetProperty(ref _mostOrderedDishesChart, value);
        }

        private bool _isRefreshing;
        public bool IsRefreshing
        {
            get => _isRefreshing;
            set => SetProperty(ref _isRefreshing, value);
        }

        public ICommand RefreshCommand { get; }
        public ICommand AskAICommand { get; }

        public StatisticsViewModel(INavigation navigation)
        {
            _firebaseClient = new FirebaseClient(FirebaseUrl);
            RefreshCommand = new AsyncRelayCommand(ExecuteRefreshCommand);
            AskAICommand = new AsyncRelayCommand(async () =>
            {
                var askAIPage = new AskAI(_statistics);
                await navigation.PushAsync(askAIPage);
            });
            _ = LoadStatistics();
        }

        private async Task ExecuteRefreshCommand()
        {
            IsRefreshing = true;    
            await LoadStatistics();    
            IsRefreshing = false;    
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
                    var jsonObject = JObject.Parse(response);
                    var ingredientsList = jsonObject["list"]?.ToObject<List<JObject>>();
                    var totalUsed = jsonObject["used"]?.ToObject<double>() ?? 0;
                    var entries = new List<ChartEntry>();

                    if (totalUsed > 0 && ingredientsList != null)
                    {
                        foreach (var ingredient in ingredientsList.Where(i => i != null))
                        {
                            var name = ingredient["name"]?.ToString();
                            var used = ingredient["used"]?.ToObject<double>() ?? 0;
                            if (!string.IsNullOrEmpty(name))
                            {
                                entries.Add(new ChartEntry((float)used)
                                {
                                    Label = name,
                                    ValueLabel = $"{Math.Round(used / totalUsed * 100, 1)}%",
                                    Color = SKColor.Parse(GetRandomColor())
                                });
                            }
                        }
                        MostOrderedIngredientsChart = new PieChart { Entries = entries.OrderByDescending(e => e.Value), LabelTextSize = 24 };
                    }
                    else
                    {
                        MostOrderedIngredientsChart = new PieChart { Entries = new[] { new ChartEntry(1) { Label = "No Data", ValueLabel = "", Color = SKColors.Gray } } };
                    }
                }
                else
                {
                    MostOrderedIngredientsChart = new PieChart { Entries = new[] { new ChartEntry(1) { Label = "No Data", ValueLabel = "", Color = SKColors.Gray } } };
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading ingredient statistics: {ex}");
                MostOrderedIngredientsChart = new PieChart { Entries = new[] { new ChartEntry(1) { Label = "Error", ValueLabel = "", Color = SKColors.Red } } };
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
                    var jsonObject = JObject.Parse(response);
                    var dishesList = jsonObject["list"]?.ToObject<List<JObject>>();
                    var totalOrders = jsonObject["orders"]?["count"]?.ToObject<int>() ?? 0;
                    var entries = new List<ChartEntry>();

                    if (totalOrders > 0 && dishesList != null)
                    {
                        foreach (var dish in dishesList.Where(d => d != null))
                        {
                            var name = dish["name"]?.ToString();
                            var count = dish["count"]?.ToObject<int>() ?? 0;
                            if (!string.IsNullOrEmpty(name))
                            {
                                entries.Add(new ChartEntry(count)
                                {
                                    Label = name,
                                    ValueLabel = $"{Math.Round((double)count / totalOrders * 100, 1)}%",
                                    Color = SKColor.Parse(GetRandomColor())
                                });
                            }
                        }
                        MostOrderedDishesChart = new PieChart { Entries = entries.OrderByDescending(e => e.Value), LabelTextSize = 24 };
                    }
                    else
                    {
                        MostOrderedDishesChart = new PieChart { Entries = new[] { new ChartEntry(1) { Label = "No Data", ValueLabel = "", Color = SKColors.Gray } } };
                    }
                }
                else
                {
                    MostOrderedDishesChart = new PieChart { Entries = new[] { new ChartEntry(1) { Label = "No Data", ValueLabel = "", Color = SKColors.Gray } } };
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading dish statistics: {ex}");
                MostOrderedDishesChart = new PieChart { Entries = new[] { new ChartEntry(1) { Label = "Error", ValueLabel = "", Color = SKColors.Red } } };
            }
        }

        public (string ingredientsSummary, string dishesSummary) GenerateStatisticsSummaries()
        {
            string ingredientsSummary = "The most ordered ingredients:\n";
            string dishesSummary = "The most ordered dishes:\n";

            if (MostOrderedIngredientsChart is PieChart ingredientPieChart &&
                ingredientPieChart.Entries != null &&
                ingredientPieChart.Entries.Any())
            {
                foreach (var entry in ingredientPieChart.Entries)
                {
                    if (!string.IsNullOrEmpty(entry.Label) && !string.IsNullOrEmpty(entry.ValueLabel))
                    {
                        ingredientsSummary += $"- {entry.Label}: {entry.ValueLabel}\n";
                    }
                }
            }
            else
            {
                ingredientsSummary += "- No data available.\n";
            }

            if (MostOrderedDishesChart is PieChart dishPieChart &&
                dishPieChart.Entries != null &&
                dishPieChart.Entries.Any())
            {
                foreach (var entry in dishPieChart.Entries)
                {
                    if (!string.IsNullOrEmpty(entry.Label) && !string.IsNullOrEmpty(entry.ValueLabel))
                    {
                        dishesSummary += $"- {entry.Label}: {entry.ValueLabel}\n";
                    }
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
    }
}