using Firebase.Database;
using Firebase.Database.Query;
using Microsoft.Maui.Storage;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using Microsoft.Maui.Graphics;
using System.Windows.Input;
using ClosedXML.Excel;
using CommunityToolkit.Maui.Storage;
using System.IO;

namespace restaurant.ViewModels
{
    public class EmployeeModel
    {
        public string Name { get; set; }
        public string Role { get; set; }
        public string Status { get; set; }
        public int Hours { get; set; }
        public string Norm { get; set; }
        public string WagePerHour { get; set; }
        public string WageForMonth { get; set; }
        public Color StatusColor { get; set; }
    }

    public class ManageClockingViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<EmployeeModel> Employees { get; set; } = new();

        private string currentUid = Preferences.Get("uid", "");
        private FirebaseClient firebase = new("https://restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app/");

        public ICommand DownloadExcelCommand { get; }

        public ManageClockingViewModel()
        {
            DownloadExcelCommand = new Command(async () => await DownloadExcelCommandAsync());
            LoadEmployees();
        }

        private async void LoadEmployees()
        {
            var users = await firebase
                            .Child("users")
                            .OrderBy("Owner")
                            .EqualTo(currentUid)
                            .OnceAsync<Dictionary<string, object>>();

            Employees.Clear();

            foreach (var user in users)
            {
                var uidAngajat = user.Key;
                var u = user.Object;

                string name = u.ContainsKey("Name") ? u["Name"]?.ToString() ?? "" : "";
                string type = u.ContainsKey("Type") ? u["Type"]?.ToString() ?? "" : "";
                string role = type == "cook" ? "Cook" : type == "waiter" ? "Waiter" : "Unknown";

                bool atWork = u.ContainsKey("at_work") && bool.TryParse(u["at_work"]?.ToString(), out var b) && b;
                string status = atWork ? "Active" : "Inactive";
                Color statusColor = atWork ? Colors.Green : Colors.Red;

                int hours = u.ContainsKey("hours") && int.TryParse(u["hours"]?.ToString(), out var h) ? h : 0;

                string norm = u.ContainsKey("Norm") ? u["Norm"]?.ToString() ?? "0" : "0";
                string wagePerHour = u.ContainsKey("WagePerHour") ? u["WagePerHour"]?.ToString() ?? "0" : "0";

                double wage = double.TryParse(wagePerHour, out var wp) ? wp * hours : 0;

                Employees.Add(new EmployeeModel
                {
                    Name = name,
                    Role = role,
                    Status = status,
                    StatusColor = statusColor,
                    Hours = hours,
                    Norm = norm,
                    WagePerHour = wagePerHour,
                    WageForMonth = wage.ToString("0.00")
                });
            }
        }

        public async Task DownloadExcelCommandAsync()
        {
            try
            {
                if (Employees == null || Employees.Count == 0)
                {
                    await Application.Current.MainPage.DisplayAlert("No Data", "There are no employees to export.", "OK");
                    return;
                }

                using var workbook = new XLWorkbook();
                var sheet = workbook.Worksheets.Add("Employees");
                sheet.Cell(1, 1).Value = "Name";
                sheet.Cell(1, 2).Value = "Role";
                sheet.Cell(1, 3).Value = "Status";
                sheet.Cell(1, 4).Value = "Hours";
                sheet.Cell(1, 5).Value = "Norm";
                sheet.Cell(1, 6).Value = "Wage/h";
                sheet.Cell(1, 7).Value = "Wage/mo";
                for (int i = 0; i < Employees.Count; i++)
                {
                    var emp = Employees[i];
                    sheet.Cell(i + 2, 1).Value = emp.Name;
                    sheet.Cell(i + 2, 2).Value = emp.Role;
                    sheet.Cell(i + 2, 3).Value = emp.Status;
                    sheet.Cell(i + 2, 4).Value = emp.Hours;
                    sheet.Cell(i + 2, 5).Value = emp.Norm;
                    sheet.Cell(i + 2, 6).Value = emp.WagePerHour;
                    sheet.Cell(i + 2, 7).Value = emp.WageForMonth;
                }

                using var ms = new MemoryStream();
                workbook.SaveAs(ms);
                ms.Seek(0, SeekOrigin.Begin);

                var result = await FileSaver.Default.SaveAsync(
                    $"Employees_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx",
                    ms,
                    new CancellationToken());

                if (result.IsSuccessful)
                {
                    await Application.Current.MainPage.DisplayAlert("Success", "Excel file saved successfully.", "OK");
                }
                else
                {
                    await Application.Current.MainPage.DisplayAlert("Cancelled", "Export was cancelled.", "OK");
                }
            }
            catch (Exception ex)
            {
                await Application.Current.MainPage.DisplayAlert("Error", $"Export failed: {ex.Message}", "OK");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}
