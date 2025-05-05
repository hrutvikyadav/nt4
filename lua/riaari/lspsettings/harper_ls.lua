return {
    settings = {
        ["harper-ls"] = {
            userDictPath = "~/.harper_dict.txt",
            fileDictPath = "",
            linters = {
                SpellCheck = false, -- false recommended for programming languages
                SentenceCapitalization = false, -- false recommended for programming languages
                SpelledNumbers = false,
                AnA = true,
                UnclosedQuotes = true,
                WrongQuotes = false,
                LongSentences = true,
                RepeatedWords = true,
                Spaces = true,
                Matcher = true,
                CorrectNumberSuffix = true
            },
            codeActions = {
                ForceStable = false,
                HarperAddToUserDict = true,
            },
            markdown = {
                IgnoreLinkTitle = false
            },
            diagnosticSeverity = "hint",
            isolateEnglish = false,
            dialect = "American"
        }
    }
}
