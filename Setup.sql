CREATE TABLE [dbo].[w3clog]
(
    [RowId] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [LogFilename] varchar(255) NOT NULL,
    [LogRow] int NOT NULL,
    [date] date NULL,
    [time] time(0) NULL,
    [datetime] AS (CONVERT(datetime2(0), date + CONVERT(datetime, time, 0), 0)) PERSISTED,
    [c-ip] varchar(50) NULL,
    [cs-username] varchar(255) NULL,
    [s-sitename] varchar(255) NULL,
    [s-computername] varchar(255) NOT NULL,
    [s-ip] varchar(50) NULL,
    [s-port] varchar(255) NULL,
    [cs-method] varchar(255) NULL,
    [cs-uri-stem] varchar(2048) NULL,
    [cs-uri-query] varchar(max) NULL,
    [sc-status] int NULL,
    [sc-substatus] int NULL,
    [sc-win32-status] bigint NULL,
    [sc-bytes] int NULL,
    [cs-bytes] int NULL,
    [time-taken] bigint NULL,
    [cs-version] int NULL,
    [cs-host] varchar(255) NULL,
    [cs(User-Agent)] varchar(1000) NULL,
    [cs(Cookie)] varchar(max) NULL,
    [cs(Referer)] varchar(2000) NULL,
    [s-event] varchar(255) NULL,
    [s-process-type] varchar(255) NULL,
    [s-user-time] int NULL,
    [s-kernel-time] int NULL,
    [s-page-faults] int NULL,
    [s-total-procs] int NULL,
    [s-active-procs] int NULL,
    [s-stopped-procs] int NULL
)

CREATE UNIQUE NONCLUSTERED INDEX [UK_w3clog_LogRow] ON dbo.[w3clog]
(
    [LogFilename] ASC,
    [LogRow] ASC
)
