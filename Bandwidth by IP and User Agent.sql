SELECT TOP 30
    [c-ip],
    [cs(User-Agent)],
    SUM([sc-bytes]) [sum-sc-bytes]
FROM
    [w3clog]
WHERE
    [datetime] >= DATEADD(dd, -5, GETUTCDATE())
GROUP BY
    [c-ip],
    [cs(User-Agent)]
ORDER BY
    SUM([sc-bytes]) DESC
