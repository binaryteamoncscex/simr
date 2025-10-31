using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace restaurant.ViewModels
{
    internal class CameraGandaciViewModel
    {
        private dynamic webView;

        public CameraGandaciViewModel(dynamic webView)
        {
            this.webView = webView;
            LoadWebsite();
        }
        private void LoadWebsite()
        {
            string url = "https://management-restaurant.eu/camera";
            webView.Source = url;
        }
    }
}