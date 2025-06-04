namespace restaurant;
using restaurant.ViewModels;
public partial class AskAI : ContentPage
{
	public AskAI(string statistics)
	{
		InitializeComponent();
        BindingContext = new AskAIViewModel(statistics);
    }
}