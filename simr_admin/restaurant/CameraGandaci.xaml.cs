namespace restaurant;

public partial class CameraGandaci : ContentPage
{
	public CameraGandaci()
	{
		InitializeComponent();
		BindingContext = new ViewModels.CameraGandaciViewModel(webView);
    }
}