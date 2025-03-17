local M = {
    "neo451/feed.nvim",
    cmd = "Feed",
}

M.dependencies = {
    "pysan3/pathlib.nvim"
}

local opts = {
    feeds = {
        -- These two styles all work
        -- "https://neovim.io/news.xml",
        -- tags given to a feed to be tagged to all its entries
        { "https://neovim.io/news.xml", name = "Neovim News", tags = { "tech", "news" } },
        { "https://reactjs.org/feed.xml", name = "reactjs.org/feed.xml", },
        { "https://devblogs.microsoft.com/dotnet/feed/", name = "devblogs.microsoft.com/dotnet/feed/", },
        { "https://www.shell-tips.com/rss.xml", name = "devblogs.microsoft.com/dotnet/feed/", },
        "https://nsearchives.nseindia.com/content/RSS/Online_announcements.xml",
        "https://nsearchives.nseindia.com/content/RSS/Voting_Results.xml",
        "https://nsearchives.nseindia.com/content/RSS/Insider_Trading.xml",
        "https://nsearchives.nseindia.com/content/RSS/Board_Meetings.xml",
        "https://nsearchives.nseindia.com/content/RSS/Annual_Reports.xml",

    },
}

function M.config()
    require("feed").setup(opts)
end

return M
