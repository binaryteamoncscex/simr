using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Newtonsoft.Json;

namespace restaurant.ViewModels
{
    internal class AskAIViewModel : BaseViewModel
    {
        private string _statistics;
        private string _userPrompt;
        private string _aiResponse;
        private bool _isBusy;

        private const string GeminiApiKey = "AIzaSyBSRT31STcLVVr6CAOaUOlGmfp3PuRrHJ8";
        private const string GeminiApiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

        public AskAIViewModel(string statistics)
        {
            _statistics = statistics;
            AskCommand = new Command(async () => await ExecuteAskCommand());
        }

        public string UserPrompt
        {
            get => _userPrompt;
            set => SetProperty(ref _userPrompt, value);
        }

        public string AiResponse
        {
            get => _aiResponse;
            set => SetProperty(ref _aiResponse, value);
        }

        public bool IsBusy
        {
            get => _isBusy;
            set => SetProperty(ref _isBusy, value);
        }

        public ICommand AskCommand { get; }

        private async Task ExecuteAskCommand()
        {
            if (string.IsNullOrWhiteSpace(UserPrompt) || IsBusy)
            {
                return;
            }

            IsBusy = true;
            AiResponse = "Thinking...";

            try
            {
                using (var client = new HttpClient())
                {
                    var requestBody = new
                    {
                        contents = new[]
                        {
                            new
                            {
                                parts = new[]
                                {
                                    new { text = $"Based on the following restaurant statistics: \"{_statistics}\"\n\nAnswer this question: \"{UserPrompt}\"" }
                                }
                            }
                        }
                    };

                    var jsonContent = new StringContent(JsonConvert.SerializeObject(requestBody), Encoding.UTF8, "application/json");

                    var response = await client.PostAsync($"{GeminiApiUrl}{GeminiApiKey}", jsonContent);

                    if (response.IsSuccessStatusCode)
                    {
                        var responseString = await response.Content.ReadAsStringAsync();
                        dynamic geminiResponse = JsonConvert.DeserializeObject(responseString);

                        string rawResponse = geminiResponse.candidates[0].content.parts[0].text;

                        AiResponse = rawResponse.Replace("*", "");
                    }
                    else
                    {
                        AiResponse = $"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}";
                    }
                }
            }
            catch (Exception ex)
            {
                AiResponse = $"An error occurred: {ex.Message}";
            }
            finally
            {
                IsBusy = false;
            }
        }
    }
}