DELETE
    s
FROM
    [#w3clog_staging] s
INNER JOIN
    dbo.[w3clog] p
  ON
    s.[LogFilename] = p.[LogFilename]
  AND
    s.[LogRow] = p.[LogRow]

DELETE FROM
    [#w3clog_staging]
WHERE
    [RowId] IN
      (
        SELECT
            RowId
        FROM
          (
            SELECT
                RowId,
                ROW_NUMBER() OVER (PARTITION BY [LogFilename], [LogRow] ORDER BY [RowId]) [Instance]
            FROM
                [#w3clog_staging]
          ) instances
        WHERE
            [Instance] > 1
      )

INSERT INTO
    [w3clog]
    (
        [LogFilename], [LogRow], [date],
        [time], [c-ip], [cs-username],
        [s-sitename], [s-computername], [s-ip],
        [s-port], [cs-method], [cs-uri-stem],
        [cs-uri-query], [sc-status], [sc-substatus],
        [sc-win32-status], [sc-bytes], [cs-bytes],
        [time-taken], [cs-version], [cs-host],
        [cs(User-Agent)], [cs(Cookie)], [cs(Referer)],
        [s-event], [s-process-type], [s-user-time],
        [s-kernel-time], [s-page-faults], [s-total-procs],
        [s-active-procs], [s-stopped-procs]
    )
SELECT
    [LogFilename], [LogRow], [date],
    [time], [c-ip], [cs-username],
    [s-sitename], [s-computername], [s-ip],
    [s-port], [cs-method], [cs-uri-stem],
    [cs-uri-query], [sc-status], [sc-substatus],
    [sc-win32-status], [sc-bytes], [cs-bytes],
    [time-taken], [cs-version], [cs-host],
    [cs(User-Agent)], [cs(Cookie)], [cs(Referer)],
    [s-event], [s-process-type], [s-user-time],
    [s-kernel-time], [s-page-faults], [s-total-procs],
    [s-active-procs], [s-stopped-procs]
FROM
    [#w3clog_staging]
