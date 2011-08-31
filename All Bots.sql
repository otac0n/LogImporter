SELECT
    [cs(User-Agent)],
    COUNT(*) [hits],
    COUNT(DISTINCT [c-ip]) [ips]
FROM
    [w3clog]
WHERE
    [cs(User-Agent)] LIKE '%http%'
GROUP BY
    [cs(User-Agent)]
ORDER BY
    [hits] DESC,
    [ips] DESC
