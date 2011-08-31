SELECT TOP 50
    [date],
    COUNT(*) [hits],
    SUM([sc-bytes]) [sum-sc-bytes],
    AVG([sc-bytes]) [avg-sc-bytes]
FROM
    [w3clog]
WHERE
    [datetime] >= DATEADD(dd, -30, GETUTCDATE())
GROUP BY
    [date]
