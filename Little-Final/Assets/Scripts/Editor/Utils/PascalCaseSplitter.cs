using System.Text.RegularExpressions;

namespace Editor.Utils
{
    public class PascalCaseSplitter
    {
        public static string SplitPascalCase(string input)
        {
            if (string.IsNullOrEmpty(input))
            {
                return input;
            }

            string result = Regex.Replace(input, "(\\B[A-Z])", " $1");
            return result.Trim();
        }
    }
}