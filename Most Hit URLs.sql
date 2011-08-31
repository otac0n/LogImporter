SELECT TOP 50
    'http://' + [cs-host] + [cs-uri-stem] [url],
    COUNT(*) [hits]
FROM
    [w3clog]
WHERE
    [datetime] >= DATEADD(dd, -5, GETUTCDATE())
GROUP BY
    [cs-host],
    [cs-uri-stem]
ORDER BY
    [hits] DESC
