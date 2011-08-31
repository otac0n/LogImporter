SELECT TOP 100
    'http://' + [cs-host] + CASE WHEN LEFT([cs-uri-stem], 1) = '/' THEN '' ELSE '/' END + [cs-uri-stem] + ISNULL('?' + [cs-uri-query], '') [Url],
    COUNT(*) [errors]
FROM
    [dbo].[w3clog]
WHERE
    [datetime] >= DATEADD(dd, -4, getutcdate())
  AND
    [sc-status] >= 400
GROUP BY
    [cs-host],
    [cs-uri-stem],
    ISNULL('?' + [cs-uri-query], '')
HAVING
    COUNT(*) > 1
ORDER BY
    [errors] DESC
