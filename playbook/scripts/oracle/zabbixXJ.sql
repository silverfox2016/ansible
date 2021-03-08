set head off
set linesize 20000
set echo off
set feedback off
set pagesize 0
set termout off
set trimout on
set trimspool on

COLUMN c_free_mb NEW_VALUE _c_free_mb NOPRINT
COLUMN c_total_mb NEW_VALUE _c_total_mb NOPRINT
COLUMN c_retvalue NEW_VALUE _c_retvalue NOPRINT
COLUMN c_dbfilesize NEW_VALUE _c_dbfilesize NOPRINT

select total_mb c_total_mb,free_mb c_free_mb from v$asm_diskgroup where GROUP_NUMBER = 1;
select to_char(sum(bytes/1024/1024/1024), 'FM99999999999999990') c_retvalue from dba_data_files;
SELECT to_char(sum(  NVL(a.bytes/1024/1024/10 - NVL(f.bytes/1024/1024/10, 0), 0)), 'FM99999999999999990') c_dbfilesize FROM sys.dba_tablespaces d, (select tablespace_name, sum(bytes) bytes from dba_data_files group by tablespace_name) a, (select tablespace_name, sum(bytes) bytes from dba_free_space group by tablespace_name) f WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = f.tablespace_name(+) AND NOT (d.extent_management like 'LOCAL' AND d.contents like 'TEMPORARY');

spool /home/oracle/zabbixXJ.log

prompt free_mb:&_c_free_mb
prompt total_mb:&_c_total_mb
prompt dbfilesize:&_c_retvalue
prompt dbsize:&_c_dbfilesize
prompt query:

SELECT * FROM (
select '- Tablespace ->',t.tablespace_name ktablespace,
       '- Type->',substr(t.contents, 1, 1) tipo,
       '- Used(MB)->',trunc((d.tbs_size-nvl(s.free_space, 0))/1024/1024) ktbs_em_uso,
       '- ActualSize(MB)->',trunc(d.tbs_size/1024/1024) ktbs_size,
       '- MaxSize(MB)->',trunc(d.tbs_maxsize/1024/1024) ktbs_maxsize,
       '- FreeSpace(MB)->',trunc(nvl(s.free_space, 0)/1024/1024) kfree_space,
       '- Space->',trunc((d.tbs_maxsize - d.tbs_size + nvl(s.free_space, 0))/1024/1024) kspace,
       '- Perc->',decode(d.tbs_maxsize, 0, 0, trunc((d.tbs_size-nvl(s.free_space, 0))*100/d.tbs_maxsize)) kperc
from
  ( select SUM(bytes) tbs_size,
           SUM(decode(sign(maxbytes - bytes), -1, bytes, maxbytes)) tbs_maxsize, tablespace_name tablespace
    from ( select nvl(bytes, 0) bytes, nvl(maxbytes, 0) maxbytes, tablespace_name
              from dba_data_files
    )
    group by tablespace_name
    ) d,
    ( select SUM(bytes) free_space,tablespace_name tablespace
    from dba_free_space
    group by tablespace_name
    ) s,
    dba_tablespaces t
    where t.tablespace_name = d.tablespace(+) and
    t.tablespace_name = s.tablespace(+)
    order by 8) 
    where tipo <>'T'
union all
select '- Tablespace ->',t.tablespace_name ktablespace,
       '- Type->', t.tipo,
       '- Used(MB)->',trunc((t.tbs_size-nvl(d.free_space, 0))/1024/1024) ktbs_em_uso,
       '- ActualSize(MB)->',trunc(t.tbs_size/1024/1024) ktbs_size,
       '- MaxSize(MB)->',trunc(t.tbs_maxsize/1024/1024) ktbs_maxsize,
       '- FreeSpace(MB)->',trunc(nvl(d.free_space, 0)/1024/1024) kfree_space,
       '- Space->',trunc((t.tbs_maxsize - t.tbs_size + nvl(d.free_space, 0))/1024/1024) kspace,
       '- Perc->',decode(t.tbs_maxsize, 0, 0, trunc((t.tbs_size-nvl(d.free_space, 0))*100/t.tbs_maxsize)) kperc
FROM 
(
SELECT TABLESPACE_NAME,  
    'T' tipo, 
    SUM(BYTES)  tbs_size,
    SUM(MAXBYTES) tbs_maxsize
FROM DBA_TEMP_FILES
GROUP BY TABLESPACE_NAME
) t,
(
    SELECT TABLESPACE_NAME,   
    SUM(BYTES_USED) tbs_em_uso,
    SUM(BYTES_FREE) free_space
FROM V$TEMP_SPACE_HEADER
GROUP BY TABLESPACE_NAME
) d
WHERE  t.TABLESPACE_NAME = d.TABLESPACE_NAME(+);

spool off
exit;
