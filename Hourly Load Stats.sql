SELECT
    DATEPART(hour, [time]),
    COUNT(*) [hits],
    SUM([sc-bytes]) [upload-bytes],
    SUM([cs-bytes]) [download-bytes]
FROM
    dbo.[w3clog]
WHERE
    [datetime] >= DATEADD(day, -3, GETUTCDATE())
GROUP BY
    DATEPART(hour, [time])
