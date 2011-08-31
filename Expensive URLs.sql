SELECT TOP 25
    'http://' + [cs-host] + [cs-uri-stem] [url],
    COUNT(*) [hits],
    AVG([sc-bytes]) [avg-sc-bytes],
    SUM([sc-bytes]) [sum-sc-bytes]
FROM
    [w3clog]
WHERE
    [datetime] >= DATEADD(dd, -5, GETUTCDATE())
GROUP BY
    [cs-host],
    [cs-uri-stem]
ORDER BY
    [sum-sc-bytes] DESC
