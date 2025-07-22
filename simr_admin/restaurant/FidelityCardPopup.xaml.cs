using CommunityToolkit.Maui.Views;
using Microsoft.Maui.Controls;
using System;

namespace restaurant.Views
{
    public partial class FidelityCardPopup : Popup
    {
        public event Action<string, string> FidelityCardSet;

        public FidelityCardPopup()
        {
            InitializeComponent();
        }

        private async void OnConfirmClicked(object sender, EventArgs e)
        {
            string purchases = PurchasesEntry.Text?.Trim();
            string procent = ProcentEntry.Text?.Trim();

            if (!string.IsNullOrWhiteSpace(purchases) && !string.IsNullOrWhiteSpace(procent))
            {
                FidelityCardSet?.Invoke(purchases, procent);
                await CloseAsync();
            }
        }
    }
}
