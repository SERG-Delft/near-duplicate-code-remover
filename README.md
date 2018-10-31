Near-Duplicate Code Detector
===

This cross-platform sample tool detects exact and near duplicates of code maintained by MSRC. It has been created for the purpose of deduplicating code corpora for research purposes.

*Requirements*: .NET Core 2.1 or higher. For parsing code, an appropriate runtime for each of the languages that needs to be tokenized is also required.

To run the near-duplicate detection run:
```
dotnet run /path/to/DuplicateCodeDetector.csproj detect path/to/dataFolder outputFile
```
This will use all the `.jsonl.gz` files in the `dataFolder` and output an `outputFile` with the duplicate pairs and an `outputFile.json` with the groups of detected duplicates.

### Input Data

The input data should be one or more `.jsonl.gz` files. These are compressed files where each line has a single JSON entry of the form
```
{
    "filename": "unique identifier of file, such as a path or a unique id",
    "tokens" : ["list", "of", "tokens", "in", "file"]
}
```

The `tokenizers` folder in this repository contains tokenizers for 
C\#, Java, JavaScript and Python. Feel free to contribute tokenizers for other languages too.

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
