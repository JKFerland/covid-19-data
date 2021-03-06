url <- "http://www.chp.gov.hk/files/misc/statistics_on_covid_19_testing_cumulative.csv"

df <- fread(url, showProgress = FALSE)

setnames(df, c("from", "Date", "tests1", "tests2", "tests3", "tests4"))
df[, change := rowSums(df[, c("tests1", "tests2", "tests3", "tests4")], na.rm = TRUE)]

df[, from := NULL]
df[, Date := dmy(Date)]

setorder(df, Date)
df[, `Cumulative total` := cumsum(change)]
df <- df[, c("Date", "Cumulative total")]

df[, Country := "Hong Kong"]
df[, Units := "tests performed"]
df[, `Source URL` := url]
df[, `Source label` := "Department of Health"]
df[, Notes := NA_character_]
df[, `Testing type` := "PCR only"]

fwrite(df, "automated_sheets/Hong Kong.csv")
