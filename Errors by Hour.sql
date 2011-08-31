SELECT
    DATEADD(hh, DATEPART(hh, [time]), CAST([date] as datetime2(0))) [hour],
    SUM(CASE WHEN [sc-status] >= 400 THEN 1 ELSE 0 END) [errors]
FROM
    [w3clog]
WHERE
    [datetime] >= DATEADD(dd, -1, GETUTCDATE())
GROUP BY
    DATEADD(hh, DATEPART(hh, [time]), CAST([date] as datetime2(0)))
ORDER BY
    [hour] DESC
